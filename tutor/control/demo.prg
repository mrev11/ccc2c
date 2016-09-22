
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

#include "radio.say"
 

******************************************************************************
function main()
    radio({|g|load(g)},{|g|readmodal(g)},{|g|store(g)})
    return NIL


******************************************************************************
static function load(getlist)

local g1:={}
local g2:={}

    g_a:addto(g1)
    g_b:addto(g1)
    g_c:addto(g1)
    g_d:addto(g1)

    g_e:addto(g2)
    g_f:addto(g2)
    g_g:addto(g2)
    g_h:addto(g2)
    
    g_aa:picture:="@S10 "+replicate("X",64)
    
    g_aa:item("1 Van, aki forr�n szereti!")
    g_aa:item("2 Pr�ba szerencse")
    g_aa:item("3 �t sz�p sz�zl�ny �r�lt �r�t ny�z")
    g_aa:item("4 Van, aki forr�n szereti!")
    g_aa:item("5 Pr�ba szerencse")
    g_aa:item("6 �t sz�p sz�zl�ny �r�lt �r�t ny�z")
    g_aa:select(3)


    g_bb:item("1 Van, aki forr�n szereti!")
    g_bb:item("2 Pr�ba szerencse")
    g_bb:item("3 �t sz�p sz�zl�ny �r�lt �r�t ny�z")
    g_bb:item("4 Van, aki forr�n szereti!")
    g_bb:item("5 Pr�ba szerencse")
    g_bb:item("6 �t sz�p sz�zl�ny �r�lt �r�t ny�z")
    g_bb:item("7 Van, aki forr�n szereti!")
    g_bb:item("8 Pr�ba szerencse")
    g_bb:item("9 �t sz�p sz�zl�ny �r�lt �r�t ny�z")
    g_bb:item("10 Van, aki forr�n szereti!")
    g_bb:item("11 Pr�ba szerencse")
    g_bb:item("12 �t sz�p sz�zl�ny �r�lt �r�t ny�z")
    g_bb:item("13 Van, aki forr�n szereti!")
    g_bb:item("14 Pr�ba szerencse")
    g_bb:item("15 �t sz�p sz�zl�ny �r�lt �r�t ny�z")
    g_bb:item("16 Van, aki forr�n szereti!")
    g_bb:item("17 Pr�ba szerencse")
    g_bb:item("18 �t sz�p sz�zl�ny �r�lt �r�t ny�z")
    g_bb:item("19 Hopp!")
    g_bb:item("20 Hopp!")
    g_bb:select(1)
  
    
    
    //g_a:postblock:={|g|if(g:varget,(alert("WRONG"),.f.),.t.)}
   
    aeval(getlist,{|g|g:display})

    return NIL


******************************************************************************
static function store(getlist)
    aeval(getlist,{|g|qout(g:varget)})
    return .t.    



******************************************************************************
