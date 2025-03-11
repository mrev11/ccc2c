
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


#include "charconv.ch"

#define  CCC(x) _charconv(x,CHARTAB_CWI2CCC)
#define  CWI(x) _charconv(x,CHARTAB_CCC2CWI)
#define  LAT(x) _charconv(x,CHARTAB_CCC2LAT)

#define VERZIO  "1.7"   //2021-02-20 felulvizsgalat

//#define VERZIO  "1.06"  //2001.11.10  (emprow tot_col*2 hossz�) 
//#define VERZIO  "1.05"  //2001.05.08 (inicializ�l�s jav�tva, kis/nagybet� megtartva) 
//#define VERZIO  "1.04"  //2000.01.26 (batch m�d nemt�rli a k�perny�t)
//#define VERZIO  "1.03"  //2000.01.12 (CCC k�drendszer) 
//#define VERZIO  "1.02"  //1999.05.20
//#define VERZIO  "1.01"  //1999.02.09

#define PAGEEXT    ".pge"
 

*************************************************************************

static tot_row:=64            // �sszes sorok sz�ma
static tot_col:=160           // �sszes oszlopok sz�ma

static page                   // a teljes k�pet soronk�nt t�rol� t�mb

static batch_pgefile:=""
static batch_codegen:="*"


*************************************************************************
function main(*)

local arg:={*,NIL}
local n:=0, a

    set date format "yyyy-mm-dd"
    
    while( !empty(a:=arg[++n]) )

        if( PAGEEXT$a .and. file(a) )
            batch_pgefile:=a

        elseif( file(a+PAGEEXT) )
            batch_pgefile:=a+PAGEEXT

        elseif( "-f"$a )
            if( !PAGEEXT$a )
                a+=PAGEEXT
            end
            batch_pgefile:=substr(a,3)

        elseif( "-g"$a )
            batch_codegen:=substr(a,3,1)
            
            if( batch_codegen=="S" )
                //OK .say output
            elseif( batch_codegen=="O" )
                //OK .out output
            else
                errorlevel(1)
                usage()
            end

        elseif( "?"$a .or. "-H"$a )
            usage()

        else
            errorlevel(1)
            usage()
        end
    end

    if( !empty(batch_pgefile) .and. !file(batch_pgefile) )
        ? batch_pgefile+" does not exist"
        errorlevel(1)
        quit
    end

    empchr() //inicializ�lni kell
    emprow() //inicializ�lni kell
    
    page:=array(tot_row)
    for n:=1 to tot_row
        page[n]:=emprow()
    next

    if( !empty(batch_pgefile) )
        readpge(batch_pgefile)

        if( left(batch_codegen,1)=="S" )
            PrgOutS(ExtractName(batch_pgefile),page)

        elseif( left(batch_codegen,1)=="O" )
            PrgOutQ(ExtractName(batch_pgefile),page)
        end
    end


*************************************************************************
function usage()
    ? "Usage: page [[-f]PGEFILE] [-gOUT|-gSAY] [-H|-?|?]"
    quit


*************************************************************************
static function readpge(filnam)

local totpage:=LAT(CCC(memoread(filnam)))
local totlen:=len(totpage)
local begrow, n

    for n:=1 to tot_row
        if( (begrow:=(n-1)*tot_col*2+1)<totlen )
            page[n]:=substr(totpage, begrow, tot_col*2)
        else
            page[n]:=emprow()
        end
    next

    return page

*************************************************************************
function emprow() // egy �res sor (sz�nk�ddal)
static empty_row
    if( empty_row==NIL )
        empty_row:=replicate(empchr(),tot_col)
    end
    return empty_row

*************************************************************************
function empchr() // egy �res karakter (sz�nk�ddal)
static empty_chr
    if( empty_chr==NIL )
        empty_chr:=chr(32)+chr(7)
    end
    return empty_chr


*************************************************************************
function ExtractName(filename)  // file.ext --> file
   return fname(filename)


*************************************************************************
function ModuleName(filename)  // \path\file.ext --> file
local ppos,epos
local f:=filename

   if( empty(filename) )
       filename:=""
   end

   ppos:=rat(dirsep(),filename)
   epos:=rat(".",filename)

   if( epos>ppos )
       filename:=substr(filename,ppos+1,epos-ppos-1)
   else
       filename:=substr(filename,ppos+1)
   end
   
   return filename


*************************************************************************
function getFileName(file,ext)
    
    if( !empty(batch_pgefile) )
        file+=ext
    end
    return .t.
    

*************************************************************************
