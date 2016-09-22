
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

#include <cccapi.h>

//------------------------------------------------------------------------
void _clp_valtype(int argno)
{
    VALUE *base=stack-argno;

    if( argno<1 )
    {
        PUSHNIL();
    }
    
    const char *vtype="U";

    switch( base->type )
    {
        case TYPE_NIL:
            vtype="U";
            break;

        case TYPE_NUMBER:
            vtype="N";
            break;

        case TYPE_STRING:
            vtype="C";
            break;

        case TYPE_FLAG:
            vtype="L";
            break;

        case TYPE_DATE:
            vtype="D";
            break;

        case TYPE_POINTER:
            vtype="P";
            break;

        case TYPE_ARRAY:
            vtype="A";
            break;

        case TYPE_BLOCK:
            vtype="B";
            break;

        case TYPE_OBJECT:
            vtype="O";
            break;
    }
    
    stack=base;
    string(vtype);
}

//------------------------------------------------------------------------
