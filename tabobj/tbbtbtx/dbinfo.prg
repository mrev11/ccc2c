
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

#include "fileio.ch"
#include "tabobj.ch"


//table alapj�n k�sz�t egy olyan m�sik nem statikus t�rol�s�
//objektumot, ami a lehet� legink�bb konzisztens a lemezfil�vel
//az �gy k�sz�lt objektum alkalmas kell legyen a fil�k megnyit�s�ra,
//�gy a strukt�ra elt�r�s�nek vizsg�lat�ra (tabVerify, KVERIF), 
//�s a strukt�ra konverzi�j�ra (tabUpgrade)
//
//p�lda: tabOpen DBSTRUCT elt�r�s miatt nem tudja megnyitni a fil�t,
//ekkor tabStructInfo-val kiolvassuk a fil� t�nyleges strukt�r�j�t,
//ez �sszehasonl�that� az objektummal, �s elv�gezhet� a konverzi�.
//
//visszat�r�s:
//1. !empty: siker�lt haszn�lhat� (kompatibilis) inf�t gy�jteni
//2. {}    : a fil� strukt�r�ja nem �llap�that� meg (inkompatibilis)
//3. NIL   : a fil� foglalt, nem lehetett beleolvasni


******************************************************************************
function tabStructInfo(table) //megnyithat� objektum a fil� info alapj�n

//table alapj�n k�sz�t egy olyan m�sik nem statikus t�rol�s�
//objektumot, ami a lehet� legink�bb konzisztens a lemezfil�vel
//az �gy k�sz�lt objektum alkalmas kell legyen a fil�k megnyit�s�ra,
//�gy a strukt�ra elt�r�s�nek vizsg�lat�ra (tabVerify, KVERIF), 
//�s a strukt�ra konverzi�j�ra (tabUpgrade)

    return tabResource( lower(tabPathName(table)) )


******************************************************************************
function tabResource(dbfspec)

local table,n
local column,index
local db:=_db_open(fopen(lower(dbfspec),FO_READWRITE+FO_SHARED))
local path,file,ext,alias
local poffs:=max(rat(dirsep(),dbfspec),rat(":",dbfspec))
local eoffs:=rat(".",dbfspec)

    if( db!=NIL )
        path:=substr(dbfspec,1,poffs)
        file:=substr(dbfspec,poffs+1,if(eoffs>poffs,eoffs-poffs-1,NIL))
        ext:=if(eoffs>poffs,substr(dbfspec,eoffs),"")
        alias:=file
        
        table:=tabNew0(alias)
        tabPath(table,path)
        tabFile(table,file)
        tabExt(table,ext)
        

        column:=readColumn(db)
        for n:=1 to len(column)
            tabAddColumn(table,column[n])
        next

        index:=readIndex(db)
        for n:=1 to len(index)
            tabAddIndex(table,index[n])
        next
        
        _db_close(db)
    end

    return table


******************************************************************************
static function readColumn(btree)
local buffer:=space(4096)
    _db_read1(btree,buffer,1,0)
    return _chr2arr(buffer)


******************************************************************************
static function readIndex(btree)
local buffer:=space(4096)
    _db_read1(btree,buffer,1,1)
    return _chr2arr(buffer)


******************************************************************************
