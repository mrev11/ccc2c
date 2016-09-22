
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

//Ideiglenesen blokkolja a szign�lokat,
//a blokkol�s felold�sa ut�n a szign�lok �rv�nyre jutnak.
//Ennek mint�j�ra lehet saj�t szign�lkezel�ket �rni.
//
//A signal_lock(), signal_unlock() API csak azt a sz�lat v�di
//a szign�lt�l, ami a signal_lock()-ot megh�vta. Ett�l m�g b�rmely 
//m�sik sz�l kaphat SIGINT-et, �s az eg�sz program kil�phet.     
//Windowson �ppens�ggel mindig ez a helyzet, ui. a SIGINT-et
//mindig egy �jonnan indul� sz�l kapja. A signal_lock() ez�rt 
//csak arra val�, hogy a mutexeket v�dje deadlock ellen. Ha ui.
//egy sz�l �ppen fog egy mutexet mik�zben egy szign�l megszak�tja,
//�s a szign�lkezel�b�l �jra meg akarn� fogni ugyanazt a mutexet, 
//akkor deadlock keletkezne.
//    
//Ha az eg�sz programot kell v�deni a SIGINT-t�l (v�ratlan kil�p�st�l),
//akkor ki kell cser�lni a minden sz�lra glob�lis signalblock()-ot.


static mutex:=thread_mutex_init()
#define MUTEX_LOCK    (signal_lock(),thread_mutex_lock(mutex))
#define MUTEX_UNLOCK  (thread_mutex_unlock(mutex),signal_unlock())

static oldblock
static sigpend:=0
static locklevel:=0  //enged�lyezve

*****************************************************************************
static function sighandler(signum)
    MUTEX_LOCK
    sigpend:=numor(sigpend,signum)
    MUTEX_UNLOCK

*****************************************************************************
function setposixsignal(onoff)

    MUTEX_LOCK
    if( onoff==.f. )  //letilt
        if( locklevel++==0 )
            oldblock:=signalblock({|s|sighandler(s)})
            sigpend:=0
        end
    elseif( onoff==.t. ) //enged�lyez
        if( --locklevel==0 )
            signalblock(oldblock)
            oldblock:=NIL
            if( sigpend!=0 )
                signal_raise(sigpend)
            end
            sigpend:=0
        end
    end
    MUTEX_UNLOCK
    
    //A felgy�lt szign�lok csak itt (MUTEX_UNLOCK ut�n) jutnak �rv�nyre,
    //ui. a signal_raise(sigpend) �ltal a megh�vott signal_handler()-ben
    //MUTEX_LOCK miatt siglocklev>0.
    

*****************************************************************************

