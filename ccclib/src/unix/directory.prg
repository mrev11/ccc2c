
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

#include "fileconv.ch"
#include "stat.ch"

***************************************************************************
function directory(mask,type) //Clipper

// Inkompatibilit�sok:
//
// dosconv=on eset�n csak a convertfspec2nativeformat(fname)==fname 
// felt�telnek megfelel� fil�ket adja.
//
// UNIX-on a 'filename' �s 'filename.' nevek (a Windowst�l elt�r�en)
// k�l�nb�z�nek sz�m�tanak.
// 
// A fil� attrib�tumban 'L' jel�li a szimbolikus linkeket. 
// Windowson nincsenek szimbolikus linkek.
//
// V�logatni a 'D' �s 'L' attrib�tumok szerint lehet. 
// A default v�laszt�s: directoryk nem, minden fil� (linkek is) igen.
//
// A kapcsol�k szintaktik�ja: X, vagy +X bekapcsol, -X kikapcsol.
// Ezek szerint a symlinkek a -L kapcsol�val tilthat�k le.

local dlist:=array(32),dlist_size:=0
local fname_upper:=numand(get_dosconv(),DOSCONV_FNAME_UPPER)!=0
local fspec_asterix:=numand(get_dosconv(),DOSCONV_FSPEC_ASTERIX)!=0
local dirspec,fmask,fname,dfname,ftype,st,lsm,dati,i
local adddir:=.f.,isdir
local addlnk:=.t.,islnk

static mutex:=thread_mutex_init()
 
    if( mask==NIL )
        mask:="*"
    elseif( mask=="" )
        mask:="*"
    end

    mask:=convertfspec2nativeformat(mask)

    if( 0==(i:=rat('/',mask)) )
        dirspec:="."
        fmask:=mask
    elseif( i==1 )
        dirspec:="/"
        fmask:=substr(mask,2)
    else
        dirspec:=substr(mask,1,i-1)
        fmask:=substr(mask,i+1)
    end

    if( fspec_asterix .and. fmask=="*.*" )
        fmask:="*"
    end
    
    if( type!=NIL )
        adddir:= !"-D"$upper(type) .and. "D"$upper(type)
        addlnk:= !"-L"$upper(type)
    end
 
    thread_mutex_lock(mutex)
 
    if( 0==__opendir(dirspec) )

        while( NIL!=(fname:=__readdir()) )

            if( fname==convertfspec2nativeformat(fname) .and. like(fmask,fname) )
            
                dfname:=dirspec+"/"+fname
                st:=stat(dfname)
                lsm:=lstat_st_mode(dfname)

                if( NIL==st .or. NIL==lsm )
                    //nem stat-olhat�, kihagyni
                
                elseif( (isdir:=s_isdir(st[STAT_MODE])) .and. !adddir )
                    //directory, nem k�rik, kihagyni
                     
                elseif( (islnk:=s_islnk(lsm)) .and. !addlnk )
                    //symlink, nem k�rik, kihagyni
                    
                else //bevessz�k

                    dati:=ostime2dati(st[STAT_MTIME])
 
                    ftype:=""
                    if( isdir ) 
                        ftype+="D"
                    end
                    if( islnk )
                        ftype+="L" 
                    end
                    
                    if( dlist_size>=len(dlist) )
                        asize(dlist,dlist_size+32)
                    end

                    dlist[++dlist_size]:={;
                        if(fname_upper,upper(fname),fname),;
                        st[STAT_SIZE],; //fsize
                        dati[1],; //fdate,;
                        dati[2],; //ftime,;
                        ftype }
                end
            end
        end
    end
    __closedir()
    thread_mutex_unlock(mutex)

    return asize(dlist,dlist_size)

***************************************************************************
