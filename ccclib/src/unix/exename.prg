
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

**************************************************************************
function exename(keepPath) //CA-tools

// determine exe name from argv[0]
// search in the PATH if necessary

local exename:=argv(0)
local path

    if( empty(exename) .or. left(exename,1)=='/' )
        return exename
    end

    if( !'/'$exename )
        if( NIL==(path:=__findinpath(exename)) )
            return exename
        end
        exename:=path+"/"+exename
    end

    if( keepPath==.t. .or. left(exename,1)=='/' )
        return exename
    end
    
    return dirname()+"/"+exename

**************************************************************************
function __findinpath(fname) //nincs NG-ben
local path,home,i 

    if( NIL==(path:=getenv("PATH")) )
        return NIL
    end

    if( NIL==(home:=getenv("HOME")) )
        home:=""
    end

    path:=wordlist(path,":")
    for i:=1 to len(path)
        if( left(path[i],2)=='~/' )
            path[i]:=home+substr(path[i],2)
        end
        if( !path[i]=="" .and. fileisexecutable(path[i]+"/"+fname) )
            return __standardizepathname(path[i])
            //return path[i]
        end
    next
    return NIL

**************************************************************************
