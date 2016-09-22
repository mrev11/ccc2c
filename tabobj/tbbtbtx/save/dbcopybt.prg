
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

#include "fileio.ch"
#include "tabobj.ch" 


#define PRIME          1103
#define KEYNAME(t,o)   tabPathName(t)+alltrim(str(o)) 

******************************************************************************
#ifdef TABCOPYBT_NOTOPTIMIZED

function tabCopybt(table)

local btname,tfile 
local fd,db,ps,pn
local n,i,rb,recbuf
local msg,total,cnt:=0 

    btname:=lower(tabPathName(table))

    fd:=fopen(btname,FO_READWRITE+FO_EXCLUSIVE)
    if( fd<0 )
        taberrOperation("tabCopybt")
        taberrDescription("Filé nyitási hiba (fd)")
        tabError(table) 
    end

    db:=_db_open(fd)
    if( db==NIL )
        taberrOperation("tabCopybt")
        taberrDescription("Filé nyitási hiba (db)")
        tabError(table) 
    end

    ps:=_db_pagesize(db)
    pn:=fseek(fd,0,FS_END)/ps
    total:="/"+alltrim(str(_db_lastrec(db)))

    tfile:=tabFile(table) 
    tabFile(table,TMPCHR+tfile)
    tabCreate(table)
    tabOpen(table,OPEN_EXCLUSIVE)
    tabZap(table)
    
    //A rekordok sorrendje eltérhet a felvitel idõrendi sorrendjétõl,
    //ui. a page-ek növekvõ sorrendjében haladunk, ami a szabadlista miatt
    //nem feltétlenül lineáris. Nem akarom azonban, hogy a recovery
    //sikere függjön a recno index épségétõl, és nem akarok a data
    //page-ek listába fûzésével sem veszõdni.

    recbuf:=space(ps) //ebbe biztosan belefér

    for n:=2 to pn-1  //header(0) és resource(1) kihagyva
        i:=0
        while( .t. )
            rb:=_db_read1(db,recbuf,n,i++) 

            if( rb==0 )
                //nincs több rekord, vagy nem is datapage 
                exit 

            elseif( left(recbuf,1)=="*" )
                //törölt rekord

            elseif( rb==table[TAB_RECLEN] )
                tabAppend(table)
                table[TAB_RECBUF]:=left(recbuf,rb)
                tabCommit(table)
                if( ++cnt%1103==0 )
                    msg:=message(msg,"Pack "+tfile+str(cnt)+total)
                end
            end
        end
    next

    if( msg!=NIL )
        message(msg)
    end
    
    _db_close(db)
    tabClose(table)
    
    ferase(btname)
    frename(lower(tabPathName(table)),btname)
    tabFile(table,tfile) //visszaállít
 
    return .t.
 

******************************************************************************
#else //OPTIMIZED aktuális változat, a kulcsokat rendezi

//2002.12.18 memók packolása (opcionális)
#define MEMOPACK  //packolja-e a memókat?

function tabCopybt(table)

local btname,btxname,tfile 
local fd,db,db1,mh,mh1,ps,pn
local n,i,rb,wb,stat
local msg,total,cnt:=0 
local recno:=0,recbuf,reclen 
local fdkey:={},kfilnam 
local ord,key
local column,memblk,mx,mv

    //-----------------------
    //régi adatfilé
    //-----------------------
 
    btname:=lower(tabPathName(table))
    btxname:=lower(tabMemoName(table))
 
    fd:=fopen(btname,FO_READWRITE+FO_EXCLUSIVE)
    if( fd<0 )
        taberrOperation("tabCopybt")
        taberrDescription("Filé nyitási hiba (fd)")
        tabError(table) 
    end

    db:=_db_open(fd)
    if( db==NIL )
        taberrOperation("tabCopybt")
        taberrDescription("Filé nyitási hiba (db)")
        tabError(table) 
    end

    #ifdef MEMOPACK
    if( 0<tabMemoCount(table) )
        mh:=memoOpen(btxname)
        if( mh<0 )
            taberrOperation("tabCopybt")
            taberrDescription("Filé nyitási hiba (mh)")
            tabError(table) 
        end
    end
    #endif
 
    //-----------------------
    //új adatfilé
    //-----------------------
 
    tfile:=tabFile(table) 
    tabFile(table,TMPCHR+tfile)
    ferase(lower(tabPathName(table)))
    tabCreate(table)
    tabOpen(table,OPEN_EXCLUSIVE)
    tabZap(table)
    db1:=table[TAB_BTREE]
    
    #ifdef MEMOPACK
    if( 0<tabMemoCount(table) )
        mh1:=tabMemoHandle(table)

        memblk:={}
        column:=tabColumn(table)
        for n:=1 to len(column)
            if( tabMemoField(table,column[n]) )
                aadd(memblk,column[n][COL_BLOCK])
            end
        next
    end
    #endif
 
    //-----------------------
    //ideiglenes kulcsfilék
    //-----------------------
 
    for ord:=0 to len(tabIndex(table)) 
        ferase(kfilnam:=KEYNAME(table,ord))
        aadd(fdkey,fcreate(kfilnam,FO_READWRITE+FO_SHARED))
        if( atail(fdkey)<0 )
            taberrOperation("tabCopybt")
            taberrDescription("Filé létrehozási hiba (fdkey)")
            tabError(table) 
        end
    next

    //A rekordok sorrendje eltérhet a felvitel idõrendi sorrendjétõl,
    //ui. a page-ek növekvõ sorrendjében haladunk, ami a szabadlista miatt
    //nem feltétlenül lineáris. Nem akarom azonban, hogy a recovery
    //sikere függjön a recno index épségétõl, és nem akarok a data
    //page-ek listába fûzésével sem veszõdni.
 
    ps:=_db_pagesize(db)
    pn:=fseek(fd,0,FS_END)/ps
    total:="/"+alltrim(str(_db_lastrec(db)))
    reclen:=table[TAB_RECLEN] 
    recbuf:=space(reclen) 

    for n:=2 to pn-1  //header(0) és resource(1) kihagyva
        i:=0
        while( .t. )
            rb:=_db_read1(db,recbuf,n,i++) 

            if( rb==0 )
                //nincs több rekord, vagy nem datapage 
                exit 

            elseif( rb!=reclen )
                //sérült filé
                taberrOperation("tabCopybt")
                taberrDescription("Filé olvasási hiba (rb!=reclen)")
                tabError(table) 

            elseif( left(recbuf,1)=="*" )
                //törölt rekord
 
            else

                if( ++cnt%PRIME==0 )
                    msg:=message(msg,"COPY "+btname+str(cnt)+total)
                end
                
                table[TAB_RECBUF]    :=  recbuf

                #ifdef MEMOPACK
                if( memblk!=NIL )
                    set signal block
                    table[TAB_EOF]:=.f.           //EOF törölve
                    for mx:=1 to len(memblk)
                        table[TAB_MEMOHND]:=mh    //régi memó
                        mv:=eval(memblk[mx])      //olvasás a memóból
                        table[TAB_MEMOHND]:=mh1   //új memó
                        eval(memblk[mx],mv)       //írás a memóba
                    next
                    table[TAB_MODIF]:=.f.         //commit törölve
                    table[TAB_MEMODEL]:=NIL       //memodel törölve
                    set signal unblock  
                end
                #endif                

                table[TAB_RECPOS]    :=  _db_append(db1,recbuf) 
                table[TAB_POSITION]  :=  ++recno
 
                for ord:=0 to len(tabIndex(table))
                    key:=tabKeyCompose(table,ord)
                    fwrite(fdkey[1+ord],key)
                next
            end
        end
    next

    for ord:=0 to len(tabIndex(table)) 
        if( recno>0 ) //2002.11.13
            build_index(table,ord,fdkey[1+ord],msg,btname) 
        end
        fclose(fdkey[1+ord])
        ferase(KEYNAME(table,ord))
    next

    if( msg!=NIL )
        message(msg)
    end
    
    _db_close(db)
    if( mh!=NIL .and. mh>=0 )
        memoClose(mh)
    end
    tabClose(table)
    
    set signal block
    ferase(btname);  frename(lower(tabPathName(table)),btname) 
    #ifdef MEMOPACK
      ferase(btxname); frename(lower(tabMemoName(table)),btxname)
    #else
      ferase(lower(tabMemoName(table))) 
    #endif
    set signal unblock
 
    tabFile(table,tfile)
 
    return .t.

 
******************************************************************************
static function build_index(table,ord,fd,msg,btname)

local keyval,keynam,keylen
local db1:=table[TAB_BTREE]
local rcount:=table[TAB_POSITION] 
local n,rb,stat

    if( ord==0 )
        keynam:="recno"
    else
        keynam:=tabIndex(table)[ord][IND_NAME] 
    end

    if( 0>_db_setord(db1,keynam) )
        taberrOperation("tabCopybt")
        taberrDescription("Index hiányzik (_db_setord<0)")
        taberrArgs({keynam})
        tabError(table) 
    end
    
    keylen:=tabKeyLength(table,ord)  
    keyval:=space(keylen)

    if( ord>0 )
        __bt_sortkey(KEYNAME(table,ord),rcount,keylen)
    end                   

    fseek(fd,0,FS_SET)
    for n:=1 to rcount
    
        if( n%PRIME==0 .and. msg!=NIL )
            message(msg,"COPY "+btname+" ("+keynam+")"+str(n))
        end

        rb:=fread(fd,@keyval,keylen)

        if( rb!=keylen )
            taberrOperation("tabCopybt")
            taberrDescription("Filé olvasási hiba (rb!=keylen)")
            taberrArgs({keynam,ferror()})
            tabError(table) 
        end

        stat:=_db_put(db1,keyval)
        if( stat!=0 )
            taberrOperation("tabCopybt")
            taberrDescription("Index építési hiba (_db_put!=0)")
            taberrArgs({keynam,stat})
            tabError(table) 
        end
    next
    
    return NIL

******************************************************************************
#endif 
