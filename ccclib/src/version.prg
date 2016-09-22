
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

#define VERDATE   "2.3.03 (2007.02.12)"

#define VERSION   ver_ccclib
#define VERTEXT   txt_ccclib
#define VERFILE   "VERSION.CCC"


#ifdef MSVC
#define VERNAME   "windows-msc"
#endif

#ifdef MINGW
#define VERNAME   "windows-mng"
#endif

#ifdef WATCOM
#define VERNAME   "windows-wat"
#endif

#ifdef BORLAND
#define VERNAME   "windows-bor"
#endif

#ifdef _LINUX_
#define VERNAME   "linux"
#endif

#ifdef _FREEBSD_
#define VERNAME   "freebsd"
#endif

#ifdef _NETBSD_
#define VERNAME   "netbsd"
#endif

#ifdef _SOLARIS_
#define VERNAME   "solaris"
#endif
 
#ifndef VERNAME
#define VERNAME   "unknown"
#endif

#include "set.ch"

***************************************************************************
function VERSION()

static flag
local oldfile, oldonoff

    if( flag==NIL )
        flag:=.t.

        if( "on"$lower(getenv("GETVERSION")) )

            oldfile:=set(_SET_ALTFILE,VERFILE,.t.)
            oldonoff:=set(_SET_ALTERNATE,.t.) 

            ? padr(VERNAME,12), padr(VERDATE,24), exename()

            set(_SET_ALTFILE,oldfile,.t.) 
            set(_SET_ALTERNATE,oldonoff)
        end
    end

    return NIL


***************************************************************************
function VERTEXT()
    return VERNAME+" "+VERDATE


***************************************************************************
