
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

/*
Alternat�v programgener�l�s PAGE-hez. Az eredeti PAGE say utas�t�sokkal
fixen poz�cion�lt �br�t k�sz�t, ez ? utas�t�sokkal abba a sorba �r, ahol
�ppen tart. A legy�rtott program t�bb f�ggv�nyt tartalmaz a rajzban
elhelyezett section-oknak megfele�en. Igy kell elk�sz�teni a rajzot:

#section1
     ...
     rajzr�szlet1
     ...
#section2
     ...
     rajzr�szlet2
     ...
#end

Minden f�ggv�ny argumentuma ugyanaz a pgelist, ami ugyanolyan, mint
a kor�bbi PAGE-ben. Azok a sorok, ahol a bal oldali els� token csupa
nagybet�, ism�tl�sorok. Az ilyen sorokhoz tartoz� pgelist elemek 
�rt�k��l arrayt kell megadni, �s a sor annyiszor fog im�tl�dni, amilyen
hossz� a megadott array.


Kieg�sz�t�s: 1997.10.17

Ha nincs a rajzban egyetlen section sem, akkor az olyan, mintha

#section (=pgefilename)
     ...
     rajz
     ...
#end

volna megadva, azaz automatikusan egy sectionba foglalja az
eh�sz rajzot, a section nev�t a pge fil� nev�b�l k�pezve. 
Igy ugyanabb�l a pge rajzb�l lehet say �s out programot k�sz�teni.

*/

*************************************************************************
function PrgOutQ(file,page0)

local page                          // trimelt, kieg�sz�tett page
local tot_row                       // sorok sz�ma
local tot_col                       // oszlopok sz�ma
local llin                          // kit�lt�tt sorhossz
local ntok:=0                       // v�ltoz�k sz�ma
local line,color                    // karakterek/sz�nek
local ltok                          // token hossz
local isttoken:=""                  // a sor els� v�ltoz�ja
local token:=""                     // aktu�lis v�ltoz�
local lprog:=""                     // programk�d egy sor
local sprog:=""                     // programk�d egy section
local prog:=""                      // programk�d
local defi:=""                      // #define defin�ci�k
local decl:=""                      // v�ltoz� deklar�ci�k
local index:=""                     // token array index
local section:=""                   // section azonos�t�
local r,c
local crlf:=chr(13)+chr(10)
local crlf4:=crlf+space(4)
    
    if( !getFileName(@file,".out") )
        return NIL
    end
    
    page:=trimpage(page0,file)
    tot_row:=len(page)           
    tot_col:=len(page[1])/2      

    for r:=1 to tot_row

        // sz�nk�dok �s karakterek sz�tv�laszt�sa
        color:=array(tot_col)
        for c:=1 to tot_col
            color[c]:=asc(substr(page[r],c+c,1)) // sz�nk�dok t�mbje
        next
        line:=screenchar(page[r]) // sz�nk�dok n�lk�li sor

        if( left(line,1)=="#" )
            if( !empty(section) )
                sprog+=crlf4+"set printer off"
                sprog+=crlf4+"set console on"
                sprog+=crlf4+"return height"
                sprog+=crlf
            end
            prog+=(decl+sprog)

            section:=alltrim(substr(line,2))
            if( section=="end" )
                exit
            end
            decl:=crlf+"static function "+ModuleName(section)+"(pgelist)"
            decl+=crlf+"local height:=0,n"
            sprog:=crlf4+"set console off"
            sprog+=crlf4+"set printer on"
            loop
        end
        
        // sorhossz meghat�roz�s
        for llin:=tot_col to 1 step -1        
            if( color[llin]>=16 .or. !empty(substr(line,llin,1)) )
                exit
            end
        next
       
        lprog:=crlf4+'height++;? ""'
        isttoken:=""
        index:=""
        c:=1
        while( c<=llin )

            // Kiemelt sz�n: v�ltoz�
            while( c<=llin .and. color[c]>=16 )
                token+=substr(line,c,1)
                c++
            end
            
            if( len(token)>0 )
                ntok++
                ltok:=len(token)
                token:=alltrim(token)
                if( empty(isttoken) )
                    isttoken:=token  // a sorban tal�lt els� token
                end

                if( !empty(isttoken) .and. isttoken==upper(isttoken) )
                    index:="[n]"
                else
                    index:=""
                end

                if( left(token,1)=="<" )
                    token:=alltrim(substr(token,2))
                    lprog+="+padr(p_"+token+index+","+str(ltok,3)+")"

                elseif( left(token,1)==">" )
                    token:=alltrim(substr(token,2))
                    lprog+="+padl(p_"+token+index+","+str(ltok,3)+")"

                elseif( left(token,1)=="*" )
                    token:=alltrim(substr(token,2))
                    lprog+="+padc(p_"+token+index+","+str(ltok,3)+")"

                else
                    // default: balra igaz�t�s
                    lprog+="+padr(p_"+token+index+","+str(ltok,3)+")"
                end
               
                defi+=crlf+"#define "+padr("p_"+token,16)+" pgelist["+str(ntok,3)+"]"
                defi+=" //"+str(ltok,3) // kommentk�nt a mez�hossz
                token:=""
            end

            // Nem kiemelt sz�n: sz�vegkonstans
            while( c<=llin .and. color[c]<16 )
                token+=substr(line,c,1)
                c++
            end
            if( len(token)>0 )
                lprog+="+"+'"'+token+'"'
                token:=""
            end
        end

        if( empty(index) )
            sprog+=lprog
        else
            sprog+=crlf4+"for n:=1 to len(p_"+isttoken+")"
            sprog+=space(4)+lprog
            sprog+=crlf4+"next"
        end
    next

    defi+=crlf+crlf+"#define PGELIST       "+str(ntok,3)
    return memowrit(file,defi+crlf+prog+crlf)


*************************************************************************
static function trimpage(page0,outname)

//lev�gja a page v�g�r�l az �res sorokat,
//ha nincs defini�lva #section/#end, akkor beteszi,
//�gy az eredeti k�dgener�l�son nem kell v�ltoztatni.

local page:={},m,n,i
    
    for n:=len(page0) to 1 step -1
        if( page0[n]==emprow() )
            //�res
        else
            exit //n==az utols� nem �res sor
        end
    next
    
    for m:=1 to n
        if( page0[m]==emprow() )
            //�res
        else
            exit //m==az els� nem �res sor
        end
    next

    if( !"#"==left(page0[m],1) )
        aadd(page,makerow("#"+ModuleName(outname)))
    end

    for i:=1 to n              
        aadd(page,page0[i])
    next

    if( !"#"==left(page0[m],1) )
        aadd(page,makerow("#end"))
    end

    return page        


*************************************************************************
static function makerow(str)
local row:="", i
local colorcode:=substr(empchr(),2)

    for i:=1 to len(str)
        row+=substr(str,i,1)+colorcode
    next
    return left(row+emprow(),len(emprow()))


*************************************************************************
