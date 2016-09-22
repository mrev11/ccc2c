
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


#define MAXFIELD  1024

typedef struct
{
  char  *alias;    //alias nev
  char  *field;    //mezo nev
  VALUE codeblk;   //oszlop blokk
  long  ninsert;   //ellenorzo szam
} FIELDREF;

static FIELDREF ftab[MAXFIELD];
static long ninsert=0;
static int lastpos=0;
static int initflag=0;


//----------------------------------------------------------------------
void _clp__field_insert(int argno)
{
    CCC_PROLOG("_field_insert",3);
    
    //printf("\n_field_insert");getchar();
    
    if( !initflag )
    {
        memset(ftab,0,sizeof(ftab));
        initflag=1;
    }
    
    if( 0==++ninsert )
    {
        ninsert++;
    }
    
    int n=lastpos;
    while( ftab[n].ninsert )
    {
        if( MAXFIELD<=++n ) n=0;
        if( n==lastpos ) {printf("\nftab overflow");exit(1);}
    }
    lastpos=n;

    //printf("\n %d %d %s %s",lastpos,ninsert,_parc(1),_parc(2)); //getchar();

    ftab[n].alias   = _parc(1);
    ftab[n].field   = _parc(2);
    ftab[n].codeblk = *PARPTR(3);
    ftab[n].ninsert = ninsert;
    
    _ret();
    CCC_EPILOG();
}


//----------------------------------------------------------------------
void _clp__field_delete(int argno)
{
    CCC_PROLOG("_field_delete",1);
    char *alias=_parc(1);
    int n;
    
    //printf("\n _field_delete:%s",alias);getchar();
    
    if( initflag )
    {
        for(n=0; n<MAXFIELD; n++)
        {
            if( (ftab[n].alias!=NULL)  && (0==stricmp(ftab[n].alias,alias)) )
            {
                ftab[n].alias   = NULL;
                ftab[n].field   = NULL;
                ftab[n].ninsert = 0;
            }
        }
    }
    _ret();
    CCC_EPILOG();
}


//----------------------------------------------------------------------
static void fsearch_error(const char*alias, const char*field)
{
    extern void _clp_taberroperation(int);  
    extern void _clp_taberrdescription(int);  
    extern void _clp_taberrargs(int);  
    extern void _clp_taberror(int);  
    
    string("Invalid field reference"); _clp_taberrdescription(1); pop();
    string("dbfield:fsearch"); _clp_taberroperation(1); pop();
    stringn(alias); stringn(field); array(2); _clp_taberrargs(1);pop();
    _clp_taberror(0); pop();
}


//----------------------------------------------------------------------
#ifndef CLASS_DBFIELD

class dbfield
{
    const char *alias;
    const char *field;
    int  ftabidx;
    int  ninsert;
    void fsearch(void);

  public:
    dbfield(char*a,char*f);
    dbfield(const char*a,const char*f);
    void fget(void);
    void fput(void);
};

#define CLASS_DBFIELD
#endif


//----------------------------------------------------------------------
dbfield::dbfield(char*a, char*f)
{
    ftabidx=-1;
    alias=(const char*)a;
    field=(const char*)f;

    //printf("\nconstructed: %s->%s",a,f);flushall();
};

//----------------------------------------------------------------------
dbfield::dbfield(const char*a, const char*f)
{
    ftabidx=-1;
    alias=a;
    field=f;

    //printf("\nconstructed: %s->%s",a,f);flushall();
};

//----------------------------------------------------------------------
void dbfield::fsearch(void)
{
    //printf("\nfsearch");getchar();

    ftabidx=-1;
    int n;

    if( initflag )
    {
        for(n=0; n<MAXFIELD; n++)
        {
            //printf("\nfsearch %d %s %s %s %s",
            //       n,
            //       alias,
            //       field,
            //       (ftab[n].alias?ftab[n].alias:"????"),
            //       (ftab[n].field?ftab[n].field:"????") );
            //getchar();
        
            if( ftab[n].alias && (stricmp(ftab[n].alias,alias)==0) &&
                ftab[n].field && (stricmp(ftab[n].field,field)==0) )
            {
                ftabidx=n;
                ninsert=ftab[n].ninsert;
                return;
            }
        }
    }
    
    fsearch_error(alias,field);
}


//----------------------------------------------------------------------
void dbfield::fget(void)  //stack:   --- value
{
    //printf("\nfget");getchar();

    if( (ftabidx<0) || ftab[ftabidx].ninsert!=ninsert )
    {
        fsearch();
    }
    PUSH(&ftab[ftabidx].codeblk);
    _clp_eval(1);
}


//----------------------------------------------------------------------
void dbfield::fput(void)  //stack: value --- value
{
    //printf("\nfput");getchar();

    if( (ftabidx<0) || ftab[ftabidx].ninsert!=ninsert )
    {
        fsearch();
    }
    
    //printf("\n %s %s ",ftab[ftabidx].alias,ftab[ftabidx].field);flushall();
    
    DUP();
    *TOP2()=ftab[ftabidx].codeblk;
    _clp_eval(2);

}

//----------------------------------------------------------------------
