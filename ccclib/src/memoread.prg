
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

******************************************************************
function memoread(fspec)

local hnd,len,buffer:=""

    if( 0<=(hnd:=fopen(fspec,FO_SHARED)) .and.;
        0<(len:=fseek(hnd,0,FS_END)) .and.;
        len<__maxstrlen() )

        buffer:=space(len)
        fseek(hnd,0)

        if( 0>fread(hnd,@buffer,len) )
            buffer:=""
        end
    end
    fclose(hnd)
    return buffer

******************************************************************
function memowrit(fspec,string)
local hnd:=fcreate(fspec)
local lng:=len(string)

    if( 0<=hnd .and. lng==fwrite(hnd,string,lng) )
        fclose(hnd)
        return .t.
    end
    return .f.

******************************************************************
