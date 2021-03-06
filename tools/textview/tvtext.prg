
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
function textview.text(this,x)
    if( x!=NIL )
        this:_text_:=str2bin(x)
        this:setpos(1)
    end
    return this:_text_


********************************************************************************************
function textview.eolpos(this,n)
    return this:atxt[n]


********************************************************************************************
function textview.bolpos(this,n)
    if( this:atxt[n]!=NIL )
        if( n>1 .and. this:atxt[n-1]!=NIL )
            return this:atxt[n-1]+1
        end
        return rat(bin(10),this:text,this:atxt[n]-1)+1
    end


********************************************************************************************
function textview.line(this,n)
local p1:=this:bolpos(n)
local p2:=this:eolpos(n)
    if( p1==NIL .or. p2==NIL )
        return ""
    end
    p2-- //x"0a"
    if( p1<=p2 .and. this:text[p2]==x"0d" )
        p2--
    end
    return this:text[p1..p2]::bin2str


********************************************************************************************
function textview.linex(this,n)
local p1:=this:bolpos(n)
local p2:=this:eolpos(n)
    if( p1==NIL .or. p2==NIL )
        return ""
    end
    return this:text[p1..p2]


********************************************************************************************
