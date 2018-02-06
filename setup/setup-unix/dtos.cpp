
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

//------------------------------------------------------------------------
static unsigned int lofm[]={31,28,31,30,31,30,31,31,30,31,30,31};

//------------------------------------------------------------------------
void _clp___num2dat(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
//
    if( base->type==TYPE_NUMBER )
    {
        base->type=TYPE_DATE;
        base->data.date=D2LONG(base->data.number);
    }
    else
    {
        base->type=TYPE_DATE;
        base->data.date=(long)0;
    }
}

//------------------------------------------------------------------------
void _clp___dat2num(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
//
    if( base->type==TYPE_DATE )
    {
        base->type=TYPE_NUMBER;
        base->data.number=base->data.date;
    }
    else
    {
        base->type=TYPE_NUMBER;
        base->data.number=0.;
    }
}

//------------------------------------------------------------------------
static void dtos(long n, char *buf)  
{
// viszony�t�s:  730501 -- 2001.01.01 h�tf�
// 1900 �s 2100 k�z�tt j�, 
// 1900.02.29 �s 2100.02.29 nem l�tezik

    unsigned int y,m;

    if( n==0 )
    {
        //strcpy(buf,"00000000");
        strcpy(buf,"        "); //nem logikus, de ilyen a Clipper!
    }
    else
    {
        y=1+((n-1)/1461)*4;
        n=1+mod(n-1,1461);
     
        if( n<=365 ){}
        else if( n-=365, y++, n<=365 ){}
        else if( n-=365, y++, n<=365 ){}
        else if( n-=365, y++, n<=366 ){}

        lofm[1]=(mod(y,4)==0?29:28);

        m=1;
        while( m<12 && lofm[m-1]<(unsigned int)n )
        {
            n-=lofm[m-1];
            m++;
        }
     
        sprintf(buf,"%04d%02d%02d",y,m,(unsigned int)n);
    }
}     

//------------------------------------------------------------------------
void _clp_dtos(int argno)   //CA-Tools 
{
// stack: d�tum --- yyyymmdd

VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();

    if( base->type!=TYPE_DATE )
    {
        error_arg("dtos",base,1);
    }

    char buf[16];
    dtos(base->data.date,buf);
    stack=base;
    stringn(buf);
}     

//-------------------------------------------------------------------------
long stod(const char *s)  // yyyymmdd --> d�tum
{
    unsigned int y=0,m=0,d=0;

    if( 3!=sscanf(s,"%4d%2d%2d",&y,&m,&d) )
    {
        return 0;
    }

    lofm[1]=(mod(y,4)==0?29:28); //febru�r

    if( m<1 || 12<m || d<1 || lofm[m-1]<d )
    {
        return 0;
    }

    while( --m>0 )
    {  
        d+=lofm[m-1];
    }
    
    return (((long)y-1)/4)*1461 + mod(y-1,4)*365 + d;
}     

//-------------------------------------------------------------------------
void _clp_stod(int argno)  //CA-Tools
{
// stack: yyyymmdd --- d�tum

VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();

    VALUE *v=TOP();
     
    if( (v->type!=TYPE_STRING) || (STRINGLEN(v)!=8) )
    {
        error_arg("stod",base,1);
    }

    long n=stod(STRINGPTR(v));     

    v->type=TYPE_DATE;
    v->data.date=n;
}     


//-------------------------------------------------------------------------
