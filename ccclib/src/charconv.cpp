
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
#include <stdio.h>
#include <charconv.ch>
#include <chartab.h>
#include <cccapi.h>

#define VARSTACK(x)  //(printf("\n\n### varstack-%d",x),_clp_varstack(0),pop(),fflush(0))

//---------------------------------------------------------------------
char *charconv_selecttab(int tab)
{
    switch( tab )
    {
        case CHARTAB_CCC2CWI      : return chartab_ccc2cwi;
        case CHARTAB_CWI2CCC      : return chartab_cwi2ccc;
        case CHARTAB_CCC2LAT      : return chartab_ccc2lat;
        case CHARTAB_LAT2CCC      : return chartab_lat2ccc;
        case CHARTAB_CCC2WIN      : return chartab_ccc2win;
        case CHARTAB_LOWER2UPPER  : return chartab_lower2upper;  //ékezetes!
        case CHARTAB_UPPER2LOWER  : return chartab_upper2lower;  //ékezetes! 
        default                   : return NULL;
    }
}    

//---------------------------------------------------------------------
void charconv_top(int tab)
{
    VARSTACK(0);

    char *t=charconv_selecttab(tab);
    if( t==0 )
    {
        return;
    }
    unsigned int len=STRINGLEN(TOP());
    if( len==0 )
    {
        return;
    }
   
    char *source=STRINGPTR(TOP());
    stringl(len);
    VARSTACK(1);
    char *destin=STRINGPTR(TOP());
    for(unsigned n=0; n<len; n++)
    {
        destin[n]=t[255&source[n]];
    }
    VARSTACK(2);
    *TOP2()=*TOP();
    POP();

    VARSTACK(3);
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
