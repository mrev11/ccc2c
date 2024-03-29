
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

//ez nézi, hogy a hibaágakban szivárog-e a memória

function main(arg:="0")
local p,dom,e,n:=0

    thread_create({||dogc()})

    while( inkey()==0 )
    
        begin
            if( ++n%1000==0  )
                ?? "."
            end
            p:=xmlparser2New()
            p:file:="x-hibaNN.xml"::strtran("NN",arg)
            p:info:buildflag:=.f.
            //p:debug:=.t.
            dom:=p:parse 

        recover e <apperror>
            if( n%1000==0  )
                ? e:description
            end
        end
    end
    ?

****************************************************************************
function dogc()
    ? thread_self()
    while(.t.)
        sleep(100)
        gc()
    end

****************************************************************************
