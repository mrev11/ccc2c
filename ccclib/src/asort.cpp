
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
#include <stdlib.h>
#include <cccapi.h>

extern void valuemove(VALUE *to, VALUE *fr, int n);
extern void valuesort(VALUE *, int);
extern int  valuecompare(const void *x, const void *y);
 

//------------------------------------------------------------------------
void _clp_asort(int argno) // asort(arr,[st],[cn],[blk])
{
VALUE *base=stack-argno;
stack=base+min(argno,4);
while(stack<base+4)PUSHNIL();
push_call("asort",base);
//
    VALUE *a=base;     
    VALUE *s=base+1;     
    VALUE *c=base+2;     
    VALUE *b=base+3;     

    if( a->type!=TYPE_ARRAY )
    {
        error_arg("asort",base,4);
    }
    
    if( s->type==TYPE_NIL )
    {
        *s=ONE;
    }

    if( c->type==TYPE_NIL )
    {
        push_symbol(a);
        _clp_len(1);
        *c=*TOP();
        POP();
    }

    if( b->type==TYPE_NIL )
    {
        _clp__asort_ascendblock(0);
        *b=*TOP();
        POP();
    }

    if( s->type!=TYPE_NUMBER ||  c->type!=TYPE_NUMBER || b->type!=TYPE_BLOCK )
    {
        error_arg("asort",base,4);
    }

    unsigned int len=ARRAYLEN(a);
    unsigned int st=D2INT(s->data.number);
    unsigned int cn=D2INT(c->data.number);
    VALUE *p=ARRAYPTR(a);

    push_symbol(b); 
    // qsort alatt az �sszehasonl�t� block van a stack tetej�n,
    // ezt a compare haszn�lja k�t array elem �sszehasonl�t�s�ra

    //debug("qsort h�v�s el�tt");
    //qsort(p+st-1,min(cn,len-st+1),sizeof(VALUE),valuecompare);
    valuesort(p+st-1,min(cn,len-st+1));
    //debug("qsort h�v�s ut�n");
//
*base=*a;
stack=base+1;
pop_call();
}

//------------------------------------------------------------------------
int valuecompare(const void *x, const void *y)
{
#ifdef MULTITHREAD
    //Mik�zben qsort megh�vja az �sszehasonl�t�st,
    //engedni kell a szem�tgy�jt�st, m�sk�l�nben deadlock keletkezik,
    //ha az �sszehasonl�t� bokkban objektumok is k�sz�lnek.
    if( thread_data::tdata_count>1 )    
    {
        thread_data_ptr->unlock();
    }
#endif    

    SIGNAL_UNLOCK();
    
    //TOP=�sszehasonl�t� block
    //stack v�ltozatlan marad

    // Az �sszehasonl�t�st k�t ir�nyban is el kell v�gezni,
    // hogy detekt�lhat� legyen az egyenl� eset. A Clipperben
    // megadhat� k�dblock nem szimmetrikus (csak T/F-et ad),
    // �s ez�rt az egyen� elemeket tartalmaz� array-re a qsort
    // nem mindig tud lefutni, ha csak -1/1-et adogatunk neki.
    // �gy is baj lehet a Clipper string �sszehasonl�tasa miatt.

    //egyik ir�ny
    DUP();
    push_symbol((VALUE*)x);
    push_symbol((VALUE*)y);
    _clp_eval(3);
    int f1=flag();

    //m�sik ir�ny
    DUP();
    push_symbol((VALUE*)y);
    push_symbol((VALUE*)x);
    _clp_eval(3);
    int f2=flag();

    SIGNAL_LOCK();

#ifdef MULTITHREAD
    if( thread_data::tdata_count>1 )    
    {
        thread_data_ptr->lock();
    }
#endif    

    return (f1==f2)?0:(f1?-1:1);
}

//------------------------------------------------------------------------

