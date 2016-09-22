
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

#include "ddict2.ver"


#include "inkey.ch"
 
#include "table.ch"
#include "_ddict.ch"


****************************************************************************
function main(a,b,c,d) //argumentumok: dbf directory, adatszótár

local sset:=standardset()
local psiz:=4
local p:=array(psiz),i,dbfdir,ddict
local karbtart:={}, struct:={}, program:={}
local ddpath, ddname, n
local browse

    p[1]:=a
    p[2]:=b
    p[3]:=c
    p[4]:=d

    i:=1
    while( i<=len(p) .and. p[i]!=NIL )
    
        p[i]:=strtran(p[i],"/",dirsep())
        p[i]:=strtran(p[i],"\",dirsep())
 
        if( p[i]$",-u+,/u+,/u,-u," )
            underscore("_") //default
            adel(p,i)

        elseif( p[i]$",-u-,/u-," )
            underscore("") 
            adel(p,i)

        elseif( p[i]$",-s+,/s+,/s,-s," )
            superlist(.t.) //default
            adel(p,i)

        elseif( p[i]$",-s-,/s-," )
            superlist(.f.) 
            adel(p,i)

        else
            i++
        end
    end
    
    if( p[1]==NIL )
        ? "Data Dictionary Utility Version "+VERZIO
        ? "Copyright (C) ComFirm BT. 1998. All rights reserved"

        ?
        ? "Használat: ddict2 [dbfDir [ddPathName]]  [-u+|-u-] [-s+|-s-]"
        ?
        ? "dbfDir     : a dbf-eket tartalmazó directory (default='.')"
        ? "ddPathName : az adatszótár adatbázis állomány (default='datadict')"
        ? "-u+,-u-    : aláhúzásos objektumgeneráló függvények (default: -u+)"
        ? "-s+,-s-    : kellenek-e a _super??.prg modulok (default: -s+)"
        ?
        ? "Státuszok"
        ?
        ? "' ': OK"
        ? "'F': nincs megadva az NTX neve"
        ? "'O': az indexnek egyetlen oszlopa sincs megadva"
        ? "<n>: az <n>-edik kulcs oszlop nem létezik"
        ? "'?': az adatbázis (dbf) állomány nem elérhetõ"
        ? "'*': a szótárban tárolt struktúra eltér a dbf struktúrájától"
        ? "'!': módosítás révén megváltozott tartalmú rekord"
        ? "'M': a külsõ szótárból importálva"
        ?
        ? "Üss le egy billentyût!"
        inkey(0)
    end

    dbfdir := if(NIL==p[1],".",p[1])
    ddict  := if(NIL==p[2],"datadict",p[2])
    
    dbfRoot(dbfdir)  //beállítja a dbf directory-t
    
    n:=max( rat(dirsep(),ddict), rat(":",ddict) )   
    DDICT:path:=left(ddict,n)
    DDICT:file:=substr(ddict,n+1)
    tabDelIndex(DDICT:table)
    
    DDICT:upgrade
    DDICT:open
    DDICT:control:="table"
    DDICT:gotop

    browse:=DDICT:browse(0,0,maxrow(),maxcol())

    brwColumn(browse,"",{||DDICT_STATE},1)
    brwColumn(browse,"Tábla",{||tabver()},18)
    brwColumn(browse,"Sorrend",{||lower(DDICT_INDNAME)},10)
    brwColumn(browse,"Index oszlopok",{||DDICT_INDFIELD},36)
    brwColumn(browse,"Directory",{||DDICT_DIRECTORY},28)
    brwColumn(browse,"Módosító",{||DDICT_OWNER})
    brwColumn(browse,"Dátum",{||DDICT_STRDATE})
    brwColumn(browse,"NTX file",{||lower(DDICT_INDFILE)},16)

    brwMenuName(browse,"[Szótár:"+upper(ddictName())+if(empty(underscore()),""," UNDERSCORE")+"]")

    aadd(struct,{"Ellenõrzés az összes DBF-re           (ALT-V)",{||structVerif(browse)}})
    aadd(struct,{"A tárolt struktúra eltérése a DBF-tõl (ALT-X)",{||browseDiff(browse)}})
    aadd(struct,{"A tárolt struktúra megtekintése       (ALT-T)",{||structBrowse(browse)}})
    aadd(struct,{"A DBF-beli struktúra eltárolása              ",{||structReplace(browse)}})
    aadd(struct,{"DBF létrehozása a tárolt struktúrával        ",{||structCreate(browse)}})
    aadd(struct,{"Változások átvétele külsõ adatszótárból      ",{||mergeDdict(browse)}})
    aadd(struct,{"A kiválasztott tábla browse-olása     (ALT_B)",{||browseData(browse)}})
    brwMenu(browse,"Struktúra","A tárolt és a DBF-ben talált struktúrák összevetése",struct)

    aadd(karbtart,{"Tábla definíció bevitele      (ALT-A)",{||sorBev(browse)}})
    aadd(karbtart,{"Aktuális definíció módosítása (ALT-M)",{||sorMod(browse)}})
    aadd(karbtart,{"Aktuális definíció törlése           ",{||sorTor(browse)}})
    aadd(karbtart,{MENUSEP})
    aadd(karbtart,{"Verzió készítése sorszám növeléssel  ",{||verzioMake(),browse:refreshAll(),.t.}})
    aadd(karbtart,{"Korábbi verzió rekordjainak törlése  ",{||verzioDelete(),browse:refreshAll(),.t.}})
    brwMenu(browse,"Karbantartás","Index definíciók bevitele, módosítása, törlése",karbtart)

    aadd(program,{"#ifdef ARROW vegyes típusú include-ok",{||progOutPut(browse,"##")}})
    aadd(program,{"(FIELD:alias:count) típusú include-ok",{||progOutPut(browse,"::")}})
    aadd(program,{"alias->field típusú include-ok (RDD)",{||progOutPut(browse,"->")}})
    brwMenu(browse,"Program","Programkimenet (PRG-CH) elõállítása",program)

    brwMenu(browse,"Tömörítés!","Az adatszótár tömörítése",{||ddictPack(browse),.t.})

    browse:freeze:=2

    brwApplyKey(browse,{|b,k|applykey(b,k)})
    brwCaption(browse,"Data Dictionary Utility "+VERZIO)
    brwSetFocus(browse)

    if( underscore()=="_" )
        browse:colorspec("w/b,bg/w,,,w/b")
    else
        browse:colorspec("w/n,bg/w,,,w/n")
    end
    
    brwShow(browse)
    brwLoop(browse)
    brwHide(browse)

    setcolor("w/n,n/w")
    cls
    return NIL


****************************************************************************
static function tabver()
    return DDICT_TABLE+str(int(1000.0001-DDICT_VERSION),3,0) 


****************************************************************************
static function brwSeekKey(browse,ncol,key)
local column:=browse:getColumn(ncol)
local pos

#define HEADING   column:cargo[1]
#define SEEKKEY   column:cargo[2]

    if( column:cargo==NIL )
        column:cargo:={column:heading,""}
    end
    
    if( 32<key.and.key<255 )
        SEEKKEY+=upper(chr(key))

        DDICT:seek(SEEKKEY)

        if( DDICT_TABLE!=SEEKKEY )
            SEEKKEY:=left(SEEKKEY,len(SEEKKEY)-1)
        else
            pos:=DDICT:position
            browse:goTop()
            DDICT:goto:=pos
            column:heading:=SEEKKEY
            browse:configure()
            browse:refreshAll()
        end
        return .t.

    elseif( !empty(SEEKKEY) )
        SEEKKEY:=""
        column:heading:=HEADING //vissza az eredetit
        browse:configure()
        browse:refreshAll()
    end

    return NIL


****************************************************************************
static function applykey(b,k)
    if(k==K_ALT_M)
        sorMod(b)
        return .t.

    elseif(k==K_INS)
        sorNez(b)
        return .t.

    elseif(k==K_ALT_A)
        sorBev(b)
        return .t.

    elseif(k==K_ALT_V)
        structVerif(b)
        return .t.

    elseif(k==K_ALT_X)
        browseDiff(b)
        return .t.

    elseif(k==K_ALT_T)
        structBrowse(b)
        return .t.

    elseif(k==K_ALT_B)
        browseData(b)
        return .t.

    elseif(k==K_ESC)
        return 2!=alert("Ki akar lépni a programból?", {"Marad","Kilép"}) 

    end

    return brwSeekKey(b,2,k)


****************************************************************************
function dbfRoot(path)  //a dbf-ekhez vezetõ path
static rootpath:=""
    if( !empty(path) )
        path:=upper(alltrim(path))
        if( !right(path,1)$":"+dirsep() )
            path+=dirsep()
        end
        rootpath:=path
    end
    return rootpath


****************************************************************************
function ddictName()
    return DDICT:file


****************************************************************************
function ddictPath()
    return DDICT:path


****************************************************************************
function ddictPack()
local state:=DDICT:save
    if( DDICT:open(OPEN_EXCLUSIVE,{||.f.}) )
        DDICT:pack
        DDICT:open
    end
    DDICT:restore:=state
    return NIL


****************************************************************************
function standardset()

    setcursor(0)
    setcolor("w/bg,b/w")
    underscore("_") //default

    return NIL


****************************************************************************
