
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

//Lényegében ugyanaz, mint a régebbi bt2ted,
//csak nem XML szintaktikájú ted kimenetet készít,
//hanem az olvashatóbb tds-t (table definition script).

#include "table.ch"

#define VERSION "bt2tds 1.0.01"

******************************************************************************
function usage()
local x:=<<usage>>
Usage: bt2tds ifile -p pkey [-n nspac] [-t table] [-0 colnn]* [-s colsk]* [-o ofile]

    ifile : input file specification (bt table)
    pkey  : primary key (must be an index in table)
    nspac : namespace for tableentity class
    table : qualified table name in SQL database
    colnn : column notnull
    colsk : column skip
    ofile : output file (table definition script)

<<usage>>
    ?? x
    quit
    return NIL

******************************************************************************
function main()

local n:=0,p,i
local fspec,output,primkey,notnull:={},colskip:={},nspace,tname
local table,indname,indcol

    while( (p:=argv(++n))!=NIL )
        if( p=="-p" )
            primkey:=upper(argv(++n))
        elseif( p=="-0" )
            aadd(notnull,upper(argv(++n)) )
        elseif( p=="-s" )
            aadd(colskip,upper(argv(++n)) )
        elseif( p=="-o" )
            output:=argv(++n)
        elseif( p=="-n" )
            nspace:=argv(++n)
        elseif( p=="-t" )
            tname:=argv(++n)
        else
            fspec:=p
        end
    end

    if( NIL==fspec )
        usage()
    elseif( NIL==primkey )
        usage()
    elseif( !file(fspec) )
        ? fspec, "not found"
        usage()
    elseif( NIL==(table:=tabResource(fspec)) )
        ? fspec, "not a valid table"
        usage()
    end
    
    for i:=1 to len(tabIndex(table))
        indname:=tabIndex(table)[i][IND_NAME]
        indcol:=indname2indcol(table,indname)
        for n:=1 to len(indcol)
            aadd(notnull,indcol[n])
        next
    next
    
    if( output!=NIL )
        set printer to (output)
    else
        set printer to (lower(tabAlias(table))+".tds")
    end
    set printer on
    set console off
    
    outtds(table,primkey,notnull,colskip,nspace,tname)

    return NIL


******************************************************************************
static function outtds(table,primkey,notnull,colskip,nspace,tname)
local n

    ? "name:", if(nspace==NIL,tabAlias(table),nspace)
    ? "version:",'"'+VERSION+'"'
    ?
    ? "table:",if(tname==NIL,tabAlias(table),tname)
    ?

    for n:=1 to len(tabColumn(table))
        if( 0==ascan(colskip,{|x|x==tabColumn(table)[n][COL_NAME]}) )
            outcoldef(table,n,notnull)
        end
    next
    ?

    outpkeydef(table,primkey)
    ?

    for n:=1 to len(tabIndex(table))
        outinddef(table,n,primkey)
    next
    ?

    return NIL


******************************************************************************
static function outcoldef(table,colidx,notnull)
local col,nam,typ,wid,dec

    col:=tabColumn(table)[colidx] 

    nam:=col[COL_NAME] 
    typ:=col[COL_TYPE] 
    wid:=col[COL_WIDTH] 
    dec:=col[COL_DEC] 

    if( typ=="C" )
        if( left(nam,3)=="DBM" .and. wid==10 )
            nam:=substr(nam,4)
            typ:="M"
        else
            typ:="C"+alltrim(str(wid))
        end

    elseif( typ=="N" )
        typ:="N"+alltrim(str(wid)) 
        if( dec!=0 )
            typ+="."+alltrim(str(dec)) 
        end
    end

    ? "column: ",padr(nam,16),padr(typ,8)
    if( 0<ascan(notnull,{|x|x==nam}) )
        ?? "nn"
    end
    return NIL


******************************************************************************
static function outpkeydef(table,primkey)

local indcol:=indname2indcol(table,primkey),n

    ? "primkey: "
    for n:=1 to len(indcol)
        ?? if(n==1,"",",")+indcol[n]
    next
 
    return NIL

******************************************************************************
static function outinddef(table,indidx,primkey)

local indname:=tabIndex(table)[indidx][IND_NAME],n
local indcol:=indname2indcol(table,indname)

    if( indname==primkey )
        //már ki van írva
    else
        ? "index: ",lower(indname)+"(" 
        for n:=1 to len(indcol)
            ?? if(n==1,"",",")+indcol[n]
        next
        ?? ")"
    end
 
    return NIL
 

******************************************************************************
static function indname2indcol(table,indname) //index név -> oszlopok
local indcol:=tabGetIndex(table,indname),n
    indcol:=tabIndex(table)[indcol][IND_COL]
    indcol:=aclone(indcol)
    for n:=1 to len(indcol)
        if( valtype(indcol[n])=="N" )
            indcol[n]:=tabColumn(table)[indcol[n]][COL_NAME]
        end
    next
    return indcol

******************************************************************************
 