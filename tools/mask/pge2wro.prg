
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

//*******************************************************************
// Utility page filék wro filékre való konvertálására
// 1999, Csiszár Levente

#include "inkey.ch"

#include "charconv.ch"

#define  CCC(x) _charconv(x,CHARTAB_CWI2CCC)
#define  CWI(x) _charconv(x,CHARTAB_CCC2CWI)
 
*************************************************************************
// Mj.: A cr_lf() függvény ide nem jó!
#define CR_LF chr(13)+chr(10)

*************************************************************************

#define SCR_MAXROW 25
#define SCR_MAXCOL 80

#define PGE_MAXROW 64            // összes sorok száma
#define PGE_MAXCOL 160           // összes oszlopok száma


*************************************************************************
function main(p1,p2,p3,p4,p5/*pgefile,wrofile*/)
local pge,pgestr,n,begrow
local pgefile,wrofile,sima:=.f.
local p:={p1,p2,p3,p4,p5}
local i,w,kellPict:=.f.
local srTomb

   set scoreboard off
   set date to ansi
   for i:=1 to len(p)
      p[i]:=lower(ifNil(p[i],""))
      if (!empty(p[i]))
         if (left(p[i],1)=='-')
            w:=substr(p[i],2)
            sima:=sima .or. 's'$lower(w)
            kellPict:=kellPict .or. 'p'$lower(w)
            if (w=="r")
               // alert("Hopp!")
               w:=memoread(p[i+1])
               w:=strtran(w,chr(10),"")
               w:=strtran(w,chr(13),"")
               w:=strtran(w," ","")
               srTomb:=wordlist(w)
               i++
            endif
         elseif (pgefile==nil)
            pgefile:=p[i]
         elseif (wrofile==nil)
            wrofile:=p[i]
         endif
      endif
   end for
   if (empty(pgefile))
      ?? "page->wro konverziós program. PGE2WRO "+ver()+", (c) Csiszár Levente, 1995"
      ?  "Használd: pge2wro [-sp] [-r rendFile] -pge-file [wro-file]"
      ?  "-s: sima. Ha van olyan sor, ami '#'-al kezdõdik, akkor azt"
      ?  "szekciós (#section1 ... #section2 ... #end)"
      ?  ".pge filének tekinti, kivéve, ha megadtuk a -s kapcsolót"
      ?  "-p: Hozzáadja a picture-okat is."
      ?  "-r rendFile : A rendezettséget leíró filé neve."
      ?  "              Az itt felsorolt mezõnevek a felsorolás"
      ?  "              sorrendjében fognak szerepelni a getlist-ben."
      ?  "              Az elemeket vesszõvel kell elválasztani."
      ?
      quit
   endif
   pgefile:=addEKieg(pgefile,".pge")
   pgestr:=CCC(memoread(pgefile))
   if (len(pgestr)==PGE_MAXROW*PGE_MAXCOL*2+1)
      // Billy meglepetése hiszékenyeknek, a Ctrl-Z ott van a végén!!!
      // @#$%^&!
      pgestr:=left(pgestr,len(pgestr)-1)
   elseif (len(pgestr)!=PGE_MAXROW*PGE_MAXCOL*2)
      ? pgefile+": Nem page filé!"
      ?
      quit
   endif
   pge:=array(PGE_MAXROW)
   for n:=1 to PGE_MAXROW
      begrow:=(n-1)*PGE_MAXCOL*2+1
      pge[n]:=substr(pgestr, begrow, PGE_MAXCOL*2)
   next
   if (empty(wrofile))
      wrofile:=addKieg(pgefile,".wro")
   else
      wroFile:=addEKieg(wrofile,".wro")
   endif
   if (sima)
      wroOut(pge,wrofile,kellPict,srTomb)
   else
      // alert("wro2out!")
      wro2Out(pge,wrofile,kellPict,srTomb)
   endif

   // restscreen(0,0,maxrow(),maxcol(),screen)
   return nil

*************************************************************************
// A charSet-ben levõ karaktereket keresi visszafelé az str-ben
// Ret. pos, ha talált, 0, ha nem.
function findRev(str,charSet)
local i,w

   i:=len(str)
   while (i>0)
      if (0!=(w:=at(substr(str,i,1),charSet)))
         return i
      endif
      i--
   end for
return 0

*************************************************************************
function ExtractName( filename )  // file.ext --> file
local i
   if( empty(filename) )
       return ""
   end
   i:=findRev(fileName,".:\/")
   if (i==0)
      return fileName
   endif
   if (substr(fileName,i,1)=='.')
      return left(fileName,i-1)
   endif
return fileName

*************************************************************************
function BaseName( filename )  // path\file.ext --> file.ext
local i
   if( empty(filename) )
       return ""
   end
   i:=findRev(fileName,":\/")
   if (i==0)
      return fileName
   endif
return substr(fileName,i+1)


*************************************************************************
// Pl. addKieg("haz.pge",".wro") --> "haz.wro"
// Pl. addKieg("haz.",".wro")    --> "haz.wro"
function addKieg(filename,kieg)
local w
   w:=ExtractName(filename)
   filename:=w+kieg
return filename

*************************************************************************
// Pl. addEKieg("haz.pge",".wro") --> "haz.pge"
// Pl. addEKieg("haz",".wro")     --> "haz.wro"
function addEKieg(filename,kieg)
local w
   w:=ExtractName(filename)
   if (w==filename)
      filename:=w+kieg
   endif

return filename

*************************************************************************
function WroOut(page,file,kellPict,srTomb)
local r,c,c1,line,color,ltok,ntok:=0
local token:="", xtoken:=""
local prog:=""
local defi:="",defpict:=""
local decl:=""
local i,w,defia:={}
// local CR_LF:=chr(13)+chr(10)
#define POS(x,y)  "   @"+str(x-1,3)+","+str(y-1,3)

    /*
    if( !getFileName(@file,".wro") )
        return NIL
    end
    */
    decl+=CR_LF+"static function wr"+BaseName(ExtractName(file))+"(scr,pgelist"+if(kellPict==.t.,",pictlist","")+")"
    if (kellPict)
       prog+=CR_LF+"   if (pictlist==nil)"+;
             CR_LF+"      pictlist:=array(PGELIST)"+;
             CR_LF+"   endif"

    endif
    // prog+=CR_LF+"   set device to print"

    for r:=1 to PGE_MAXROW
        color:=array(PGE_MAXCOL)
        for c:=1 to PGE_MAXCOL
            color[c]:=asc(substr(page[r],c+c,1)) // színkódok tömbje
        next
        line:=screenchar(page[r]) // színkódok nélküli sor

        c:=1
        while( c<=PGE_MAXCOL )

            c1:=c // Kiemelt szín: változó
            while( c<=PGE_MAXCOL .and. color[c]>=16 )
                token+=substr(line,c,1)
                c++
            end
            if( !empty(token) )
                ntok++
                ltok:=len(token)
                token:=alltrim(token)
                xtoken:=token

                if( left(token,1)=="<" )
                    token:=alltrim(substr(token,2))
                    // prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadr(p_"+token+", "+if(kellPict==.t.,"wrpict("+str(ntok,3)+")","")+","+str(ltok,3)+")"
                    prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadr(p_"+token+", "+if(kellPict==.t.,"pict_"+token,"")+","+str(ltok,3)+")"
                elseif( left(token,1)==">" )
                    token:=alltrim(substr(token,2))
                    // prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadl(p_"+token+", wrpict("+str(ntok,3)+"),"+str(ltok,3)+")"
                    // prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadl(p_"+token+", "+if(kellPict==.t.,"wrpict("+str(ntok,3)+")","")+","+str(ltok,3)+")"
                    prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadl(p_"+token+", "+if(kellPict==.t.,"pict_"+token,"")+","+str(ltok,3)+")"
                elseif( left(token,1)=="*" )
                    token:=alltrim(substr(token,2))
                    // prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadc(p_"+token+", wrpict("+str(ntok,3)+"),"+str(ltok,3)+")"
                    // prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadc(p_"+token+", "+if(kellPict==.t.,"wrpict("+str(ntok,3)+")","")+","+str(ltok,3)+")"
                    prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadc(p_"+token+", "+if(kellPict==.t.,"pict_"+token,"")+","+str(ltok,3)+")"
                elseif (left(xtoken,1)=="?" .and. len(xtoken)>=3)
                   xtoken:=substr(xtoken,2)
                   token:=alltrim(substr(token,2))
                   prog+=CR_LF+POS(r,c1)+" screen scr say '['"
                   prog+=CR_LF+POS(r,c1+1)+" screen scr say p_"+xtoken
                   prog+=CR_LF+POS(r,c1+2)+" screen scr say ']'"
                else
                    //prog+=CR_LF+POS(r,c1)+" screen scr say p_"+token
                    //új default: balra igazítás
                    // prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadr(p_"+token+", wrpict("+str(ntok,3)+"),"+str(ltok,3)+")"
                    // prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadr(p_"+token+", "+if(kellPict==.t.,"wrpict("+str(ntok,3)+")","")+","+str(ltok,3)+")"
                    prog+=CR_LF+POS(r,c1)+" screen scr say xtrpadr(p_"+token+", "+if(kellPict==.t.,"pict_"+token,"")+","+str(ltok,3)+")"
                end

                aadd(defia,{token,ltok})
                /*
                defi+=CR_LF+"#define "+padr("p_"+token,16)+" pgelist["+str(ntok,3)+"]"
                defi+=" //"+str(ltok,2) // kommentként a mezõhossz
                if (kellPict==.t.)
                   defpict+=CR_LF+"#define "+padr("pict_"+token,16)+" pictlist["+str(ntok,3)+"]"
                endif
                */
                token:=""
            end

            c1:=c // Nem kiemelt szín: szövegkonstans
            while( c<=PGE_MAXCOL .and. color[c]<16 .and. !empty(substr(line,c,1) )  )
                token+=substr(line,c,1)
                c++
            end
            if( !empty(token) )
                prog+=CR_LF+POS(r,c1)+" screen scr say "+'"'+token+'"'
                token:=""
            end

            c1:=c // Üres rész: átugorja
            while( c<=PGE_MAXCOL .and. color[c]<16 .and. empty(substr(line,c,1)) )
                c++
            end

        end
    next

    if (!empty(srTomb))
       sorrend(defia,srTomb)
    endif

    for i:=1 to len(defia)
       w:=defia[i]
       defi+=CR_LF+"#define "+padr("p_"+w[1],16)+" pgelist["+str(i,3)+"]"
       defi+=" //"+str(w[2],2) // kommentként a mezõhossz
       if (kellPict==.t.)
          defpict+=CR_LF+"#define "+padr("pict_"+w[1],16)+" pictlist["+str(i,3)+"]"
       endif
    end for

    defi+=CR_LF+CR_LF+"#define PGELIST       "+str(len(defia),3)
    // prog+=CR_LF+"   eject"
    // prog+=CR_LF+"   set device to screen"
    prog+=CR_LF+"   return scr"

    return( memowrit( file, "// pge2wro "+ver()+CR_LF+;
                            headerMakro()+;//'#include "scrstr.ch"'+CR_LF+;
                            defi+CR_LF+;
                            defpict+CR_LF+CR_LF+;
                            decl+CR_LF+;
                            prog+CR_LF ))
*************************************************************************
function headerMakro()
return CR_LF+;
   "#ifndef I_SCRSTR                                        "+CR_LF+;
   "#define I_SCRSTR                                        "+CR_LF+;
   "#command @ <row>, <col> SCREEN <scr> SAY <xpr>         ;"+CR_LF+;
   "                        [PICTURE <pic>]                ;"+CR_LF+;
   "                        [COLOR <color>]                ;"+CR_LF+;
   "                                                       ;"+CR_LF+;
   "      => scrPos( <scr>, <row>, <col> )                 ;"+CR_LF+;
   "       ; scrOutPict( <scr>, <xpr>, <pic> [, <color>] )  "+CR_LF+;
   "#define wrpict(i) if(pictlist==nil,nil,pictlist[i])     "+CR_LF+;
   "#endif                                                  "+CR_LF+;
   CR_LF

/*
   "#ifndef I_SCRSTR                                        "+CR_LF+;
   "#define I_SCRSTR                                        "+CR_LF+;
   "#command @ <row>, <col> SCREEN <scr> SAY <xpr>         ;"+CR_LF+;
   "                        [PICTURE <pic>]                ;"+CR_LF+;
   "                        [COLOR <color>]                ;"+CR_LF+;
   "                                                       ;"+CR_LF+;
   "      => scrPos( <scr>, <row>, <col> )                 ;"+CR_LF+;
   "       ; scrOutPict( <scr>, <xpr>, <pic> [, <color>] )  "+CR_LF+;
   "#define wrpict(i) if(pictlist==nil,nil,pictlist[i])     "+CR_LF+;
   "#endif                                                  "+CR_LF+;
*/
*************************************************************************

*************************************************************************
function Wro2Out(page,file,kellPict,srTomb)
local r,c,c1,line,color,ltok,ntok:=0
local token:="", xtoken:=""
local prog:=""
local defi:="",defpict:=""
local section
local rSection
local i,w,defia:={}
local extended:=.f.
local prefix:=""
local maxhossz
// local CR_LF:=chr(13)+chr(10)
// #define POS(x,y)  "   @"+str(x-1,3)+","+str(y-1,3)

    /*
    if( !getFileName(@file,".wro") )
        return NIL
    end
    */
    // decl+=CR_LF+"static function wr"+BaseName(ExtractName(file))+"(scr,pgelist,pictlist)"
    // prog+=CR_LF+"   set device to print"

    rSection:=0
    for r:=1 to PGE_MAXROW
        rSection++
        color:=array(PGE_MAXCOL)
        for c:=1 to PGE_MAXCOL
            color[c]:=asc(substr(page[r],c+c,1)) // színkódok tömbje
        next
        line:=screenchar(page[r]) // színkódok nélküli sor
        if (left(line,1)=="#") // Section
           if (section!=nil)
              prog+=CR_LF+"return scr"
           endif
           section:=alltrim(substr(line,2))
           if( section=="end" )
               exit
           elseif( section=="extended")
               extended:=.t.
               section:=nil
               loop
           end

           prog+=CR_LF+CR_LF+CR_LF+"static function "+section+"(scr,pgelist"+if(kellPict==.t.,",pictlist","")+")"
           if (kellPict)
              prog+=CR_LF+"   if (pictlist==nil)"+;
                    CR_LF+"      pictlist:=array(PGELIST)"+;
                    CR_LF+"   endif"
           endif
           rSection:=0
           if (extended)
              prefix:=section+"_"
           end
           loop
        endif
        c:=1

        while( c<=PGE_MAXCOL )

            c1:=c // Kiemelt szín: változó
            while( c<=PGE_MAXCOL .and. color[c]>=16 )
                token+=substr(line,c,1)
                c++
            end
            if( !empty(token) )
                ntok++
                xtoken:=token
                ltok:=len(token)
                token:=alltrim(token)
                if( left(token,1)=="<" )
                    token:=alltrim(substr(token,2))
                    prog+=CR_LF+POS(rSection,c1)+" screen scr say xtrpadr(p_"+prefix+token+", "+if(kellPict==.t.,"pict_"+token,"")+","+str(ltok,3)+")"
                elseif( left(token,1)==">" )
                    token:=alltrim(substr(token,2))
                    prog+=CR_LF+POS(rSection,c1)+" screen scr say xtrpadl(p_"+prefix+token+", "+if(kellPict==.t.,"pict_"+token,"")+","+str(ltok,3)+")"
                elseif( left(token,1)=="*" )
                    token:=alltrim(substr(token,2))
                    prog+=CR_LF+POS(rSection,c1)+" screen scr say xtrpadc(p_"+prefix+token+", "+if(kellPict==.t.,"pict_"+token,"")+","+str(ltok,3)+")"
                elseif (left(xtoken,1)=="?" .and. len(xtoken)>=3)
                   xtoken:=substr(xtoken,2)
                   token:=alltrim(substr(token,2))
                   prog+=CR_LF+POS(rSection,c1)+" screen scr say '['"
                   prog+=CR_LF+POS(rSection,c1+1)+" screen scr say p_"+prefix+xtoken
                   prog+=CR_LF+POS(rSection,c1+2)+" screen scr say ']'"
                else
                    //prog+=CR_LF+POS(rSection,c1)+" screen scr say p_"+prefix+token
                    //új default: balra igazítás
                    prog+=CR_LF+POS(rSection,c1)+" screen scr say xtrpadr(p_"+prefix+token+", "+if(kellPict==.t.,"pict_"+token,"")+","+str(ltok,3)+")"
                end

                aadd(defia,{prefix+token,ltok})
                token:=""
            end

            c1:=c // Nem kiemelt szín: szövegkonstans
            while( c<=PGE_MAXCOL .and. color[c]<16 .and. !empty(substr(line,c,1) )  )
                token+=substr(line,c,1)
                c++
            end
            if( !empty(token) )
                prog+=CR_LF+POS(rSection,c1)+" screen scr say "+'"'+token+'"'
                token:=""
            end

            c1:=c // Üres rész: átugorja
            while( c<=PGE_MAXCOL .and. color[c]<16 .and. empty(substr(line,c,1)) )
                c++
            end
        end
        if (empty(line) .and. section!=nil)
           prog+=CR_LF+POS(rSection,1)+" screen scr say ' '"
        endif
    next

    if (!empty(srTomb))
       sorrend(defia,srTomb)
    endif

    maxhossz:=0
    for i:=1 to len(defia)
       if (maxhossz<len(defia[i][1]))
          maxhossz:=len(defia[i][1])
       endif
    end for
    for i:=1 to len(defia)
       w:=defia[i]
       defi+=CR_LF+"#define "+padr("p_"+w[1],maxhossz+4)+" pgelist["+str(i,3)+"]"
       defi+=" //"+str(w[2],2) // kommentként a mezõhossz
       if (kellPict==.t.)
          defpict+=CR_LF+"#define "+padr("pict_"+w[1],maxhossz+6)+" pictlist["+str(i,3)+"]"
       endif
    end for

    defi+=CR_LF+CR_LF+"#define PGELIST       "+str(len(defia),3)
    // prog+=CR_LF+"   eject"
    // prog+=CR_LF+"   set device to screen"
    // prog+=CR_LF+"   return NIL"
    if (section==nil)
       // ? "Nincs szekció definiálva!"
       // return 0
       if (kellPict)
          prog:=CR_LF+"   if (pictlist==nil)"+;
                CR_LF+"      pictlist:=array(PGELIST)"+;
                CR_LF+"   endif"+;
                prog
       endif
       prog:=CR_LF+"static function wr"+BaseName(ExtractName(file))+"(scr,pgelist"+if(kellPict==.t.,",pictlist","")+")"+CR_LF+;
             prog+CR_LF+;
             "return scr"+CR_LF
    elseif (lower(section)!="end")
       ?? "Nincs end szekció!"
       ?
       errorlevel(1)
       quit
    endif
return( memowrit( file, "// pge2wro "+ver()+CR_LF+;
                         headerMakro()+;//'#include "scrstr.ch"'+CR_LF+;
                        defi+CR_LF+;
                        defpict+CR_LF+CR_LF+;
                        prog+CR_LF ))
*************************************************************************

static function ifNil(valOrig,valNil)
return if(valOrig==nil,valNil,valOrig)
*************************************************************************
// A sorrendTomb-ben szereplo get azonosítók sorrendjét megváltoztatja
// a glsta-ban úgy, hogy a sorrendjük a sorrendTombben levõkkel azonos
// legyen. Ha egy glsta elem nem szerepel a sorrendTomb-ben,
// akkor a helye nem változik.
static function sorrend(glsta,sorrendTomb)
local i,j,t:={},tg:={}
   for i:=1 to len(sorrendTomb)
      if (0==(j:=ascan(glsta,{|x| sorrendTomb[i]==x[1]})))
         alert("A '"+sorrendTomb[i]+"';"+;
               "sorrend kulcs nem szerepel a get-ek között!")
      else
         // aadd(t,{j,i,glsta[j]})
         aadd(t,j)
         aadd(tg,glsta[j])
      endif
   end for
   asort(t)
   for i:=1 to len(t)
      glsta[t[i]]:=tg[i]
   end for
return nil

***************************************************************************
/*
    A sep separátorral elválasztott (szöveges) listából Clipper
    array-t készít. Ha sep nincs megadva, akkor ","-t tételez fel.
*/
static function wordlist(txt,sep)
local wlist:={}, n:=0, i

    if(sep==NIL)
        sep:=","
    end
    
    while( n<len(txt) )
        txt:=substr(txt,n+1)    
    
        if( (i:=at(sep,txt))==0 )
            aadd(wlist, txt)
            n:=len(txt)
        elseif(i==1)
            aadd(wlist,"")
            n:=1
        else
            aadd(wlist,substr(txt,1,i-1))
            n:=i
        end
    end
    return wlist

*************************************************************************
function ver()
return "v2.2.01 "

*************************************************************************
