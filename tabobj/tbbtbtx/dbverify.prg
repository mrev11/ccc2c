
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
//
//function tabVerify(table)               //objektum <--> filé (belsõ)
 
******************************************************************************
function tabVerify(table) //egyezteti az objektum és a filé adatait
    tabVerifyColumn(table)
    tabVerifyIndex(table) 
    return NIL

******************************************************************************
static function tabVerifyColumn(table) //egyezteti a mezõket
 
local fld  //a filében talált oszlopok tömbje
local col  //az objektumban lévõ oszlopok tömbje
local c,n,m
 
    fld:=tabReadColumn(table)   
    col:=tabColumn(table)  
 
    //for n:=1 to len(fld)
    //    ? padr("'"+fld[n][COL_NAME]+"'",12),fld[n][COL_TYPE],fld[n][COL_WIDTH],fld[n][COL_DEC]
    //next

    for n:=1 to len(col)

        //nem okoz hibát, ha a fld bõvebb
        
        c:=col[n]
        m:=ascan(fld,{|f|f[COL_NAME]==c[COL_NAME]})

        //if( m!=0 )
        //    ? n, padr(c[COL_NAME],10),;
        //        c[COL_TYPE]  ,fld[m][COL_TYPE],;
        //        c[COL_WIDTH] ,fld[m][COL_WIDTH],;
        //        c[COL_DEC]   ,fld[m][COL_DEC]
        //else
        //    ? n, padr(c[COL_NAME],10), "hiányzik"
        //end

        if( m==0.or.;
            c[COL_TYPE]!=fld[m][COL_TYPE].or.;
            c[COL_WIDTH]!=fld[m][COL_WIDTH].or.;
            c[COL_DEC]!=fld[m][COL_DEC] )

            taberrOperation("tabVerify")            
            taberrDescription("DBSTRUCT eltérés")
            taberrArgs(c)            
            tabStructError(table) //break van benne
        end
    next 
    
    //az oszlopstruktúrát újraépítjük
    
    asize(tabColumn(table),0) //kiüríti
    for n:=1 to len(fld)
        tabAddColumn(table,fld[n])
    next

    return NIL


******************************************************************************
static function tabVerifyIndex(table) //egyezteti az indexeket

local aCtxInd:=tabReadIndex(table)      //a fájlban talált indexek
local aTabInd:=tabIndex(table,aCtxInd)  //objektum szerinti indexek
local n, i, indnam, rebuild:={}

    //Jelenleg az objektumban a filé-resource-ból kiolvasott 
    //index definíció van, ezt egyeztetjük az eredeti objektumnal.

    for n:=1 to len(aTabInd)
        if( NIL==tabScanIndex(table,aTabInd[n]) )

            //A filében vagy nincs meg aTabInd[n],
            //vagy ha megvan, eltér a szerkezete.

            aadd(rebuild,indnam:=aTabInd[n][IND_NAME])
            i:=ascan(tabIndex(table),{|x|x[IND_NAME]==indnam})

            if( i>0 )
                adel(tabIndex(table),i)
                asize(tabIndex(table),len(tabIndex(table))-1)
                //egyezõ nevû, eltérõ szerkezetû index törölve
            end
            tabAddIndex(table,aTabInd[n])
        end
    next
    
    //Most az objektumban, a filé és az eredeti objektum indexeinek
    //uniója van, és azonos nevû, de eltérû tartalmú indexek esetén
    //az objektumbeli definíció van megtartva (kész a konverzióra).
    //A rebuild array tartalmazza az újraépítendõ indexek nevét.
    
    if( !empty(rebuild) )
        taberrOperation("tabVerifyIndex")
        taberrDescription("Inkompatibilis index")
        taberrArgs(rebuild)
        tabIndexError(table) //break van benne
    end

    //Ezen a ponton teljesül, hogy a filében lévõ indexek 
    //kompatibilisek az objektummal, de lehet, hogy a filében
    //több index is van, és a sorrendjük is eltérhet.
    //A programnak minden meglévõ indexet karban kell tartania,
    //a filében érvényes index sorrendet kell használnia,
    //ezért a legegyszerûbb, ha az index struktúrát lecseréljük.
    //Az index struktúrát a tabAddindex-szel kell újraépíteni,
    //hogy a kulcs oszlopok megfelelõ blockot kapjanak.
    
    //? "obj infó:", aTabInd
    //? "res infó:", aCtxInd
    
    tabIndex(table,{}) //kiüríti
    
    for n:=1 to len(aCtxInd)
        tabAddIndex(table,aCtxInd[n])
    next

    return NIL

******************************************************************************
static function tabReadColumn(table)
local buffer:=space(4096)
    _db_read1(table[TAB_BTREE],buffer,1,0)
    return _chr2arr(buffer)

******************************************************************************
static function tabReadIndex(table)
local buffer:=space(4096)
    _db_read1(table[TAB_BTREE],buffer,1,1)
    return _chr2arr(buffer)

******************************************************************************
