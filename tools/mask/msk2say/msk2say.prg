
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

//altbuttonok tamogatasa (Vermes M. 2017.05.09)
//szinek tamogatasa: CCC_MSKCOLOR_SAY, CCC_MSKCOLOR_GET (Vermes M. 2017.05.09)
//egesz sorokat iro mskSay-eket general (Vermes M. 2017.05.09)
//kikeruli az idezojel karaktereket (Vermes M. 2017.05.09)
//sorrend kezeles javitva (Vermes M. 2017.04.26)
//nagy maszkok támogatása (Vermes M. 2014.01.15)
//checkbox/radiobutton támogatás (Vermes M. 2000.04.21)
//portolva CCC kódrendszerre (Vermes M. 2000.01.11)
 
*************************************************************************

// Utility mask filék say filékre való konvertálására

#include "inkey.ch"

#include "charconv.ch"

#define  CCC(x) _charconv(x,CHARTAB_CWI2CCC)
#define  CWI(x) _charconv(x,CHARTAB_CCC2CWI)
#define  LAT(x) _charconv(x,CHARTAB_CCC2LAT)
 
*************************************************************************

#define MSK_MAXROW     f_maxrow()
#define MSK_MAXCOL     f_maxcol()


#define TOP    rect[1]
#define LEFT   rect[2]
#define BOTTOM rect[3]
#define RIGHT  rect[4]

#define POS(row,col)    "   @"+str(row,3)+","+str(col,3)
#define POSR(row,col)   "   @"+str(row+startRow,3)+","+str(col+startCol,3)
#define POSRO(row,col)  (str(row,3)+","+str(col,3))
#define NEVPAD(nev) padr(nev,12)


#define ISGUIFGV "isGUI()"


static size80x25:={80,25}
static size100x50:={100,50}
static size120x60:={120,60}
static size160x60:={160,60}
static size200x60:={200,60}
static termsize:=size80x25
#define CALCSIZE(t)  (t[1]*t[2]*2)


*************************************************************************
static function termsetup()
    f_maxcol(termsize[1])
    f_maxrow(termsize[2])

*************************************************************************
static function f_maxrow(s)
static x:=25
    if( s!=NIL )
        x:=s
    end
    return x

static function f_maxcol(s)
static x:=80
    if( s!=NIL )
        x:=s
    end
    return x

*************************************************************************
function main(p1,p2,p3,p4)

local msk,mskstr,n,begrow
local mskfile,sayfile
local p:={p1,p2,p3,p4}
local i,j,w
local srTomb,say_mode

   set date to ansi

   for i:=1 to len(p)

      p[i]:=ifNil(p[i],"")

      if (!empty(p[i]))

         if (left(p[i],1)=='-')
            w:=lower(substr(p[i],2))

            if (w=="r")
               w:=memoread(p[i+1])
               w:=strtran(w,chr(13),"")
               w:=strtran(w,chr(10)," ")
               w:=strtran(w,","," ")
               while( "  "$w )
                  w::=strtran("  "," ")   
               end
               w::=alltrim
               srTomb:=wordlist(w," ")
               i++
            end

         elseif (mskfile==nil)
            mskfile:=p[i]

         elseif (sayfile==nil)
            sayfile:=p[i]
         end
      end
   next

   if (empty(mskfile))
      usage()
      quit
   end

   mskfile:=addEKieg(mskfile,".msk")
   mskstr:=memoread(mskfile)

    if( len(mskstr)%4!=0  )
        mskstr:=left(mskstr,len(mskstr)-1)
    end

    if( len(mskstr)==CALCSIZE(size80x25) )
        termsize:=size80x25
    elseif( len(mskstr)==CALCSIZE(size100x50) )
        termsize:=size100x50
    elseif( len(mskstr)==CALCSIZE(size120x60) )
        termsize:=size120x60
    elseif( len(mskstr)==CALCSIZE(size160x60) )
        termsize:=size160x60
    elseif( len(mskstr)==CALCSIZE(size200x60) )
        termsize:=size200x60
    else
        ? "Incompatible msk file length",len(mskstr)
        ?
        quit
    end
    termsetup()


   if (empty(sayfile))
      sayfile:=addKieg(mskfile,".say")
   else
      sayFile:=addEKieg(sayfile,".say")
   end

   sayLTOutObj(mskLeiroTomb(mskstr),sayfile,srTomb)

   return nil

*************************************************************************
function usage()
   ? "MSK2SAY "+ver()
   ?  "Usage: msk2say [-r sort-file] msk-file [say-file]"
   quit
   return nil

*************************************************************************
function findRev(str,charSet)

// A charSet-ben levõ karaktereket keresi visszafelé az str-ben
// Ret. pos, ha talált, 0, ha nem.

local i,w

   i:=len(str)
   while (i>0)
      if (0!=(w:=at(substr(str,i,1),charSet)))
         return i
      end
      i--
   next
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
   end

   if (substr(fileName,i,1)=='.')
      return left(fileName,i-1)
   end
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
   end
   return substr(fileName,i+1)

*************************************************************************
function addKieg(filename,kieg)

// Pl. addKieg("haz.msk",".say") --> "haz.say"
// Pl. addKieg("haz.",".say")    --> "haz.say"

local w

   w:=ExtractName(filename)
   filename:=w+kieg
   return filename

*************************************************************************
function addEKieg(filename,kieg)

// Pl. addEKieg("haz.msk",".say") --> "haz.msk"
// Pl. addEKieg("haz",".say")     --> "haz.say"

local w

   w:=ExtractName(filename)
   if (w==filename)
      filename:=w+kieg
   end

   return filename

*************************************************************************
function calcRect(screen)

local rect:={0,0,0,0}
local i,j,line,color,c,w,nemUres

   LEFT:=MSK_MAXCOL
   RIGHT:=1
   TOP:=MSK_MAXROW
   BOTTOM:=1

   for i:=1 to MSK_MAXROW
      nemUres:=.f.
      line:=substr(screen,1+MSK_MAXCOL*2*(i-1),2*MSK_MAXCOL)

      for c:=1 to len(line)/2
         color:=asc(substr(line,c+c,1)) // színkódok tömbje
         if (color>16)
            if (RIGHT<c)
               RIGHT:=c
            end
            if (LEFT>c)
               LEFT:=c
            end
            nemUres:=.t.
         end
      next

      line:=screenchar(line) // színkódok nélküli sor
      w:=len(line)-len(ltrim(line))+1

      if (w<LEFT)
         LEFT:=w
      end
      w:=len(rtrim(line))

      if (w>RIGHT)
         RIGHT:=w
      end

      if (nemUres .or. !empty(line))
         BOTTOM:=i
         if (TOP>i)
            TOP:=i
         end
      end

   next
   LEFT--
   RIGHT--
   TOP--
   BOTTOM--
   return rect

*************************************************************************

static function ifNil(valOrig,valNil)
return if(valOrig==nil,valNil,valOrig)

***************************************************************************
static function wordlist(text,sep)
local wlist:={}, n:=0, i

    if(sep==NIL)
        sep:=","
    end
    
    while( n<len(text) )
        text:=substr(text,n+1)    
    
        if( (i:=at(sep,text))==0 )
            aadd(wlist, text)
            n:=len(text)
        elseif(i==1)
            aadd(wlist,"")
            n:=1
        else
            aadd(wlist,substr(text,1,i-1))
            n:=i
        end
    end
    return wlist

*************************************************************************
#define MSKL_RECT     1
#define MSKL_OBJTOMB  2
#define N_MSKL        2

#define MSKLO_TYPE         1
#define MSKLO_ROW          2
#define MSKLO_COL          3
#define MSKLO_FIELDLEN     4
#define MSKLO_STR          5
#define N_MSKLO            5

*************************************************************************
function mskLeiroTomb(screen)
 

// Ad egy tömböt, amiben a say-ek és a get-ek fel vannak sorolva.
//
// return: nil, ha a képernyõ üres, egyébként {rect,objTomb}
//
// rect: {top,left,bottom,right}
//
// objTomb: {{típus,row,col,len,str,megjelenít}, ... }
//
// A 'típus' jelenleg lehet: 'S' say, 'G' get.
//
// A row,col az ablak bal felsõ sarkához relatív, 
// a számozás 0-tól indul.
//
// A 'len' a mezõ hosszát mutatja. Say-nél az str pontosan 
// ilyen hosszú.
//
// Az 'str' say-nél a megjelenítendõ string, get-nél a mezõ
// neve balra igazítva, a végérõl az üres karakerek levágva.
//
// A 'megjelenít' jelenleg lehet: NIL (mindig kell)
// és 'C' (csak karakteres megjelenítésnél kell).


local rect:=calcRect(screen) // MarkRect(K_F9)
local result,r,line,color,c,i,startI,startColor,w,nev,sor

    if( empty(rect) )
        return NIL
    end

    result:={}

    for r:=TOP to BOTTOM
        line:=substr(screen,1+2*(MSK_MAXCOL*(r)+LEFT),2*(RIGHT-LEFT+1))
        color:=array(len(line)/2)

        for c:=1 to len(line)/2
            color[c]:=asc(substr(line,c+c,1)) // színkódok tömbje
        next
        line:=screenchar(line) // színkódok nélküli sor
        sor:=r-TOP

        i:=1
        while (i<=len(line))

            if (color[i]<16)
                // Nem kiemelt szín.
                // Szöveg konstans eleje.
                startI:=i
                while (i<=len(line) .and. color[i]<16)
                    i++
                end 
#define WHOLE_LINE
#ifndef WHOLE_LINE
                aadd(result,{"S",sor,startI-1,i-startI,substr(line,startI,i-startI),nil}) // say kulon
#endif

            else
                // Kiemelt szín. Ezt a színt kell követni.
                startColor:=color[i]
                startI:=i

                while (i<=len(line) .and. color[i]==startColor)
                    i++
                end 

                w:=substr(line,startI,i-startI)
                nev:=alltrim(w)

                if( empty(nev) )
                    aadd(result,{"S",sor,startI-1,i-startI,w,nil})

                elseif( left(nev,1)=='?' )
                
                    //Csiszár-féle checkbox támogatás,
                    //a körülvevõ [] karakterek GUI-ban
                    //nem jelenítõdnek meg, Clipperben is
                    //mûködik, én (V.M.) nem használom.
                
                    nev:=alltrim(substr(nev,2))
                 
                    if( empty(nev) )
#ifndef WHOLE_LINE
                        aadd(result,{"S",sor,startI-1,i-startI,space(startI-i),nil}) // say kulon
#endif

                    elseif (len(w)==2)
                        aadd(result,{"G",sor,startI-1,1,nev,nil})
                        aadd(result,{"S",sor,startI-1+1,1," ",nil})
                 
                    else
                        aadd(result,{"S",sor,startI-1,  1,"[","C"})
                        aadd(result,{"G",sor,startI-1+1,1,nev,nil})
                        aadd(result,{"S",sor,startI-1+2,1,"]","C"})
                        if( len(w)>3 )
                            aadd(result,{"S",sor,startI-1+3,space(len(w)-3),nil})
                        end
                    end
                
                else
                    aadd(result,{"G",sor,startI-1,i-startI,nev,nil})
                end
            end
        end 

#ifdef WHOLE_LINE       
        //say-ek kulon
        //Ez a megoldas egesz sorokat ir ki,
        //nem keruli ki, hanem csak space-ekkel helyettesiti a geteket.
        //Amikor a getek kirajzoljak magukat, akkor ezek a helyek felulirodnak.
        //Nem jo kikerulni a geteket, mert a nemrajzolas is rajzolas:
        //Peldaul egy get nem tudja kisebbre venni magat a berajzoltnal,
        //mert ott marad a berajzolt helyen egy lyuk.

        for i:=1 to len(line)
            startI:=i
            while( i<len(line) .and. color[i]>=16 )
                ++i
            end
            if( startI<i )
                line:=line[1..startI-1]+space(i-startI)+line[i..]
            end
        next  
        aadd(result,{"S",sor,0,len(line),line,NIL}) //say-ek kulon
#endif

    next
    return {rect,result}


******************************************************************************
static function decomp(str) 
    return '"' + str::strtran('"',<<REPL>>"+'"'+"<<REPL>>) + '"'

//eredetileg ez CCC3-ban a szovegek kikereseset vegezte
//az NLS tamogatas celjabol, itt csak az idezojeleket vedjuk le


*************************************************************************
static function gname(x)
local name:=x[MSKLO_STR] 
local type:=left(name,1)

   if( type=="[" )
       name:=strtran(substr(name,2),"]","")
   elseif( type=="(" )
       name:=strtran(substr(name,2),")","")
   elseif( type=="{" )
       name:=strtran(substr(name,2),"}","")
   elseif( type=="/" )
       name:=strtran(substr(name,2),"/","")
   elseif( type=="<" )
       name:=strtran(substr(name,2),">","")
   end
   return alltrim(name)


*************************************************************************
static function gtype(x)
local name:=x[MSKLO_STR] 
local type:=left(name,1)

   if( type=="[" )
       type:="Check"
   elseif( type=="(" )
       type:="Radio"
   elseif( type=="{" )
       type:="List"
   elseif( type=="/" )
       type:="AltButton"
   elseif( type=="<" )
       type:="PushButton"
   else
       type:="Get"
   end
   return type
 

*************************************************************************
function sayLTOutObj(mskLeiroTomb,file,srTomb)

//mskLeiroTomb-bõl objektumos típusú .say filét állít elõ

local rect:=mskLeiroTomb[MSKL_RECT] 
local vers:="//msk2say-"+ver()+endofline()
local prog:=""
local defi:=""
local decl:=""
local glst:=""
local glsta,oTomb
local newl:=endofline()
local startRow,startCol
local i,w

    if( empty(mskLeiroTomb) )
        return NIL
    end

    startRow:=TOP
    startCol:=LEFT
    decl+=newl+"static function msk"+upper(BaseName(ExtractName(file)))+"create(bLoad,bRead,bStore)"

    oTomb:=mskLeiroTomb[MSKL_OBJTOMB]
    glsta:={}

    prog+=newl+"    msk:=mskCreate("+str(TOP,3)+","+str(LEFT,3)+",";
                                    +str(BOTTOM,3)+","+str(RIGHT,3)+;
                                    ",bLoad,bRead,bStore)"
    prog+=newl
    prog+=newl+"    mskColorSay() //push"

    for i:=1 to len(oTomb)
       if (oTomb[i][MSKLO_TYPE]=='S')
          //w:='"'+oTomb[i][MSKLO_STR]+'"'
          w:=decomp(oTomb[i][MSKLO_STR]) //NLS
          prog+=newl+"    mskSay(msk,"+POSRO(oTomb[i][MSKLO_ROW],oTomb[i][MSKLO_COL])+","+w+")"
       elseif (oTomb[i][MSKLO_TYPE]=='G')
          decl+=newl+"local "+NEVPAD(gname(oTomb[i]))+":=space("+str(oTomb[i][MSKLO_FIELDLEN],2)+")"
          aadd(glsta,oTomb[i])
       else
          ? "say/get of unknown type:",oTomb[i][MSKLO_TYPE]
          quit
       end
    next
    prog+=newl+"    mskColorRestore() //pop"

    if( !empty(srTomb) )
        sorrend(glsta,srTomb)
    end

    for i:=1 to len(glsta)
        w:=glsta[i]
        glst+=newl+"    msk"+padr(gtype(w),10)+"(msk,"+POSRO(w[MSKLO_ROW],w[MSKLO_COL])+",@"+gname(w)+","+'"'+gname(w)+'"'+")"
        defi+=newl+"#define g_"+NEVPAD(gname(w))+"  "+"getlist["+str(i,2)+"]"
    next

    decl+=newl+"local msk"


    prog+=newl
    prog+=newl+"    mskColorGet() //push"
    prog+=glst
    prog+=newl+"    mskColorRestore() //pop"
    prog+=newl+"    return msk"

    prog+=newl

    prog+=newl+"static function "+upper(BaseName(ExtractName(file)))+"(bLoad,bRead,bStore)"
    prog+=newl+"local msk:=msk"+upper(BaseName(ExtractName(file)))+"create(bLoad,bRead,bStore)"
    prog+=newl+"    mskShow(msk)"
    prog+=newl+"    mskLoop(msk)"
    prog+=newl+"    mskHide(msk)"
    prog+=newl+"    return lastkey()"

    return( memowrit(file,LAT(CCC(vers+defi+newl+decl+newl+prog+newl))) )

    //LAT(CCC(x)) -> Latin ékezetek + Csiszár féle dobozrajzolók
    //hogy a régi msk-kból ne kerüljön a kódba CWI ékezetes karakter
    //vigyázat: CCC(LAT(x)) az Ö-t dobozrajzolóba viszi

*************************************************************************
static function sorrend(glsta,sorrendTomb)

//A sorrendTomb-ben szereplõ get azonosítók sorrendjét megváltoztatja
//a glsta-ban úgy, hogy a sorrendjük a sorrendTombben levõkkel azonos
//legyen. Ha egy glsta elem nem szerepel a sorrendTomb-ben, akkor a helye 
//nem változik. A glsta formája megfelel az mskLeiro-ban szereplõ OBJTOMB-nek.

local i,j,t:={},tg:={}

   for i:=1 to len(sorrendTomb)
      if (0==(j:=ascan(glsta,{|x| sorrendTomb[i]==gname(x)})))
         alert("'"+sorrendTomb[i]+"' nevû get mezõ nincs!")
      else
         aadd(t,j)
         aadd(tg,glsta[j])
      end
   next

   asort(t)

   for i:=1 to len(t)
      glsta[t[i]]:=tg[i]
   next

   return nil


*************************************************************************
static function ver()
    return "2.1.1-Latin2"

*************************************************************************
