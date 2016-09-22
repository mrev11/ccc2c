
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

#include "tabobj.ch"


//#define PUP_TABLE       1  //minden form�tumban
//#define PUP_POSITION    2  //minden form�tumban 
//#define PUP_RECBUF      3  //minden form�tumban 
 
#ifdef _DBFNTX_

function tranNotAllowedInTransaction(table,op,mode)
    return NIL

#else

static debug:="debug"$getenv("TRANCOMMIT")

static trantables:={} //2000.07.16 jav�t�s 
static tranindex:={}
static pendingupdate:={}
static activetransaction:=.f.
static tableid:=0
 

****************************************************************************
function tranIsActiveTransaction()
    return activetransaction 


****************************************************************************
function tranAddToPendingUpdates(pup)

local tab:=pup[PUP_TABLE]     
//local pos:=pup[PUP_POSITION]
//local rec:=pup[PUP_RECBUF]

    if( tab[TAB_TRANID]==NIL )
        tab[TAB_TRANID]:=++tableid
        aadd(trantables,tab)
    end

    aadd(pendingupdate,pup)
    return NIL
 

****************************************************************************
function tranRecordLockedInTransaction(table)

    if( table[TAB_TRANID]==NIL )
        table[TAB_TRANID]:=++tableid
        aadd(trantables,table)
    end
    if( table[TAB_TRANLOCK]==NIL )
        table[TAB_TRANLOCK]:=len(table[TAB_LOCKLST])
        //megjegyzi az els� olyan lock index�t,
        //ami a tranzakci�n bel�l lett felt�ve
    end
    return NIL

****************************************************************************
function tranDeleteOnRollback(table,pos)

    if( table[TAB_TRANID]==NIL )
        table[TAB_TRANID]:=++tableid
        aadd(trantables,table)
    end
    if( table[TAB_TRANDEL]==NIL )
        table[TAB_TRANDEL]:={pos}
    else
        aadd(table[TAB_TRANDEL],pos)
    end
    return NIL
 
****************************************************************************
static function tranClearTransactionID(rb) 

//2000.07.16 jav�t�s
//kor�bban ez tabObjectList minden elem�re t�rt�nt,
//ami elengedett minden lockot, olyan fil�k lockjait is,
//amik nem vettek r�szt a tranzakci�ban

//2003.03.21 jav�t�s
//csak azokat a lockokat engedj�k el, 
//amik a tranzakci�n bel�l lettek felt�ve,
//t�r�lj�k a TAB_TRANDEL list�ban felsorolt rekordokat

local n, table
local dlst,llst,x,i

    for n:=1 to len(trantables)
    
        table:=trantables[n] 

        // t�rlend� rekordok (rollback)

        if( rb==.t. .and. NIL!=(dlst:=table[TAB_TRANDEL]) )
            for i:=1 to len(dlst)
                if( tabGoto(table,dlst[i]) )
                    tabDelete(table)
                end
            next
        end
 
        // unlockoland� rekordok

        x:=table[TAB_TRANLOCK] 
        if( x==NIL )
            //nincs lock
        elseif( x==1 )
            tabUnlock(table)
        else
            llst:=aclone(tabLocklist(table))
            for i:=x to len(llst)
                tabUnlock(table,llst[i])
            next
        end

        table[TAB_TRANDEL]:=NIL
        table[TAB_TRANLOCK]:=NIL
        table[TAB_TRANID]:=NIL
    next

    trantables:={}
    return NIL
 
 
****************************************************************************
function tranSyncronizeRecord(table) //compatibility
    return tranSynchronizeRecord(table)


****************************************************************************
function tranSynchronizeRecord(table,lockflag)  

//�jra�rva 2001.12.14
//Ki�rja az aktu�lis rekordot.
//Olyankor van r� sz�ks�g, amikor tranzakci�
//k�zben r� kell seekelni egy �j rekordra (pl.insert),
//vagy azonnal l�that�v� kell tenni egy k�z�sen
//haszn�lt sz�ml�l� tartalm�t.

//kieg�sz�tve 2002.02.16
//Ha lockflag==.t., akkor a rekord lockj�t elengedi.
//En�lk�l pl. a PARAM t�bla �gysz�m sz�ml�l�t tartalmaz�
//rekordj�n a tranzakci� eg�sz ideje alatt lock maradna,
//ami teljesen sorba�ll�tan� a konkurrens programokat.

local pup,t,n
local tranid,recno

    tabCommit(table)
 
    if( activetransaction )

        if( debug )   
            ? replicate("-",79)
            ? "Synchronized"
            ? replicate("-",79)
        end
 
        tranid:=table[TAB_TRANID] 
        recno:=tabPosition(table)
 
        for n:=1 to len(pendingupdate)
            pup:=pendingupdate[n]
            
            if( pup!=NIL .and.;
                pup[PUP_TABLE][TAB_TRANID]==tranid .and.;
                pup[PUP_POSITION]==recno )

                if( debug )   
                    print_debug_info(pup)
                end

                table[TAB_MODIF]:=.t.
                tabCommit(table,pup)
                pendingupdate[n]:=NIL
            end
        next
 
        if( lockflag==.t. )
            activetransaction:=.f. 
            tabUnlock(table,recno)
            activetransaction:=.t. 
        end
    end
    return NIL


****************************************************************************
function tranLastRecordUpdate(table,info)
 
local n,pup,pos,tid 
 
    if( !empty(tid:=table[TAB_TRANID]) )
        pos:=tabPosition(table) 

        for n:=len(pendingupdate) to 1 step -1
            pup:=pendingupdate[n]

            if( pup!=NIL .and.;
                pos==pup[PUP_POSITION] .and.;
                tid==pup[PUP_TABLE][TAB_TRANID] )

                table[TAB_RECBUF]:=substr(pup[PUP_RECBUF],1)
                info:=pup //2001.12.27 BTBTX-hez
                return .t.
            end
        next
    end
    return .f.


****************************************************************************
function tranNotAllowedInTransaction(table,op,mode)
local err
    if( activetransaction .and. (mode==NIL .or. table[TAB_TRANID]!=NIL) )
        err:=errorNew()
        err:operation:=op
        err:description:="not allowed in transaction"
        err:filename:=tabPathName(table)
        break(err)
    end
    return NIL


****************************************************************************
function tranBegin()
    tabCommitAll() 
    activetransaction:=.t. 
    aadd(tranindex,len(pendingupdate)+1)
    return len(tranindex)


****************************************************************************
function tranRollback(tx)

local err, n, t
 
    tabCommitAll() 
 
    if( activetransaction )

        if( tx==NIL )
            tx:=len(tranindex)
        end
    
        if( tx<1 .or. len(tranindex)<tx )
            err:=errorNew()
            err:operation:="tranRollback"
            err:description:="invalid transaction ID"
            break(err)
        end
 
        asize(pendingupdate,tranindex[tx]-1)
        asize(tranindex,tx-1)

        for n:=1 to len(trantables)
            t:=trantables[n] 
            tabGoto(t,tabPosition(t))  
            if( tabDeleted(t) )
                tabGoEOF(t)
            end
        next
 
        if( empty(tranindex) )  
            activetransaction:=.f. 
            tranClearTransactionID(.t.)  
        end
    end

    return NIL


****************************************************************************
function tranCommit(tx)

local err,n,pup,table,pos
local savepos


    tabCommitAll() 

    if( activetransaction )
    
        if( tx==NIL )
            tx:=len(tranindex) 
        end

        if( tx<1 .or. len(tranindex)<tx )
            err:=errorNew()
            err:operation:="tranCommit"
            err:description:="invalid transaction ID"
            break(err)
        end

        asize(tranindex,tx-1)
     
        if( empty(tranindex) )
    
            if( debug )
                ? replicate("-",79)
                ? "Pending updates"
                ? replicate("-",79)
            end
            
            savepos:=array(len(pendingupdate))

            set signal disable
 
            for n:=1 to len(pendingupdate)
                pup:=pendingupdate[n] 

                if( pup!=NIL )
                    table:=pup[PUP_TABLE]

                    if( table[TAB_TRANID]!=NIL )
                        savepos[n]:={table,tabPosition(table)}
                        table[TAB_TRANID]:=NIL
                    end
 
                    if( debug )   
                        print_debug_info(pup)
                    end
 
                    table[TAB_MODIF]:=.t.
                    tabCommit(table,pup)
                end
            next

            set signal enable

            for n:=1 to len(savepos)
                //csak miut�n minden commit megvan,
                //azut�n poz�cion�lunk az eredeti rekordra
                if( savepos[n]!=NIL )
                    tabGoto(savepos[n][1],savepos[n][2]) 
                end
            next
 
            activetransaction:=.f. 
            tranClearTransactionID()  
            pendingupdate:={}
        end
    end
    
    return NIL

 
*****************************************************************************
static function print_debug_info(pup)

local tab:=pup[PUP_TABLE]
local pos:=pup[PUP_POSITION]
local rec:=pup[PUP_RECBUF]
local tid:=tab[TAB_TRANID]

local pos0:=tabPosition(tab)
local rec0:=array(tabFcount(tab)),v0
local rec1:=array(tabFcount(tab)),v1 
local del0
local del1
local n, keyx

    //a tranzakci� el�tt lemezre �rt rekord:
    //tranid t�rl�se miatt tabGoto nem szedi fel
    //a mem�ri�ban t�rolt rekordv�ltozatot

    tab[TAB_TRANID]:=NIL
    tabGoto(tab,pos)     

    del0:=tabEof(tab).or.tabDeleted(tab)
    if( !del0 )
        for n:=1 to tabFcount(tab)
            rec0[n]:=tabEvalcolumn(tab,n) 
        next
        keyx:=key(tab)
    end
    
    //a tranzakci� k�zben m�dosult rekord:
    //a pup-ban t�rolt rekord k�zvetlen�l bet�ltve
    
    tab[TAB_RECBUF]:=substr(rec,1)
    del1:=tabDeleted(tab)
    if( !del1 )
        for n:=1 to tabFcount(tab)
            rec1[n]:=tabEvalcolumn(tab,n) 
        next
        keyx:=key(tab)
    end
    
    //az eredeti t�bla�llapot vissza�ll�t�sa,
    //nincs r� sz�kseg, de biztos, ami biztos
    
    tab[TAB_TRANID]:=tid 
    tabGoto(tab,pos0)    
    
    //az elt�r�sek list�z�sa:
    //al�bb m�r nem m�dos�tjuk a t�bl�t,
    //�s a rekordbuffert sem olvassuk

    ? "table:", tabFile(tab), " recno:", pos, " key:", keyx
    
    if( !del0 .and. del1 )
        ?? " deleted"
        for n:=1 to tabFcount(tab)
            v0:=rec0[n]
            if( !empty(v0) )
                ? " ", tabColumn(tab)[n][COL_NAME], "[", v0, "]"
            end
        next
 
    elseif( del0 .and. !del1 )
        ?? " appended"
        for n:=1 to tabFcount(tab)
            v1:=rec1[n]
            if( !empty(v1) )
                ? " ", tabColumn(tab)[n][COL_NAME], "[", v1, "]"  
            end
        next
 
    else
        for n:=1 to tabFcount(tab)
            v0:=rec0[n]
            v1:=rec1[n]
            if( !v0==v1 )
                ? " ", tabColumn(tab)[n][COL_NAME], "[", v0, "] -> [", v1, "]"  
            end
        next
    end
    
    return NIL


*****************************************************************************
static function key(table) 
local key, n 
    if( empty(table[TAB_ORDER]) )
        key:={"recno"}
    else
        key:=aclone(table[TAB_INDEX][table[TAB_ORDER]][IND_COL])
        for n:=1 to len(key)
            key[n]:=tabEvalColumn(table,key[n])
        next
    end
    return key
 

*****************************************************************************
 
#endif

 