
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

#include "fileio.ch"


*************************************************************************
function _clp_filecopy(xf1,xf2) // CA-TOOLS függvény
local f1:=convertfspec2nativeformat(xf1)
local f2:=convertfspec2nativeformat(xf2)
local ok:=__copyfile(f1,f2) //Win32 API hívás
local result:=if(ok,filesize(f2),-1)
    ferror(if(ok,0,-1)) //errno beállítása
    return result //ez már nem állítja át errno-t


*************************************************************************
function filemove(xf1,xf2)  //CA-TOOLS függvény
local f1:=convertfspec2nativeformat(xf1)
local f2:=convertfspec2nativeformat(xf2)
    return frename(f1,f2)


*************************************************************************
