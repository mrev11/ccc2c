
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

function beep()
function console_type(); return "CONSOLE" 
function getkey(w); return inkey(w)
function refreshscrn()
function remote_console(); return "Y" 
function _setsl_incremental(); return .t.


**************************************************************************************
function defaultwindowcaption(c)
static caption:=NIL
local  prevcap:=if(caption==NIL,"",caption)
    if( c==NIL )
        return if(caption==NIL,exename(),caption)
    elseif( valtype(c)=="C" )
        caption:=if(c=="",NIL,c)
    end
    return prevcap


**************************************************************************************
function settermcaption( x:=defaultwindowcaption() )
    return setcaption(x)


**************************************************************************************
