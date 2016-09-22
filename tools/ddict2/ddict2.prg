
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
function main(a,b,c,d) //argumentumok: dbf directory, adatsz�t�r

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
        ? "Haszn�lat: ddict2 [dbfDir [ddPathName]]  [-u+|-u-] [-s+|-s-]"
        ?
        ? "dbfDir     : a dbf-eket tartalmaz� directory (default='.')"
        ? "ddPathName : az adatsz�t�r adatb�zis �llom�ny (default='datadict')"
        ? "-u+,-u-    : al�h�z�sos objektumgener�l� f�ggv�nyek (default: -u+)"
        ? "-s+,-s-    : kellenek-e a _super??.prg modulok (default: -s+)"
        ?
        ? "St�tuszok"
        ?
        ? "' ': OK"
        ? "'F': nincs megadva az NTX neve"
        ? "'O': az indexnek egyetlen oszlopa sincs megadva"
        ? "<n>: az <n>-edik kulcs oszlop nem l�tezik"
        ? "'?': az adatb�zis (dbf) �llom�ny nem el�rhet�"
        ? "'*': a sz�t�rban t�rolt strukt�ra elt�r a dbf strukt�r�j�t�l"
        ? "'!': m�dos�t�s r�v�n megv�ltozott tartalm� rekord"
        ? "'M': a k�ls� sz�t�rb�l import�lva"
        ?
        ? "�ss le egy billenty�t!"
        inkey(0)
    end

    dbfdir := if(NIL==p[1],".",p[1])
    ddict  := if(NIL==p[2],"datadict",p[2])
    
    dbfRoot(dbfdir)  //be�ll�tja a dbf directory-t
    
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
    brwColumn(browse,"T�bla",{||tabver()},18)
    brwColumn(browse,"Sorrend",{||lower(DDICT_INDNAME)},10)
    brwColumn(browse,"Index oszlopok",{||DDICT_INDFIELD},36)
    brwColumn(browse,"Directory",{||DDICT_DIRECTORY},28)
    brwColumn(browse,"M�dos�t�",{||DDICT_OWNER})
    brwColumn(browse,"D�tum",{||DDICT_STRDATE})
    brwColumn(browse,"NTX file",{||lower(DDICT_INDFILE)},16)

    brwMenuName(browse,"[Sz�t�r:"+upper(ddictName())+if(empty(underscore()),""," UNDERSCORE")+"]")

    aadd(struct,{"Ellen�rz�s az �sszes DBF-re           (ALT-V)",{||structVerif(browse)}})
    aadd(struct,{"A t�rolt strukt�ra elt�r�se a DBF-t�l (ALT-X)",{||browseDiff(browse)}})
    aadd(struct,{"A t�rolt strukt�ra megtekint�se       (ALT-T)",{||structBrowse(browse)}})
    aadd(struct,{"A DBF-beli strukt�ra elt�rol�sa              ",{||structReplace(browse)}})
    aadd(struct,{"DBF l�trehoz�sa a t�rolt strukt�r�val        ",{||structCreate(browse)}})
    aadd(struct,{"V�ltoz�sok �tv�tele k�ls� adatsz�t�rb�l      ",{||mergeDdict(browse)}})
    aadd(struct,{"A kiv�lasztott t�bla browse-ol�sa     (ALT_B)",{||browseData(browse)}})
    brwMenu(browse,"Strukt�ra","A t�rolt �s a DBF-ben tal�lt strukt�r�k �sszevet�se",struct)

    aadd(karbtart,{"T�bla defin�ci� bevitele      (ALT-A)",{||sorBev(browse)}})
    aadd(karbtart,{"Aktu�lis defin�ci� m�dos�t�sa (ALT-M)",{||sorMod(browse)}})
    aadd(karbtart,{"Aktu�lis defin�ci� t�rl�se           ",{||sorTor(browse)}})
    aadd(karbtart,{MENUSEP})
    aadd(karbtart,{"Verzi� k�sz�t�se sorsz�m n�vel�ssel  ",{||verzioMake(),browse:refreshAll(),.t.}})
    aadd(karbtart,{"Kor�bbi verzi� rekordjainak t�rl�se  ",{||verzioDelete(),browse:refreshAll(),.t.}})
    brwMenu(browse,"Karbantart�s","Index defin�ci�k bevitele, m�dos�t�sa, t�rl�se",karbtart)

    aadd(program,{"#ifdef ARROW vegyes t�pus� include-ok",{||progOutPut(browse,"##")}})
    aadd(program,{"(FIELD:alias:count) t�pus� include-ok",{||progOutPut(browse,"::")}})
    aadd(program,{"alias->field t�pus� include-ok (RDD)",{||progOutPut(browse,"->")}})
    brwMenu(browse,"Program","Programkimenet (PRG-CH) el��ll�t�sa",program)

    brwMenu(browse,"T�m�r�t�s!","Az adatsz�t�r t�m�r�t�se",{||ddictPack(browse),.t.})

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
        return 2!=alert("Ki akar l�pni a programb�l?", {"Marad","Kil�p"}) 

    end

    return brwSeekKey(b,2,k)


****************************************************************************
function dbfRoot(path)  //a dbf-ekhez vezet� path
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
