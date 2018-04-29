
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
void _clp_alltrim(int argno)
{

// stack: string --- trim(string)

VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();

    VALUE *s=base;
    
    if(  s->type!=TYPE_STRING )
    {
        error_arg("alltrim",base,1);
    }
    
    binarysize_t len=STRINGLEN(s);      //a string hossza

    if( len==0 )
    {
        return;     
    }
    else
    {
        char *p=STRINGPTR(s);
        while( len>0 && *(p+len-1)==' ' )
        {
            --len;
        }
        while( len>0 && *p==' ' )
        {
            ++p;
            --len;
        }
        strings(p,len);
        RETURN(base);
    }
}

//------------------------------------------------------------------------
void _clp_ltrim(int argno)
{

// stack: string --- trim(string)

VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();

    VALUE *s=base;
    
    if(  s->type!=TYPE_STRING )
    {
        error_arg("ltrim",base,1);
    }
    
    binarysize_t len=STRINGLEN(s);      //a string hossza

    if( len==0 )
    {
        return;     
    }
    else
    {
        char *p=STRINGPTR(s);

        while( len>0 && *p==' ' )
        {
            ++p;
            --len;
        }
        strings(p,len);
        RETURN(base);
    }
}


//------------------------------------------------------------------------
void _clp_rtrim(int argno)
{

// stack: string --- trim(string)

VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();

    VALUE *s=base;
    
    if(  s->type!=TYPE_STRING )
    {
        error_arg("rtrim",base,1);
    }
    
    binarysize_t len=STRINGLEN(s);      //a string hossza

    if( len==0 )
    {
        return;     
    }
    else
    {
        char *p=STRINGPTR(s);
        while( len>0 && *(p+len-1)==' ' )
        {
            --len;
        }
        strings(p,len);
        RETURN(base);
    }
}

//------------------------------------------------------------------------
void _clp_trim(int argno)
{
    _clp_rtrim(argno);
}

//------------------------------------------------------------------------
