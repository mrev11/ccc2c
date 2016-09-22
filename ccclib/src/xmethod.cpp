
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

#include <stdio.h>
#include <string.h>
#include <cccapi.h>

//----------------------------------------------------------------------
_method_::_method_(char *sname)
{
    classid=0;
    slotname=sname; 
    slot.type=TYPE_NIL;
}

_methods_::_methods_(char *sname, char *bname)
{
    classid=0;
    slotname=sname; 
    basename=bname; 
    slot.type=TYPE_NIL;
}

_methodc_::_methodc_(char *sname, char *bname)
{
    classid=0;
    slotname=sname; 
    basename=bname; 
    slot.type=TYPE_NIL;
}

_methodp_::_methodp_(char *sname, char *pname, char *bname)
{
    classid=0;
    slotname=sname; 
    prntname=pname; 
    basename=bname; 
    slot.type=TYPE_NIL;
}
 
//----------------------------------------------------------------------
void _method_::findslot(int clid)
{
    extern void _clp___findslot(int argno);

    number(clid);
    string(slotname);
    _clp___findslot(2);  
    
    //Clipper szinten keresünk
    //ha nem talált, akkor ide már nem jön,
    //mert a hibát _clp___findslot() kezeli,
    //ha talált, akkor a method blokkja,
    //vagy az attribútum indexe van a stacken.
    
    //Ezt a blokkot/indexet megõrízzük a slot memberben,
    //(VIGYáZAT) itt a blokkot a szemétgyûjtés nem tudja 
    //megtalálni, és csak amiatt nem takarítódik le, 
    //mert ugyanerre az objektumra a static aclass
    //tömbbõl is van hivatkozás.
    
    classid=clid;
    slot=*TOP();
    POP();
}

void _methods_::findslot(int clid)
{
    extern void _clp___findslot_s(int argno);

    number(clid);
    string(slotname);
    string(basename);
    _clp___findslot_s(3);  
    classid=clid;
    slot=*TOP();
    POP();
}

void _methodc_::findslot(int clid)
{
    extern void _clp___findslot_c(int argno);

    number(clid);
    string(slotname);
    string(basename);
    _clp___findslot_c(3);  
    classid=clid;
    slot=*TOP();
    POP();
}

void _methodp_::findslot(int clid)
{
    extern void _clp___findslot_p(int argno);

    number(clid);
    string(slotname);
    string(prntname);
    string(basename);
    _clp___findslot_p(4);  
    classid=clid;
    slot=*TOP();
    POP();
}
 
 
//----------------------------------------------------------------------
void _method_::eval(int argno)
{
    //stack: Obj A1 A2... Aargno-1 --- retval
    
    VALUE *base=stack-argno;  //object
    
    if( base->type!=TYPE_OBJECT )
    {
        error_obj(slotname,base,argno);
    }

    if( base->data.object.subtype!=classid )
    {
        findslot(base->data.object.subtype); 
        
        //static int cnt=0;
        //printf("\n%d findslot %s %d %d",++cnt,slotname,base->data.object.subtype,classid);
    }
    
    //ha findslot sikeres,
    //akkor a classid és slot member már ki van töltve,
    //egyébként findslot kezeli a hibát
    
    //ha a slot unionban szám van, akkor az egy attribútum indexe
    //ha a slot unionban kódblokk van, akkor azt ki kell értékelni,


    if( slot.type==TYPE_NUMBER )
    {
        //attribútum kiolvasás/felülírás
    
        unsigned int len=OBJECTLEN(base);
        unsigned int idx=(int)slot.data.number;

        if( (idx<1) || (len<idx) )
        {
            error_siz("_method_::eval",base,argno);
        }
    
        VALUE *v=OBJECTPTR(base)+idx-1;

        if( argno>1 ) //beírás
        {
            *v=*(base+1);
        }

        *base=*v;
        stack=base+1;
    }
    
    else if( slot.type==TYPE_BLOCK )
    {
        //method végrehajtás
        //a stacket eggyel feljebb kell hozni,
        //hogy a kódblokkot be tehessük alulra
        
        if( argno==1 )
        {
            //speciális eset,
            //csak az objektum, ezt elég duplázni,
            //úgy is jó, ha mindig az else ágra megy

            DUP();
        }
        else
        {
            //nem threadsafe
            //stack++;
            //memmove(base+1,base,argno*sizeof(VALUE));

            PUSHNIL();
            int i;
            for( i=argno; i>0; i-- )
            {
                *(base+i)=*(base+i-1);
            }
        }
        
        //ha most a base-be bemásoljuk a kódblokkot,
        //akkor a verem éppen olyan, mint _clp_eval-nál
        
        *base=slot;
        base->data.block.code(argno+1);
    }

    else
    {
        error_gen("invalid slot type","_method_::eval",base,argno);
    }
}


//--------------------------------------(ismétlõdik s)
void _methods_::eval(int argno)
{
    //stack: Obj A1 A2... Aargno-1 --- retval
    
    VALUE *base=stack-argno;  //object
    
    if( base->type!=TYPE_OBJECT )
    {
        error_obj(slotname,base,argno);
    }

    //if( base->data.object.subtype!=classid )
    if( !classid )
    {
        findslot(base->data.object.subtype); 
    }
    
    if( slot.type==TYPE_NUMBER )
    {
        //attribútum kiolvasás/felülírás
    
        unsigned int len=OBJECTLEN(base);
        unsigned int idx=(int)slot.data.number;

        if( (idx<1) || (len<idx) )
        {
            error_siz("_method_::eval",base,argno);
        }
    
        VALUE *v=OBJECTPTR(base)+idx-1;

        if( argno>1 ) //beírás
        {
            *v=*(base+1);
        }

        *base=*v;
        stack=base+1;
    }
    else if( slot.type==TYPE_BLOCK )
    {
        //method végrehajtás

        //stack++;
        //memmove(base+1,base,argno*sizeof(VALUE));

        PUSHNIL();
        int i;
        for( i=argno; i>0; i-- )
        {
            *(base+i)=*(base+i-1);
        }

        *base=slot;
        base->data.block.code(argno+1);
    }
    else
    {
        error_gen("invalid slot type","_method_::eval",base,argno);
    }
}

//--------------------------------------(ismétlõdik c)
void _methodc_::eval(int argno)
{
    //stack: Obj A1 A2... Aargno-1 --- retval
    
    VALUE *base=stack-argno;  //object
    
    if( base->type!=TYPE_OBJECT )
    {
        error_obj(slotname,base,argno);
    }

    //if( base->data.object.subtype!=classid )
    if( !classid )
    {
        findslot(base->data.object.subtype); 
    }
    
    if( slot.type==TYPE_NUMBER )
    {
        //attribútum kiolvasás/felülírás
    
        unsigned int len=OBJECTLEN(base);
        unsigned int idx=(int)slot.data.number;

        if( (idx<1) || (len<idx) )
        {
            error_siz("_method_::eval",base,argno);
        }
    
        VALUE *v=OBJECTPTR(base)+idx-1;

        if( argno>1 ) //beírás
        {
            *v=*(base+1);
        }

        *base=*v;
        stack=base+1;
    }
    else if( slot.type==TYPE_BLOCK )
    {
        //method végrehajtás

        //stack++;
        //memmove(base+1,base,argno*sizeof(VALUE));

        PUSHNIL();
        int i;
        for( i=argno; i>0; i-- )
        {
            *(base+i)=*(base+i-1);
        }

        *base=slot;
        base->data.block.code(argno+1);
    }
    else
    {
        error_gen("invalid slot type","_method_::eval",base,argno);
    }
}

//--------------------------------------(ismétlõdik: p)
void _methodp_::eval(int argno)
{
    //stack: Obj A1 A2... Aargno-1 --- retval
    
    VALUE *base=stack-argno;  //object
    
    if( base->type!=TYPE_OBJECT )
    {
        error_obj(slotname,base,argno);
    }

    //if( base->data.object.subtype!=classid )
    if( !classid )
    {
        findslot(base->data.object.subtype); 
    }
    
    if( slot.type==TYPE_NUMBER )
    {
        //attribútum kiolvasás/felülírás
    
        unsigned int len=OBJECTLEN(base);
        unsigned int idx=(int)slot.data.number;

        if( (idx<1) || (len<idx) )
        {
            error_siz("_method_::eval",base,argno);
        }
    
        VALUE *v=OBJECTPTR(base)+idx-1;

        if( argno>1 ) //beírás
        {
            *v=*(base+1);
        }

        *base=*v;
        stack=base+1;
    }
    else if( slot.type==TYPE_BLOCK )
    {
        //method végrehajtás

        //stack++;
        //memmove(base+1,base,argno*sizeof(VALUE));

        PUSHNIL();
        int i;
        for( i=argno; i>0; i-- )
        {
            *(base+i)=*(base+i-1);
        }

        *base=slot;
        base->data.block.code(argno+1);
    }
    else
    {
        error_gen("invalid slot type","_method_::eval",base,argno);
    }
}

 
//----------------------------------------------------------------------
