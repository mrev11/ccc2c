
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
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#ifdef WIN32
    #include <direct.h>
#endif
 
#include <cccapi.h>

//------------------------------------------------------------------------
void _clp_file(int argno)  //Clipper
{
    CCC_PROLOG("file",1);
    if( !ISSTRING(1) )
    {
        ARGERROR();
    }
    
    if( _parclen(1)==0 )
    {
        _retl(0);
    }
    else
    {
        _clp_directory(1);
        _clp_empty(1);
        _retl(!flag());
    }
    CCC_EPILOG();
}

//------------------------------------------------------------------------
void _clp_ferase(int argno) //Clipper
{
    CCC_PROLOG("ferase",1);
    _clp_convertfspec2nativeformat(1);
    errno=0;   
    _retni( remove(_parc(1)) );
    CCC_EPILOG();
}    

//------------------------------------------------------------------------
void _clp_frename(int argno) //Clipper
{
    CCC_PROLOG("frename",2);
    _clp_convertfspec2nativeformat(1); swap();
    _clp_convertfspec2nativeformat(1); swap();
    errno=0;   
    _retni( rename(_parc(1),_parc(2)) );
    CCC_EPILOG();
}    

//------------------------------------------------------------------------
void _clp_dirmake(int argno) //CA-tools
{
    CCC_PROLOG("dirmake",1);
    _clp_convertfspec2nativeformat(1);
    errno=0;
    char *dir=_parc(1);
#ifdef _UNIX_
    _retni( mkdir(dir,0777) );  //0777-et korlátozza umask
#else
    _retni( mkdir(dir) );
#endif
    CCC_EPILOG();
}

//------------------------------------------------------------------------
void _clp_dirremove(int argno) //CA-tools 
{
    CCC_PROLOG("dirremove",1);
    _clp_convertfspec2nativeformat(1); 
    errno=0;   
    char *dir=_parc(1);
    _retni( rmdir(dir) );
    CCC_EPILOG();
}    

//------------------------------------------------------------------------
void _clp_dirchange(int argno) //CA-tools  
{
    CCC_PROLOG("dirchange",1);
    _clp_convertfspec2nativeformat(1);
    errno=0;   
    char *dir=_parc(1);
    _retni( chdir(dir) );
    CCC_EPILOG();
}

//------------------------------------------------------------------------
void _clp_diskchange(int argno) //CA-tools  

//A korábbi változat visszatérése tévesen a hibakód volt,
//holott a Clipper t/f-et ad (kipróbálva, NG-ben ellenôrizve).

{
    CCC_PROLOG("diskchange",1);
#ifdef _UNIX_
    errno=-1;
    _retl( 0 ); // unix-on sikertelen
#else
    _clp_upper(1);
    _clp_asc(1);
    int drv=_parni(1)-'A'+1;
    errno=0;
    _retl( 0==_chdrive(drv) );
#endif    
    CCC_EPILOG();
}

//------------------------------------------------------------------------
void _clp_deletefile(int argno)  //CA-tools
{
    CCC_PROLOG("deletefile",1);
    _clp_convertfspec2nativeformat(1);
    errno=0;   
    _retni( remove(_parc(1)) );
    CCC_EPILOG();
}

//----------------------------------------------------------------------------

