
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

************************************************************************
function wordlist(txt:="",sep:=",")
local wlist:={}, n:=1, i

    while( 0<(i:=at(sep,txt,n)) )
        aadd(wlist,txt[n..i-1])
        n:=i+1
    end

    //ha van maradék, azt még hozzáadjuk
    //a "" (üres) stringet nem adjuk hozzá

    if( len(txt)>=n )
        aadd(wlist,txt[n..])
    end
    return wlist


************************************************************************
#ifdef NOTDEFINED //régi változat

function wordlist(txt,sep)

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

#endif
************************************************************************
