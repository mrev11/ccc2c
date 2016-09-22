
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
#include <fileconv.ch>

//-----------------------------------------------------------------------------
void _clp_getenv(int argno)  //Clipper
{
    CCC_PROLOG("getenv",1);
    if( DOSCONV & DOSCONV_ENVVAR2UPPER )
    {
        _clp_upper(1);
    }
    const char *var=_parc(1); //-Wno-nonnull
    const char *env=getenv(var); 
    _retc( env?env:"" );
    CCC_EPILOG();
}

//-----------------------------------------------------------------------------
void _clp_putenv(int argno) //nincs NG-ben,  putenv("ID=value")
{
    CCC_PROLOG("putenv",1);

    char *str=_parc(1);
    char *equ=NULL;
              
    if( (_parclen(1)==0) || (NULL==(equ=strchr(str,'='))) )
    {
        _retl(0); //nem megfelel� form�tum
    }

    else if( *(equ+1) ) //set, ha NEM '=' az utols� karakter
    {
        strings(str,equ-str);
        if( DOSCONV & DOSCONV_ENVVAR2UPPER )
        {
            _clp_upper(1);
        }
        stringn(equ);
        add();
        //printf("\n[%s]",STRINGPTR(TOP()));
        _retl( putenv(strdup(STRINGPTR(TOP())))==0 );
        
        //A manpage nem �r semmit arr�l, hogy putenv/setenv k�sz�t-e
        //m�solatot az argumentum�r�l. Az OpenLinux 2.2, Corel Linux,
        //Debian-slink k�sz�t, azonban a SuSE 6.3 NEM! �gy SuSE 6.3
        //alatt a szem�tgy�jt�s letakar�tja azt a stringet, amit
        //putenv-nek megadtunk, ez�rt azt strdup-pal le kell m�solni.
        //Sajnos �gy mem�ria z�rv�nyok keletkeznek. NT-n is �gy van.
    }

    else //unset, ha '=' az utols� karakter 
    {          
        strings(str,equ-str);
        if (DOSCONV & DOSCONV_ENVVAR2UPPER)
        {
            _clp_upper(1);
        }

        //printf("\n[%s]",STRINGPTR(TOP()));

        #if defined _SOLARIS_
          stringn("=");
          add();
          _retl( putenv(strdup(STRINGPTR(TOP())))==0 );

        #elif defined _LINUX_
          unsetenv( STRINGPTR(TOP()) ); //void!
          _retl( 1 );

        #elif defined _FREEBSD_
          unsetenv( STRINGPTR(TOP()) ); //void!
          _retl( 1 );

        #else  // _NETBSD_
          unsetenv( STRINGPTR(TOP()) ); //void!
          _retl( 1 );
        #endif
    }
 
    CCC_EPILOG();    
}

//-----------------------------------------------------------------------------
void _clp_environment(int argno) //eg�sz k�rnyezet
{
    CCC_PROLOG("environment",0);
    extern char **environ;
    char **env=environ;
    int n=0;
    while( *env )
    {
        stringn(*env);
        n++;
        env++;
    }
    array(n);
    _rettop();
    CCC_EPILOG();
}
 
//-----------------------------------------------------------------------------

