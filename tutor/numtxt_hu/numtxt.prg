
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

#ifdef DEBUG_NUMTXT

function main(arg)
    ? numtxt(val(arg))
    return NIL

#endif    
    

***************************************************************************
function numtxt(arg)  //sz�mb�l stringet

static egyes  :={"egy","kett�","h�rom","n�gy","�t","hat","h�t","nyolc","kilenc"}
static tizes0 :={"t�z","h�sz"}
static tizes  :={"tizen","huszon","harminc","negyven","�tven","hatvan","hetven","nyolcvan","kilencven"}
static szazas :={"sz�z","k�tsz�z","h�romsz�z","n�gysz�z","�tsz�z","hatsz�z","h�tsz�z","nyolcsz�z","kilencsz�z"}
static helyert:={"","ezer","milli�","milli�rd","billi�"}

local ntxt:=alltrim(transform(arg,"@R 999,999,999,999,999"))
local narr:=wordlist(ntxt)
local n,lnarr:=len(narr)
local e,t,s,x

    ntxt:=""

    for n:=1 to lnarr 
    
        x:=padl(narr[n],3)
        s:=substr(x,1,1)
        t:=substr(x,2,1)
        e:=substr(x,3,1)
        
        x:=""
        
        x+=if(s$" 0","",szazas[val(s)] )
        x+=if(t$" 0","",if(e$" 0".and.t$"12",tizes0[val(t)],tizes[val(t)]))
        x+=if(e$" 0","",egyes[val(e)] )
        
        if( !empty(x) )
            ntxt+=x+helyert[lnarr-n+1]+" "
        end
    next

    //kiv�telek kezel�se    
    
    if( empty(ntxt) )
        ntxt:="nulla"
    elseif( arg<=2000 )
        ntxt:=strtran(ntxt,"egyezer ","ezer")
    end

    return ntxt


***************************************************************************









    