
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

//TARTALOM  : a t�blaobjektum szemafor lockja
//STATUS    : k�z�s

//function tabSLock(table,usrblk)    //lock
//function tabSUnlock(table)         //unlock

//ezt ki lehet eg�sz�teni a dummy fil�ken alkalmazott
//lockokkal �gy, hogy helyettes�tse a nat�v rekordlockokat,
//ilyen lesz a lock rendszer az sql-es motorokban,
//�s esetleg az �sszes t�bbiben is (az egys�gess�g kedv��rt)


******************************************************************************
#include "fileio.ch"
#include "tabobj.ch"

#define SEMDIR     "semaphor.tmp"

//1998.11.18
//Kor�bban a sema_open �s sema_close utility f�ggv�nyeket
//haszn�ltuk a table szemaforoz�s�hoz, a szemafor directoryt
//azonban jobb mindenhol k�l�n l�trehozni, ez�rt itt saj�t
//static f�ggv�nyeket haszn�lok, m�g az eredeti f�ggv�nyek
//meg vannak tartva �ltal�nos c�lra. A szemafor fil� nev�t
//nem tabAlias()-b�l, hanem tabFile()-b�l kell k�pezni.


******************************************************************************
function tabSLock(table,usrblk)

local n:=0, cnt, hnd

    while( .t. )

        if( table[TAB_SLOCKCNT]>0 )
            cnt:=++table[TAB_SLOCKCNT]
            exit

        elseif( 0<=(hnd:=_s_open(table)) )
            table[TAB_SLOCKHND]:=hnd
            table[TAB_SLOCKCNT]:=cnt:=1
            exit

        else
            table[TAB_SLOCKHND]:=-1
            table[TAB_SLOCKCNT]:=cnt:=0
            sleep(100) 
            
            if( ++n>50 ) //5 sec alatt 50-szer

                taberrOperation("tabSLock")
                taberrDescription("Szemaforlock sikertelen")
                taberrUserblock(usrblk,"PUK")

                if( valtype(usrblk)=="B" )
                    return tabError(table) 
                else
                    tabError(table)  
                end
            end
        end
    end
    
    return cnt


******************************************************************************
function tabSUnlock(table)
local cnt
    cnt:=--table[TAB_SLOCKCNT]
    if( cnt<=0 )
        _s_close(table[TAB_SLOCKHND])
        table[TAB_SLOCKHND]:=-1
        table[TAB_SLOCKCNT]:=cnt:=0
    end
    return cnt



****************************************************************************
static function _s_open(table,mode)

local p:=tabPath(table)
local f:=tabFile(table)
local sdir:=p+SEMDIR
local sfil:=sdir+dirsep()+f

    if( !file(lower(sfil)) )

        dirmake(lower(sdir))
        
        //itt szerencs�re el�g a dirmake(),
        //mert tabCreate nem hozza l�tre automatikusan
        //a tabPath-ban megadott alk�nyvt�rat, �s ez�rt
        //legfeljebb egy k�nyvt�rral kell lejjebb menni,
        //dirdirmake() a klibrary-ban volna
        
        //ellen�rizni kell, hogy a directory val�ban l�trej�tt-e, 
        //ha a kre�l�s sikertelen, akkor az val�sz�n�leg
        //a tabPath() alk�nyvt�r hi�ny�t jelenti, ekkor
        //nem "Szemfor lock sikertelen"-t kell jelenteni,
        //hanem norm�l runtime errort gener�lni
        
        if( empty(directory(lower(sdir),"HD")) )
            taberrOperation("tabSlock")
            taberrDescription("Szemafor directory nem hozhat� l�tre")
            taberrFilename(sdir)
            tabError(table)
        end
        
        fclose(fcreate(lower(sfil)))
    end
    
    if( mode==NIL )
        mode:=FO_EXCLUSIVE
    end
    
    return fopen(lower(sfil),mode) 



****************************************************************************
static  function _s_close(hnd)
    return fclose(hnd)



****************************************************************************
