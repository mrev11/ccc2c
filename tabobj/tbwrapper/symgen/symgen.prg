
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

#define LF  chr(10)
#define RET chr(13)
 
****************************************************************************
function main()
local list, n

    set console off
    set printer to ("../symbols.h")
    set printer on

    list:=memoread("symgen.txt")
    list:=strtran(list,RET,"")
    list:=wordlist(list,LF)

    ? "#if GCC_VERSION_MAJOR < 3"

    for n:=1 to len(list)
        if( !empty(list[n]) .and. !";"$list[n] )
            symgen_gcc2( alltrim(list[n]) )
        end
    next

    ? "#else"

    for n:=1 to len(list)
        if( !empty(list[n]) .and. !";"$list[n]  )
            symgen_gcc3( alltrim(list[n]) )
        end
    next

    ? "#endif"
    ?
    return NIL


****************************************************************************
static function symgen_gcc2(s)
    ?  'void _clp_'+s+'(int argno){'
    ?? 'static void *paddr=symload("_clp_'+s+'__Fi");'
    ?? '((void(*)(int))paddr)(argno);}'
    return NIL

****************************************************************************
static function symgen_gcc3(s)
local name:='_clp_'+s
local z:='_Z'+alltrim(str(len(name)))
    ?  'void '+name+'(int argno){'
    ?? 'static void *paddr=symload("'+z+name+'i");'
    ?? '((void(*)(int))paddr)(argno);}'
    return NIL

****************************************************************************
