
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

*************************************************************************

// Utility mask filék page filékre való konvertálására

#include "inkey.ch"

*************************************************************************
// Mj.: A cr_lf() függvény ide nem jó!
#define CR_LF chr(13)+chr(10)

*************************************************************************
// A sor-ból kitörli/helyettesíti a rajzoló karaktereket.

#define MSK_RAJZOLO "³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÕÕÖ×ØÙÚ"
#define MSK_DUPLA_VIZSZINT "µ¸¹»¼¾ÆÈÉÊËÌÍÎÏÑÕÕØ"
#define MSK_EGYKE_VIZSZINT "´¶·½¿ÀÁÂÃÄÅÇÐÒÓÖ×ÙÚ"
#define MSK_FUGGOLEGES "³º"
 
*************************************************************************

#define SCR_MAXROW 25
#define SCR_MAXCOL 80

#define PGE_MAXROW 64            // összes sorok száma
#define PGE_MAXCOL 160           // összes oszlopok száma


*************************************************************************
function main(p1,p2,p3/*,maskfile,pgefile*/)
local extChar:=' '+chr(7)
local rowKieg:=replicate(extChar,PGE_MAXCOL-SCR_MAXCOL)
local pge,screen,i,sor,w,maskfile,pgefile
local uresLe:=.f.,vegKieg,uresSor
local nemRajzol:=.f.
local p:={p1,p2,p3}

   set scoreboard off
   set date to ansi
   for i:=1 to len(p)
      p[i]:=lower(ifNil(p[i],""))
      if (!empty(p[i]))
         if (left(p[i],1)=='-')
            w:=substr(p[i],2)
            uresLe:=uresLe .or. 'u'$lower(w)
            nemrajzol:=nemrajzol .or. 'r'$lower(w)
         elseif (maskfile==nil)
            maskfile:=p[i]
         elseif (pgefile==nil)
            pgefile:=p[i]
         endif
      endif
   end for

   if (empty(maskfile))
      ?? "mask->page konverziós program. MSK2PGE "+ver()+", (c) Csiszár Levente, 1995"
      ?  "Használd: msk2pge [-ur] msk-file [pge-file]"
      ?  "-u: Levágja az elejérõl az üres sorokat"
      ?  "-r: Átalakítja a rajzoló karaktereket. A függõlegeseket kitörli,"
      ?  "    a vizszinteseket pedig '-'-el és '='-el helyettesíti."
      ?
      quit
   endif
   maskfile:=addKieg(maskfile,".msk",.t.)
   screen:=memoread(maskfile)
   if (len(screen)==SCR_MAXROW*SCR_MAXCOL*2+1)
      // Billy meglepetése hiszékenyeknek, a Ctrl-Z ott van a végén!!!
      // @#$%^&!
      screen:=left(screen,len(screen)-1)
   elseif (len(screen)!=SCR_MAXROW*SCR_MAXCOL*2)
      ? maskfile+": Nem mask filé!"
      ?
      quit
   endif
   if (empty(pgefile))
      pgefile:=addKieg(maskfile,".pge")
   else
      pgeFile:=addEKieg(pgefile,".pge")
   endif
   pge:=""
   rowKieg:=replicate(extChar,PGE_MAXCOL-SCR_MAXCOL)
   uresSor:=replicate(extChar,SCR_MAXCOL)
   vegKieg:=""
   for i:=1 to SCR_MAXROW
      sor:=substr(screen,1+SCR_MAXCOL*2*(i-1),2*SCR_MAXCOL)
      if (uresLe==.t. .and. sor==uresSor)
         vegKieg+=sor+rowKieg
      else
         uresLe:=.f.
         if (nemRajzol)
            sor:=rajzki(sor)
         endif
         pge+=sor+rowKieg
      endif
   next
   pge+=vegKieg
   pge+=replicate(extChar,PGE_MAXCOL*(PGE_MAXROW-SCR_MAXROW))
   memowrit(pgefile,pge)
   // restscreen(0,0,maxrow(),maxcol(),screen)
   return nil

*************************************************************************
// A sor-ból kitörli/helyettesíti a rajzoló karaktereket.
//"³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÕÕÖ×ØÙÚ"
static function rajzKi(sor)
local i,n
local w:=""
   // return sor
   // Clipper hiba:
   // substr("abc",4,1)$"abc" --> .f.
   // ""$"abc"                --> .t.
   // Pedig mind a kétszer üres stringet keresünk!
   for i:=1 to len(sor)-1 step 2
      if (substr(sor,i,1)$MSK_DUPLA_VIZSZINT) // "µ¸¹»¼¾ÆÈÉÊËÌÍÎÏÑÕÕØ"
         w+="="+substr(sor,i+1,1)
      elseif (substr(sor,i,1)$MSK_EGYKE_VIZSZINT) // "´¶·½¿ÀÁÂÃÄÅÇÐÒÓÖ×ÙÚ"
         w+="-"+substr(sor,i+1,1)
      elseif (substr(sor,i,1)$MSK_FUGGOLEGES) // "³º"
         w+=" "+substr(sor,i+1,1)
      else
         w+=substr(sor,i,2)
      endif
      // ? "rajzKi: i: ",i,"len(w): ",len(w)
   end for
   // ? "rajzKi vege: i: ",i,"len(w): ",len(w),"len(sor):",len(sor)
return w

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
// Pl. addKieg("haz.msk",".say") --> "haz.say"
// Pl. addKieg("haz.",".say")    --> "haz.say"
function addKieg(filename,kieg)
local w
   w:=ExtractName(filename)
   filename:=w+kieg
return filename

*************************************************************************
// Pl. addEKieg("haz.msk",".say") --> "haz.msk"
// Pl. addEKieg("haz",".say")     --> "haz.say"
function addEKieg(filename,kieg)
local w
   w:=ExtractName(filename)
   if (w==filename)
      filename:=w+kieg
   endif

return filename
*************************************************************************

#ifdef OLD
*************************************************************************
function ExtractName( filename )  // file.ext --> file
   if( empty(filename) )
       return ""
   end
return left( filename, at(".", filename+".")-1 )

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
#endif

*************************************************************************

#ifdef OLD
*************************************************************************
function PrgOut(page,file)
local r,c,c1,line,color,ltok,ntok:=0
local token:=""
local prog:=""
local defi:=""
local decl:=""
// local CR_LF:=chr(13)+chr(10)
#define POS(x,y)  "   @"+str(x,3)+","+str(y,3)

    /*
    if( !getFileName(@file,".wro") )
        return NIL
    end
    */
    file:=addKieg(file,".wro")
    decl+=CR_LF+"static function "+ExtractName(file)+"(scr,pgelist)"
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
                if( left(token,1)=="<" )
                    token:=alltrim(substr(token,2))
                    prog+=CR_LF+POS(r,c1)+" screen scr say padr(p_"+token+","+str(ltok,3)+")"
                elseif( left(token,1)==">" )
                    token:=alltrim(substr(token,2))
                    prog+=CR_LF+POS(r,c1)+" screen scr say padl(p_"+token+","+str(ltok,3)+")"
                elseif( left(token,1)=="*" )
                    token:=alltrim(substr(token,2))
                    prog+=CR_LF+POS(r,c1)+" screen scr say padc(p_"+token+","+str(ltok,3)+")"
                else
                    //prog+=CR_LF+POS(r,c1)+" screen scr say p_"+token
                    //új default: balra igazítás
                    prog+=CR_LF+POS(r,c1)+" screen scr say padr(p_"+token+","+str(ltok,3)+")"
                end

                defi+=CR_LF+"#define "+padr("p_"+token,16)+" pgelist["+str(ntok,3)+"]"
                defi+=" //"+str(ltok,2) // kommentként a mezõhossz
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

    defi+=CR_LF+CR_LF+"#define PGELIST       "+str(ntok,3)
    // prog+=CR_LF+"   eject"
    // prog+=CR_LF+"   set device to screen"
    prog+=CR_LF+"   return NIL"

    return( memowrit( file, defi+CR_LF+decl+CR_LF+prog+CR_LF ))

*************************************************************************
// Csak egy lapot tud felírni!
*************************************************************************
#define SCR_NROW   1
#define SCR_NCOL   2
#define SCR_ROW    3
#define SCR_COL    4
#define SCR_STRT   5
*************************************************************************
function createScr(nrow,ncol)
return {nrow,ncol,0,0,{}}

*************************************************************************
function scrStr(scr)
local str:=""
   aeval(scr[SCR_STRT],{|x| str+=x+CR_LF})
return str

*************************************************************************
function scrPos(scr,row,col)
   scr[SCR_ROW]:=row
   scr[SCR_COL]:=col
return scr
*************************************************************************
function scrOutPict(scr,str,pict)
local i,l,isCR_LF
   if (pict!=nil)
      str:=transform(str,pict)
   endif
   while(len(str)!=0)
      i:=at(CR_LF,str)
      if (i==0)
         i:=len(str)
         isCR_LF:=.t.
         l:=str
         str:=""
      else
         isCR_LF:=.f.
         l:=substr(str,1,i)
         str:=substr(str,i+3)
      endif
      if (scr[SCR_ROW]>=scr[SCR_NROW])
         return scr
      endif
      scr[SCR_STRT]:=xakieg(scr[SCR_STRT],scr[SCR_ROW]+1)
      scr[SCR_STRT][scr[SCR_ROW]+1]:=xreplStr(scr[SCR_STRT][scr[SCR_ROW]+1],scr[SCR_COL]+1,l,scr[SCR_NCOL])
      if (isCR_LF)
         scr[SCR_ROW]++
      endif
   end while
return scr

*************************************************************************
// Ha a tomb kisebb, akkor kiegészíti a size-re, ha nagyobb vagy egyenlõ,
// akkor nem csinál semmit.
// A kiegészitett elemek a def-et kapják értékül.
function xaKieg(tomb,size,def)
local l
   if (len(tomb)<size)
      l:=len(tomb)
      asize(tomb,size)
      for l:=l+1 to size
         tomb[l]:=def
      next
   endif
return tomb

*************************************************************************
// Az str pos pozíciójára beírja a mivel-t, felülírással.
// Ha a string hosszabb lenne, mint a maxlen, akkor a végét levágja.
// A pos számolása 1-tõl indul.
function xreplStr(str,pos,mivel,maxlen)
   if (len(str)+len(mivel)>maxlen)
      mivel:=left(mivel,maxlen-len(str))
   endif
   str:=substr(str,1,pos-1)+mivel+substr(str,pos+len(mivel))
return str
*************************************************************************
#endif

*************************************************************************
static function ifNil(valOrig,valNil)
return if(valOrig==nil,valNil,valOrig)

*************************************************************************
static function ver()
return "v1.0.02"

*************************************************************************

