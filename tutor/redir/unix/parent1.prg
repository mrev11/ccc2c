
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

local p1:=pipe()
local r1:=p1[1],w1:=p1[2]
local p2:=pipe()
local r2:=p2[1],w2:=p2[2]

local redir:=" <&"+alltrim(str(r1))+" >&"+alltrim(str(w2)) 
local nowait:=" &"

local torun:="child.exe"
 
local childpid
local d, n
local c:=space(1)
    
    set dosconv off
    
    if( (childpid:=fork())==0 )
        //child
        fclose( w1 )
        fclose( r2 )
        run( torun+redir+nowait ) 
        quit
    end

    //parent

    waitpid(childpid,,0) //0 hang, 1 nohang
    
    //megv�rtuk a fork-kal ind�tott process kil�p�s�t
    //ezzel szemben m�g fut a val�di child: child.exe 
 
    fclose( r1 )
    fclose( w2 )
    
    d:=directory("*","H")
    
    for n:=1 to len(d)
        fwrite( w1, d[n][1]+endofline() )
    next

    fclose( w1 )
    
    while( 0<fread(r2,@c,1) )
        ?? upper(c)
    end
    
    //child.exe kil�p�s�t az jelzi, hogy lez�r�dik r2,
    //amibe child.exe az stdout-j�t �rja

    
    return NIL
