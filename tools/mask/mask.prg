
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

// Utility get-read képernyõk elõállítására

#include "inkey.ch"
#include "box.ch"
#include "charconv.ch"


#define  CCC(x) _charconv(x,CHARTAB_CWI2CCC)
#define  CWI(x) _charconv(x,CHARTAB_CCC2CWI)
#define  LAT(x) _charconv(x,CHARTAB_CCC2LAT)
 
#define VERZIO  "1.10"  //2016.05.02 (msk beolvasásakor ccc->lat konverzió)

//#define VERZIO  "1.09"  //2014.03.04 (ENTER mutatja a pozíciót (mint a CCC3-ban))
//#define VERZIO  "1.08"  //2014.01.15 (nagyobb maszkok)
//#define VERZIO  "1.07"  //2011.08.12 (dosconv megszüntetve, hexa kódok)
//#define VERZIO  "1.06"  //2002.03.27 (Solarisos javítások)
//#define VERZIO  "1.05"  //2000.07.08 (keymap.z támogatás)
//#define VERZIO  "1.04"  //2000.04.21 (checkbox támogatás)
//#define VERZIO  "1.03"  //2000.01.12 (CCC kódrendszer)
//#define VERZIO  "1.02"  //1999.05.20
//#define VERZIO  "1.01"  //1999.02.09
 
*************************************************************************
#define  KEY_HELP      K_F1
#define  KEY_SAVE      K_F2
#define  KEY_LOAD      K_F3
#define  KEY_MARK      K_F4
#define  KEY_COPY      K_F5
#define  KEY_MOVE      K_F6
#define  KEY_LINS      K_F7
#define  KEY_LIND      K_F8
#define  KEY_PROG      K_F9
#define  KEY_PRNT      K_F10

*************************************************************************
#define TOP            rect[1]
#define LEFT           rect[2]
#define BOTTOM         rect[3]
#define RIGHT          rect[4]

#define MAXROW         f_maxrow()
#define MAXCOL         f_maxcol()

#define MASKEXT        ".msk"

*************************************************************************

static batch_mskfile:=""
static batch_codegen:="*"


static origscrn:=NIL
static origsize:=NIL    //a sizeCCCxRRR-ek kozul az egyik


static size80x25:={80,25}
static size100x50:={100,50}
static size120x60:={120,60}
static size160x60:={160,60}
static size200x60:={200,60}
static termsize:=NIL    //a sizeCCCxRRR-ek kozul az egyik

#define CALCSIZE(t)  (t[1]*t[2]*2)


*************************************************************************
static function f_maxrow(s)
static x:=24
    if( s!=NIL )
        x:=s
    end
    return x

static function f_maxcol(s)
static x:=79
    if( s!=NIL )
        x:=s
    end
    return x

*************************************************************************
static function termsetup()
    f_maxcol(termsize[1]-1)
    f_maxrow(termsize[2]-1)
    //settermsize(MAXROW+1,MAXCOL+1)  //a CCC3 terminal meretezheto, a CCC2 nem 
    setcursor(1)


*************************************************************************
static function termrect(size)
    if( size==CALCSIZE(size80x25) )
        return size80x25
    elseif( size==CALCSIZE(size100x50) )
        return size100x50
    elseif( size==CALCSIZE(size120x60) )
        return size120x60
    elseif( size==CALCSIZE(size160x60) )
        return size160x60
    elseif( size==CALCSIZE(size200x60) )
        return size200x60
    end
    ? "Incompatible screen size",size
    ?
    quit


*************************************************************************
function main(a1,a2,a3,a4,a5,a6,a7,a8,a9)

local xscreen,currow,curcol
local arg:={a1,a2,a3,a4,a5,a6,a7,a8,a9,NIL}
local n:=0, a, line

    xscreen:=savescreen(0,0,maxrow(),maxcol())
    currow:=row()
    curcol:=col()

    setcursor(1)
 

    while( !empty(a:=arg[++n]) )

        if( MASKEXT$a .and. file(a) )
            batch_mskfile:=a

        elseif( file(a+MASKEXT) )
            batch_mskfile:=a+MASKEXT

        elseif( "-F"$a )
            if( !MASKEXT$a )
                a+=MASKEXT
            end
            batch_mskfile:=substr(a,3)

        elseif( "-G"$a )
            batch_codegen:=substr(a,3,1)
            
            if( batch_codegen=="T" )
                //OK
            elseif( batch_codegen=="O" )
                //OK
            else
                errorlevel(1)
                usage()
            end

        elseif( a=="-size80x25" )
            termsize:=size80x25
      
        elseif( a=="-size100x50" )
            termsize:=size100x50

        elseif( a=="-size120x60" )
            termsize:=size120x60

        elseif( a=="-size160x60" )
            termsize:=size160x60

        elseif( a=="-size200x60" )
            termsize:=size200x60

        elseif( "-size"$a )
            ? "Known size options: -size80x25 -size100x50 -size120x60 -size160x60 -size200x60"
            ?
            quit

        elseif( "?"$a .or. "-H"$a )
            usage()

        else
            errorlevel(1)
            usage()
        end
    end

    if( termsize!=NIL )
        if( termsize[1]>maxcol()+1 .or. termsize[2]>maxrow()+1 )
            alert("Nagyobb terminálra van szükség!")
            return NIL
        end
    end


    if( empty(batch_mskfile)  )
        //nincs megadva bemeneti file
        //ures kepernyovel indulunk

        if( termsize==NIL )
            termsize:=size80x25 //regi default
        end
        termsetup()
        clear screen
        screenedit()

    elseif( !file(batch_mskfile) )
        //meg van adva bemeneti file
        //de nem talalhato -> hiba
        ? batch_mskfile+" does not exist"
        errorlevel(1)
        quit

    elseif( !batch_codegen=="*" )
        //bemeneti file megvan (megadtak, letezik),
        //de nem kell editalni, csak kodot generalunk
        //(sajnos ilyenkor is meg kell jeleniteni)

        origscrn:=ReadMask(batch_mskfile)
        origsize:=termrect(len(origscrn))
        termsize:=origsize
        termsetup()
        restscreen(0,0,MAXROW,MAXCOL,origscrn)
        PrgOut(ExtractName(batch_mskfile))

    else
        //a megadott bemeneti filet kell editalni
    
        origscrn:=ReadMask(batch_mskfile)
        origsize:=termrect(len(origscrn))

        if( termsize!=NIL )
            termsetup()
       
            if( len(origscrn)<=CALCSIZE(termsize) )
                //nagyobba tolti be, mint az eredeti merete
                restscreen(0,0,origsize[2]-1,origsize[1]-1,origscrn)
                origscrn:=savescreen(0,0,MAXROW,MAXCOL)

            else
                //kisebbe tolti be, mint az eredeti merete
                for n:=0 to MAXROW
                    line:=origscrn::substr(n*origsize[1]*2+1,origsize[1]*2)::left(termsize[1]*2)
                    restscreen(n,0,n,MAXCOL,line)
                next
                origscrn:=savescreen(0,0,MAXROW,MAXCOL)
            end
        else
            //akkoraba tolti be, mint amekkora a merete
            termsize:=origsize
            termsetup()
            restscreen(0,0,MAXROW,MAXCOL,origscrn)
        end
    
        screenedit(batch_mskfile)
    end


    restscreen(0,0,maxrow(),maxcol(),xscreen)
    setpos(currow,curcol)

    return NIL


*************************************************************************
function usage()
    ? "Usage: mask [[-f]MASKFILE] [-gOBJ|-gTRAD] [-h|-?|?]"
    quit
    return NIL


*************************************************************************
function screenedit(maskfile)
local key, choice:=1
local posr, posc, screen
local menukey:={K_F1,K_F2,K_F3,K_F4,K_F5,K_F6,K_F7,K_F8,K_F9,K_F10}
local aFile
local ins:=.f.

    #ifdef _UNIX_
      keymap(memoread(getenv("HOME")+"/.z/keymap.z"))
    #else
      keymap(memoread(strtran(lower(exename()),"mask.exe","keymap.z")))
    #endif
    
    if( maskfile==NIL )
        maskfile:=""
    end
    
    setpos(0,0)
    
    while( .t. )

       key:=keymap(inkey(0))
       
       if(key==255.and.choice>0)
           key:=menukey[choice]
       end

       if( key==K_ESC )
           if(2==alert("Ki akar lépni a programból?", {"Marad", "Kilép"}) )     
               exit
           end

       elseif( key==K_ENTER )
           showpos()

       elseif( key==K_UP )
           MoveCursor(-1,0)

       elseif( key==K_DOWN )
           MoveCursor(1,0)

       elseif( key==K_LEFT )
           MoveCursor(0,-1)

       elseif( key==K_RIGHT )
           MoveCursor(0,1)
       
       elseif( key==K_HOME )
           setpos(row(), 0)

       elseif( key==K_END )
           setpos(row(), MAXCOL)

       elseif( key==K_PGUP )
           setpos(0, col())

       elseif( key==K_PGDN )
           setpos(MAXROW, col())

       elseif( key==K_CTRL_LEFT )
       elseif( key==K_CTRL_RIGHT )
       elseif( key==K_CTRL_HOME )
       elseif( key==K_CTRL_END )
       elseif( key==K_CTRL_PGUP )
       elseif( key==K_CTRL_PGDN )
       elseif( key==K_CTRL_RET )
       elseif( key==K_RETURN )
       elseif( key==K_TAB )
       elseif( key==K_SH_TAB )
       elseif( key==K_CTRL_BS )

       elseif( key==K_DEL )
           DeleteChar()

       elseif( key==K_INS )
           ins:=!ins

       elseif( key==K_BS )
           BackSpace()

       elseif(key==KEY_LIND .or. key==KEY_LINS)
           DrawLine(key)

       elseif(key==KEY_MARK)
           MarkRect(key)

       elseif(key==KEY_HELP)
           posr:=min(row(), MAXROW-11)
           posc:=min(col(), MAXCOL-18)
           choice:=ChoiceBox(posr,posc,posr+11,posc+18,{;
                 "F1  - Help",;
                 "F2  - Save",;
                 "F3  - Load",;
                 "F4  - Mark rect",;
                 "F5  - Copy rect",;
                 "F6  - Move rect",;
                 "F7  - Line single",;
                 "F8  - Line double",;
                 "F9  - PRG output",;
                 "F10 - Printer"})
           if(choice>0)
               keyboard( chr(255) )
           end

       elseif(key==KEY_MOVE .or. key==KEY_COPY)
           CopyRect(key)

       elseif( key==KEY_SAVE )
           maskfile:=SaveMask(ExtractName(maskfile))

       elseif( key==KEY_LOAD )
           aFile:=SelectFile("*.msk",,4,23,18,57)
           if(!empty(aFile))
               maskfile:=aFile[1]
               origscrn:=ReadMask(maskfile) //1a-t levágja
               if( !empty(origscrn) )
                   // ha nem eleg nagy a terminal,
                   // ReadMask ureset ad (akkor ide nem jon)
                   origsize:=termrect(len(origscrn))
                   termsize:=origsize
                   termsetup()
                   clear screen
                   restscreen(0,0,MAXROW,MAXCOL,origscrn)
               end
           end

       elseif( key==KEY_PROG )
           PrgOut(ExtractName(maskfile))

       elseif( key==KEY_PRNT )
           PrintOut(maskfile)
           
       else 
       
           if(ins .and. col()<MAXCOL)
               posr:=row()
               posc:=col()
               screen:=savescreen(posr,posc,posr,MAXCOL-1)
               restscreen(posr,posc+1,posr,MAXCOL,screen)
               setpos(posr,posc)
           end
            
           OutChar( chr(key) ) 

       end    
       
    end
    return key


*************************************************************************
//  A képernyõt printerre nyomja landscape orientációval,
//  az inverz mezõket alápontozva
//
function PrintOut(caption)
local screen:=savescreen(), i, j, n, color, char

    if(isprinter())

        set console off
        set printer on
        
        ?? chr(27)+"E"        // inicializálás
        ?? chr(27)+"&l1O"     // landscape
        ?? chr(27)+"&l12E"    // top margin
        ?? chr(27)+"&a16L"    // left margin
        ?? chr(27)+"(8Q"      // IBM-PC Character Set
        
        for i:=0 to 24
            for j:=1 to 80
                n:=2*(80*i+j)
                char:=substr(screen,n-1,1)             
                color:=asc(substr(screen,n,1))

                ?? chr(27)+"&f0S" // push
                if(color<16)  
                    // normál
                    //?? chr(177)
                    ?? chr(159)
                else
                    // inverz
                    ?? chr(27)+"*p+12Y"
                    ?? "."
                end
                ?? chr(27)+"&f1S" // pop
                ?? char
            next
            ?
        next
        
        ?
        ?
        ?  chr(27)+"(s1S"+padc(upper(alltrim(caption)),80)

        eject
        ?? chr(27)+"E" // inicializálás
        set printer off
        set console on

    else
        alert("A printer nincs bekapcsolva!")
    end
    return NIL

*************************************************************************
function CopyRect(key)
local posr:=row(), posc:=col()
local rect:=MarkRect(key)
local screen, key1

    if( rect!=NIL )
        while( .t. )
            key1:=inkey(0) 
            if(key1==K_ESC)
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
                exit
            elseif(key1==KEY_MOVE .and. key==KEY_MOVE)
                posr:=row()
                posc:=col()
                InverseRect(posr,posc,posr+BOTTOM-TOP,posc+RIGHT-LEFT)
                screen:=savescreen(TOP,LEFT,BOTTOM,RIGHT)
                @ TOP, LEFT clear to BOTTOM, RIGHT
                restscreen(posr,posc,posr+BOTTOM-TOP,posc+RIGHT-LEFT,screen)
                exit
            elseif(key1==KEY_COPY .and. key==KEY_COPY)
                posr:=row()
                posc:=col()
                InverseRect(posr,posc,posr+BOTTOM-TOP,posc+RIGHT-LEFT)
                screen:=savescreen(TOP,LEFT,BOTTOM,RIGHT)
                restscreen(posr,posc,posr+BOTTOM-TOP,posc+RIGHT-LEFT,screen)
                exit
            elseif(key1==K_UP .and. row()>0)
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
                MoveCursor(-1,0)
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
            elseif(key1==K_DOWN .and. row()<MAXROW-BOTTOM+TOP )
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
                MoveCursor(1,0)
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
            elseif(key1==K_LEFT .and. col()>0)
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
                MoveCursor(0,-1)
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
            elseif(key1==K_RIGHT .and. col()<MAXCOL-RIGHT+LEFT )
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
                MoveCursor(0,1)
                InverseRect(row(),col(),row()+BOTTOM-TOP,col()+RIGHT-LEFT)
            end
        end
    end
    setpos(posr,posc)
    return NIL


*************************************************************************
function GetRect()
local rect:={0,0,MAXROW,MAXCOL}, n
 
    n:=0
    while( n<=MAXROW )
        if( !empty(screenchar(savescreen(n,0,n,MAXCOL))) )
            rect[1]:=n
            exit
        end
        n++
    end

    if( n>MAXROW ) 
        return NIL
    end

    n:=MAXROW
    while( n>=0 )
        if( !empty(screenchar(savescreen(n,0,n,MAXCOL))) )
            rect[3]:=n
            exit
        end
        n--
    end

    n:=0
    while( n<=MAXCOL )
        if( !empty(screenchar(savescreen(0,n,MAXROW,n))) )
            rect[2]:=n
            exit
        end
        n++
    end
    
    n:=MAXCOL
    while( n>=0 )
        if( !empty(screenchar(savescreen(0,n,MAXROW,n))) )
            rect[4]:=n
            exit
        end
        n--
    end

    return rect


*************************************************************************
function PrgOut(file) 
   if( batch_codegen=="T" )
       return PrgOutTrad(file)
   else
       return PrgOutObj(file)
   end
   return NIL

*************************************************************************
function PrgOutObj(file) 

local rect:=GetRect()

local r,c,c1,c2,line,color,nget:=0
local prog:=""
local defi:=""
local decl:=""
local glst:=""

local vget:=""
local vput:=""
local gpic:=""
 
local newl:=endofline()

#define SAY(r,c,s)    "    mskSay(msk,"+str(r-TOP,3)+","+str(c-LEFT,3)+","+s+")"
#define GET(r,c,g)    "    mskGet   (msk,"+str(r-TOP,3)+","+str(c-LEFT,3)+",@"+g+',"'+g+'")'
#define CHECK(r,c,g)  "    mskCheck (msk,"+str(r-TOP,3)+","+str(c-LEFT,3)+",@"+g+',"'+g+'")'
#define RADIO(r,c,g)  "    mskRadio (msk,"+str(r-TOP,3)+","+str(c-LEFT,3)+",@"+g+',"'+g+'")'
#define LIST(r,c,g)   "    mskList  (msk,"+str(r-TOP,3)+","+str(c-LEFT,3)+",@"+g+',"'+g+'")'
 
 
#define SUBLIN  substr(line,c1,c2-c1)
#define TOKEN   alltrim(SUBLIN)
#define PTOK    padr(TOKEN,12)

#define TOKENC  alltrim(strtran(strtran(TOKEN,"[",""),"]",""))
#define PTOKC   padr(TOKENC,12)

#define TOKENR  alltrim(strtran(strtran(TOKEN,"(",""),")",""))
#define PTOKR   padr(TOKENR,12)

#define TOKENL  alltrim(strtran(strtran(TOKEN,"{",""),"}",""))
#define PTOKL   padr(TOKENL,12)

    if( empty(rect) )
        return NIL
    end

    if( empty(file) )
        if( empty( file:=GetText("Enter filename:", file)) )
            return NIL
        end
        if( rat(".",file)<=rat(dirsep(),file) )
            file+=".say"
        end
        if( file(file) .and.;
            2!=alert("A fájl már létezik, felülírja?", {"Nem","Felülír"} ) )
            return NIL
        end
    else
        file+=".say"
    end

    decl+=newl+"static function "+ModuleName(file)+"(bLoad,bRead,bStore)"

    for r:=TOP to BOTTOM
        line:=savescreen(r,LEFT,r,RIGHT)
        color:=array(len(line)/2)
        for c:=1 to len(line)/2
            color[c]:=asc(substr(line,c+c,1)) // színkódok tömbje
        next
        line:=screenchar(line) // színkódok nélküli sor
        
        c1:=1
        for c2:=1 to len(line)
            if( color[c1] != color[c2] )

               if( color[c1]<16 )  
                      // nem kiemelt szín -- szöveg konstans
                   prog+=newl+SAY(r,c1+LEFT-1,'"'+SUBLIN+'"')

               else   // kiemelt szín -- get mezõ
                   nget++
                   
                   if( left(TOKEN,1)=="[" )
                       glst+=newl+CHECK(r,c1+LEFT-1,TOKENC)
                       defi+=newl+"#define g_"+PTOKC+"  "+"getlist["+str(nget,2)+"]"  
                       decl+=newl+"local "+PTOKC+":=space("+str(c2-c1,2)+")"

                       gpic+=newl+"    g_"+PTOKC+":picture:='"+replicate("X",c2-c1)+"'"
                       vget+=newl+"    g_"+PTOKC+":varget"
                       vput+=newl+"    g_"+PTOKC+":varput()"
 
                   elseif( left(TOKEN,1)=="(" )
                       glst+=newl+RADIO(r,c1+LEFT-1,TOKENR)
                       defi+=newl+"#define g_"+PTOKR+"  "+"getlist["+str(nget,2)+"]"  
                       decl+=newl+"local "+PTOKR+":=space("+str(c2-c1,2)+")"

                       gpic+=newl+"    g_"+PTOKR+":picture:='"+replicate("X",c2-c1)+"'"
                       vget+=newl+"    g_"+PTOKR+":varget"
                       vput+=newl+"    g_"+PTOKR+":varput()"
 
                   elseif( left(TOKEN,1)=="{" )
                       glst+=newl+LIST(r,c1+LEFT-1,TOKENL)
                       defi+=newl+"#define g_"+PTOKL+"  "+"getlist["+str(nget,2)+"]"  
                       decl+=newl+"local "+PTOKL+":=space("+str(c2-c1,2)+")"

                       gpic+=newl+"    g_"+PTOKL+":picture:='"+replicate("X",c2-c1)+"'"
                       vget+=newl+"    g_"+PTOKL+":varget"
                       vput+=newl+"    g_"+PTOKL+":varput()"
 
                   else
                       glst+=newl+GET(r,c1+LEFT-1,TOKEN)
                       defi+=newl+"#define g_"+PTOK+"  "+"getlist["+str(nget,2)+"]"  
                       decl+=newl+"local "+PTOK+":=space("+str(c2-c1,2)+")"

                       gpic+=newl+"    g_"+PTOK+":picture:='"+replicate("X",c2-c1)+"'"
                       vget+=newl+"    g_"+PTOK+":varget"
                       vput+=newl+"    g_"+PTOK+":varput()"
                   end
               end
               c1:=c2
            end
        next
        // maradék  
        prog+=newl+SAY(r,c1+LEFT-1,'"'+substr(line,c1)+'"')
    next

    decl+=newl+"local msk:=mskCreate("+;
                           str(TOP,3)+","+str(LEFT,3)+","+;
                           str(BOTTOM,3)+","+str(RIGHT,3)+;
                           ",bLoad,bRead,bStore)"

    prog+=newl+glst+newl
    prog+=newl+"    mskShow(msk)"
    prog+=newl+"    mskLoop(msk)"
    prog+=newl+"    mskHide(msk)"
    prog+=newl+"    return lastkey()"
    
    //memowrit("out",gpic+newl+vget+newl+vput+newl)  //ez minek?

    return memowrit(file, LAT(CCC(CWI(defi+newl+decl+newl+prog+newl))) ) 


*************************************************************************
function PrgOutTrad(file) 

local rect:=GetRect()
local r,c,c1,c2,line,color,nget:=0
local prog:=""
local defi:=""
local decl:=""
local glst:=""
local newl:=endofline()
#define POS(x,y)  "   @"+str(x,3)+","+str(y,3)

#undef SUBLIN 
#undef TOKEN  
#undef PTOK   

#define SUBLIN  substr(line,c1,c2-c1)
#define TOKEN   alltrim(SUBLIN)
#define PTOK    padr(TOKEN,12)
    
    if( empty(rect) )
        return NIL
    end

    if( empty(file) )

        if( empty( file:=GetText("Enter filename:", file)) )
            return NIL
        end
        if( rat(".",file)<=rat(".",file) )
            file+=".say"
        end
        if( file(file) .and.;
            2!=alert("A fájl már létezik, felülírja?", {"Nem","Felülír"} ) )
            return NIL
        end
    else
        file+=".say"
    end

    prog+=newl+"   dispbegin()"
    prog+=newl+POS(TOP,LEFT)+" clear to "+str(BOTTOM,2)+","+str(RIGHT,2)
    decl+=newl+"static function "+ExtractName(file)+"(bLoad,bRead,bStore)"

    for r:=TOP to BOTTOM
        line:=savescreen(r,LEFT,r,RIGHT)
        color:=array(len(line)/2)
        for c:=1 to len(line)/2
            color[c]:=asc(substr(line,c+c,1)) // színkódok tömbje
        next
        line:=screenchar(line) // színkódok nélküli sor
        
        c1:=1
        for c2:=1 to len(line)
            if( color[c1] != color[c2] )

               if( color[c1]<16 )  
                      // nem kiemelt szín -- szöveg konstans
                   prog+=newl+POS(r,c1+LEFT-1)+" say "+'"'+SUBLIN+'"'

               else   // kiemelt szín -- get mezõ
                   nget++
                   glst+=newl+POS(r,c1+LEFT-1)+" get "+TOKEN
                   defi+=newl+"#define g_"+PTOK+"  "+"getlist["+str(nget,2)+"]"  
                   decl+=newl+"local "+PTOK+':=space('+str(c2-c1,2)+")"
               end
               c1:=c2
            end
        next
        // maradék  
        prog+=newl+POS(r,c1+LEFT-1)+" say "+'"'+substr(line,c1)+'"'
    next

    decl+=newl+"local getlist:={}"
    decl+=newl+"local screen:=savescreen("+str(TOP,2)+","+str(LEFT,2)+",";
                                          +str(BOTTOM,2)+","+str(RIGHT,2)+")"
    decl+=newl+"local cursor:=setcursor(1)"

    prog+=newl+glst
    prog+=newl+"   eval(bLoad,getlist)"
    prog+=newl+"   dispend()"
    prog+=newl+"   readexit(.f.)"

    prog+=newl+"   while(.t.)"
    prog+=newl+"       eval(bRead,getlist)"
    prog+=newl+"       if( lastkey()==27 .or. eval(bStore,getlist) )"
    prog+=newl+"           exit"
    prog+=newl+"       end"
    prog+=newl+"   end"

    prog+=newl+"   setcursor(cursor)"
    prog+=newl+"   restscreen("+str(TOP,2)+","+str(LEFT,2)+",";
                               +str(BOTTOM,2)+","+str(RIGHT,2)+",screen)"
    prog+=newl+"   return lastkey()"

    return( memowrit(file, defi+newl+decl+newl+prog+newl ))


*************************************************************************
function SelectFile(spec, attr, top, left, bottom, right)

local t:=if(top==NIL,10,top) 
local l:=if(left==NIL,38,left) 
local b:=if(bottom==NIL,20,bottom) 
local r:=if(right==NIL,78,right) 
local aDir:=directory(spec,attr)
local aMenu:={}, n
local inich:=1,item
static prev:=""

    asort(aDir,,,{|a,b|a[1]<b[1]})

    for n:=1 to len(aDir)
        if( aDir[n][1]==prev )
            inich:=n
        end
        
        item:= padr(aDir[n][1],13)+;     // name
               padl(aDir[n][3],9) +;     // date
               padl(aDir[n][4],9)        // time
               
        item:=lower(" "+item)
        aadd(aMenu,item)
    next

    if((n:=ChoiceBox(t,l,b,r,aMenu,,,inich))<1)
        prev:=""
        return NIL
    end
    
    prev:=aDir[n][1]
    return aDir[n]                 



*************************************************************************
function SaveMask(filnam0)
local filnam:=filnam0

    if( !empty(filnam:=GetText("Enter filename:", filnam)) )
    
        if( rat(".",filnam)<=rat(dirsep(),filnam) )
             filnam+=MASKEXT
        end

        if( !file(filnam) .or.;
            2==alert("A fájl már létezik, felülírja?", {"Nem","Felülír"} ) )
    
            memowrit(filnam, CWI(savescreen(0,0,MAXROW,MAXCOL)) )
            return filnam
        end
    end

    return filnam0


*************************************************************************
function ReadMask(filnam)
local x:=LAT(CCC(memoread(filnam)))
local len:=len(x),tr
    len-=len%4 //leszedi az esetleges EOF-ot a regi filekrol
    tr:=termrect(len)
    if( tr[1]>maxcol()+1 .or. tr[2]>maxrow()+1 )
        alert("Nagyobb terminálra van szükség: "+filnam+_any2str(tr)  )
        return NIL
    end
    return left(x,len) 


*************************************************************************
function ExtractName(filename)  // /path/file.ext --> /path/file
local ppos,epos

   if( empty(filename) )
       filename:=""
   end

   ppos:=rat(dirsep(),filename)
   epos:=rat(".",filename)

   if( epos>ppos )
       filename:=left(filename,epos-1)
   end
   
   return filename


*************************************************************************
function ModuleName(filename)  // \path\file.ext --> file
local ppos,epos

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
function GetText(prompt, txt:="", length:=128)
local posr:=row(), posc:=col()
local ncur:=setcursor(1)
local ww:=48 //window width
local t:=MAXROW/2+1, l:=MAXCOL/2-2-ww/2
local b:=t+6, r:=l+4+ww
local screen:=DrawBox(t,l,b,r,B_DOUBLE)
local get:=GetNew(t+4,l+2,{|x|if(x==NIL,padr(txt,length),txt:=padr(x,length))})

     get:picture:="@S"+alltrim(str(ww))

     @ t+2,l+2 say prompt
     ReadModal({get})
     if(lastkey()==K_ESC)
         txt:=NIL
     else
         txt:=alltrim(txt)
     end

     setcursor(ncur)
     restscreen(t,l,b,r,screen)
     setpos(posr,posc)

     return txt


*************************************************************************
function OutChar(c)
local s:=savescreen(row(),col(),row(),col())
     restscreen( row(),col(),row(),col(), c+substr(s,2,1) )
     if( col()<MAXCOL )
         setpos(row(), col()+1)
     end
     return NIL


*************************************************************************
function MoveCursor(r,c)
    
    if( (r+=row())<0 )
        r:=0
    elseif(r>MAXROW)
        r:=MAXROW
    end
    
    if( (c+=col())<0 ) 
        c:=0
    elseif(c>MAXCOL)
        c:=MAXCOL
    end
    
    setpos(r,c)
    return NIL
    
*************************************************************************
function DeleteChar()
local r:=row(), c:=col()
local screenrow
    if( c<MAXCOL )
        screenrow:=savescreen(r,c+1,r,MAXCOL)
        restscreen(r,c,r,MAXCOL-1,screenrow )
    end
    @ r, MAXCOL say " "
    setpos(r,c)
    return NIL
 
*************************************************************************
function BackSpace()
    if(col()>0)
        MoveCursor(0,-1)
        DeleteChar()
    end
    return NIL

*************************************************************************
function MarkRect(TermChar)
local rect:={row(), col(), row(), col()}    
local key, posr:=row(), posc:=col()
 
    InverseRect(TOP,LEFT,BOTTOM,RIGHT)

    while( (key:=inkey(0))!=TermChar )

        if(key==K_ESC)
            InverseRect(TOP,LEFT,BOTTOM,RIGHT)
            setpos(posr, posc)
            return(NIL)

        elseif(key==K_UP .and. row()>TOP)
            InverseRect(BOTTOM,LEFT,BOTTOM,RIGHT)
            BOTTOM--
            MoveCursor(-1,0)
            
        elseif(key==K_DOWN .and. row()<MAXROW )
            BOTTOM++
            InverseRect(BOTTOM,LEFT,BOTTOM,RIGHT)
            MoveCursor(1,0)

        elseif(key==K_LEFT .and. col()>LEFT )
            InverseRect(TOP,RIGHT,BOTTOM,RIGHT)
            RIGHT--
            MoveCursor(0,-1)

        elseif(key==K_RIGHT .and. col()<MAXCOL)
            RIGHT++
            InverseRect(TOP,RIGHT,BOTTOM,RIGHT)
            MoveCursor(0,1)
        end
    end
    setpos(posr, posc)
    return rect

*************************************************************************
static function nu()
static grchr:=x'cfb5a4b8b2b4b7ccb3b6c5cbc0c3b1a5a6cebbb9bebac4c2bfbdbcada8acabaecac6a9afc8c7aab0'
static grd  :=    "1111011100222011102220100202222020201010"
local n:=0, ch, r:=row()-1, c:=col()
   if( r>=0 ) 
       ch:=left(savescreen(r,c,r,c), 1)
       if( (n:=at(ch,grchr)) > 0 )
           n:=asc(substr(grd, n, 1))-asc("0")
       end
   end
   return n
   
*************************************************************************
static function nd()
static grchr:=x'cfb5a4b8b2b4b7ccb3b6c5cbc0c3b1a5a6cebbb9bebac4c2bfbdbcada8acabaecac6a9afc8c7aab0'
static gru  :=    "0111101110022201110222010020222202020101"
local n:=0, ch, r:=row()+1, c:=col()
   if( r<=MAXROW ) 
       ch:=left(savescreen(r,c,r,c), 1)
       if( (n:=at(ch,grchr)) > 0 )
           n:=asc(substr(gru, n, 1))-asc("0")
       end
   end
   return n

*************************************************************************
static function nl()
static grchr:=x'cfb5a4b8b2b4b7ccb3b6c5cbc0c3b1a5a6cebbb9bebac4c2bfbdbcada8acabaecac6a9afc8c7aab0'
static grr  :=    "1102111211112100002122222220000011002200"
local n:=0, ch, r:=row(), c:=col()-1
   if( c>=0 ) 
       ch:=left(savescreen(r,c,r,c), 1)
       if( (n:=at(ch,grchr)) > 0 )
           n:=asc(substr(grr, n, 1))-asc("0")
       end
   end
   return n

*************************************************************************
static function nr()
static grchr:=x'cfb5a4b8b2b4b7ccb3b6c5cbc0c3b1a5a6cebbb9bebac4c2bfbdbcada8acabaecac6a9afc8c7aab0'
static grl  :=    "0000011211112111210000222222102200110022"
local n:=0, ch, r:=row(), c:=col()+1
   if( c<=MAXCOL ) 
       ch:=left(savescreen(r,c,r,c), 1)
       if( (n:=at(ch,grchr)) > 0 )
           n:=asc(substr(grl, n, 1))-asc("0")
       end
   end
   return n

*************************************************************************
function DrawLine(line)

static r:=x'b6cfcab2b5b2c6cfb9b6b4c5b3b7b3c3b4cb'
static u:=x'a4ceb0b2b3b2c7cec2a4a5a6b5b7b5b8a5cc'
static l:=x'b6b1a9cea5ceafb1a8b6b4c5b3b7b3c3b4cb'
static d:=x'a4b1aacfb4cfc8b1c4a4a5a6b5b7b5b8a5cc'
static rr:=x'bfc8bbc7b8bbbababebfc4bdc2ccbdbcbcc0'
static uu:=x'acafaec6c3aebababcaca8abb9cbabbebec0'
static ll:=x'bfaaadb0a6adaeaeabbfc4bdc2ccbdbcbcc0'
static dd:=x'aca9adcac5adbbbbbdaca8abb9cbabbebec0'

local arrow:=chr(K_UP)+chr(K_DOWN)+chr(K_LEFT)+chr(K_RIGHT)
local ind, key, cpr, cpc

    while( (key:=inkey(0))!=K_ESC )

       if( chr(key) $ arrow )
           cpr:=row()
           cpc:=col()

           if(line==KEY_LINS)

               if( key==K_UP ) 
                  ind:=if(nd()==1,1,0)
                  ind:=3*ind+nr()
                  ind:=3*ind+nl()
                  ind++
                  @ cpr, cpc say substr(u, ind, 1) 
                  setpos(cpr, cpc)
                  MoveCursor(-1,0)
               
               elseif( key==K_LEFT )           
                  ind:=if(nr()==1,1,0)
                  ind:=3*ind+nu()
                  ind:=3*ind+nd()
                  ind++
                  @ cpr, cpc say  substr(l, ind, 1) 
                  setpos(cpr, cpc)
                  MoveCursor(0,-1)
                  
               elseif( key==K_DOWN )           
                  ind:=if(nu()==1,1,0)
                  ind:=3*ind+nr()
                  ind:=3*ind+nl()
                  ind++
                  @ cpr, cpc say  substr(d, ind, 1) 
                  setpos(cpr, cpc)
                  MoveCursor(1,0)

               elseif( key==K_RIGHT )           
                  ind:=if(nl()==1,1,0)
                  ind:=3*ind+nu()
                  ind:=3*ind+nd()
                  ind++
                  @ cpr, cpc say  substr(r, ind, 1) 
                  setpos(cpr, cpc)
                  MoveCursor(0, 1)
               end
           
           elseif(line==KEY_LIND)

               if( key==K_UP ) 
                  ind:=if(nd()==2,1,0)
                  ind:=3*ind+nr()
                  ind:=3*ind+nl()
                  ind++
                  @ cpr, cpc say  substr(uu, ind, 1) 
                  setpos(cpr, cpc)
                  MoveCursor(-1,0)
               
               elseif( key==K_LEFT )           
                  ind:=if(nr()==2,1,0)
                  ind:=3*ind+nu()
                  ind:=3*ind+nd()
                  ind++
                  @ cpr, cpc say  substr(ll, ind, 1) 
                  setpos(cpr, cpc)
                  MoveCursor(0,-1)
                  
               elseif( key==K_DOWN )           
                  ind:=if(nu()==2,1,0)
                  ind:=3*ind+nr()
                  ind:=3*ind+nl()
                  ind++
                  @ cpr, cpc say  substr(dd, ind, 1) 
                  setpos(cpr, cpc)
                  MoveCursor(1,0)

               elseif( key==K_RIGHT )           
                  ind:=if(nl()==2,1,0)
                  ind:=3*ind+nu()
                  ind:=3*ind+nd()
                  ind++
                  @ cpr, cpc say  substr(rr, ind, 1) 
                  setpos(cpr, cpc)
                  MoveCursor(0, 1)
               end

           end

       elseif(key==KEY_LINS .or. key==KEY_LIND)
            line:=key
       elseif(key==K_ENTER)
            showpos()
       end

    end
    return NIL


*************************************************************************
static function keymap(c)
static map:={}
local aline,n,x,key

    if( valtype(c)=="C" .and. !empty(c) )
        c:=strtran(c,chr(13),"")
        aline:=wordlist(c,chr(10))
        for n:=1 to len(aline)
            x:=wordlist(aline[n])
            if( len(x)>=2 )
                aadd(map,{val(x[1]),val(x[2])})
            end
        next
    
    elseif( valtype(c)=="N" )
        n:=ascan(map,{|x|x[1]==c})
        if( n>0 )
            key:=map[n][2]
        else
            key:=c
        end
    end
    
    return key


*************************************************************************
static function showpos()
local get:=message(NIL,"("+(1+col())::str::alltrim+","+(1+row())::str::alltrim+")" )
local key:=inkey(4)
    message(get)
    if( key!=0 .and. key!=K_ENTER )
        keyboard(chr(key))
    end

*************************************************************************
 