
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

//Kimutatja, ha a compiler (hib�san) optimaliz�lja VALUE::operator=()-t.
//Ugyanazon a rendszeren, ugyanaz a compiler n�ha optimaliz�l, n�ha nem,
//tal�n a k�rnyez� k�dt�l f�gg�en.

#ifdef EMLEKEZTETO
    else if( v.type<TYPE_ARRAY )
    {
        //type=TYPE_NIL;  //atomi
        memset(this,0,sizeof(VALUE));
        data=v.data;
        type=v.type;  //atomi

        //el kell �rni, hogy itt ne optimaliz�ljon
    }
#endif

*****************************************************************************
function main()
local th, cnt:=0

    ? "valueassign"

    printpid()
    printexe()
    
    th:=thread_create({||gc()}); thread_detach(th)
    th:=thread_create({||nyuzo()}); thread_detach(th)

    while( inkey()!=asc("q")  )
        sleep(1000)
        ?? str(++cnt,4)
    end
    ?

*****************************************************************************
static function gc()
    while(.t.)    
        vartab_rebuild()
        sleep(rand())
    end

*****************************************************************************
function nyuzo()
local a:={1},b
    while(.t.)
        b:=a[1]
    end

*****************************************************************************
static function printpid()
    set printer to pid
    set printer on
    ?? getpid()
    set printer to
    set printer off

static function printexe()
    set printer to exe
    set printer on
    ?? exename()
    set printer to
    set printer off

*****************************************************************************
