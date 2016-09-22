
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

#define ESC         chr(27)
#define ECMA        ESC+"(0N"   // ECMA-94 Latin 1 
#define IBMPC       ESC+"(8Q"   // IBM-PC Set
#define PUSH        ESC+"&f0S" 
#define POP         ESC+"&f1S"
#define UP(c)       if(isupper(c),ESC+"&a-10V","")
#define LEFT        chr(8)+ESC+"&a-06H"+chr(180)
#define RIGHT       chr(8)+ESC+"&a+20H"+chr(180)

#define ekezet1(c)  (ECMA+chr(c)+IBMPC)
#define ekezet2(c)  (ECMA+chr(c)+PUSH+UP(chr(c))+LEFT+RIGHT+POP+IBMPC)


***************************************************************************
function hpcwi(string)
local i, c, hp:=""

    for i:=1 to len(string)

        c:=asc( substr(string,i,1) )

        if( c==160 )                    // �
            hp+=ekezet1(225)
        elseif( c==130 )               // �
            hp+=ekezet1(233)
        elseif( c==161 )               // �
            hp+=ekezet1(237)
        elseif( c==162 )               // �
            hp+=ekezet1(243)
        elseif( c==148 )               // �
            hp+=ekezet1(246)
        elseif( c==147 )               // �
            hp+=ekezet2(111)
        elseif( c==163 )               // �
            hp+=ekezet1(250)
        elseif( c==129 )               // �
            hp+=ekezet1(252)
        elseif( c==150 )               // �
            hp+=ekezet2(117)

        elseif( c==143 )               // �
            hp+=ekezet1(193)
        elseif( c==144 )               // �
            hp+=ekezet1(201)
        elseif( c==140 )               // �
            hp+=ekezet1(205)
        elseif( c==149 )               // �
            hp+=ekezet1(211)
        elseif( c==153 )               // �
            hp+=ekezet1(214)
        elseif( c==167 )               // �
            hp+=ekezet2(79)
        elseif( c==151 )               // �
            hp+=ekezet1(218)
        elseif( c==154 )               // �
            hp+=ekezet1(220)
        elseif( c==152 )               // �
            hp+=ekezet2(85)
        else
            hp+=chr(c)     
        end
    next

    return hp


***************************************************************************
