
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

// a konyvtar verzio fuggvenye
// minden konyvtar tartalmaz ilyen fuggvenyt,
// hogy az alkalmazas komponensei azonosithatok legyenek

#define VERSION   ver_dbtable
#define VERNAME   "dbtable"

#include "btbtx.ver"
#include "set.ch"

***************************************************************************
function VERSION()

static flag
local oldfile, oldonoff

    if( flag==NIL )
        flag:=.t.

        if( "on"$lower(getenv("GETVERSION")) )

            oldfile:=set(_SET_ALTFILE,"version.",.t.)
            oldonoff:=set(_SET_ALTERNATE,.t.) 

            ? padr(VERNAME,12), padr(VERDATE,24), exename()

            set(_SET_ALTFILE,oldfile,.t.) 
            set(_SET_ALTERNATE,oldonoff)
        end
    end

    return NIL

***************************************************************************
