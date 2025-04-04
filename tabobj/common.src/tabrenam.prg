
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

//TARTALOM  : tabla alkaterszeinek mentese, atnevezese
//STATUS    : egyelore kozos, ifdef, SQL-ben eltero lesz
//
//function tabRename(table,name)   adatfile, index, memo atnevezese
//function tabBackup(table)        adatfile, memo atmasolasa backup.tmp-be
//function tabDelTable(table)      adatfile, index,memo torlese
//function tabDelIndex(table)      index(ek) torlese

#include "tabobj.ch"

#define BACKUPDIR "backup.tmp"  //nem lehet a vegen dirsep!


****************************************************************************
function tabRename(table,name)

local result:=.t.
local fname1,fname2
    
    fname1:=tabPathName(table)
    fname2:=tabPath(table)+name+tabDataExt(table)
    result:=result.and._rename(fname1,fname2)

    return result


****************************************************************************
function tabBackup(table)

local result:=.t.
local path:=tabPath(table)
local name:=tabFile(table)
local fname1,fname2

    dirmake(path+BACKUPDIR)
    
    fname1:=tabPathName(table)
    fname2:=path+BACKUPDIR+dirsep()+name+tabDataExt(table)
    result:=result.and._rename(fname1,fname2)
    
    return result
    

****************************************************************************
function tabDelTable(table)
local result:=.t.
    ferase(tabPathName(table))
    if( file(tabPathName(table)) )
        result:=.f.
    end
    return result


****************************************************************************
function tabDelIndex(table)
local result:=.t.
    return result

    
****************************************************************************
static function _rename(f1,f2)

local result:=.t.

    ferase(f2)

    if( file(f2) )
        result:=.f. //a korabbi peldany nem torolheto
    
    elseif( file(f1) )

        //csak akkor kell mukodnie,
        //ha letezik az atnevezendo file
        
        frename(f1,f2)

        if( !file(f2) )
            result:=.f. //nem vitte at az uj nevbe/helyre
        end
    end
    
    return result

****************************************************************************
