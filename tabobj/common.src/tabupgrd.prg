
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

//TARTALOM  : fil� strukt�r�j�nak friss�t�se az objektum szerint
//STATUS    : k�z�s, ifdef
//
//function tabUpgrade(table,force)     //strukt�ra friss�t�se
//function tabAutoUpgrade(table,force) //friss�t, ha sz�ks�ges


#include "tabobj.ch"

//konvert�lja a t�nyleges fil�t az objektumnak megfelel�en,
//ha a h�v�skor a fil� nyitva van, akkor nem csin�l semmit,
//hiszen megnyithat� fil�n�l nincs sz�ks�g konverzi�ra,
//konverzi� ut�n a fil� lez�rva marad, azaz :isopen nem v�ltozik
//
//konverzi�s szab�lyok:
//    nem enged mez�t kihagyni
//    mez� t�pusa nem lehet elt�r�
//    mez�hosszt hajland� megv�ltoztatni (cs�kkent/n�vel)
//
//    force==.t.-vel er�szakos konverzi�t csin�l
//
//visszat�r�s:
//    .t., ha OK
//    .f., ha a szab�lyok nem engedik a konverzi�t
//    NIL, ha a fil� foglalt


******************************************************************************
function tabUpgrade(table,force) //.t.=OK, NIL=foglalt, .f.:=nem konvert�lhat�

local result
local savefile:=tabFile(table)
local saveindex:=tabIndex(table)

    tranNotAllowedInTransaction(table,"upgrade")

    if( tabIsopen(table)>0 )
        //nyitva van, 
        //nincs sz�ks�g konverzi�ra

        result:=.t. 

    elseif( tabSlock(table,{||0})<=0 )
        //ha nem lehet r� szemafort tenni,
        //akkor m�svalaki foglalkozik vele,
        //nem lehet upgradelni 
       
        result:=NIL        

    else

        result:=_upgrade(table,force)
 
        tabFile(table,savefile)
        tabIndex(table,saveindex)
        tabSunlock(table)
    end

    return result


******************************************************************************
static function _upgrade(table,force) 

local tabfil
local colfil,colobj
local konvtab:={}, n, i
local fld,len,typ,kiolvas,beir,value
local toupgrade,total,pos,msg
local name1,name2
local logged
 
#ifdef _DBFNTX_    
    tabDelIndex(table) 
    tabIndex(table,{})

    //DBFNTX-ben az indexeket ki kell venni az objektumn�l, 
    //mert a tmp fil�n�v k�pz�s miatt (+"$") a transzform�lt
    //indexnevek hosszabbak voln�nak 8-n�l, �s ezen elakad

    //DATIDX-ben �s Btrieve-ben nem szabad az objektumb�l kivenni, 
    //mert akkor a fil� resource-�ba sem ker�ln�nek be az indexek
    
    //DBFCTX-ben mindegy
#endif    

    //a fil�b�l kiolvasott adatok alapj�n
    //l�trehozunk egy (nem statikus) t�bl�t, 
    //amivel megnyithat� a fil� (tabVerify �tengedi)

    tabfil:=tabStructInfo(table)

    if( tabfil==NIL )
        return NIL //foglalt
    elseif( empty(tabfil) )
        return .f. //nem �llap�that� meg a strukt�ra, nem konvert�lhat�
    end
    
    //ne tegyen r� szemafor lockot,
    //az ugyanis �sszeakadna a m�r megl�v�,
    //azonos nev�, de m�sik objektumban (table)
    //nyilv�ntartott lockkal:

    tabfil[TAB_SLOCKCNT]:=1 
    
    if( !tabOpen(tabfil,OPEN_EXCLUSIVE,{||.f.}) )
        return NIL //foglalt
    end

    //ideiglenes n�ven l�trehozzuk az objektummal megegyez� 
    //strukt�r�j� �res fil�t, el�sz�r t�r�lj�k a marad�kot
    //meg kell gondolni az NTX-ek �tk�z�s�t

    logged:=table[TAB_LOGGED]
    table[TAB_LOGGED]:=.f.
 
    tabFile(table,TMPCHR+tabFile(table))
    tabDelTable(table) 
    tabCreate(table)
    tabOpen(table,OPEN_APPEND) 

    //�sszeszedj�k a konvert�land� oszlopokat

    colfil:=tabColumn(tabfil)  //eredeti fil�
    colobj:=tabColumn(table)   //�j fil� az objektum alapj�n

    for n:=1 to len(colfil)

        fld:=colfil[n][COL_NAME]  
        typ:=colfil[n][COL_TYPE]  
        len:=colfil[n][COL_WIDTH] 
        
        i:=ascan(colobj,{|c|c[COL_NAME]==fld})
        
        if( 0<i .and. colobj[i][COL_TYPE]==typ )

            kiolvas:=colfil[n][COL_BLOCK]
            beir   :=colobj[i][COL_BLOCK]
            aadd(konvtab,{kiolvas,beir})
        
        else
            //akkor konvert�lhat�,
            //ha minden mez� megvan az �j t�bl�ban,
            //egyezik a t�pusa, 
            //egy�bk�nt jelezni kell, hogy nem konvert�lhat�
            //force==.t. er�szakos konverzi�t �r el�
            
            if( force!=.t. )
                tabClose(table)
                tabClose(tabfil)
                return .f. //nem konvert�lhat�
            end
        end
    next

    //konvert�lunk
    
    toupgrade:="Copy  "+tabPathName(tabfil)
    total:="/"+alltrim(str(tabLastrec(tabfil)))
    pos:=0
    msg:=message(msg,toupgrade+str(pos)+total)

    tabGoTop(tabfil)
    while( !tabEof(tabfil) )
        if( ((++pos)%20)==0 )
            msg:=message(msg,toupgrade+str(pos)+total)
        end
        
        tabAppend(table) 

        for n:=1 to len(konvtab)
            value:=eval(konvtab[n][1]) //olvas a r�gib�l
            eval(konvtab[n][2],value)  //�r az �jba
        next
        tabSkip(tabfil)
    end
    msg:=message(msg,toupgrade+str(pos)+total)
    
    tabClose(table)
    tabClose(tabfil)
    
    
    //el��llt a konvert�lt fil� ideiglenes n�ven, 
    //el kell m�g v�gezni a backup-ot �s az �tnevez�seket
    //tabfil : structinfo-b�l, name (eredeti fil�)
    //table  : program-b�l, $name (konvert�lt fil�)
    
    if( !tabBackup(tabfil) )
        //? "nem siker�lt elmenteni a r�gi verzi�t"
        return NIL 
    end

    if( !tabRename(table,tabFile(tabfil)) )
        //? "nem siker�lt �tnevezni az �j fil�t"
        return NIL 
    end

    sleep(100)
    message(msg)

    table[TAB_LOGGED]:=logged
    tabWriteChangeLogUpgrade(table) 

    return .t.


******************************************************************************
function tabAutoUpgrade(table,force)

local err, result:=.t.

    begin sequence
        tabOpen(table)
        tabClose(table)

    recover err <tabstructerror>
        tabClose(table)
        result:=tabUpgrade(table,force)

    recover err <tabindexerror>
        tabClose(table)
        result:=tabUpgrade(table,force)

    end sequence

    return result


******************************************************************************



