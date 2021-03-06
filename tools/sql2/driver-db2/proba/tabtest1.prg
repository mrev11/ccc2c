
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

function main()
local con
local tab
local seq
local n,row,err

    set date format 'yyyy-mm-dd'

    con:=sql2.db2.sqlconnectionNew("@sample")
    con:list
    ? con:version


    tab:=proba.tableEntityNew(con)
    //tab:list
    
    begin
        tab:drop
    recover err <sqlerror>
        ? err:description
    end
    tab:create
    
    seq:=con:sqlsequenceNew("konto.seqproba")
    seq:start:=1001
    begin 
        seq:drop
    recover err <sqlerror>
        ? err:description
    end
    seq:create

    
    for n:=1 to 100
    
        row:=tab:instance
        row:szamlaszam  :=n::str::alltrim::padl(18,"0")+"abcdef"
        row:devnem      :="HUF"
        /*
        */        

        row:nev         := (asc('a')+n%26)::chr::replicate( 20 )
        row:egyenleg    :=n+n/10
        row:sorszam     :=seq:nextval
        row:tulmenflag  :=n%3==0
        row:konyvkelt   :=date()+n
        row:megjegyzes  :="XXXXXXX"+str(n)+replicate("x",10)+replicate("y",10)+replicate("z",10)
        row:insert
        
        if( n%10==0  )
            con:sqlcommit
            //row:insert
        end
        
    next
    
    con:sqlcommit
    ?