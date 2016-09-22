
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

//TARTALOM  : t�bla objektum oszlop met�dusok platformf�ggetlen r�sze
//STATUS    : k�z�s
//
//function tabColNumber(table,colName)   oszlopn�vb�l oszlopsorsz�m
//function tabColumn(table)              oszlopok strukt�r�ja
//function tabGetColumn(table,col)       oszlop keres�se az objektumban
//function tabEvalColumn(table,col,exp)  oszlop ki�rt�kel�se �s �rt�kad�sa
//function tabBlock(table,col,block)     oszlop ki�rt�kel� blockja
//function tabFcount(table)              oszlopok sz�ma
//function tabPicture(table,col,pict)    oszlop picture-je

#include "tabobj.ch"

******************************************************************************
function tabColNumber(table,colName) //oszlopn�vb�l oszlopsorsz�m
local column:=table[TAB_COLUMN], num
    colName:=upper(alltrim(colName))
    num:=ascan(column,{|x|x[COL_NAME]==colName} )
    if(num<=0)
        taberrOperation("tabColNumber")
        taberrDescription("Neml�tez� oszlopn�v")
        taberrArgs(colName)
        tabError(table)
    end
    return num


******************************************************************************
function tabColumn(table) //oszlopok strukt�r�ja
    return table[TAB_COLUMN]


******************************************************************************
function tabGetColumn(table,col) //oszlop keres�se az objektumban
    if(valtype(col)=="C")
        col:=tabColNumber(table,col)
    end
    return table[TAB_COLUMN][col]


******************************************************************************
function tabEvalColumn(table,col,exp) //oszlop ki�rt�kel�se �s �rt�kad�sa
    return eval(tabGetColumn(table,col)[COL_BLOCK],exp)


******************************************************************************
function tabBlock(table,col,block) //oszlop ki�rt�kel� blockja
local column:=tabGetColumn(table,col)
    return if(block==NIL,column[COL_BLOCK],column[COL_BLOCK]:=block)


******************************************************************************
function tabPicture(table,col,pict)  //oszlop picture-je
local column:=tabGetColumn(table, col)
    return if(pict==NIL,column[COL_PICT],column[COL_PICT]:=pict)


******************************************************************************
function tabFcount(table) //oszlopok sz�ma
    return len(table[TAB_COLUMN])


******************************************************************************
