
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

//TARTALOM  : a t�blaobjektumhoz tartoz� fil�k nevei
//STATUS    : k�z�s, ifdef
//
//tabAlias(table,par) alias n�v 
//tabFile(table,par)  f�jl neve path �s kiterjeszt�s n�lk�l
//tabPath(table,par)  .-b�l a f�jlhoz vezet� relat�v �t (a v�g�n dirsep)
//tabExt(table,par)   a fil� kiterjeszt�se
//tabNameExt(table)   a fil�n�v kiterjeszt�ssel
//tabPathName(table)  .-ra relat�v f�jlspecifik�ci�
//tabIndexName(table) .-ra relat�v indexf�jl specifik�ci�
//tabMemoName()       mem�fil� neve


#include "tabobj.ch"


#define UAT(x) upper(alltrim(x))

******************************************************************************
function tabAlias(table,par) //alias n�v 
    return if(par==NIL, table[TAB_ALIAS], table[TAB_ALIAS]:=UAT(par))


******************************************************************************
function tabFile(table,par) //f�jl neve path kiterjeszt�s n�lk�l
    return if(par==NIL, table[TAB_FILE], table[TAB_FILE]:=UAT(par))


******************************************************************************
function tabPath(table,par) //.-b�l a f�jlhoz vezet� relat�v �t (a v�g�n dirsep)
    if( par!=NIL )
        par:=UAT(par)
        par:=strtran(par,"/",dirsep()) //2000.09.29
        par:=strtran(par,"\",dirsep()) //2000.09.29 
        if( !empty(par) .and. !right(par,1)$":"+dirsep() )
            par+=dirsep()
        end
        table[TAB_PATH]:=par
    end
    return table[TAB_PATH]


******************************************************************************
function tabExt(table,par) //az adatfil� aktu�lis kiterjeszt�se
    return if(par==NIL, table[TAB_EXT], table[TAB_EXT]:=UAT(par))


******************************************************************************
function tabNameExt(table) // filename.ext
    return table[TAB_FILE]+table[TAB_EXT]


******************************************************************************
function tabPathName(table) //.-ra relat�v f�jlspecifik�ci�
    return table[TAB_PATH]+table[TAB_FILE]+table[TAB_EXT]


******************************************************************************
function tabIndexName(table) //.-ra relat�v f�jlspecifik�ci�
    return table[TAB_PATH]+table[TAB_FILE]+tabIndexExt()


******************************************************************************
function tabMemoName(table)  //.-ra relat�v f�jlspecifik�ci�
    return table[TAB_PATH]+table[TAB_FILE]+tabMemoExt()


******************************************************************************

