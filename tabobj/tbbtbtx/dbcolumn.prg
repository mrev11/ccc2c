
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

#include "tabobj.ch"

******************************************************************************
//Public interface

//function tabAddColumn(table,column)   //oszlop hozz�ad�sa az objektumhoz
//function tabSetColBlock(table,column) //oszlop block �jra be�ll�t�sa

******************************************************************************
function tabAddColumn(table,column) //oszlop hozz�ad�sa az objektumhoz

// column szerkezete: {name,type,width,dec,pict,block,keyflag,offs}
// az els� n�gy elem megad�sa k�telez�
//
// name     alltrim, upper
// dec      nem sz�mmez�kn�l 0
// pict     kit�ltj�k 
// offs     kit�ltj�k (k�s�bb v�ltozhat)
// block    kit�ltj�k (v�ltozik, ha offs, vagy key v�ltozik
// keyflag  kit�ltj�k (egyel�re nem ismert, default .f.)
//
// a sorsz�m szerinti oszlophivatkoz�s mindig a tabAddColumn()
// szerinti sorrendet jelenti, �s nem a fil�-beli sorrendet

local type  :=column[COL_TYPE]
local width :=column[COL_WIDTH]
local dec   :=column[COL_DEC]
local pict

    if( empty(table[TAB_COLUMN]) )
        table[TAB_FLDNUM]:=0
        table[TAB_RECLEN]:=1 //deleted flag
    end

    asize(column, COL_SIZEOF)

    column[COL_NAME]    := upper(alltrim(column[COL_NAME]))
    column[COL_OFFS]    := table[TAB_RECLEN] //k�s�bb m�g v�ltozhat
    column[COL_KEYFLAG] := .f. //m�g nem ismert, v�ltozhat
    
    if( type!="N" )
        column[COL_DEC]:=0
    end

    if( type=="C" )
        pict:="@R "+replicate("X",min(width,64))

        if( tabMemoField(table,column) )
            pict:=tabMemoPict()
        end

    elseif( type=="D" )
        pict:="D"

    elseif( type=="L" )
        pict:="@! L"

    elseif( type=="N" )
        pict:=replicate("9",width)
        if( dec>0 )
            pict+="."+replicate("9",dec)
            pict:=right(pict,width)
            pict:="@R "+pict
        end
    end

    column[COL_PICT]:=pict

    tabSetColBlock(table,column) //kit�lti az oszlop k�dblokkj�t
    
    //blokkok tov�bbi �ll�tgat�sa tabAddindex/tabVerify-ban
    //
    //Az adatfil�ben olyan mez�k is lehetnek, 
    //amik az objektumb�l hi�nyoznak, ez�rt az objektum alapj�n
    //sz�m�tott mez�offsetek a val�di offsett�l elt�rhetnek.
    //A m�r megnyitott dbf-ben a mez�k a fejl�cb�l n�v alapj�n 
    //kikereshet�k, �s a pontos hely�k szerinti blokk k�pezhet�.
    //
    //A tabAddIndex az oszlopok n�melyik�t kulcsnak min�s�ti,
    //ezeknek ki kell cser�lni a blokkj�t olyanra, amelyik a commitban
    //kiv�ltja az index karbantart�s�t: a r�gi kulcs�rt�ket t�r�lni, 
    //az �jat berakni kell. (TAB_KEYFLAG be�ll�t�s)
    //
    //Tov�bbi bonyodalom, hogy a fil� tov�bbi, az objektumb�l
    //nem ismert indexeket is tartalmazhat, amiket szint�n karban 
    //kell tartani, ez�rt ezeknek a blokkj�t is cser�lni kell.

    aadd(table[TAB_COLUMN],column)

    table[TAB_FLDNUM]+=1
    table[TAB_RECLEN]+=width

    return column


******************************************************************************
function tabSetColBlock(table,column)

local name  :=column[COL_NAME]
local type  :=column[COL_TYPE]
local width :=column[COL_WIDTH]
local dec   :=column[COL_DEC]
local offs  :=column[COL_OFFS]
local key   :=column[COL_KEYFLAG]


    //? name,type,key

    if(type=="C")

        if( tabMemoField(table,column) )
            column[COL_BLOCK]:=blkmemo(table,offs,width)
        else
            column[COL_BLOCK]:=if(key,xblkchar(table,offs,width),blkchar(table,offs,width))
        end

    elseif(type=="N")
        column[COL_BLOCK]:=if(key,xblknumber(table,offs,width,dec),blknumber(table,offs,width,dec))

    elseif(type=="D")
        column[COL_BLOCK]:=if(key,xblkdate(table,offs),blkdate(table,offs))


    elseif(type=="L")
        column[COL_BLOCK]:=if(key,xblkflag(table,offs),blkflag(table,offs))

    else
        taberrOperation("tabSetColBlock")
        taberrDescription("Rossz oszlopdefin�ci�")
        taberrArgs(column)
        tabError(table)

    end

    return NIL


******************************************************************************
static function islocked(table)

    if( !table[TAB_MODIF] )
        table[TAB_MODIF]:=.t.

        //Engedj�k-e az �r�st EOF-ba?
        //Ha kulcsmez�t �rnak �t EOF-ban, akkor ronda hib�t kapunk:
        //nem tudjuk t�r�lni az indexb�l a kulcs kor�bbi p�ld�ny�t.
        //Ha viszont itt meg�llunk, akkor j�nak tudott programokr�l
        //der�lhet ki v�ratlanul, hogy EOF-ba �rnak.

        if( tabEof(table) )
            taberrOperation("tabEvalColumn")
            taberrDescription("�r�s EOF-ba")
            tabError(table)
        end

        if( !tabIsLocked(table) )
            taberrOperation("tabEvalColumn")
            taberrDescription("Rekordlock sz�ks�ges")
            tabError(table)
        end
    end
    return .t.


static function xislocked(table) //kulcsszegmensekn�l speci�lis

local index,ord

    if( !table[TAB_MODIFKEY] )
        table[TAB_MODIFKEY]:=.t.
        islocked(table)

        //meg kell jegyezni, hogy mi volt a kulcs �rt�ke
        //a mez� �t�r�sa el�tt, hogy k�s�bb (tabCommit)
        //meg lehessen tal�lni az eredeti kulcsokat
        
        //b�rmely kulcsot alkot� mez� m�dos�t�sa kiv�ltja
        //az �sszes kulcs update-j�t
        
        index:=tabIndex(table)
        for ord:=1 to len(index)
            index[ord][IND_CURKEY]:=tabKeyCompose(table,ord)
        next
    end
    return .t.


******************************************************************************
static function blkchar(table,offs,width)
    return {|x| if(x==NIL.or.!islocked(table),;
                xvgetchar(table[TAB_RECBUF],offs,width),;
                (xvputbin(table[TAB_RECBUF],offs,width,x),x)) }

static function blknumber(table,offs,width,dec)
    return {|x| if(x==NIL.or.!islocked(table),;
                val(xvgetchar(table[TAB_RECBUF],offs,width)),;
                (xvputchar(table[TAB_RECBUF],offs,width,str(x,width,dec)),x)) }
    
static function blkdate(table,offs)
    return {|x| if(x==NIL.or.!islocked(table),;
                stod(xvgetchar(table[TAB_RECBUF],offs,8)),;
                (xvputchar(table[TAB_RECBUF],offs,8,dtos(x)),x)) }

static function blkflag(table,offs)  //megj: T=84, F=70
    return {|x| if(x==NIL.or.!islocked(table),;
                84==xvgetbyte(table[TAB_RECBUF],offs),;
                (xvputbyte(table[TAB_RECBUF],offs,if(x,84,70)),x)) }

static function blkmemo(table,offs,width)  
    return {|x| if(x==NIL.or.!islocked(table),;
                tabMemoRead(table,xvgetchar(table[TAB_RECBUF],offs,width)),;
                (xvputchar(table[TAB_RECBUF],offs,width,tabMemoWrite(table,xvgetchar(table[TAB_RECBUF],offs,width),x)),x))}


// xblk... = blk... (islocked <- xislocked)


static function xblkchar(table,offs,width)
    return {|x| if(x==NIL.or.!xislocked(table),;
                xvgetchar(table[TAB_RECBUF],offs,width),;
                (xvputbin(table[TAB_RECBUF],offs,width,x),x)) }

static function xblknumber(table,offs,width,dec)
    return {|x| if(x==NIL.or.!xislocked(table),;
                val(xvgetchar(table[TAB_RECBUF],offs,width)),;
                (xvputchar(table[TAB_RECBUF],offs,width,str(x,width,dec)),x)) }
    
static function xblkdate(table,offs)
    return {|x| if(x==NIL.or.!xislocked(table),;
                stod(xvgetchar(table[TAB_RECBUF],offs,8)),;
                (xvputchar(table[TAB_RECBUF],offs,8,dtos(x)),x)) }

static function xblkflag(table,offs)  //megj: T=84, F=70
    return {|x| if(x==NIL.or.!xislocked(table),;
                84==xvgetbyte(table[TAB_RECBUF],offs),;
                (xvputbyte(table[TAB_RECBUF],offs,if(x,84,70)),x)) }


//Megj: egy xvgetnumber/xvputnumber f�ggv�nyp�rral a sz�mmez�k 
//kezel�se l�nyegesen felgyors�that� volna!


******************************************************************************
