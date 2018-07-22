
/*
 *  CCC - The Clipper to C++ Compiler
 *  Copyright (C) 2005 ComFirm BT.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <cccapi.h> 
 
//  Javitasok
//
//  2014.07.24 A CCC3-beli program visszaegyszerusitve CCC2-re
//          (string.cpp-ben stringek oref-beli hossza 1 helyett -1!).
//  2007.05.12 rekurzio nelkul, typeinfo nelkul, 0-as oref
//  2007.05.05 generacios szemetgyujtes, age hisztogramm
//  2007.04.11 MUTEX_LOCK/MUTEX_UNLOCK makrok
//  2006.03.17 unicode tamogatas (TYPE_BINARY <--> TYPE_STRING)
//  2005.07.20 szalkezeles atirva, szignalkezeles
//  2003.07.30 multithreading tamogatas
//  2002.06.28 oref_size merete linkeleskor szabalyozhato    
//  1999.01.16 oref tobbe egyaltalan nem latszik ki    
//  1998.05.03 oref,vref static, szabalyozhato meretu
//  1996.06.26 0-as oref nincs


//---------------------------------------------------------------------------
static int vnext;  // a kovetkezo szabad index vref-ben
static int onext;  // a kovetkezo szabad index oref-ben

static int vfree;  // szabad elemek szama vref-ben szemetgyujtes utan
static int ofree;  // szabad elemek szama oref-ben szemetgyujtes utan

static int alloc_count=0;  // foglalasok szama
static long alloc_size=0;  // foglalasok osszmerete 


static char *env_garbage=NULL;  // szemetgyujtes debug info

static int  OREF_SIZE   =   40000;
static int  VREF_SIZE   =    5000;

static int  ALLOC_COUNT =   40000;
static long ALLOC_SIZE  = 4000000;  //4MB
 
static OREF *oref;
static VREF *vref;

static volatile int garbage_collection_is_running=0;

static void vartab_mark(VALUE*);
static void vartab_sweep();


#if ! defined MULTITHREAD
//---------------------------------------------------------------------------
#define VARTAB_STOP()
#define VARTAB_CONT()
 
void vartab_lock0(){}
void vartab_unlock0(){}
void vartab_lock(){ SIGNAL_LOCK(); }
void vartab_unlock(){ SIGNAL_UNLOCK(); }

//---------------------------------------------------------------------------
void valuemove(VALUE *to, VALUE *fr, int n)  //egyszalu 
{
    SIGNAL_LOCK();
    memmove(to,fr,n*sizeof(VALUE));
    SIGNAL_UNLOCK();
}

#else //MULTITHREAD
//---------------------------------------------------------------------------
MUTEX_CREATE(mutex);

#define VARTAB_STOP()    vartab_stop() 
#define VARTAB_CONT()    vartab_cont() 

void vartab_lock0(){ MUTEX_LOCK(mutex); }
void vartab_unlock0(){ MUTEX_UNLOCK(mutex); }
void vartab_lock(){ SIGNAL_LOCK(); MUTEX_LOCK(mutex); }
void vartab_unlock(){ MUTEX_UNLOCK(mutex); SIGNAL_UNLOCK(); }


//---------------------------------------------------------------------------
void valuemove(VALUE *to, VALUE *fr, int n)
{
    if( n==0 )
    {
    }
    else if( thread_data::tdata_count==1 )
    {
        SIGNAL_LOCK();
        memmove(to,fr,n*sizeof(VALUE));
        SIGNAL_UNLOCK();
    }
    else
    {
        SIGNAL_LOCK();
        thread_data_ptr->lock();
        memmove(to,fr,n*sizeof(VALUE));
        thread_data_ptr->unlock();
        SIGNAL_UNLOCK();
    }
}

//---------------------------------------------------------------------------
VALUE VALUE::operator=(VALUE v)
{
    if( this==&v )
    {
        //OK
    }
    else if( (thread_data::tdata_count==1) || (v.type<TYPE_STRING) )
    {
        //fontos optimalizalas;
        //masik szalon futo szemetgyujtes alatt is megengedett
        //a skalar<--skalar es array<--skalar tipusu ertekadas;
        //lenyeges, hogy amig type es data nem osszetartozo
        //ertekeket tartalmaz, addig type-ban ne legyen array tipus,
        //mert akkor a szemetgyujtes elromolhat;
        //ugyanez a vedelem kell egyszalu esetben is,
        //ui. a szignalkezelobol is indulhat szemetgyujtes;

        ((volatile VALUE*)this)->type=TYPE_NIL; //atomi
        data=v.data;
        type=v.type; //atomi
    }
    else
    {
        SIGNAL_LOCK();
        thread_data_ptr->lock();
        type=v.type;
        data=v.data;
        thread_data_ptr->unlock();
        SIGNAL_UNLOCK();
    }
    return *this;
}

//---------------------------------------------------------------------------
static void vartab_stop()  //a tobbi szalat elzarja az ertekadastol
{
    thread_data *td=thread_data::tdata_first;
    while( td!=0 )
    {
        td->lock();
        td=td->next;
    }
}

//---------------------------------------------------------------------------
static void vartab_cont() // minden varakozo szalat kienged
{
    thread_data *td=thread_data::tdata_first;
    while( td!=0 )
    {
        td->unlock();
        td=td->next;
    }
}
 
#endif //MULTITHREAD


//---------------------------------------------------------------------------
static int *mark_stack=0;
static int *mark_stack_ptr=0;

static void mark_stack_init()
{
    mark_stack_ptr=mark_stack;
}

static void mark_push(OREF*o)
{
    *mark_stack_ptr++=(o-oref); //indexet tarol
}

static OREF *mark_pop()
{
    if( mark_stack_ptr>mark_stack )
    {
        return oref+(*--mark_stack_ptr);
    }
    return 0;
}

//---------------------------------------------------------------------------
void vartab_ini(void)
{
    static int initialized=0;
    if( initialized )
    {
        return;
    }
    initialized=1;

#if ! defined  MULTITHREAD
    //ures
#elif defined UNIX
    pthread_key_create(&thread_key,0);
    pthread_setspecific(thread_key,new thread_data());
#else
    thread_key=TlsAlloc();
    TlsSetValue(thread_key,new thread_data());
#endif
    siglocklev=0; //unlock (kezdetben lockolva van)
 
    char *orsp=getenv("OREF_SIZE");
    if( orsp )
    {
        long size=atol(orsp);
        OREF_SIZE=size;
        ALLOC_COUNT=size;
        ALLOC_SIZE=size*100;
    }

    char *vrsp=getenv("VREF_SIZE");
    if( vrsp )
    {
        long size=atol(vrsp);
        VREF_SIZE=size;
    }
    
    static struct VARTAB_SETSIZE vss={ &OREF_SIZE, &VREF_SIZE, 
                                       &ALLOC_COUNT, &ALLOC_SIZE };
    vartab_setsize(&vss);

    oref=(OREF*)MEMALLOC(OREF_SIZE*sizeof(OREF));
    if(oref==NULL)
    {
        fprintf(stderr,"\nNo memory for oref!");
        exit(1);
    }

    vref=(VREF*)MEMALLOC(VREF_SIZE*sizeof(VREF));
    if(vref==NULL)
    {
        fprintf(stderr,"\nNo memory for vref!");
        exit(1);
    }

    mark_stack=(int*)MEMALLOC(OREF_SIZE*sizeof(int));
    if(mark_stack==NULL)
    {
        fprintf(stderr,"\nNo memory for mark_stack!");
        exit(1);
    }

    env_garbage=getenv("GARBAGE");

    int n;

    for(n=0; n<VREF_SIZE; n++)
    {
        vref[n].value.type=TYPE_NIL;
        vref[n].next=n+1;
    }
    vnext=0;

    for(n=0; n<OREF_SIZE; n++)
    {
        oref[n].ptr.valptr=NULL;
        oref[n].length=0;
        oref[n].next=n+1;
    }
    onext=0;
}

//---------------------------------------------------------------------------
void vartab_rebuild(void)
{
    if( garbage_collection_is_running )
    {
        return;
    }
    else
    {
        garbage_collection_is_running=1;
    }

    VARTAB_STOP();
 
    if( env_garbage ) //debug info
    { 
        fprintf
        (
            stderr,
            "\nalloc_count: %d/%d, alloc_size: %ldK/%ldK",
            alloc_count,ALLOC_COUNT,alloc_size>>10,ALLOC_SIZE>>10 
        );
        fflush(0);
    }

    alloc_count=0;
    alloc_size=0;
    
    mark_stack_init();
    int n;

    for( n=0; n<VREF_SIZE; n++ )
    {
        if( vref[n].next!=NEXT_LOCKED )
        {
            vref[n].next=NEXT_UNKNOWN;
        }
    }

    for( n=0; n<OREF_SIZE; n++ )
    {
        if( oref[n].next!=NEXT_LOCKED )
        {
            oref[n].next=NEXT_UNKNOWN;
        }
    }

    //static valtozok stack-je
    VALUE *sp;

    for( sp=ststackbuf; sp<ststack; sp++)
    {
        vartab_mark(sp);
    }

#ifdef MULTITHREAD
    //local valtozok stack-je
    //az osszes szal local stackjet be kell jarni

    thread_data *td=thread_data::tdata_first;

    while( td!=0 )
    {
        for( sp=td->_stackbuf; sp<td->_stack; sp++)
        {
            vartab_mark(sp);
        }
        td=td->next;
    }
#else
    //local valtozok stack-je
    for( sp=stackbuf; sp<stack; sp++)
    {
        vartab_mark(sp);
    }
#endif

    OREF *marked_oref;
    while( 0!=(marked_oref=mark_pop()) ) //pop
    {
        VALUE *v=marked_oref->ptr.valptr;
        for( int t=v->type; t>=TYPE_NIL; t=(++v)->type )
        {
            vartab_mark(v); //push
        }
    }

    vartab_sweep();

    if( env_garbage ) //degub info
    {
        fprintf(stderr,"\nofree=%d vfree=%d\n",ofree,vfree);
        fflush(0);
    }

    garbage_collection_is_running=0;
    VARTAB_CONT();
    return;
}

//---------------------------------------------------------------------------
static void vartab_mark(VALUE *valueptr)
{
    int type=valueptr->type;
    void *ptr=valueptr->data.pointer;

#ifdef USE_TYPE_INFO //not defined

    if( type<TYPE_STRING )
    {
        //kihagy
    }
    else if( type<TYPE_REF )
    {
        unsigned int oidx=(OREF*)ptr-oref;
        if( oidx<(unsigned)OREF_SIZE ) //valid oref
        {
            OREF *o=oref+oidx;
            if( o->next==NEXT_UNKNOWN )
            {
                o->next=NEXT_RESERVED;
                if( o->length>0 )
                {
                    mark_push(o);
                }
            }
        }
    }
    else
    {
        unsigned int vidx=(VREF*)ptr-vref;
        if( vidx<(unsigned)VREF_SIZE ) //valid vref
        {
            VREF *r=vref+vidx;
            if( r->next==NEXT_UNKNOWN )
            {
                r->next=NEXT_RESERVED;
                vartab_mark(&(r->value));
            }
        }
    }
#else
        // Szalbiztonsag:
        // Ez a stabilabbnak gondolt valtozat.
        // A szemetgyujtes igy nem fugg attol,
        // hogy milyen sorrendben allitjak be
        // v->type-ot es v->data.pointer-t.
        // Amig egy pointer beallitasa atomi,
        // a tipus es a pointer beallitasa nem atomi.
        // A NIL-ekben levo inicializalatlan pointer
        // feleslegesen megorzott objektumokat okoz,
        // ezert celszeru a NIL-eket nullazni.

        unsigned int oidx=(OREF*)ptr-oref;
        if( oidx<(unsigned)OREF_SIZE ) //valid oref
        {
            OREF *o=oref+oidx;
            if( o->next==NEXT_UNKNOWN )
            {
                o->next=NEXT_RESERVED;
                if( o->length>0 )
                {
                    mark_push(o);
                }
            }
            return;
        }
        unsigned int vidx=(VREF*)ptr-vref;
        if( vidx<(unsigned)VREF_SIZE ) //valid vref
        {
            VREF *r=vref+vidx;
            if( r->next==NEXT_UNKNOWN )
            {
                r->next=NEXT_RESERVED;
                vartab_mark(&(r->value));
            }
            return;
        }
#endif

}

//---------------------------------------------------------------------------
static void vartab_sweep()
{
    // vref-ek takaritasa

    vfree=0;
    int vprev=vnext=-1;
    int n;

    for( n=0; n<VREF_SIZE; n++ )
    {
        if( vref[n].next==NEXT_UNKNOWN )
        {
            vref[n].value.type=TYPE_NIL;

            if( vfree++==0 )
            {
                vprev=vnext=n;
            }
            else
            {
                vref[vprev].next=n;
                vprev=n;
            }
        }
    }

    if( vfree>0 )
    {
        vref[vprev].next=VREF_SIZE;
    }
    else
    {
        fprintf(stderr,"\nVREF overflow");
        fflush(0);
        exit(1);
    }

    // oref-ek takaritasa

    ofree=0;
    int oprev=onext=-1;

    for( n=0; n<OREF_SIZE; n++ )
    {
        if( oref[n].next==NEXT_UNKNOWN )
        {
            if( oref[n].length )
            {
                //*oref[n].ptr.binptr='@'; // szandekos rongalas
                MEMFREE(oref[n].ptr.valptr);
            }
            oref[n].ptr.valptr=NULL;
            oref[n].length=0;

            if( ofree++==0 )
            {
                oprev=onext=n;
            }
            else
            {
                oref[oprev].next=n;
                oprev=n;
            }
        }
    }

    if( ofree>0 )
    {
        oref[oprev].next=OREF_SIZE;
    }
    else
    {
        fprintf(stderr,"\nOREF overflow");
        fflush(0);
        exit(1);
    }
}

//---------------------------------------------------------------------------
VREF *vref_new(void)
{
    if( ++alloc_count>ALLOC_COUNT || vnext>=VREF_SIZE )
    {
        vartab_rebuild();
    }
    VREF *v=vref+vnext;
    vnext=v->next;
    v->next=NEXT_LOCKED;
    return v;
}

//---------------------------------------------------------------------------
OREF *oref_new(void)
{
    if( ++alloc_count>ALLOC_COUNT || onext>=OREF_SIZE )
    {
        vartab_rebuild();
    }
    OREF *o=oref+onext;
    onext=o->next;
    o->next=NEXT_LOCKED;
    return o;
}

//---------------------------------------------------------------------------
void deleteValue(VALUE *v)
{
    MEMFREE(v);
}

//---------------------------------------------------------------------------
VALUE *newValue(unsigned int len)
{
    alloc_count++;
    alloc_size+=sizeof(VALUE)*len;
    if( alloc_count>ALLOC_COUNT || alloc_size>ALLOC_SIZE )
    {
        vartab_rebuild();
    }

    VALUE *p=(VALUE*)MEMALLOC( len*sizeof(VALUE) );

    if( p==NULL )
    {
        vartab_rebuild();
        p=(VALUE*)MEMALLOC(len*sizeof(VALUE));
        if( p==NULL )
        {
            fprintf(stderr,"\nmemory overbooked: %d",len);
            fflush(0);
            exit(1);
        }
    }
    memset(p,0,len*sizeof(VALUE));
    return p;
}

//-------------------------------------------------------------------------
char *newChar(unsigned int len)
{
    alloc_count++;
    alloc_size+=sizeof(char)*len;
    if( alloc_count>ALLOC_COUNT || alloc_size>ALLOC_SIZE )
    {
        vartab_rebuild();
    }

    char *p=(char*)MEMALLOC(len*sizeof(char));

    if( p==NULL )
    {
        vartab_rebuild();
        p=(char*)MEMALLOC(len*sizeof(char));
        if( p==NULL )
        {
            fprintf(stderr,"\nmemory overbooked: %d",len);
            fflush(0);
            exit(1);
        }
    }
    return p;
}


//---------------------------------------------------------------------------
void _clp_vartab_rebuild(int argno)
{
    stack-=argno;
    VARTAB_LOCK();
    vartab_rebuild();
    VARTAB_UNLOCK();
    push(&NIL);
}



//---------------------------------------------------------------------------
//DEBUG: object inventory
//---------------------------------------------------------------------------
static int typecode(int type)
{
    switch(type)
    {
        case TYPE_END        : return 'E';
        case TYPE_NIL        : return 'U';
        case TYPE_NUMBER     : return 'N';
        case TYPE_DATE       : return 'D';
        case TYPE_FLAG       : return 'L';
        case TYPE_POINTER    : return 'P';
        case TYPE_STRING     : return 'C';
        case TYPE_ARRAY      : return 'A';
        case TYPE_BLOCK      : return 'B';
        case TYPE_OBJECT     : return 'O';
        case TYPE_REF        : return 'R';
    }
    return '_';
}

//---------------------------------------------------------------------------
static void valprn(VALUE *valptr)
{
    fprintf(stderr,"%c",typecode(valptr->type));

    if( valptr->type==TYPE_NUMBER )
    {
        fprintf(stderr,"%d",(int)valptr->data.number);
    }

    else if( valptr->type==TYPE_DATE )
    {
        fprintf(stderr,"%ld",valptr->data.date);
    }

    else if( valptr->type==TYPE_FLAG )
    {
        fprintf(stderr,"%d",0!=valptr->data.flag);
    }

    else if( valptr->type==TYPE_POINTER )
    {
        fprintf(stderr,"%p",(void*)valptr->data.pointer);
    }

    else if( valptr->type==TYPE_STRING )
    {
        fprintf(stderr,"%d",(int)valptr->data.string.len);
    }

    else if( valptr->type==TYPE_ARRAY )
    {
        OREF*oref=valptr->data.array.oref;
        if(oref)
        {
            fprintf(stderr,"%d",oref->length);
        }
    }

    else if( valptr->type==TYPE_BLOCK )
    {
        OREF*oref=valptr->data.block.oref;
        if(oref)
        {
            fprintf(stderr,"%d",oref->length);
            if( oref->length )
            {
                fprintf(stderr,"<");
                for(int i=0; i<oref->length; i++)
                {
                    valprn( oref->ptr.valptr+i );
                }
                fprintf(stderr,">");
            }
        }
    }

    else if( valptr->type==TYPE_OBJECT )
    {
        fprintf(stderr,"%d",valptr->data.object.subtype);
    }

    else if( valptr->type==TYPE_REF )
    {
        VREF*vref=valptr->data.vref;
        valprn( &(vref->value) );
    }
}

//---------------------------------------------------------------------------
void _clp___oref_list(int argno)
{
    stack-=argno;
    push(&NIL);

    fprintf(stderr,"\n==============================");

    int cnt=0;
    for( int n=0; n<OREF_SIZE; n++ )
    {
        if( oref[n].next == NEXT_RESERVED  ) 
        {
            cnt++;

            fprintf(stderr,"\n"); 
            //fprintf(stderr,"%08lx ",(unsigned long)oref[n].ptr.valptr);
            fprintf(stderr,"%4d ",oref[n].length);

            if( oref[n].length<=0 )
            {
                if(oref[n].ptr.chrptr)
                {
                    fprintf(stderr,"[%s]",oref[n].ptr.chrptr);
                }
            }
            else
            {
                for(int i=0; i<oref[n].length; i++ )
                {
                    valprn( oref[n].ptr.valptr+i );
                }
            }
        }
    }

    fprintf(stderr,"\n%d",cnt);
    fprintf(stderr,"\n==============================");
    fprintf(stderr,"\n");
    fflush(0);

}
 
//---------------------------------------------------------------------------


