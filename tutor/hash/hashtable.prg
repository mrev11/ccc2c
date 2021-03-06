
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

#define  HASHTAB_INITSIZE        256
#define  HASHTAB_INCREMENT(x)    len(x)*2
#define  HASHTAB_MAXFILL(x)      len(x)*0.66

namespace tutor

****************************************************************************
class hashtable(object)
    method initialize
    attrib itemcount
    attrib hasharray
    method add
    method get

****************************************************************************
function hashtable.initialize(this,size) 
    this:(object)initialize
    this:itemcount:=0
    this:hasharray:=array(if(size==NIL,HASHTAB_INITSIZE,size))
    return this

****************************************************************************
static function hashtable.add(this,item)
local x:=hash_index(this:hasharray,item[1])
    if( this:hasharray[x]==NIL )
        if( ++this:itemcount>HASHTAB_MAXFILL(this:hasharray) )
            this:hasharray:=hash_rebuild(this:hasharray,HASHTAB_INCREMENT(this:hasharray))
            x:=hash_index(this:hasharray,item[1])
        end
    end
    this:hasharray[x]:=item
    return item

****************************************************************************
static function hashtable.get(this,key)
local x:=hash_index(this:hasharray,key)
    return this:hasharray[x]


****************************************************************************
//hash algoritmus
****************************************************************************
static function hash_rebuild(hash,len)
local hash1:=array(len),n,x
    for n:=1 to len(hash)
        if( hash[n]!=NIL )
            x:=hash_index(hash1,hash[n][1])
            hash1[x]:=hash[n]
        end
    next
    return hash1

// A hash t�bla egy array: {item1,item2,...},
// ahol item==NIL, vagy item=={key,...} alak�.

****************************************************************************
static function hash_index(hash,key)

local hlen:=len(hash)
local hcode:=hashcode(key)
local hidx:=hcode%hlen

    while( .t. )
        if( NIL==hash[1+hidx] )
            return 1+hidx
        elseif( key==hash[1+hidx][1] )
            return 1+hidx
        elseif( ++hidx>=hlen )
            hidx:=0
        end
    end
    return NIL


// Keres�s a hash t�bl�ban:
//    
// A ciklus v�get �r, ui. a t�bla hosszabb, 
// mint ah�ny nem NIL elem van benne.    
//
// visszat�r�s: hashidx
//
// Ha hash[hasidx]==NIL, akkor a keresett elem nincs a t�bl�ban,
//                       �s �ppen a hashidx helyre kell/lehet betenni.
//
// Ha hash[hasidx]!=NIL, akkor az a keresett elem.

****************************************************************************
