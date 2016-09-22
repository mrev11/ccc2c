
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

#include <direct.h>
#include <cccapi.h>

extern void _clp_diskname(int argno);
extern void _clp_diskchange(int argno);
extern void _clp_varstack(int argno);
 
//------------------------------------------------------------------------
void _clp_curdir(int argno)
{
    CCC_PROLOG("curdir",1);
    
    int diskchg=0;
    int success=1;
  
    if( ISSTRING(1) )
    {
        _clp_diskname(0);
        swap();
        _clp_diskchange(1);
        diskchg=1;
        success=flag();
    }

    //stack: DISK/NIL
    
    char buf[1024];
    if( success && _getcwd(buf,1023) )
    {
        stringn(buf+3); //OK 
    }
    else
    {
        string(""); //HIBA 
    }
    
    if( diskchg && success )
    {
        swap();
        _clp_diskchange(1);
        POP();
    }

    _rettop();
 
    CCC_EPILOG();
}

//------------------------------------------------------------------------
void _clp_diskname(int argno) //CA-TOOLS diskname()
{
    stack-=argno;
    char buf[1024];
    _getcwd(buf,1023);
    buf[1]=0x00; 
    stringn(buf);
}

//------------------------------------------------------------------------

