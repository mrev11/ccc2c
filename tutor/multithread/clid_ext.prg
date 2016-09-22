
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

#define CLID_EXT
#define WAIT 1

#ifdef EMLEKEZTETO
    Ez a program demonstr�lja a CCC-nek azt a tulajdons�g�t,
    hogy a k�ls� static v�ltoz�k inicializ�tor�t szinkroniz�lja.

    A CLID_EXT defini�l�s�val clid_test K�LS� v�ltoz�, 
    a CCC automatikusan szinkroniz�lja az inicializ�tort, 
    ez�rt WAIT �rt�k�t�l f�ggetlen�l testRegister() csak egyszer 
    fut, ez a megk�v�nt m�k�d�s.
    
    A CLID_EXT defin�ci� n�lk�l clid_test BELS� v�ltoz�,
    amit a CCC (jelenleg) nem szinkroniz�l automatikusan,
    ez�rt WAIT>0 eset�n testRegister() hib�san k�tszer fut.
    
    Megjegyz�s: A C++ egy�ltal�n nem foglalkozik a static v�ltoz�k 
    inicializ�tor�nak szinkroniz�l�s�val (nem r�sze a nyelvnek),
    ez�rt C++-ban a static v�ltoz�k t�bbsz�r inicializ�l�dhatnak
    (ezt a hib�t �r�kli a CCC).
    
    Megjegyz�s: Ha mutex-szel szinkroniz�lunk, annak nyilv�n
    static-nak kell lennie, hogy minden sz�l ugyanazt a mutexet fogja.
    Ha a CCC mutex bels� static v�ltoz�nak van defini�lva,
    akkor el�fordulhat, hogy a static mutex hib�san t�bbsz�r is
    inicializ�l�dik, teh�t haszn�lhatatlan. Ez�rt K�LS� static 
    mutexeket c�lszer� haszn�lni.
    
    Megjegyz�s: A bels� static-ok az�rt nincsenek szinkroniz�lva, 
    mert a szinkroniz�l�s dr�ga, �s viszonylag ritk�n van r� sz�ks�g 
    (kev�s t�bbsz�l� program van).  A k�ls�k static-ok szinkroniz�lva 
    vannak, m�sk�pp minden mutexet el�re l�tre kellene hozni (a program 
    egysz�l� kor�ban), nehogy m�r maga a mutex is rossz legyen.
    
    Megjegyz�s: A CCC static v�ltoz�k inicializ�tora akkor fut,
    amikor a program haszn�lni kezdi a v�ltoz�t. Kor�bban ez nem
    �gy volt, �s probl�m�t okozott, hogy az MSC nem tudta kezelni
    a rekurz�v inicializ�l�st, amikor egy inicializ�tor hivatkozik
    egy m�sik static v�ltoz�ra, amit szint�n inicializ�lni kell...
    
    Megjegyz�s: Mit mond a C/C++ szabv�ny a static v�ltoz�k
    inicializ�l�s�r�l?
#endif


#ifdef CLID_EXT
static clid_test:=testRegister()
#endif

function testClass()
#ifndef CLID_EXT
static clid_test:=testRegister()
#endif
    return clid_test

static function testRegister()
local clid:=classRegister("test",{objectClass()})
    ?? "*"
    sleep(WAIT)
    return clid

*****************************************************************************
function main()
local th1,th2
    th1:=thread_create({||th()})
    th2:=thread_create({||th()})
    thread_join(th1)
    thread_join(th2)
    ?

static function th()
    ? "clid", testClass()

*****************************************************************************
