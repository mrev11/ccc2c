
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

#command ?  [ <list,...> ]      => outerr( <list>, chr(10))
#command ?? [ <list,...> ]      => outerr( <list> )


#include "directry.ch"

static delimeter:=replicate(a"zxcvbnm",10)


****************************************************************************************
function main(*)

local autocache
local exenam,exe,md5
local rsplink
local nammd5
local nampid
local nampidrsp
local nampidexe
local nampidobj
local n

    set date format "yyyy-mm-dd"

    autocache:=getenv("CCC_AUTOCACHE")
    if( empty(autocache) )
        ? "CCC_AUTOCACHE variable not set"
        quit
    end
    
    if( !direxist(autocache) )
        dirdirmake(autocache)
    end
    if( !direxist(autocache) )
        ? "cannot create autocache directory", autocache
        quit
    end
    
    exenam:=findexe()
    exe:=memoread(exenam,.t.) //beolvassa magat
    md5:=exe::crypto_md5::crypto_bin2hex::bin2str
    exe::=splitx(delimeter) //mint split, de tobbkarakteres delimetert is kezel
    
    if( len(exe)<3 )
        ? exenam,"not an autolink executable"
        quit
    end
    
    nammd5:=autocache+dirsep()+fname(exenam)+"-"+md5+".exe"
    nampid:=autocache+dirsep()+fname(exenam)+"-"+getpid()::str::alltrim
    nampidexe:=nampid+".exe"
    nampidrsp:=nampid+"-rsp"
    
    exe[1]:=NIL //autolink.exe ez fut

    rsplink:=exe[2]

    if( !file(nammd5) .or. need_relink(nammd5,rsplink) )
        ? "relink", exenam

        rsplink::=strtran(a"EXECUTABLE",nampidexe::str2bin)   
        rsplink::=strtran(a"OBJECT",nampid::str2bin+a"-obj")
        rsplink::=strtran(a"\",a"/") //mindig '/' kell!
        memowrit(nampidrsp,rsplink)
        
        for n:=3 to len(exe)
            nampidobj:=nampid+"-obj-"+(n-2)::str::alltrim
            memowrit(nampidobj,exe[n])
        next
    
        run("c++ @"+nampidrsp)


        ferase(nammd5) //Windowson maskepp nem megy az atnevezes
        frename(nampidexe,nammd5)

        #ifdef WINDOWS
            run("del /q "+nampid+"*.*")
        #else
            run("rm -f "+nampid+"*")
        #endif
    end
    
    exec(nammd5,*)

    //ide csak hiba eseten jon
    ? "cannot link or exec ", exenam
    quit


****************************************************************************************
function findexe() //megkeresi magat a path-ban

local exe:=exename()
local path,n

#ifdef WINDOWS
    //windowson ez egyszeru
    return exe
#endif

    if( exe[1]==dirsep() )
        return exe

    elseif( exe[1]=="." )
        exe:=dirname()+dirsep()+exe
        return exe
    
    else
        path:=getenv("PATH")::split(pathsep())
        for n:=1 to len(path)
            if( empty(path[n]) )
                loop
            end
            if( path[n][1]=='"' )
                path[n]:=path[n][2..len(path[n])-1]
            end
            if( path[n]::right(1)!=dirsep() )
                path[n]+=dirsep()
            end
            if( file(path[n]+exe) )
                //es vegrehajthato?
                //megvan
                exe:=path[n]+exe
                if( exe[1]=="." )
                    exe:=dirname()+dirsep()+exe
                end
                return exe
            end
        next

        ? exe, "not found" 
        quit
    end


****************************************************************************************
function need_relink(nammd5,rsplink)
local exetime:=ftime(nammd5)
local libtime
local n,line
local canrelink:=.t.
local needrelink:=.f.

    rsplink::=strtran(x"0d",x"")
    rsplink::=split(x"0a")
    
    for n:=1 to len(rsplink)
        //megkeresi az elso OBJECT sort
        line:=rsplink[n]
        if( at(a"OBJECT",line)==1 )
            //elso OBJECT
            exit
        end
    next    

    for n:=n to len(rsplink)
        //megkeresi az elso nem OBJECT sort
        line:=rsplink[n]
        if( at(a"OBJECT",line)!=1 )
            //elso nem OBJECT
            exit
        end
    next    

    for n:=n to len(rsplink)
        // -W jelzi az elso nem konyvtar sort
        line:=rsplink[n]
        if( at(a"-W",line)==1 )
            exit
        end

        //external lib specification
        
        libtime:=ftime(line)
        //? libtime, exetime, if(libtime!=NIL .and. libtime>exetime, "*"," "),line
        
        if( libtime==NIL )
            canrelink:=.f.
            ? "cannot relink:", line

        elseif( libtime>exetime ) 
            needrelink:=.t.
            ? "need relink:", line
        end
    next    

    return canrelink .and. needrelink


****************************************************************************************
function ftime(fspec)
local d:=directory(fspec)
    if( !empty(d) )
        return d[1][F_DATE]::dtos+d[1][F_TIME]
    end
    return NIL //ha nincs meg a file


****************************************************************************************
        