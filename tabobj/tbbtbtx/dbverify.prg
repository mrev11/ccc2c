
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
//function tabVerify(table)               //objektum <--> fil� (bels�)
 
******************************************************************************
function tabVerify(table) //egyezteti az objektum �s a fil� adatait
    tabVerifyColumn(table)
    tabVerifyIndex(table) 
    return NIL

******************************************************************************
static function tabVerifyColumn(table) //egyezteti a mez�ket
 
local fld  //a fil�ben tal�lt oszlopok t�mbje
local col  //az objektumban l�v� oszlopok t�mbje
local c,n,m
 
    fld:=tabReadColumn(table)   
    col:=tabColumn(table)  
 
    //for n:=1 to len(fld)
    //    ? padr("'"+fld[n][COL_NAME]+"'",12),fld[n][COL_TYPE],fld[n][COL_WIDTH],fld[n][COL_DEC]
    //next

    for n:=1 to len(col)

        //nem okoz hib�t, ha a fld b�vebb
        
        c:=col[n]
        m:=ascan(fld,{|f|f[COL_NAME]==c[COL_NAME]})

        //if( m!=0 )
        //    ? n, padr(c[COL_NAME],10),;
        //        c[COL_TYPE]  ,fld[m][COL_TYPE],;
        //        c[COL_WIDTH] ,fld[m][COL_WIDTH],;
        //        c[COL_DEC]   ,fld[m][COL_DEC]
        //else
        //    ? n, padr(c[COL_NAME],10), "hi�nyzik"
        //end

        if( m==0.or.;
            c[COL_TYPE]!=fld[m][COL_TYPE].or.;
            c[COL_WIDTH]!=fld[m][COL_WIDTH].or.;
            c[COL_DEC]!=fld[m][COL_DEC] )

            taberrOperation("tabVerify")            
            taberrDescription("DBSTRUCT elt�r�s")
            taberrArgs(c)            
            tabStructError(table) //break van benne
        end
    next 
    
    //az oszlopstrukt�r�t �jra�p�tj�k
    
    asize(tabColumn(table),0) //ki�r�ti
    for n:=1 to len(fld)
        tabAddColumn(table,fld[n])
    next

    return NIL


******************************************************************************
static function tabVerifyIndex(table) //egyezteti az indexeket

local aCtxInd:=tabReadIndex(table)      //a f�jlban tal�lt indexek
local aTabInd:=tabIndex(table,aCtxInd)  //objektum szerinti indexek
local n, i, indnam, rebuild:={}

    //Jelenleg az objektumban a fil�-resource-b�l kiolvasott 
    //index defin�ci� van, ezt egyeztetj�k az eredeti objektumnal.

    for n:=1 to len(aTabInd)
        if( NIL==tabScanIndex(table,aTabInd[n]) )

            //A fil�ben vagy nincs meg aTabInd[n],
            //vagy ha megvan, elt�r a szerkezete.

            aadd(rebuild,indnam:=aTabInd[n][IND_NAME])
            i:=ascan(tabIndex(table),{|x|x[IND_NAME]==indnam})

            if( i>0 )
                adel(tabIndex(table),i)
                asize(tabIndex(table),len(tabIndex(table))-1)
                //egyez� nev�, elt�r� szerkezet� index t�r�lve
            end
            tabAddIndex(table,aTabInd[n])
        end
    next
    
    //Most az objektumban, a fil� �s az eredeti objektum indexeinek
    //uni�ja van, �s azonos nev�, de elt�r� tartalm� indexek eset�n
    //az objektumbeli defin�ci� van megtartva (k�sz a konverzi�ra).
    //A rebuild array tartalmazza az �jra�p�tend� indexek nev�t.
    
    if( !empty(rebuild) )
        taberrOperation("tabVerifyIndex")
        taberrDescription("Inkompatibilis index")
        taberrArgs(rebuild)
        tabIndexError(table) //break van benne
    end

    //Ezen a ponton teljes�l, hogy a fil�ben l�v� indexek 
    //kompatibilisek az objektummal, de lehet, hogy a fil�ben
    //t�bb index is van, �s a sorrendj�k is elt�rhet.
    //A programnak minden megl�v� indexet karban kell tartania,
    //a fil�ben �rv�nyes index sorrendet kell haszn�lnia,
    //ez�rt a legegyszer�bb, ha az index strukt�r�t lecser�lj�k.
    //Az index strukt�r�t a tabAddindex-szel kell �jra�p�teni,
    //hogy a kulcs oszlopok megfelel� blockot kapjanak.
    
    //? "obj inf�:", aTabInd
    //? "res inf�:", aCtxInd
    
    tabIndex(table,{}) //ki�r�ti
    
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
