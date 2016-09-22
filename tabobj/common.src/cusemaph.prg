
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

//TARTALOM  : egyszer� szemafor protokol
//STATUS    : k�z�s utility


#include "fileio.ch"

// egyszer� szemafor protokoll
//
// hnd:=sema_open(sname,mode)
// sema_close(hnd)
//
// mode �rt�ke lehet FO_EXCLUSIVE (default), vagy FO_SHARED
//
// ezek k�z�ns�ges file open/close m�veletek,
// a fil�k a semaphor-ban j�nnek l�tre (automatikusan),
// hiba: az exclusive szemafor lockok nem �gyazhat�k egym�sba
//
// a protokol nyilv�n platformf�ggetlen, 
// a f� neh�zs�g, hogy meg kell �llapodni a szemafor nevekben,

// a t�bla objketumok szemaforoz�sa a tabslock-ban meg�rt
// k�l�n f�ggv�nyekkel t�rt�nik, ezek megmaradtak �ltal�nos
// haszn�latra


#define SEMDIR     "semaphor.tmp"
#define SEMFIL(x)  lower(SEMDIR+dirsep()+x)


****************************************************************************
function sema_open(sname,mode)

    if( !file(SEMFIL(sname)) )
        dirmake(SEMDIR)
        fclose(fcreate(SEMFIL(sname)))
    end
    
    if( mode==NIL )
        mode:=FO_EXCLUSIVE
    end
    
    return fopen(SEMFIL(sname),mode)


****************************************************************************
function sema_close(hnd)
    return fclose(hnd)


****************************************************************************
