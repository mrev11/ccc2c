
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

#include "spawn.ch"

// V�grehajt egy 
//
//  cmd arg1 @arg2 arg3 ... 
//
// alak� parancsot. Ha egy param�ter els� karaktere @, 
// akkor az egy response fil�t jel�l, aminek tartalm�t szavakra 
// v�gva beilleszti a t�bbi param�ter k�z�. A MinGW eszk�z�kh�z 
// kell, amik nem  tudj�k parametereiket scriptb�l felszedni, 
// r�ad�sul a Windows parancssor hossza korl�tozott.

******************************************************************************
function main()

local cmd:={},n:=0,arg,i

    // Rugalmasabb, de ez sem tud hossz� parancsokat kezelni.
    //
    // Batch fil�knek �tadott param�terek �sszhossza 4K lehet.
    // A 4K-n�l hosszabb batch parancsok �gy sz�llnak el:
    //  The following character string is too long: ...
    //
    // Ha exe programot ind�tunk spawn-nal, akkor a param�terek 
    // �sszhossza kb. 32K lehet. CCC programok eset�ben az �tvehet�
    // param�terek sz�m�t korl�tozza a CCC stack m�rete (2048 db).

    while( !empty(arg:=argv(++n)) )

        if( left(arg,1)=="@" )  
            arg:=memoread(substr(arg,2))
            arg:=strtran(arg,chr(13),"")
            arg:=strtran(arg,chr(10)," ")
            arg:=wordlist(arg," ")
            for i:=1 to len(arg)
                if( !empty(arg[i]) )
                    aadd(cmd,arg[i])
                end
            next
        else
            aadd(cmd,arg)
        end
    end
    errorlevel(spawn(SPAWN_WAIT+SPAWN_PATH,cmd))
    return NIL


******************************************************************************
#ifdef REGEBBI_VALTOZAT

//Kor�bban a parancsot egy stringben raktuk �ssze,
//a Windows parancssor hossza azonban korl�tozott.
 
function main()
local cmd:="",n:=0,arg

    while( !empty(arg:=argv(++n)) )

        if( left(arg,1)=="@" )  
            arg:=memoread(substr(arg,2))
            arg:=strtran(arg,chr(13),"")
            arg:=strtran(arg,chr(10)," ")
        end
        cmd+=" "+arg
    end
    errorlevel( run(cmd) )
    return NIL

#endif


******************************************************************************
 
 