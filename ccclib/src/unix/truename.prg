
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
function truename(pathName,noTrim) //CA-tools

// Standardizálja a pathName-et, majd az elején a leghosszabb
// direktorira mutató path-t helyettesíti azzal, amit erre 
// a direktorira a curdir ad.

local wPath,existPLen,origCurDir,restPath

    pathName:=__standardizePathName(pathName,noTrim)
    wPath:=pathName

    existPLen:=len(wPath)
    while( !wPath=="" .and. !direxist(wPath) )
        if( 0==(existPLen:=rat('/',wPath)) )
            wPath:=""
        else
            wPath:=substr(wPath,1,existPLen-1)
        end
    end

    origCurDir:=dirname()

    if( wPath=="" .or. wPath==origCurDir )
        return pathName
    end

    if( 0==dirchange(wPath) )
        wPath:=dirname()
        if( ""==(restPath:=substr(pathName,existPLen+1)) )
            pathName:=wPath
        else
            pathName:=wPath+"/"+restPath
        end
    end

    dirchange(origCurDir)
    return pathName


***************************************************************************
function __standardizePathName(pathName,noTrim)

//  Standardizálja a pathName-et. A lépések:
//
//  - Levágja az elejérõl és a végérõl a space-ket.
//    Ha a noTrim igaz, akkor nem vágja le.
//  - Ha a pathName üres, akkor helyettesíti a '.'-al.
//  - Átkonvertálja a convertfspec2nativeformat()-al.
//  - Abszolút névvé alakítja.
//  - Kiirtja belõle a '//'-ket, a '/./'-eket és a '/../' -eket, és a
//    végérõl a '/.' -okat és '/..' -kat.


local t:={}
local i, pathList

    if( noTrim==.t. )
        pathName:=alltrim(pathName)
    end

    if( pathName==NIL .or. pathName=="" )
        pathName:="."
    end

    pathName:=convertfspec2nativeformat(pathName)

    if( !left(pathName,1)=="/" )
        pathName:=dirname()+"/"+pathName
    end

    pathName:=substr(pathName,2)

    t:=wordlist(pathName,"/")

    pathList:={}
    for i:=1 to len(t)
        if( t[i]=="." .or. t[i]=="" )
            // Semmit sem kell csinálni.
        elseif( t[i]==".." )
            if( len(pathList)>=1 )
                asize(pathList,len(pathList)-1)
            end
        else
            aadd(pathList,t[i])
        end
    next

    pathName:=""
    aeval(pathList,{|x| pathName+="/"+x})
    if( empty(pathName) )
        pathName:="/"
    end

    return pathName


***************************************************************************

