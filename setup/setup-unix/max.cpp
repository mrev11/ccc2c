
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
void _clp_min(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
push_call("min",base);
//
    VALUE *x1=base;
    VALUE *x2=base+1;

    if( x1->type==TYPE_NUMBER && x2->type==TYPE_NUMBER )
    {
        x1->data.number=min(x1->data.number,x2->data.number);
    }
    else if( x1->type==TYPE_DATE && x2->type==TYPE_DATE )
    {
        x1->data.date=min(x1->data.date,x2->data.date);
    }
    else
    {
        error_arg("min",base,2);
    }
//
pop_call();
stack=base+1;
return;
}

//------------------------------------------------------------------------
void _clp_max(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
push_call("max",base);
//
    VALUE *x1=base;
    VALUE *x2=base+1;

    if( x1->type==TYPE_NUMBER && x2->type==TYPE_NUMBER )
    {
        x1->data.number=max(x1->data.number,x2->data.number);
    }
    else if( x1->type==TYPE_DATE && x2->type==TYPE_DATE )
    {
        x1->data.date=max(x1->data.date,x2->data.date);
    }
    else
    {
        error_arg("max",base,2);
    }
//
pop_call();
stack=base+1;
return;
}

//------------------------------------------------------------------------
