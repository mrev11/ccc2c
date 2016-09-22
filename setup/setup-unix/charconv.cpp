
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

//---------------------------------------------------------------------
void charconv_string(int tab, char *buf, unsigned int len)
{
    char *t=charconv_selecttab(tab);
    if( t )
    {
        unsigned int n;
        for(n=0; n<len; n++)
        {
            buf[n]=t[255&buf[n]];
        }
    }
}

//---------------------------------------------------------------------
int charconv_char(int tab, int c)
{
    char *t=charconv_selecttab(tab);
    return t ? t[255&c] : c;
}


//---------------------------------------------------------------------
void charconv_top(int tab)
{
    VALUE *s=TOP();
    unsigned int len=STRINGLEN(s);
    if( len>0 )
    {
        strings(STRINGPTR(s),len);
        charconv_string(tab,STRINGPTR(TOP()),len);
        *TOP2()=*TOP();
        POP();
    }
}

//---------------------------------------------------------------------
void _clp__charconv(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
//
    VALUE *s=base;
    VALUE *t=base+1;
    
    if( s->type!=TYPE_STRING )
    {
        error_arg("_charconv",base,2);
    }
    if( t->type!=TYPE_NUMBER )
    {
        error_arg("_charconv",base,2);
    }
    
    int tab=D2INT(t->data.number);
    POP();
    charconv_top(tab);
}

//---------------------------------------------------------------------
