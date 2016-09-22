
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

#define INDORDER    table[TAB_INDEX][table[TAB_ORDER]] 
#define RECORDER    "recno"
#define KEYORDER    if(table[TAB_ORDER]==0,RECORDER,INDORDER[IND_NAME])
 
******************************************************************************
// Public interface

//function tabSkip(table,stp)          //skip el�re/h�tra
//function tabSeek(table,exp)          //nagyobbegyenl�re
//function tabSeekLE(table,exp)        //kisebbegyenl�re (vagy legkisebbre)
//function tabSeekGE(table,exp)        //nagyobbegyenl�re (vagy legnagyobbra)
//function tabGoTop(table)             //gotop
//function tabGoBottom(table)          //gobottom
//function tabGetNext(table,stp)       //el�re index szerint (bels�)
//function tabGetPrev(table,stp)       //h�tra index szerint (bels�)
//function tabGoto(table,pos)          //goto
//function tabEstablishPosition(table) //prev/next be�ll�t�sa (bels�)
//function tabPosition(table)          //recno() vagy 0, ha EOF-on �ll
//function tabLastRec(table)           //rekordok sz�ma
//function tabEof(table)               //eof().or.bof()
//function tabFound(table)             //found()


******************************************************************************
//EOF be�ll�t�sa:
//
//  tabEOF() k�tf�le szitu�ci�ban ad .t.-t
//    
//  1) ha kis�rlet t�rt�nt top el� poz�cion�lni (skip -1),
//     ilyenkor tabEOF()==.t., �s tabPosition()==1.
//
//  2) ha neml�tez� rekordra (pos<=0 .or. lastrec<pos) akarnak
//     poz�cion�lni, ilyenkor tabEOF()==.t., �s tabPosition()==0.
//       
//  Teh�t a f�jl poz�cion�latlans�g�t (utols� ut�ni fikt�v rekordon
//  �ll�s�t) a tabPosition()==0 rel�ci� mutatja. 


******************************************************************************
function tabSkip(table,stp)  //skip el�re/h�tra

    if(table[TAB_MODIF]); tabCommit(table); end
    if(stp==NIL); stp:=1; end
    table[TAB_FOUND]:=.f.

    if( stp>0 )
        if( stp>tabGetNext(table,stp) )
            tabGoEOF(table) // EOF-ra �ll
        else
            table[TAB_EOF]:=.f.
        end

    elseif( stp<0 )
        if( -stp>tabGetPrev(table,-stp) )
            tabGoTop(table)
            table[TAB_EOF]:=.t.
        else
            table[TAB_EOF]:=.f.
        end

    elseif( tabEof(table) )
        //??

    else
        //�jraolvassuk a rekordot
        tabSetPos(table, _db_wrbig32(table[TAB_POSITION])+table[TAB_RECPOS] )
    end   
    return !table[TAB_EOF]


******************************************************************************
function tabSeek(table,exp)  //keres�s nagyobbegyenl�re

// �sszetett indexkifejez�st {}-ban felsorolva kell megadni,
// csak TAB_ORDER>0 eset�n (azaz be�ll�tott indexszel) alkalmazhat�

local ord:=table[TAB_ORDER]
local key,keyf,pos

    tabCommit(table)
    table[TAB_EOF]:=.f.

    if( ord<=0 )
        taberrOperation("tabSeek")
        taberrDescription("Nincs vez�rl� index")
        tabError(table)

    elseif( valtype(exp)=="A" )
        key:=tabExpIndex(table,exp)
    else
        key:=tabExpIndex(table,{exp})
    end
    
    _db_setord(table[TAB_BTREE],KEYORDER)
    keyf:=_db_seek(table[TAB_BTREE],key)

    if( !tabSetPos(table,keyf) )  
        //EOF-ra �llt

    elseif( tabInscope(table) )
        table[TAB_EOF]:=.f.

    elseif( 1>tabGetNext(table,1) )
        tabGoEOF(table)
    
    else
        table[TAB_EOF]:=.f.
    end

    if( table[TAB_EOF] )
        table[TAB_FOUND]:=.f.
    else
        keyf:=tabKeyCompose(table,table[TAB_ORDER])
        table[TAB_FOUND]:=keyf<=key
    end

    return table[TAB_FOUND]
    
    //Megjegyz�s: a tal�lt kulcs egyez�s�g�t csak a megadott 
    //hosszban (key hossz�ban) kell vizsg�lni (<= oper�tor).


******************************************************************************
function tabSeekLE(table,exp) //seek kisebbegyenl�re (vagy legkisebbre)
    if( tabSeek(table,exp) )
        return .t.
    elseif( tabEof(table) )
        tabGoBottom(table)
    else
        tabSkip(table,-1)
    end
    return .f.
 

******************************************************************************
function tabSeekGE(table,exp) //seek nagyobbegyenl�re (vagy legnagyobbra)
    if( tabSeek(table,exp) )
        return .t.
    elseif( tabEof(table) )
        tabGoBottom(table)
    end
    return .f.


******************************************************************************
static function tabExpIndex(table,aexp) //t�mbb�l indexkifejez�s

// az aexp kifejez�slist�b�l kulcs�rt�ket k�sz�t seek sz�m�ra
// (column az aktu�lis indexet alkot� oszlopok sorsz�m�nak list�ja)

local column:=table[TAB_INDEX][table[TAB_ORDER]][IND_COL],n
local col,type,width,dec,segval,key:=""

    if( len(column)<len(aexp) )
        taberrOperation("tabExpIndex")
        taberrDescription("Kulcslista hosszabb")
        taberrArgs(aexp)
        tabError(table)
    end
    
    //megengedj�k, hogy aexp r�videbb legyen
    
    for n:=1 to len(aexp)

        col    := tabGetColumn(table,column[n])
        type   := col[COL_TYPE]
        width  := col[COL_WIDTH]
        dec    := col[COL_DEC]
        segval := aexp[n]

        if( type=="C" )
            key+=padr(segval,width)

        elseif( type=="N" )
            key+=_db_numseg(segval,width,dec) 

        elseif( type=="D" )
            key+=dtos(segval)

        elseif( type=="L" )
            key+=if(segval,"T","F")
        end
    next

    return key 
    
    //az itteni key v�g�n nincs a recno-b�l k�pzett suffix,
    //ez�rt az mindig r�videbb, mint amit tabKeyCompose ad,
    //egy�bk�nt a k�t f�ggv�ny nagyon hasonl�


******************************************************************************
function tabGoTop(table)  //gotop

    tabCommit(table)
    table[TAB_FOUND]:=.f.
    
    _db_setord(table[TAB_BTREE],KEYORDER)

    if( !tabSetPos(table,_db_first(table[TAB_BTREE])) )
        //EOF-ra �llt
    elseif( tabInscope(table) )
        table[TAB_EOF]:=.f.
    elseif( 1>tabGetNext(table,1) )
        tabGoEOF(table)
    else
        table[TAB_EOF]:=.f.
    end

    return !table[TAB_EOF]


*****************************************************************************
function tabGoBottom(table)  //gobottom

    tabCommit(table)
    table[TAB_FOUND]:=.f.

    _db_setord(table[TAB_BTREE],KEYORDER)
 
    if( !tabSetPos(table,_db_last(table[TAB_BTREE])) )
        //EOF-ra �llt
    elseif( tabInscope(table) )
        table[TAB_EOF]:=.f.
    elseif( 1>tabGetPrev(table,1) )  
        tabGoEOF(table)
    else
        table[TAB_EOF]:=.f.
    end

    return !table[TAB_EOF]


******************************************************************************
function tabGetNext(table,stp) //el�re index szerint 
local n:=0,nextpos
    if( tabPosition(table)==0 )
        // EOF-r�l nem lehet el�re l�pni
        return 0 
    end

    while( n<stp .and.;
           NIL!=(nextpos:=_db_next(table[TAB_BTREE])) .and.;
           tabSetPos(table,nextpos) )

        if( tabInscope(table) )
            n++                    
        end
    end
    return n


******************************************************************************
function tabGetPrev(table,stp) //h�tra index szerint 
local n:=0,prevpos
    if( tabPosition(table)==0 )
        //EOF-r�l el�sz�r BOTTOM-ra kell visszal�pni
        if( tabGobottom(table) .and. tabInscope(table) ) 
            n++                    
        end
    end
    while( n<stp .and.;
           NIL!=(prevpos:=_db_prev(table[TAB_BTREE])) .and.;
           tabSetPos(table,prevpos) )

        if( tabInscope(table) )
            n++                    
        end
    end
    return n


******************************************************************************
function tabGoto(table,pos) //goto
local key,keyf,pup

    tabCommit(table)
    table[TAB_EOF]:=.f.
    table[TAB_FOUND]:=.f.
    table[TAB_POSITION]:=pos
    
    _db_setord(table[TAB_BTREE],RECORDER)
    key:=_db_wrbig32(pos) 
    keyf:=_db_seek(table[TAB_BTREE],key)
 
    if( keyf!=key )

        if( table[TAB_TRANID]!=NIL .and. tranLastRecordUpdate(table,@pup) )
            //Ez az az eset, amikor egy tranzakci�ban
            //append�lt rekordra visszapoz�cion�lunk,
            //ilyenkor BTBTX-ben nem el�g a recno-t tudni,
            //hanem a recpos-t is vissza kell �ll�tani.
        
            table[TAB_RECPOS]:=pup[PUP_RECPOS]
        else
            tabGoEOF(table)
        end
    else
        table[TAB_RECPOS]:=right(keyf,6)
        if( tabReadRecord(table) )
            if( table[TAB_ORDER]!=0 ) 
                tabEstablishPosition(table)
            end
            if( table[TAB_TRANID]!=NIL )
                tranLastRecordUpdate(table) 
            end
        end
    end
    
    return !table[TAB_EOF]


******************************************************************************
function tabEstablishPosition(table) //prev/next be�ll�t�s�hoz (bels�)

local key,keyf,n:=0

    _db_setord(table[TAB_BTREE],KEYORDER)
    
    while( !tabEof(table) )
    
        key:=tabKeyCompose(table,table[TAB_ORDER])
        keyf:=_db_seek(table[TAB_BTREE],key)
    
        if( keyf!=key )
            if( ++n<10 )
                sleep(100)
                tabReadRecord(table) 
                loop
            else
                taberrOperation("tabEstablishPosition")
                taberrDescription("A fil� nem poz�cion�lhat�")
                taberrArgs({KEYORDER,key,keyf}) 
                tabError(table)
            end
        end
        exit
    end
    return NIL


******************************************************************************
static function tabReadRecord(table) //rekord olvas�s
    if( table[TAB_RECLEN]!=;
        _db_read(table[TAB_BTREE],table[TAB_RECBUF],table[TAB_RECPOS]) )
        tabGoEOF(table)
        return .f.
    end
    return .t.


******************************************************************************
static function tabSetPos(table,key) 
local primarykey

    if( key==NIL )
        tabGoEOF(table)
        return .f.
    end

    primarykey:=right(key,10) 
    table[TAB_POSITION]:=_db_rdbig32(left(primarykey,4)) 
    table[TAB_RECPOS]:=right(primarykey,6) 

    if( table[TAB_TRANID]!=NIL .and. tranLastRecordUpdate(table) )
        return .t.
    end
    return tabReadRecord(table)  



******************************************************************************
function tabPosition(table) //recno() vagy 0, ha EOF-on �ll
    return table[TAB_POSITION]


******************************************************************************
function tabLastRec(table)  //rekordsz�m
    return _db_lastrec(table[TAB_BTREE])


******************************************************************************
function tabEof(table)  //eof().or.bof()
    return table[TAB_EOF]


******************************************************************************
function tabFound(table)  //found()
    return table[TAB_FOUND]


******************************************************************************
function tabReadOriginalRecordFromDisk(table) //napl�z�shoz
local err,buffer
    buffer:=space(table[TAB_RECLEN]) 
    if( table[TAB_RECLEN]!=_db_read(table[TAB_BTREE],buffer,table[TAB_RECPOS]) )
        err:=readerrorNew()
        err:operation:="tabReadOriginalRecordFromDisk"
        err:description:="_db_read failed"
        err:filename:=tabPathName(table)
        err:oscode:=ferror()
        break(err)
    end
    return buffer
 
 
******************************************************************************
