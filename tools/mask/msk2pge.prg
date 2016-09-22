
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

// Utility mask fil�k page fil�kre val� konvert�l�s�ra

#include "inkey.ch"

*************************************************************************
// Mj.: A cr_lf() f�ggv�ny ide nem j�!
#define CR_LF chr(13)+chr(10)

*************************************************************************
// A sor-b�l kit�rli/helyettes�ti a rajzol� karaktereket.

#define MSK_RAJZOLO "����������������������������������������"
#define MSK_DUPLA_VIZSZINT "�������������������"
#define MSK_EGYKE_VIZSZINT "�������������������"
#define MSK_FUGGOLEGES "��"
 
*************************************************************************

#define SCR_MAXROW 25
#define SCR_MAXCOL 80

#define PGE_MAXROW 64            // �sszes sorok sz�ma
#define PGE_MAXCOL 160           // �sszes oszlopok sz�ma


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
      ?? "mask->page konverzi�s program. MSK2PGE "+ver()+", (c) Csisz�r Levente, 1995"
      ?  "Haszn�ld: msk2pge [-ur] msk-file [pge-file]"
      ?  "-u: Lev�gja az elej�r�l az �res sorokat"
      ?  "-r: �talak�tja a rajzol� karaktereket. A f�gg�legeseket kit�rli,"
      ?  "    a vizszinteseket pedig '-'-el �s '='-el helyettes�ti."
      ?
      quit
   endif
   maskfile:=addKieg(maskfile,".msk",.t.)
   screen:=memoread(maskfile)
   if (len(screen)==SCR_MAXROW*SCR_MAXCOL*2+1)
      // Billy meglepet�se hisz�kenyeknek, a Ctrl-Z ott van a v�g�n!!!
      // @#$%^&!
      screen:=left(screen,len(screen)-1)
   elseif (len(screen)!=SCR_MAXROW*SCR_MAXCOL*2)
      ? maskfile+": Nem mask fil�!"
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
// A sor-b�l kit�rli/helyettes�ti a rajzol� karaktereket.
//"����������������������������������������"
static function rajzKi(sor)
local i,n
local w:=""
   // return sor
   // Clipper hiba:
   // substr("abc",4,1)$"abc" --> .f.
   // ""$"abc"                --> .t.
   // Pedig mind a k�tszer �res stringet keres�nk!
   for i:=1 to len(sor)-1 step 2
      if (substr(sor,i,1)$MSK_DUPLA_VIZSZINT) // "�������������������"
         w+="="+substr(sor,i+1,1)
      elseif (substr(sor,i,1)$MSK_EGYKE_VIZSZINT) // "�������������������"
         w+="-"+substr(sor,i+1,1)
      elseif (substr(sor,i,1)$MSK_FUGGOLEGES) // "��"
         w+=" "+substr(sor,i+1,1)
      else
         w+=substr(sor,i,2)
      endif
      // ? "rajzKi: i: ",i,"len(w): ",len(w)
   end for
   // ? "rajzKi vege: i: ",i,"len(w): ",len(w),"len(sor):",len(sor)
return w

*************************************************************************
// A charSet-ben lev� karaktereket keresi visszafel� az str-ben
// Ret. pos, ha tal�lt, 0, ha nem.
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
            color[c]:=asc(substr(page[r],c+c,1)) // sz�nk�dok t�mbje
        next
        line:=screenchar(page[r]) // sz�nk�dok n�lk�li sor

        c:=1
        while( c<=PGE_MAXCOL )

            c1:=c // Kiemelt sz�n: v�ltoz�
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
                    //�j default: balra igaz�t�s
                    prog+=CR_LF+POS(r,c1)+" screen scr say padr(p_"+token+","+str(ltok,3)+")"
                end

                defi+=CR_LF+"#define "+padr("p_"+token,16)+" pgelist["+str(ntok,3)+"]"
                defi+=" //"+str(ltok,2) // kommentk�nt a mez�hossz
                token:=""
            end

            c1:=c // Nem kiemelt sz�n: sz�vegkonstans
            while( c<=PGE_MAXCOL .and. color[c]<16 .and. !empty(substr(line,c,1) )  )
                token+=substr(line,c,1)
                c++
            end
            if( !empty(token) )
                prog+=CR_LF+POS(r,c1)+" screen scr say "+'"'+token+'"'
                token:=""
            end

            c1:=c // �res r�sz: �tugorja
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
// Csak egy lapot tud fel�rni!
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
// Ha a tomb kisebb, akkor kieg�sz�ti a size-re, ha nagyobb vagy egyenl�,
// akkor nem csin�l semmit.
// A kieg�szitett elemek a def-et kapj�k �rt�k�l.
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
// Az str pos poz�ci�j�ra be�rja a mivel-t, fel�l�r�ssal.
// Ha a string hosszabb lenne, mint a maxlen, akkor a v�g�t lev�gja.
// A pos sz�mol�sa 1-t�l indul.
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

