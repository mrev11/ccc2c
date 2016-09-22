
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

//truename for DOS/NT
//
//Vermes, 1997.07.20, 2001.02.24
// 
//olyan truename, ami legalább a . és .. szimbólumokat feloldja,
//a hálózati drive-ok nevét sajnos nem tudom elõszedni;
//az algoritmus lényege az, hogy a megadott helyre navigálunk,
//és a curdir() függvénnyel lekérdezzük a hely tényleges nevét;
//nem teljesen kompatibilis a Clipperrel, mert csak létezõ 
//objektumok nevét tudja megadni;
 

//truename(".")                    d:\ccc\clp2cpp\teszt                 ok
//truename("..")                   d:\ccc\clp2cpp                       ok
//truename("..\..")                d:\ccc                               ok
//truename("")                     d:\ccc\clp2cpp\teszt                 ok
//truename("c:")                   c:\clipper5\include                  ok
//truename("c:std.ch")             c:\clipper5\include\std.ch           ok
//truename("c:config.sys")         (nem létezik, eltér a clippertõl!)   ?
 
#include "directry.ch"

****************************************************************************
function truename(direntry)

local cur_disk:=diskname()
local cur_dir:=dirname()
local trg_disk, trg_dir
local colon, fname, foffs
local name

    name:=alltrim(direntry)

    if( empty(name) )
        name:="."
    else
        name:=convertfspec2nativeformat(name)
    end
    
    if( file(name) ) //directory vagy filé?
        foffs:=max(rat(dirsep(),name),rat(":",name))
        fname:=substr(name,foffs+1)
        name:=left(name,foffs)
    end

    colon:=at(":",name)

    if( colon>0 )
        trg_disk:=left(name,colon-1)
        trg_dir:=substr(name,colon+1)
        if( !diskchange(trg_disk) )
            return "" //nem létezik a drive
        end
    else
        trg_disk:=cur_disk
        trg_dir:=name
    end

    if( !empty(trg_dir) )
        if( 0!=dirchange(trg_dir) )
            diskchange(cur_disk)
            dirchange(cur_dir)
            return "" //nem létezik a directory
        end
    end

    name:=trg_disk+":"+dirname()

    if( fname!=NIL )
        if( !empty(curdir()) )
            name+=dirsep()
        end
        name+=fname
    end
    
    diskchange(cur_disk)
    dirchange(cur_dir)

    return name

****************************************************************************

 