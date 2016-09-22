
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

***************************************************************************
function expand(string,nc,c) //CA-tools

//  ? "'"+EXPAND("123456")          +"'"   // '1 2 3 4 5 6'
//  ? "'"+EXPAND("123456",2)        +"'"   // '1  2  3  4  5  6'
//  ? "'"+EXPAND("123456",".")      +"'"   // '1.2.3.4.5.6'
//  ? "'"+EXPAND("123456",2,".")    +"'"   // '1..2..3..4..5..6'
//  ? "'"+EXPAND("123456",,65)      +"'"   // '1A2A3A4A5A6'
//
//  plusz néhány perverz eset:
//
//  ? "'"+EXPAND("123456","BB")     +"'"   // '1B2B3B4B5B6'
//  ? "'"+EXPAND("123456",2,"!!")   +"'"   // '1!!2!!3!!4!!5!!6'
//  ? "'"+EXPAND("123456",,"!!")    +"'"   // '1!2!3!4!5!6'
//  ? "'"+EXPAND("123456",{},{})    +"'"   // '1 2 3 4 5 6'
//  ? "'"+EXPAND("123456","A","B")  +"'"   // '1B2B3B4B5B6'
//  ? "'"+EXPAND("123456",0,".")    +"'"   // '1.2.3.4.5.6'
//
//  ezek mind ellenõrzötten kompatibilisek,
//  inkompatibilis az nc<0 eset, erre a DOS ""-t ad,
//  aminek semmi értelme
 
local s:="",i

    if( len(string)<2 )

        s:=string

    else

        if( valtype(c)=="C" )
            c:=left(c,1)
        elseif( valtype(c)=="N" )
            c:=chr(c)
        elseif( valtype(nc)=="C" )
            c:=left(nc,1)
        end
        

        if( valtype(nc)!="N" .or. nc<1 )
            nc:=1
        end 
        if( valtype(c)!="C" )
            c:=space(1)
        end
        

        c:=replicate(c,nc)
          
        s:=left(string,1)
        
        for i:=2 to len(string)
            s+=c+substr(string,i,1)
        next
    end

    return s


***************************************************************************
function charspread(string,length,c)  //CA-tools 

local s:=string
local ls:=len(string)  
local ins:={}, i, p:=.f., li, lc, m

    if( valtype(c)=="C" )
        c:=left(c,1)
    elseif( valtype(c)=="N" )
        c:=chr(c)        
    else
        c:=" "
    end  
    
    for i:=1 to ls
        if( substr(string,i,1)==c )
            if( !p )
                aadd(ins,i)
                p:=.t.
            end
        else
            p:=.f.
        end
    next
    
    if( length>ls .and. !empty(ins) )
    
        li:=len(ins)
        lc:=int((length-ls)/li)
        m:=length-ls-li*lc
        
        for i:=li to 1 step -1
            s:=stuff(s,ins[i],0,replicate(c,lc+if(i>m,0,1)))
        next
    end
    
    return s

***************************************************************************

    