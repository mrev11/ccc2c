
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
void _clp_asc(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_STRING) )
    {
        error_arg("asc",base,argno);
    }
    int c=0;
    if( 0<STRINGLEN(base) )
    {
        c=(int)*(unsigned char *)(STRINGPTR(base));
    }
    stack=base;
    number(c);
}

//------------------------------------------------------------------------
void _clp_chr(int argno)
{
    VALUE *base=stack-argno;
    if( (argno<1) || (base->type!=TYPE_NUMBER) )
    {
        error_arg("chr",base,argno);
    }
    char c=(char)(int)(base->data.number); 

    stack=base;
    char *p=stringl(1);
    *p=c;
    *(p+1)=0x00;
}

//------------------------------------------------------------------------
