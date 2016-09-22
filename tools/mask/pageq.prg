
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
Alternatív programgenerálás PAGE-hez. Az eredeti PAGE say utasításokkal
fixen pozícionált ábrát készít, ez ? utasításokkal abba a sorba ír, ahol
éppen tart. A legyártott program több függvényt tartalmaz a rajzban
elhelyezett section-oknak megfeleõen. Igy kell elkészíteni a rajzot:

#section1
     ...
     rajzrészlet1
     ...
#section2
     ...
     rajzrészlet2
     ...
#end

Minden függvény argumentuma ugyanaz a pgelist, ami ugyanolyan, mint
a korábbi PAGE-ben. Azok a sorok, ahol a bal oldali elsõ token csupa
nagybetû, ismétlõsorok. Az ilyen sorokhoz tartozó pgelist elemek 
értékéül arrayt kell megadni, és a sor annyiszor fog imétlõdni, amilyen
hosszú a megadott array.


Kiegészítés: 1997.10.17

Ha nincs a rajzban egyetlen section sem, akkor az olyan, mintha

#section (=pgefilename)
     ...
     rajz
     ...
#end

volna megadva, azaz automatikusan egy sectionba foglalja az
ehész rajzot, a section nevét a pge filé nevébõl képezve. 
Igy ugyanabból a pge rajzból lehet say és out programot készíteni.

*/

*************************************************************************
function PrgOutQ(file,page0)

local page                          // trimelt, kiegészített page
local tot_row                       // sorok száma
local tot_col                       // oszlopok száma
local llin                          // kitöltött sorhossz
local ntok:=0                       // változók száma
local line,color                    // karakterek/színek
local ltok                          // token hossz
local isttoken:=""                  // a sor elsõ változója
local token:=""                     // aktuális változó
local lprog:=""                     // programkód egy sor
local sprog:=""                     // programkód egy section
local prog:=""                      // programkód
local defi:=""                      // #define definíciók
local decl:=""                      // változó deklarációk
local index:=""                     // token array index
local section:=""                   // section azonosító
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

        // színkódok és karakterek szétválasztása
        color:=array(tot_col)
        for c:=1 to tot_col
            color[c]:=asc(substr(page[r],c+c,1)) // színkódok tömbje
        next
        line:=screenchar(page[r]) // színkódok nélküli sor

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
        
        // sorhossz meghatározás
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

            // Kiemelt szín: változó
            while( c<=llin .and. color[c]>=16 )
                token+=substr(line,c,1)
                c++
            end
            
            if( len(token)>0 )
                ntok++
                ltok:=len(token)
                token:=alltrim(token)
                if( empty(isttoken) )
                    isttoken:=token  // a sorban talált elsõ token
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
                    // default: balra igazítás
                    lprog+="+padr(p_"+token+index+","+str(ltok,3)+")"
                end
               
                defi+=crlf+"#define "+padr("p_"+token,16)+" pgelist["+str(ntok,3)+"]"
                defi+=" //"+str(ltok,3) // kommentként a mezõhossz
                token:=""
            end

            // Nem kiemelt szín: szövegkonstans
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

//levágja a page végérõl az üres sorokat,
//ha nincs definiálva #section/#end, akkor beteszi,
//így az eredeti kódgeneráláson nem kell változtatni.

local page:={},m,n,i
    
    for n:=len(page0) to 1 step -1
        if( page0[n]==emprow() )
            //üres
        else
            exit //n==az utolsó nem üres sor
        end
    next
    
    for m:=1 to n
        if( page0[m]==emprow() )
            //üres
        else
            exit //m==az elsõ nem üres sor
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
