
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

******************************************************************************
//Public interface

//function tabControlIndex(table,ord)     //vez�rl� index kiv�laszt�sa/lek�rdez�se
//function tabSuppIndex(table,index)      //ideiglenes indexet ad table-hoz
//function tabDropIndex(table)            //ideiglenes index t�rl�se
//function tabKeyCompose(table,order)     //kulcs az aktu�lis rekordb�l
//function tabKeyLength(table,order)      //kulcshossz az aktu�lis indexb�l 
 

******************************************************************************
function tabControlIndex(table,ord) //vez�rl� index kiv�laszt�sa/lek�rdez�se
local old:=table[TAB_ORDER]
    if( ord!=NIL .and. (ord:=tabGetIndex(table,ord))!=NIL .and. ord!=old )
        tabCommit(table)
        table[TAB_ORDER]:=ord
        tabGoto(table,tabPosition(table))
    end
    return old

 
******************************************************************************
function tabSuppIndex(table,index) //ideiglenes indexet ad table-hoz
local lkcnt:=tabSLock(table)
local res:=lkcnt>0 .and. _SuppIndex(table,index)
    tabSUnLock(table)
    return res

static function _SuppIndex(table,index) //ideiglenes indexet ad table-hoz

local state, ord, ordname, db, key 
local msg, total, n

    tranNotAllowedInTransaction(table,"suppindex",.t.)
 
    tabCommit(table)

    if( tabIsOpen(table)<OPEN_EXCLUSIVE )
        taberrOperation("tabSuppIndex")
        taberrDescription("Exclusive open sz�ks�ges")
        tabError(table)
    end
    
    if( (ord:=tabScanIndex(table,index))==NIL )

        //ha kor�bban is volt ilyen index,
        //akkor csak be kell �ll�tani,
        //olyankor ide nem j�n

        state:=tabSave(table)
        tabControlIndex(table,0)
        tabFilter(table,0)
        tabDeleteFieldTable(table)
 
        tabAddIndex(table,index)  //oszlop blockot m�dos�t!
        index[IND_TYPE]:=.t.  //ideiglenes indexet jel�l� flag
        ord:=len(table[TAB_INDEX])

      #ifdef UNSORTED_KEYS

        //A kulcsok rendezetlen sorrenben val� rakosgat�s�n�l 
        //sokkal hat�konyabb, ha el�sz�r rendezz�k a kulcsokat. 
        //Nagy fil�kn�l (t�z milli� rekord felett) �ri�si a k�l�nbs�g.
        //Ez�rt az #else (build_bt_index) �gat kell beford�tani.
        
        db:=table[TAB_BTREE]
        _db_creord(db,ordname:="<#>") //ideiglenes n�v

        n:=0
        total:="/"+alltrim(str(tabLastRec(table)))
        //msg:=message(msg,"Create index:"+str(n)+total)

        tabGotop(table)
        while( !tabEof(table) )

            key:=tabKeyCompose(table,ord) 
            _db_setord(db,ordname) 
            _db_put(db,key)
            
            if( ++n%1103==0 )
                msg:=message(msg,"Create index:"+str(n)+total)
            end
            tabSkip(table)
        end

        //Ha id�ig nem jut el, akkor az �j index <#> n�ven
        //marad benne a fil�ben, azt az open �szre fogja venni,
        //�s t�rli a f�lbemaradt indexet.

        _db_renord(db,ordname,index[IND_NAME]) //v�gleges n�v
        _db_addresource(db,_arr2chr(tabIndex(table)),1) //friss�t

        if( msg!=NIL )
            msg:=message(msg)
        end

      #else
        build_bt_index(table,ord,.t.) //optimized
      #endif
        
        tabSetFieldTable(table)
        tabRestore(table,state)
    end

    tabControlIndex(table,ord) 
    return index


******************************************************************************
function tabDropIndex(table)  //ideiglenes indexek t�rl�se
local lkcnt:=tabSLock(table)
local res:=lkcnt>0 .and. _DropIndex(table)
    tabSUnLock(table)
    return res

static function _DropIndex(table)  //ideiglenes indexek t�rl�se

local index,aindex:=tabIndex(table)
local col,acolumn:=tabColumn(table)
local n,state
local filno,status

    tranNotAllowedInTransaction(table,"dropindex",.t.)

    tabCommit(table)

    if( tabIsOpen(table)<OPEN_EXCLUSIVE )
        taberrOperation("tabDropIndex")
        taberrDescription("Exclusive open sz�ks�ges")
        tabError(table)
    end

    tabControlIndex(table,0)
    state:=tabSave(table)
    tabDeleteFieldTable(table)
    
    //el�sz�r minden indexet t�rl�nk,
    //ut�na az �lland�kat visszarakjuk
    
    for n:=1 to len(acolumn)
        col:=acolumn[n]
        col[COL_KEYFLAG]:=.f.
    next
    
    table[TAB_INDEX]:={}

    for n:=1 to len(aindex) 
        index:=aindex[n]

        if( !index[IND_TYPE] )
            tabAddIndex(table,index)
        else
            //az eg�sz indexet szabadlist�ba tessz�k
            _db_delord(table[TAB_BTREE],index[IND_NAME])
        end
    next
    
    _db_addresource(table[TAB_BTREE],_arr2chr(tabIndex(table)),1) //friss�t
    
    tabRestore(table,state)
    tabSetFieldTable(table)
    return index


******************************************************************************
function tabKeyCompose(table,order) //kulcs az aktu�lis rekordb�l

local aindex:=tabIndex(table)
local idxcol:=if(order>0,aindex[order][IND_COL],{})
local col,type,width,dec,n
local segval,key:=""
 
    for n:=1 to len(idxcol)

        col    := tabGetColumn(table,idxcol[n])
        type   := col[COL_TYPE]
        width  := col[COL_WIDTH]
        dec    := col[COL_DEC]
        segval := eval(col[COL_BLOCK])
        

        if( type=="C" )
            key+=segval  //nem kell transzform�lni

        elseif( type=="N" )
            key+=_db_numseg(segval,width,dec) 

        elseif( type=="D" )
            key+=dtos(segval) //nem kell transzform�lni
 
        elseif( type=="L" )
            key+=if(segval,"T","F")
        end
    next

    key+=_db_wrbig32(tabPosition(table))+table[TAB_RECPOS]
    return key


******************************************************************************
function tabKeyLength(table,order) //kulcshossz az aktu�lis indexb�l

local aindex:=tabIndex(table)
local idxcol:=if(order>0,aindex[order][IND_COL],{})
local keylen:=10
local col,width,n
 
    for n:=1 to len(idxcol)
        col    := tabGetColumn(table,idxcol[n])
        width  := col[COL_WIDTH]
        keylen += width
    next

    return keylen
 
******************************************************************************
