
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

#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <cccapi.h>

//A classid<->slot cache kezel�st szinkroniz�lni kell.
//
//Az xmethod modulban a k�l�nb�z� t�pus� met�dus oszt�lyokat
//egym�st�l f�ggetlen�l defini�ltuk (kompatibilit�si okokb�l),
//ez azonban nehez�tette a karbantart�st a k�dism�tl�sek miatt.
//Az xmethod2 modulban alkalmazzuk az �r�kl�d�st, a findslot-ot
//virtu�liss� tessz�k, �s bevezet�nk egy �j adattagot (slothashcode),
//amivel az oszt�ly<->met�dus p�ros�t�st optimaliz�ljuk.
//
//A r�gi xmethod oszt�ly bennmarad a k�nyvt�rban, �gy a r�gi
//ford�t�s� objectek v�ltoztat�s n�lk�l futnak. Az �j k�dgener�l�s
//a _method_ oszt�ly helyett _method2_ oszt�ly� met�dusdefin�ci�kat
//csin�l, ezek m�r az xmethod2-vel m�k�dnek. A k�zzel �rt C++
//modulokban sok�ig megmaradhatnak a r�gi xmethod hiv�tkoz�sok,
//ui. ezek �jraford�t�skor sem alakulnak �t xmethod2 k�dd�.


//----------------------------------------------------------------------
_method2_::_method2_(char *sname)
{
    extern unsigned int hashcode(const char*);

    classid=0;
    slotname=sname; 
    slothashcode=hashcode(sname);
    slot.type=TYPE_NIL;
    MUTEX_INIT(mutex);
};


_methods2_::_methods2_(char *sname, char *bname) : _method2_(sname)
{
    basename=bname; 
};


_methodc2_::_methodc2_(char *sname, char *bname) : _method2_(sname)
{
    basename=bname; 
};


_methodp2_::_methodp2_(char *sname, char *pname, char *bname) : _method2_(sname)
{
    prntname=pname; 
    basename=bname; 
};


//----------------------------------------------------------------------
_method2_::_method2_(const char *sname)
{
    extern unsigned int hashcode(const char*);

    classid=0;
    slotname=sname; 
    slothashcode=hashcode(sname);
    slot.type=TYPE_NIL;
    MUTEX_INIT(mutex);
};


_methods2_::_methods2_(const char *sname, const char *bname) : _method2_(sname)
{
    basename=bname; 
};


_methodc2_::_methodc2_(const char *sname, const char *bname) : _method2_(sname)
{
    basename=bname; 
};


_methodp2_::_methodp2_(const char *sname, const char *pname, const char *bname) : _method2_(sname)
{
    prntname=pname; 
    basename=bname; 
};


//----------------------------------------------------------------------
void _method2_::findslot(int clid)
{
    extern void _clp___findslot(int argno);

    MUTEX_UNLOCK(mutex);
    SIGNAL_UNLOCK();
    number(clid);
    string(slotname);
    number(slothashcode);
    _clp___findslot(3);  
    
    //Clipper szinten keres�nk.
    //Ha nem tal�lt, akkor ide m�r nem j�n,
    //mert a hib�t _clp___findslot() kezeli.
    //A mutex jelenleg �ppen nincs lockolva, teh�t, 
    //ha a hib�t elkapj�k, a mutex szabad �llapotban marad.
    //Ha tal�lt, akkor a method blokkja,
    //vagy az attrib�tum indexe van a stacken.
    //Ezt a blokkot/indexet meg�rizz�k a slot memberben,
    //(VIGY�ZAT) itt a blokkot a szem�tgy�jt�s nem tudja 
    //megtal�lni, �s csak amiatt nem takar�t�dik le, 
    //mert ugyanerre az objektumra a static aclass
    //t�mbb�l is van hivatkoz�s.
    
    SIGNAL_LOCK();
    MUTEX_LOCK(mutex);
    classid=clid;
    slot=*TOP();
}

void _methods2_::findslot(int clid)
{
    extern void _clp___findslot_s(int argno);

    MUTEX_UNLOCK(mutex);
    SIGNAL_UNLOCK();
    number(clid);
    string(slotname);
    string(basename);
    number(slothashcode);
    _clp___findslot_s(4);  
    SIGNAL_LOCK();
    MUTEX_LOCK(mutex);
    classid=clid;
    slot=*TOP();
}

void _methodc2_::findslot(int clid)
{
    extern void _clp___findslot_c(int argno);

    MUTEX_UNLOCK(mutex);
    SIGNAL_UNLOCK();
    number(clid);
    string(slotname);
    string(basename);
    number(slothashcode);
    _clp___findslot_c(4);  
    SIGNAL_LOCK();
    MUTEX_LOCK(mutex);
    classid=clid;
    slot=*TOP();
}

void _methodp2_::findslot(int clid)
{
    extern void _clp___findslot_p(int argno);

    MUTEX_UNLOCK(mutex);
    SIGNAL_UNLOCK();
    number(clid);
    string(slotname);
    string(prntname);
    string(basename);
    number(slothashcode);
    _clp___findslot_p(5);  
    SIGNAL_LOCK();
    MUTEX_LOCK(mutex);
    classid=clid;
    slot=*TOP();
}
 
 
//----------------------------------------------------------------------
void _method2_::eval(int argno)
{
    //stack: Obj A1 A2... Aargno-1 --- retval
    
    VALUE *base=stack-argno;  //object
    
    if( base->type!=TYPE_OBJECT )
    {
        error_obj(slotname,base,argno);
    }

    SIGNAL_LOCK();
    MUTEX_LOCK(mutex);
    if( base->data.object.subtype!=classid )
    {
        findslot(base->data.object.subtype); //virtual!

        //Ha findslot sikertelen, 
        //akkor Clipper runtime error keletkezik,
        //�s ide m�r nem j�n a vez�rl�s.
    }
    else
    {
        push(&slot);
    }
    MUTEX_UNLOCK(mutex);
    SIGNAL_UNLOCK();

    
    //Ha a TOP-ban sz�m van, akkor az egy attrib�tum indexe.
    //Ha a TOP-ban k�dblokk van, akkor azt ki kell �rt�kelni.

    if( TOP()->type==TYPE_NUMBER )
    {
        //attrib�tum kiolvas�s/fel�l�r�s
    
        unsigned int len=OBJECTLEN(base);
        unsigned int idx=(int)TOP()->data.number;

        if( (idx<1) || (len<idx) )
        {
            error_siz("_method_::eval",base,argno);
        }
    
        VALUE *v=OBJECTPTR(base)+idx-1;

        if( argno>1 ) //be�r�s
        {
            *v=*(base+1);
        }

        *base=*v;
        stack=base+1;
    }
    
    else if( TOP()->type==TYPE_BLOCK )
    {
        //method v�grehajt�s
        //a stacket eggyel feljebb kell hozni,
        //hogy a k�dblokkot betehess�k alulra
        
        VALUE blk=*TOP();
        int i;
        for( i=argno; i>0; i-- )
        {
            *(base+i)=*(base+i-1);
        }
        
        //ha most a base-be bem�soljuk a k�dblokkot,
        //akkor a verem �ppen olyan, mint _clp_eval-n�l
        
        *base=blk;
        base->data.block.code(argno+1);
    }

    else
    {
        error_gen("invalid slot type","_method_::eval",base,argno);
    }
}

//----------------------------------------------------------------------

