
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

//TARTALOM  : a mem�fil� m�veletei
//STATUS    : k�z�s
//
//function tabMemoField(table,col)         mem�-e a megadott oszlop
//function tabMemoHandle(table)            mem�fil� handlere
//function tabMemoActive(table)            van-e nyitva mem�fil�
//function tabMemoCount(table)             a mem� mez�k sz�ma
//function tabMemoWrite(table,memo,value)  mem� be�r�sa (memo=C10 offset)
//function tabMemoRead(table,memo)         mem� kiolvas�sa (memo=C10 offset)
//function tabMemoPict()                   mem� picture


#include "fileio.ch"
#include "tabobj.ch"

/*
Hogyan lehet l�trehozni mem� mez�t?
===================================

A mem� mez� neve DBM-mel kell kezd�dj�m,
�s C10 t�pusa kell legyen, pl. DBMPROBA C10.
Clipperben (�s ez�rt mindenhol) a mem� mez�k nev�nek
m�r a DBM ut�ni els� karakterben k�l�nb�zni�k kell.

A mem� �rt�k egy k�l�n fil�ben t�rol�dik
a DATIDX(DBD) form�tumban ennek kiterjeszt�se DBD
a DBFCTX(DBM) �s DBFNTX(DBM) form�tumokban a kiterjeszt�s DBM.

Maga a form�tum (a kiterjeszt�st�l eltekintve) azonos,
a jelenlegi form�tumot azonos�t� n�v: "DBM Format 1.0".
A form�tum k�l�nb�z� blokkm�rt� fil�k egyidej� kezel�s�re k�pes,
a blokkm�ret a headerben t�rol�dik, 
a legkisebb lehets�ges m�ret 64 byte, a default 256 byte.

Amikor egy mem� mez�nek �rt�ket adunk, akkor a mem� fil�be az �j
�rt�k azonnal ki�r�dik, egy�ttal a rekordbufferbe be�r�dik a mem� 
els� blokkj�nak �j offsete C10 form�tumban. 
Ha ezut�n a rekord commitol�dik akkor az �j offseten l�v� mem� �rt�k
fog a rekordhoz tartozni. Ha a commit elmarad, akkor a DBF (DAT)
�ltal t�rolt offset nem v�ltozik, �s igy a mem� �rt�ke is v�ltozatlan
(a kor�bbi mem��rt�k a commit el�tt sosem �r�dik fel�l).
A mem� fel�l�r�s�val feleslegess� v�l� blokkok a commit ut�n 
beker�lnek a mem�fil� szabadlist�j�ba. Ha a commit elmarad 
(pl. ALT-C kil�p�skor), akkor a ki�rt blokkok z�rv�nny� v�lnak,
�s csak a fil� packol�sakor sz�nnek meg.


Hol kell m�dos�tani a t�bbi forr�st?
====================================

T�blaobjektum:

 1. fel kell venni a TAB_MEMOHND attrib�tumot a t�blaobjektumba
 2. fel kell venni a TAB_MEMODEL attrib�tumot a t�blaobjektumba
 3. tabCreate-ban l�tre kell hozni a mem� fil�t (ha van mem� mez�)
 4. tabUse-ban meg kell nyitni a mem� fil�t (ha van mem� mez�)
 5. tabClose-ban le kell z�rni a mem� fil�t, ha nyitva van
 6. tabAddColumn-ban speci�lis blokkot kell k�sz�teni a mem� mez�knek
 7. tabAddColumn-ban a mem� mez�knek "@S30 XXX..." picture-t adunk
 8. tabCommit-ban a TAB_MEMODEL lista mem�it t�r�lni kell
 9. tabPack-ot ki kell eg�sz�teni a mem� fil� packol�s�val (megy en�lk�l is)
10. tabZap-ot ki kell eg�sz�teni a mem� zapol�s�val (megy en�lk�l is)
11. tabAppendRecord-ot ki kell eg�sz�teni a mem�k �tm�sol�s�val


Alkalmaz�sok:

1. kdirmodi.prg-ban az edit�l�st kicsit meg kell v�ltoztatni (megy en�lk�l is)

*/


#define MEMO_WIDTH    10


****************************************************************************
function tabMemoField(table,col) //mem�-e a megadott mez�?

    if( valtype(col)!="A" )
        col:=tabGetColumn(table,col)
    end

    return left(col[COL_NAME],3)=="DBM" .and.;
           col[COL_TYPE]=="C" .and.;
           col[COL_WIDTH]==10 


****************************************************************************
function tabMemoHandle(table)  //az objektum mem�fil�j�nek handlere
    return table[TAB_MEMOHND]


****************************************************************************
function tabMemoActive(table)  //van-e nyitva mem�fil�
local memohnd:=table[TAB_MEMOHND]
    return valtype(memohnd)=="N" .and. memohnd>=0


****************************************************************************
function tabMemoCount(table)  //a mem� mez�k sz�ma

local column:=tabColumn(table),n
local count:=0

    for n:=1 to len(column)
        if( tabMemoField(table,column[n]) )
            count++
        end
    next
    return count
        

****************************************************************************
function tabMemoDel(table)

local n,tmd,ltmd,mhnd

    if( table[TAB_MEMODEL]!=NIL )
        tmd:=table[TAB_MEMODEL]
        mhnd:=table[TAB_MEMOHND]
        ltmd:=len(tmd)
        for n:=1 to ltmd
            memoDeleteValue(mhnd,tmd[n])
        next
        table[TAB_MEMODEL]:=NIL
    end
    return NIL

    
****************************************************************************
function tabMemoRead(table,memo)

local value:=""
local offset:=val(memo)

    if( offset!=0 )
        value:=memoGetValue(tabMemoHandle(table),offset)
    end
    return value

    
****************************************************************************
function tabMemoWrite(table,memo,value)

local vlen:=len(value)
local offset

    if( !empty(memo) )
        if( table[TAB_MEMODEL]==NIL )
            table[TAB_MEMODEL]:={val(memo)}
        else
            aadd(table[TAB_MEMODEL],val(memo))
        end
    end
    memo:=""

    if( vlen>0 )
        offset:=memoAddValue(tabMemoHandle(table),value)
        memo:=str(offset,MEMO_WIDTH,0)
    end
    return memo


****************************************************************************
function tabMemoPict()
    return "@RS48 "+replicate("X",256)
                         

****************************************************************************
/*
function tabMemoPack(table)

//v�zlat arra, 
//  hogyan kell a mem� fil�t packolni,
//  a hat�konys�g kedv��rt bele fogom sz�ni
//  a k�dot a tabPack-ba, hogy ne kelljen 
//  k�tszer v�gigmenni a fil�n

local mname:=tabMemoName(table)                                  //eredeti
local tname:=tabPath(table)+TMPCHR+tabFile(table)+tabMemoExt(table) //tempor�lis
local bname:=tabPath(table)+tabFile(table)+"_DBM"+".BAK"         //backup

local mhnd:=tabMemoHandle(table), thnd
local column:=tabColumn(table),n
local blk:={},v

    memoCreate(tname)
    thnd:=memoOpen(tname)
    
    for n:=1 to len(column)
        if( tabMemoField(table,column[n]) )
            aadd(blk,column[n][COL_BLOCK])
        end
    next
    
    tabGoTop(table)
    while( !tabEof(table) )
    
        for n:=1 to len(blk)
            v:=eval(blk[n])            //olvas�s a mem�b�l
            table[TAB_MEMOHND]:=thnd   //tempor�lis handler 
            eval(blk[n],v)             //�r�s a tempor�lis mem�ba
            table[TAB_MEMOHND]:=mhnd   //memo handler vissza
        next
        
        tabSkip(table)
    end
    
    fclose(mhnd); ferase(bname); frename(mname,bname)
    fclose(thnd); ferase(mname); frename(tname,mname)

    table[TAB_MEMOHND]:=fopen(tabMemoName(table),FO_READWRITE+FO_SHARED)
    #ifdef _UNIX_   
      setcloexecflag(table[TAB_MEMOHND],.t.)
    #else
      table[TAB_MEMOHND]:=fdup(table[TAB_MEMOHND],.f.,.t.)
    #endif
    
    return NIL

*/
****************************************************************************
