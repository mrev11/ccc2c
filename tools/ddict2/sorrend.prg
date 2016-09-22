
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

//KARBANTART�S

#include "table.ch"
#include "_ddict.ch"
#include "_dummy.ch"

#include "msksor.say"

****************************************************************************
// Bevitel
****************************************************************************
function sorBev(browse) // �j sorrend bevitele
local pos:=DDICT:position
    brwKillFocus(browse)

    msksor({|g|loadBev(g)},{|g|readmodal(g)},{|g|storeBev(g,browse)})

    if( DDICT:eof )
        //nem t�rt�nt append
        DDICT:goto(pos)
    else
        browse:refreshAll()
    end

    brwSetFocus(browse)
    return NIL

****************************************************************************
static function loadBev(getlist)

    //aeval(getlist,{|g|g:picture:="@!"})
    aeval(getlist,{|g|g:picture:=if("col"$g:name,"@S16! NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN","@!")})

    g_tab:postBlock:={||valTabName(getlist)}
    g_ord:postBlock:={||valOrdName(getlist)}
    g_ind:postBlock:={||valIndFile(getlist)}

    g_col1:postBlock:={|g|oszlop(getlist,g)}
    g_col2:postBlock:={|g|oszlop(getlist,g)}
    g_col3:postBlock:={|g|oszlop(getlist,g)}
    g_col4:postBlock:={|g|oszlop(getlist,g)}
    g_col5:postBlock:={|g|oszlop(getlist,g)}
    g_col6:postBlock:={|g|oszlop(getlist,g)}
    g_col7:postBlock:={|g|oszlop(getlist,g)}
    g_col8:postBlock:={|g|oszlop(getlist,g)}

    g_dir:picture:="@!S"+alltrim(str(len(g_dir:varGet())))
    g_dir:varPut(space(len(DDICT_DIRECTORY)))
    
    aeval(getlist,{|g|g:display()})

    DDICT:goto(0) //az append el�k�sz�t�se alatt EOF-on �llunk
    return NIL


****************************************************************************
static function storeBev(getlist,browse)

local dir:=alltrim(g_dir:varGet())
local tab:=alltrim(g_tab:varGet())
local ord:=alltrim(g_ord:varGet())
local ind:=alltrim(g_ind:varGet())
local cols:=indexp(getlist)
local struct, ver
    
    if( empty(owner()) )
        return .f.
    end
    
    if( empty(cols) .and. !empty(ord)  )
        alert("Nincs egy oszlop sem!")
        return .f.
    end
    
    if( !empty(cols) .and. empty(ord) )
        alert("Felesleges oszlopok!")
        return .f.
    end

    DDICT:seek(tab)
    if( alltrim(DDICT_TABLE)==tab )
        struct:=DDICT_DBMSTRUCT
        ver:=DDICT_VERSION
    else
        struct:=atoc(g_tab:cargo)
        ver:=1000
    end

    DDICT:append

    DDICT_DIRECTORY := dir
    DDICT_TABLE     := tab
    DDICT_INDNAME   := ord
    DDICT_INDFILE   := ind
    DDICT_INDFIELD  := cols
    DDICT_VERSION   := ver
    DDICT_STATE     := "!"
    DDICT_DBMSTRUCT := struct
    DDICT_OWNER     := owner()
    DDICT_STRDATE   := dtos(date())+time() //94.10.05
    DDICT:unlock

    if( empty(dir) )
        tabDirectory(tabDirectory()) 
    else
        tabDirectory(dir) 
    end
    browse:refreshAll()

    return .t.
    

****************************************************************************
static function indexp(getlist)
local cols:=""

    if( !empty(g_col1:varGet()) )
        cols+=upper(alltrim(g_col1:varGet()))
    end
    if( !empty(g_col2:varGet()) )
        cols+=","+upper(alltrim(g_col2:varGet()))
    end
    if( !empty(g_col3:varGet()) )
        cols+=","+upper(alltrim(g_col3:varGet()))
    end
    if( !empty(g_col4:varGet()) )
        cols+=","+upper(alltrim(g_col4:varGet()))
    end
    if( !empty(g_col5:varGet()) )
        cols+=","+upper(alltrim(g_col5:varGet()))
    end
    if( !empty(g_col6:varGet()) )
        cols+=","+upper(alltrim(g_col6:varGet()))
    end
    if( !empty(g_col7:varGet()) )
        cols+=","+upper(alltrim(g_col7:varGet()))
    end
    if( !empty(g_col8:varGet()) )
        cols+=","+upper(alltrim(g_col8:varGet()))
    end
    
    return cols


****************************************************************************
static function valTabName(getlist)

//m�r szerepel az adatsz�t�rban, vagy
//l�teznie kell az adat�llom�nynak a megadott helyen

local state:=DDICT:save
local dir:=alltrim(g_dir:varGet())
local tab:=alltrim(g_tab:varGet())
local struct
local result:=.f.

    DDICT:seek(tab)

    if( alltrim(DDICT_TABLE)==tab )
        g_tab:cargo:=ctoa(DDICT_DBMSTRUCT)
        result:=.t.

    elseif( empty(struct:=structColumn(dir,tab)) )
        alert("Az adatb�zis �llom�ny nem tal�lhat�!")
    else
        g_tab:cargo:=struct
        result:=.t.
    end
    DDICT:restore(state)
    return result


****************************************************************************
static function valOrdName(getlist)

// tab+ver+ord egyedi kell legyen

local pos:=DDICT:position
local tab:=alltrim(g_tab:varGet())
local ord:=alltrim(g_ord:varGet())
local ver, fnd:=.f.

    DDICT:seek(tab)

    if( alltrim(DDICT_TABLE)==tab )
        ver:=DDICT_VERSION //�j sorrend
    else
        ver:=1000 //�j t�bla
    end
    
    while( !DDICT:eof .and. alltrim(DDICT_TABLE)==tab )
    
        if( DDICT:position!=pos .and.;
            DDICT_VERSION==ver .and.;
            alltrim(DDICT_INDNAME)==ord )

            alert("Sorrend nem egyedi!")
            fnd:=.t.
            exit
        end 
        DDICT:skip
    end
    
    DDICT:goto(pos)
    return !fnd


****************************************************************************
static function valIndFile(getlist)

//biztos�tani kell, hogy az indexfil�k ne �tk�zzenek,
//kor�bban ez az eg�sz t�bl�ban t�rt�n� keres�s r�v�n val�sult meg,
//egyszer�bb, ha k�telez�en a table nev�b�l sz�rmaztatjuk

local pos:=DDICT:position
local tab:=alltrim(g_tab:varGet())
local ord:=alltrim(g_ord:varGet())
local ind:=alltrim(g_ind:varGet())
local t1:=left(tab,1)
local result:=.t.

    if( empty(ind) )
        if( !empty(ord) )
            alert("Indexfil� magad�sa k�telez�!")
            result:=.f.
        end

    elseif( at(tab,ind)!=1 )
    
        //Az indexn�v k�pz�s szab�lya, 
        //hogy a t�blanevet egyszer�en megism�telj�k,
        //vagy t�bb index eset�n sz�mokkal kieg�sz�tj�k.

        alert("Nem kompatibilis az adatb�zis nev�vel!")
        result:=.f.

    else
        DDICT:seek(t1)

        while( !DDICT:eof .and. left(DDICT_TABLE,1)==t1 )

            if( DDICT:position!=pos .and. alltrim(DDICT_INDFILE)==ind  )
                alert("Az index fil� nem egyedi!")
                result:=.f.
                exit
            end
            DDICT:skip
        end
    end

    DDICT:goto:=pos
    return result


****************************************************************************
// M�dos�t�s
****************************************************************************
function sorMod(browse) // sorrend m�dos�t�sa
    if( structLatest("Csak az utols� verzi� m�dos�that�!") )
        brwKillFocus(browse)
        msksor({|g|loadMod(g)},{|g|readmodal(g)},{|g|storeMod(g,browse)})
        brwSetFocus(browse)
    end
    return NIL


****************************************************************************
function sorNez(browse) // n�zeget�s INS billenty�re
    brwKillFocus(browse)
    msksor({|g|loadMod(g)},{|s|s:=setcursor(0),inkey(0),setcursor(s)},{||.t.})
    brwSetFocus(browse)
    return NIL


****************************************************************************
static function loadMod(getlist)

local indcol:=wordlist(DDICT_INDFIELD)

    //aeval(getlist,{|g|g:picture:="@!"})
    aeval(getlist,{|g|g:picture:=if("col"$g:name,"@S16! NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN","@!")})
    
    g_tab:cargo:=ctoa(DDICT_DBMSTRUCT)
    g_tab:preBlock:={||.f.}

    g_ord:postBlock:={||valOrdName(getlist)}
    g_ind:postBlock:={||valIndFile(getlist)}

    g_col1:postBlock:={|g|oszlop(getlist,g)}
    g_col2:postBlock:={|g|oszlop(getlist,g)}
    g_col3:postBlock:={|g|oszlop(getlist,g)}
    g_col4:postBlock:={|g|oszlop(getlist,g)}
    g_col5:postBlock:={|g|oszlop(getlist,g)}
    g_col6:postBlock:={|g|oszlop(getlist,g)}
    g_col7:postBlock:={|g|oszlop(getlist,g)}
    g_col8:postBlock:={|g|oszlop(getlist,g)}

    g_dir:picture:="@!S"+alltrim(str(len(g_dir:varGet())))
    g_dir:varPut(space(len(DDICT_DIRECTORY)))

    g_tab:varPut(DDICT_TABLE)
    g_ord:varPut(DDICT_INDNAME)
    g_ind:varPut(DDICT_INDFILE)

    if( len(indcol)>=1 )
        //g_col1:varPut(padr(indcol[1],10)) //ez volt: 2008.06.25
        g_col1:varPut(indcol[1])
    end
    if( len(indcol)>=2 )
        g_col2:varPut(indcol[2])
    end
    if( len(indcol)>=3 )
        g_col3:varPut(indcol[3])
    end
    if( len(indcol)>=4 )
        g_col4:varPut(indcol[4])
    end
    if( len(indcol)>=5 )
        g_col5:varPut(indcol[5])
    end
    if( len(indcol)>=6 )
        g_col6:varPut(indcol[6])
    end
    if( len(indcol)>=7 )
        g_col7:varPut(indcol[7])
    end
    if( len(indcol)>=8 )
        g_col8:varPut(indcol[8])
    end

    g_dir:varPut(tabDirectory())
    aeval(getlist,{|g|g:display()})
    return NIL


****************************************************************************
static function storeMod(getlist,browse)

local dir:=alltrim(g_dir:varGet())
local tab:=alltrim(g_tab:varGet())
local ord:=alltrim(g_ord:varGet())
local ind:=alltrim(g_ind:varGet())
local cols:=indexp(getlist)

    if( empty(owner()) )
        //nincs usern�v
        return .f.
    end

    if( empty(cols) .and. !empty(ord)  )
        alert("Nincs egy oszlop sem!")
        return .f.
    end
    
    if( !empty(cols) .and. empty(ord) )
        alert("Felesleges oszlopok!")
        return .f.
    end

    DDICT:rlock
    DDICT_DIRECTORY := dir
    DDICT_INDNAME   := ord
    DDICT_INDFILE   := ind
    DDICT_INDFIELD  := cols
    DDICT_STATE     := "!"
    DDICT_OWNER     := owner()
    DDICT_STRDATE   := dtos(date())+time()
    DDICT:unlock
 
    tabDirectory(g_dir:varGet()) //a t�bbi rekordban is �t�rja
    browse:refreshAll()

    return .t.
   

****************************************************************************
function sorTor(browse)  // sorrend t�rl�se

    if( structLatest("R�gebbi verzi�t a verzi�t�rl�ssel t�r�lj!") )

        if(2==alert("T�rli a rekordot?",{"Meghagy","T�r�l"}))
            DDICT:rlock
            DDICT:delete
            DDICT:unlock
            DDICT:skip(-1)
            browse:refreshAll()
        end
    end
    return NIL
    

****************************************************************************
static function tabDirectory(dir) //be�ll�tja/lek�rdezi DIRECTORY-t

local pos:=DDICT:position
local tab:=DDICT_TABLE
local ver:=DDICT_VERSION

    if( dir==NIL )
        dir:=space(len(DDICT_DIRECTORY))
        DDICT:seek(tab)
        while( !DDICT:eof .and. DDICT_TABLE==tab .and. DDICT_VERSION==ver )
            if( !empty(DDICT_DIRECTORY) )
                dir:=DDICT_DIRECTORY
                exit
            end
            DDICT:skip
        end

    else

        DDICT:seek(tab)

        while( !DDICT:eof .and. DDICT_TABLE==tab .and. DDICT_VERSION==ver )

            if( alltrim(DDICT_DIRECTORY)==alltrim(dir) )
                //nem kell m�dos�tani
            elseif( !DDICT:rlock({||.f.}) ) 
                //nem lehet lockolni
            else
                DDICT_DIRECTORY:=dir
                DDICT:unlock
            end
            DDICT:skip
        end
    end

    DDICT:goto(pos)
    return dir


****************************************************************************
static function oszlop(getlist,get) //ellen�rzi egy oszlopn�v l�tez�s�t

local name:=get:varGet()
local struct:=g_tab:cargo
local choice
    if( empty(name) .or. 0<ascan(struct,{|c|c[1]==alltrim(name)}) )
        return .t.
    elseif( (choice:=browseStruct(struct,DDICT_TABLE,{3,10,23,50}))>0 )
        get:varPut(struct[choice][1])
        get:display()
        return .t.
    end
    return .f.


****************************************************************************
