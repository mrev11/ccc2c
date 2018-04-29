
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
#include <ctype.h>
#include <cccapi.h>

//------------------------------------------------------------------------
void _clp_isalnum(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("isalnum",base,argno);
    }
    int flag=0;
    if( 0<STRINGLEN(base) )
    {
        flag=isalnum(*(STRINGPTR(base)));
    }
    stack=base;
    logical(flag);
}

//------------------------------------------------------------------------
void _clp_isalpha(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("isalpha",base,argno);
    }
    int flag=0;
    if( 0<STRINGLEN(base) )
    {
        flag=isalpha(*(STRINGPTR(base)));
    }
    stack=base;
    logical(flag);
}
 
//------------------------------------------------------------------------
void _clp_isdigit(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("isdigit",base,argno);
    }
    int flag=0;
    if( 0<STRINGLEN(base) )
    {
        flag=isdigit(*(STRINGPTR(base)));
    }
    stack=base;
    logical(flag);
}

//------------------------------------------------------------------------
void _clp_isxdigit(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("isxdigit",base,argno);
    }
    int flag=0;
    if( 0<STRINGLEN(base) )
    {
        flag=isxdigit(*(STRINGPTR(base)));
    }
    stack=base;
    logical(flag);
}
 
//------------------------------------------------------------------------
void _clp_isupper(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("isupper",base,argno);
    }
    int flag=0;
    if(  0<STRINGLEN(base) )
    {
        flag=isupper(*(STRINGPTR(base)));
    }
    stack=base;
    logical(flag);
}

//------------------------------------------------------------------------
void _clp_islower(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("islower",base,argno);
    }
    int flag=0;
    if( 0<STRINGLEN(base) )
    {
        flag=islower(*(STRINGPTR(base)));
    }
    stack=base;
    logical(flag);
}

//------------------------------------------------------------------------
void _clp_iscntrl(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("iscntrl",base,argno);
    }
    int flag=0;
    if( 0<STRINGLEN(base) )
    {
        flag=iscntrl(*(STRINGPTR(base)));
    }
    stack=base;
    logical(flag);
}

//------------------------------------------------------------------------
void _clp_isbinary(int argno) //bináris <--> tartalmaz cntrl karaktert
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("isbinary",base,argno);
    }
    int flag=0; unsigned i;
    for( i=0; i<STRINGLEN(base); i++ )
    {
        if( iscntrl(*(STRINGPTR(base)+i)) )
        {
            flag=1;
            break;
        }
    }
    stack=base;
    logical(flag);
}
 
//------------------------------------------------------------------------
