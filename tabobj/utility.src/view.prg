
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

#include "box.ch"
#include "directry.ch"
#include "inkey.ch"

#include "utility.ver"
 
#define APPVER APPNAME+" "+VERSION

static APPNAME
 
*********************************************************************
function appview(app)

local fname,control,n:=0,v

    APPNAME:=app
 
    while( NIL!=(v:=argv(++n)) )
        if( v=="-c" )
            control:=argv(++n)
        elseif( v=="-f" )
            fname:=argv(++n)
        else
            fname:=v
        end
    end

    if( fname==NIL )
        ? APPVER, " Copyright (C) ComFirm BT. 1998."
        ? @"Usage: "+lower(APPNAME)+@" <filename>"
        ?
        quit
    end

    fname:=relpath(fname)

    #ifdef _UNIX_
        if( !fname::lower==fname )
            alert( @"Nonlowercase path;;"+fname,{@"Quit"} )
            quit
        end
    #endif

    if( !lower(tabDataExt())$lower(fname)  )
        fname+=lower(tabDataExt())
    end


    setcursor(0)
    setcolor("w/b,b/w")
    set date format to "yyyy.mm.dd"

    //set printer to (APPNAME+".REP")
    //set printer on

    
    if( !file(fname) )
        ? fname,@"not found"
        ?
        quit
    end

    kdirViewData(fname,control)
    return NIL
   

*********************************************************************
function kdirViewData(fname,control)
local brw, tab, recnum, n
local modos:={},index:={}

    if( empty(tab:=kdirOpen(fname)) )
        return NIL
    end
        
    brw:=tabBrowse(tab,0,0,maxrow(),maxcol(),.t.)
    recnum:=TBColumnNew(" Rec#",{||tabPosition(tab)},"9999999")
    brw:insColumn(1,recnum)
    brw:freeze:=1

    brwCaption(brw,APPVER)

    brwMenu(brw,"Struktura","Mezobeosztas megtekintese",{||struktura(brw,tab)},"S")

    for n:=1 to len(tabIndex(tab))
        aadd(index,{tabIndex(tab)[n][1],blkControl(tab,brw,n)})
    next
    aadd(index,{"fizikai sorrend",{||setControl(tab,brw,0)}})
    brwMenu(brw,"Index","Vezerlo index (sorrend) beallitasa",index,"I")

    aadd(modos,{"A kivalasztott rekord modositasa",{||modosit(brw,tab)}})
    aadd(modos,{"Ures rekord hozzaadasa",{||ujrekord(brw,tab)}})
    aadd(modos,{"A kivalasztott rekord torlese",{||torol(brw,tab)}})
    aadd(modos,{"A kivalasztott rekord lockolasa",{||lockol(brw,tab)}})
    aadd(modos,{"Az aktualis allomany PACKolasa",{||pakkol(brw,tab)}})
    aadd(modos,{"Az aktualis allomany ZAPolasa",{||zapol(brw,tab)}})
    aadd(modos,{"Az allomany exkluziv megnyitasa",{||xopen(brw,tab)}})
 
    brwMenu(brw,"Modosit","A kivalasztott rekord modositasa, torlese, packolas",modos,"M")


    brwApplyKey(brw,{|b,k|appkey(b,k,tab)})
    brwSetFocus(brw)
    brwMenuName(brw,"["+fname+"]")
    //brwMenuName(brw,"["+fnameext(fname)+"]")

    setControl(tab,brw,control)

    brwShow(brw)
    brwLoop(brw)
    brwHide(brw)
    tabClose(tab)
    tabDestruct(tab)

    return NIL


************************************************************************
static function appkey(brw,key,tab)

    if( key==asc("/") )
        keres(brw,tab)
        return .t.
    end
    return NIL

************************************************************************
static function struktura(dbfbrw,tab)
local brw:=brwCreate(1,32,maxrow()-1,maxcol()-1)
local str:=tabColumn(tab), n, total:=0
   
    brwKillFocus(dbfbrw)

    for n:=1 to len(str)
         total+=str[n][3]
    next
    brwFooting(brw,{"Rekordhossz: "+alltrim(str(total,4))+" byte","",""})
    brw:headSep:=B_HD
    brw:colSep:="  "
    brw:footSep:=B_HD
    brw:colorSpec:="n/w,w/n,,,n/w"
    brwArray(brw,str)

    brwColumn(brw,"Name",brwABlock(brw,1),32)
    brwColumn(brw,"Typ",brwABlock(brw,2),3)
    brwColumn(brw,"Len",brwABlock(brw,3),"@Z 999")
    brwColumn(brw,"Dec",brwABlock(brw,4),"@Z 999")

    brwMenuName(brw,rightName(tabPathname(tab),26))
    brwMenu(brw,"","adatbazis mezobeosztasa",{||.f.})
    brwSetFocus(brw)
    brwShow(brw)
    brwLoop(brw)
    brwHide(brw)
    brwSetFocus(dbfbrw)
    return .t.


************************************************************************
static function blkControl(tab,brw,ord)
    return {||setControl(tab,brw,ord)} 


************************************************************************
static function setControl(tab,brw,ord)
local indname
    
    if( empty(ord) )
        indname:="fizikai sorrend"
    elseif( valtype(ord)=="N" )
        indname:=tabIndex(tab)[ord][1]
    else
        indname:=ord
    end

    tabControl(tab,ord)
    brwFooting(brw,{"Allomany: "+rightName(tabPathName(tab),28),,"Sorrend: "+indname})
    brw:refreshAll()
    return .t.


************************************************************************
static function kdirOpen(fname)
local tab:=tabResource(fname)

    if( valtype(tab)!="A" .or.  empty(tab) )
        alert(fname+" foglalt!")
        tab:=NIL 
    else
        tabOpen(tab)
    end
    return tab


************************************************************************
function rightName(name,length)
    return if(len(name)<=length,name,"..."+right(name,length-3))


************************************************************************
static function fnameext(name)   // name.ext
local bslpos:=rat(dirsep(),name)
    name:=substr(name,bslpos+1)
    return alltrim(name)


************************************************************************
static function relpath(fname)
local dn:=dirname()+dirsep()
    if( at(dn,fname)==1 )
        fname:=substr(fname,len(dn)+1)
    end
    return fname


************************************************************************
