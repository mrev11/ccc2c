
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
//#include <wchar.h>
#include <cccapi.h>

//----------------------------------------------------------------------------
void _clp_replicate(int argno)
{
    CCC_PROLOG("replicate",2);

    unsigned long slen=_parclen(1);
    unsigned rlen=max(0,_parni(2));

    if( slen>1 && (double)slen*(double)rlen>(double)MAXSTRLEN )
    {
        error_cln("replicate",base,2);
    }

    char *p=stringl(slen*rlen);
    char *sp=_parc(1);

    if( slen==1 )
    {
        memset(p,*sp,rlen);
    }
    else
    {
        while( 0<rlen-- )
        {
            memcpy(p,sp,slen);
            p+=slen;            
        }
    }
    _rettop();
    CCC_EPILOG();
}

//----------------------------------------------------------------------------
void _clp_space(int argno)
{
    CCC_PROLOG("space",1);
    unsigned len=max(0,_parni(1));
    char *p=stringl(len);
    memset(p,' ',len);
    _rettop();
    CCC_EPILOG();
}

//----------------------------------------------------------------------------
