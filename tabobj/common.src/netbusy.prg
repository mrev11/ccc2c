
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

// Vermes M. 1993.09.16

************************************************************************
// Visszaad egy kodblokkot, amit egy sikertelen rlock hajthat vegre.
//
function busyRecord()
    return {||alert(@"Record lock failed!",{@"Quit"}),.f.}

************************************************************************
// Visszaad egy kodblokkot, amit egy sikertelen append hajthat vegre.
//
function busyFile(fname)
local fn:=if(!empty(fname),": "+fname,"!")
    return {||alert(@"File lock failed"+fn,{@"Quit"}),.f.}

************************************************************************
