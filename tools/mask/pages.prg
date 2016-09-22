
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
function PrgOutS(file,page)

local tot_row:=len(page)            // sorok száma
local tot_col:=len(page[1])/2       // oszlopok száma
local r,c,c1,line,color
local ltok,ntok:=0
local token:=""
local prog:=""
local defi:=""
local decl:=""
local crlf:=chr(13)+chr(10)
#define POS(x,y)  "   @"+str(x,3)+","+str(y,3)

    if( !getFileName(@file,".say") )
        return NIL
    end     

    decl+=crlf+"static function "+ModuleName(file)+"(pgelist)"
    prog+=crlf+"   set device to print"

    for r:=1 to tot_row
        color:=array(tot_col)
        for c:=1 to tot_col
            color[c]:=asc(substr(page[r],c+c,1)) // színkódok tömbje
        next
        line:=screenchar(page[r]) // színkódok nélküli sor
        
        c:=1
        while( c<=tot_col )

            c1:=c // Kiemelt szín: változó
            while( c<=tot_col .and. color[c]>=16 )
                token+=substr(line,c,1)
                c++
            end
            if( !empty(token) )
                ntok++
                ltok:=len(token)
                token:=alltrim(token)
                if( left(token,1)=="<" )
                    token:=alltrim(substr(token,2))
                    prog+=crlf+POS(r,c1)+" say padr(p_"+token+","+str(ltok,3)+")"
                elseif( left(token,1)==">" )
                    token:=alltrim(substr(token,2))
                    prog+=crlf+POS(r,c1)+" say padl(p_"+token+","+str(ltok,3)+")"
                elseif( left(token,1)=="*" )
                    token:=alltrim(substr(token,2))
                    prog+=crlf+POS(r,c1)+" say padc(p_"+token+","+str(ltok,3)+")"
                else
                    //prog+=crlf+POS(r,c1)+" say p_"+token
                    //új default: balra igazítás
                    prog+=crlf+POS(r,c1)+" say padr(p_"+token+","+str(ltok,3)+")"
                end
               
                defi+=crlf+"#define "+padr("p_"+token,16)+" pgelist["+str(ntok,3)+"]"
                defi+=" //"+str(ltok,2) // kommentként a mezõhossz
                token:=""
            end

            c1:=c // Nem kiemelt szín: szövegkonstans
            while( c<=tot_col .and. color[c]<16 .and. !empty(substr(line,c,1) )  )
                token+=substr(line,c,1)
                c++
            end
            if( !empty(token) )
                prog+=crlf+POS(r,c1)+" say "+'"'+token+'"'
                token:=""
            end

            c1:=c // Üres rész: átugorja
            while( c<=tot_col .and. color[c]<16 .and. empty(substr(line,c,1)) )
                c++            
            end

        end
    next

    defi+=crlf+crlf+"#define PGELIST       "+str(ntok,3)
    prog+=crlf+"   eject"
    prog+=crlf+"   set device to screen"
    prog+=crlf+"   return NIL"

    return( memowrit( file, defi+crlf+decl+crlf+prog+crlf ))
