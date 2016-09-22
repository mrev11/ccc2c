
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

//#include <stdio.h>

#include <math.h>
#include <string.h>
#include <cccapi.h>

//------------------------------------------------------------------------
void _clp_int(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
push_call("int",base);
//
    VALUE *v=base;

    if( v->type==TYPE_NUMBER )
    {
        if( v->data.number>0 )
        {
            v->data.number=floor(v->data.number);
        }
        else
        {
            v->data.number=-floor(-v->data.number);
        }
    }
    else
    {
        error_arg("int",base,1);
    }
//
pop_call();
stack=base+1;
return;
}

//------------------------------------------------------------------------
void _clp_round(int argno)  // optimalizált változat 
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
push_call("round",base);
//
    VALUE *v=base;
    VALUE *d=base+1;

    if( v->type==TYPE_NUMBER && d->type==TYPE_NUMBER )
    {
        static double p[10]={1,10,100,1000,10000,100000,1000000,10000000,100000000,1000000000};
    
        int id=D2INT(d->data.number);
        
        if( id>0 )
        {
            if(id>9) id=9;
            v->data.number=floor(0.5+v->data.number*p[id])/p[id];
        }
        else if( id<0 )
        {
            id=-id; if(id>9) id=9;
            v->data.number=floor(0.5+v->data.number/p[id])*p[id];
        }
        else
        {
            v->data.number=floor(0.5+v->data.number);
        }
    }
    else
    {
        error_arg("round",base,2);
    }
//
pop_call();
stack=base+1;
return;
}

//------------------------------------------------------------------------
#ifdef ROUND_EGYSZERU_VALTOZAT
void _clp_round(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
push_call("round",base);
//
    VALUE *v=base;
    VALUE *d=base+1;

    if( v->type==TYPE_NUMBER && d->type==TYPE_NUMBER )
    {
        double xp=pow(10.,d->data.number);
        v->data.number=floor(0.5+v->data.number*xp)/xp;
    }
    else
    {
        error_arg("round",base,2);
    }
//
pop_call();
stack=base+1;
return;
}
#endif
 
//------------------------------------------------------------------------
