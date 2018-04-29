
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


//------------------------------------------------------------------------
void _clp_getenv(int argno)
{
    CCC_PROLOG("getenv",1);
    const char *env=getenv(_parc(1)); 
    _retc( env?env:"" );
    CCC_EPILOG();
}

//------------------------------------------------------------------------
void _clp_putenv(int argno) //putenv("ID=value")
{
    CCC_PROLOG("putenv",1);
    _retl( putenv(strdup(_parc(1))) );
    CCC_EPILOG();
}

//------------------------------------------------------------------------
void _clp_environment(int argno) //egész környezet
{
    CCC_PROLOG("environment",0);
    char *env=GetEnvironmentStrings();
    int n=0;
    int len=strlen(env);
    while( len )
    {
        stringn(env);
        n++;
        env+=len+1;
        len=strlen(env);
    }
    array(n);
    _rettop();
    CCC_EPILOG();
}
 
//------------------------------------------------------------------------
