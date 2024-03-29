
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

********************************************************************************************
function textview.display(this)

local n

    dispbegin()
    for n:=1 to this:height
        this:displine(n)
    next 
    dispend()


********************************************************************************************
function textview.displine(this,n)

local text:=this:line(n)
local row:=this:top+n-1
local col:=this:left
local tbeg:=this:sftcol+1
local twid:=this:width
local color:=this:txtcolor
local pos:=0,c,lss,tss

    text::=substr(tbeg,twid)::padr(twid)

    @ row,col SAY text COLOR color

    //kiemeli a search stringet (elhagyhato)

    while( !empty(this:searchstring) .and. ;
           0<(pos:=at(this:searchstring,this:line(n),pos+1)) )

        tss:=this:searchstring
        lss:=this:searchstring::len

        if( pos<tbeg )
            c:=col
            tss::=substr(tbeg-pos+1)::left(twid)
        else
            c:=col+pos-tbeg
            tss::=left(twid-(c-col) )
        end
        @ row,c SAY tss COLOR color::logcolor(2)
    end


********************************************************************************************
