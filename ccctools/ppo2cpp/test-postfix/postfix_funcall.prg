
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

#define FNAME1(x) strtran(atail(split(x,dirsep())),".ogg","")
#define FNAME2(x) (x)::split(dirsep())::atail::strtran(".ogg","")

#define FORMAT1(x) padl(alltrim(str(x)),10,"0")
#define FORMAT2(x) (x)::str::alltrim::padl(10,"0")

***************************************************************************
function main(*)

local oggfile:="/home/vermes/zene/wagner/walkur_1.ogg"

local blk1:={|x|FORMAT1(x)}
local blk2:={|x|FORMAT2(x)}

    ? FNAME1(oggfile)
    ? FNAME2(oggfile)
    ? eval(blk1,123)
    ? eval(blk2,123)
    ? 

    ? hohoNew("HoHo"):padr(10,"x"):upper:cdata //metódushívások!
    ?

    NIL::params(1,2,3)
    params(*)
    params(*,1,*)
    NIL::params(*)
    ?

    //preprocesszor!
    //precedencia!
    ? "1"+2::str()::alltrim()
    ? (1+2)::str()::alltrim()
    ?

***************************************************************************
static function params(*)
    ? "params",{*}

***************************************************************************
class hoho(object)
    attrib  cdata
    method  initialize  {|this,x| this:cdata:=x,this}
    method  padr        {|this,w,p| w::params(*), this:cdata:=this:cdata::.padr(w,p),this}
    method  upper       {|this| params(*,"!",*), this:cdata:=this:cdata::.upper,this}

***************************************************************************
    