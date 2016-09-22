
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

// HP vezérlõkarakterek küldése

**********************************************************************
function PitchHP(p)    // p=10,12,16.66
static pprev
local q:=pprev
   
    DevOut( chr(27)+"(s"+alltrim(str(p))+"H" )
    pprev:=p
    return q

**********************************************************************
function LinesHP(l)    // l=1,2,3,4,6,8,12,16,24,48
static lprev
local q:=lprev
local as:=38 // '&' hogy ne makrozzon!
   
    DevOut( chr(27)+chr(as)+"l"+alltrim(str(l))+"D" )
    lprev:=l
    return q
      
**********************************************************************
function LayoutHP(o)   // o==0 portrait, o==1 landscape
static oprev
local q:=oprev
local as:=38 // '&' hogy ne makrozzon!
   
    DevOut( chr(27)+chr(as)+"l"+alltrim(str(o))+"O" )
    oprev:=o
    return q  
   
**********************************************************************
