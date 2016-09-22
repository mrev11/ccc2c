
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

*****************************************************************************
function like(minta,str) //CA-tools (Csisz�r Levente)

local i,j,w

    for i:=1 to len(str)

        if( substr(minta,i,1)=='?' )
            //mehet
 
        elseif( substr(minta,i,1)=='*' )

            w:=substr(minta,i+1)

            if( len(w)==0 )
                return .t.
            end

            for j:=i to len(str)
                if( like(w,substr(str,j)) )
                    return .t.
                end
            end
            return .f.

        elseif( substr(minta,i,1)==substr(str,i,1) )
            //mehet

        else
            return .f.
        end
    end 

    if( len(str)>len(minta) )
        return .f.
    elseif( len(str)==len(minta) )
        return .t.
    end

    //a minta v�g�n m�g van illeszteni val� 
    //akkor illeszkedik, ha ez csupa csillag

    for i:=len(str)+1 to len(minta)
        if( !substr(minta,i,1)=='*' )
            return .f.
        end
    end 

    return .t.

*****************************************************************************

 