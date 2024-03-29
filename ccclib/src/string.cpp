
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

#include <string.h>
#include <cccapi.h>


//------------------------------------------------------------------------
void _clp___maxbinlen(int argno)
{
    stack-=argno;
    number(MAXBINLEN);
}

//------------------------------------------------------------------------
void _clp___maxstrlen(int argno)
{
    stack-=argno;
    number(MAXSTRLEN);
}

//------------------------------------------------------------------------
void string(char const *ptr) //�j p�ld�ny r�mutat�ssal (new n�lk�l)
{
//stack:   --- s

    VARTAB_LOCK();

    OREF *o=oref_new(); 
    o->ptr.chrptr=(char*)ptr;
    o->length=0;              //szem�tgy�jt�s NEM t�rli 
    o->next=NEXT_RESERVED;
 
    VALUE *v=PUSHNIL();
    v->data.string.oref=o;
    STRINGLEN(v)=strlen(ptr);
    v->type=TYPE_STRING;
 
    VARTAB_UNLOCK();
}

//------------------------------------------------------------------------
void stringn(char const *ptr) //�j p�ld�ny m�sol�ssal (new)
{
//stack:   --- s

    VARTAB_LOCK();

    OREF *o=oref_new(); 
    int len=strlen(ptr);
    char *p=newChar(len+1);
    memcpy(p,ptr,len+1);
    o->ptr.chrptr=p;
    o->length=-1;              //szem�tgy�jt�s t�rli
    o->next=NEXT_RESERVED;
 
    VALUE *v=PUSHNIL();
    v->data.string.oref=o;
    STRINGLEN(v)=len;
    v->type=TYPE_STRING;

    VARTAB_UNLOCK();
}

//------------------------------------------------------------------------
void strings(char const *ptr, unsigned long len) //substring kim�sol�sa new-val
{
//stack:   --- s

    if(len>MAXSTRLEN)
    {
        number(len);
        error_cln("strings",stack-1,1);
    }

    VARTAB_LOCK();

    OREF *o=oref_new(); 
    char *p=newChar(len+1);
    memcpy(p,ptr,len);
    *(p+len)=0x00;
    o->ptr.chrptr=p;
    o->length=-1;              //szem�tgy�jt�s t�rli 
    o->next=NEXT_RESERVED;
  
    VALUE *v=PUSHNIL();
    v->data.string.oref=o;
    STRINGLEN(v)=len;
    v->type=TYPE_STRING;

    VARTAB_UNLOCK();
}

//------------------------------------------------------------------------
char *stringl(unsigned long len) //inicializ�latlan string new-val
{
//stack:   --- s
//return: string pointer

    if(len>MAXSTRLEN)
    {
        number(len);
        error_cln("stringl",stack-1,1);
    }

    VARTAB_LOCK();

    OREF *o=oref_new();
    o->ptr.chrptr=newChar(len+1);
    *(o->ptr.chrptr+len)=0x00; 
    o->length=-1;              //szem�tgy�jt�s t�rli  
    o->next=NEXT_RESERVED;
 
    VALUE *v=PUSHNIL();
    v->data.string.oref=o;
    STRINGLEN(v)=len;
    v->type=TYPE_STRING;
 
    VARTAB_UNLOCK();
    return o->ptr.chrptr;
}

//------------------------------------------------------------------------
void stringx(const char *s)
{
    int len=strlen(s)/2;
    char *p=stringl(len);
    int i,j;
    for(i=0,j=0; i<len; i++,j+=2)
    {
        char buf[3];
        buf[0]=s[j];
        buf[1]=s[j+1];
        buf[2]=(char)0;
        *(p+i)=(char)strtoul(buf,0,16);
    }
}

//------------------------------------------------------------------------
//compatibility
void strings(char const *ptr, unsigned int len){ strings(ptr, (unsigned long)len); }
char *stringl(unsigned int len){ return stringl((unsigned long)len); }

//------------------------------------------------------------------------
