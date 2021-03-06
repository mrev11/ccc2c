
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

#include <math.h>
#include <string.h>
#include <cccapi.h>

//------------------------------------------------------------------------
void power()
{
// stack: a,x --- a^x

    VALUE *x=TOP();
    VALUE *a=TOP2();

    if( a->type==TYPE_NUMBER && x->type==TYPE_NUMBER )
    {
        double da=a->data.number;
        double dx=x->data.number;

        if( da>0 )
        {
            a->data.number=pow(da,dx);
            stack=x;
            return;
        }
    }
    error_arg("power",a,2);
}

//------------------------------------------------------------------------
void _clp_exp(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
push_call("exp",base);
//
    VALUE *v=base;

    if( v->type==TYPE_NUMBER )
    {
        v->data.number=exp(v->data.number);
    }
    else
    {
        error_arg("exp",base,1);
    }

//
pop_call();
stack=base+1;
return;
}

//------------------------------------------------------------------------
void _clp_log(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
push_call("log",base);
//
    VALUE *v=base;

    if( v->type==TYPE_NUMBER && v->data.number>0 )
    {
        v->data.number=log(v->data.number);
    }
    else
    {
        error_arg("log",base,1);
    }

//
pop_call();
stack=base+1;
return;
}

//------------------------------------------------------------------------
void _clp_sqrt(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
push_call("sqrt",base);
//
    VALUE *v=base;

    if( v->type==TYPE_NUMBER && v->data.number>0 )
    {
        v->data.number=sqrt(v->data.number);
    }
    else
    {
        error_arg("sqrt",base,1);
    }

//
pop_call();
stack=base+1;
return;
}

//------------------------------------------------------------------------

