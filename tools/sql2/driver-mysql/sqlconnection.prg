
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

namespace sql2.mysql

#include "my.ch"
#include "sql.ch"

******************************************************************************
class sqlconnection(object)
    method  initialize
    attrib  __conhandle__
    attrib  __coninfo__
    attrib  __transactionid__
    attrib  __isolationlevel__
    attrib  __sessionisolationlevel__
    attrib  __statementstoclose__
    method  __addstatementtoclose__
    method  __clearstatement__
    method  driver              {||"sql2.mysql"}
    method  version
    method  duplicate
    method  sqldisconnect
    method  sqlexecx
    method  sqlexec
    method  sqlisolationlevel
    method  sqlcommit
    method  sqlrollback
    method  sqlquerynew         {|this,stmt,bind|sql2.mysql.sqlqueryNew(this,stmt,bind)}
    method  sqlsequencenew      {|this,name|sql2.mysql.sqlsequenceNew(this,name)}
    method  __tableentityclass__{|this|sql2.mysql.tableentityClass()}

******************************************************************************
static function sqlconnection.initialize(this,coninfo)
    this:(object)initialize

    if( coninfo==NIL )
        coninfo:=getenv("MYSQL_CONNECT")
    end

    this:__coninfo__:=coninfo

    //        1    2    3      4  5    6    7    
    //coninfo=host:user:passwd:db:port:usck:cflag
    //példa ":konto:konto:konto" (default host=localhost, default port ...)

    coninfo::=split(":")::asize(7)

    if( coninfo[5]::empty )
        coninfo[5]:=0
    else
        coninfo[5]::=val
    end

    if( coninfo[7]::empty )
        coninfo[7]:=0
    else
        coninfo[7]::=val
    end
    coninfo[7]::=numor(2) //CLIENT_FOUND_ROWS (update rowcount error!)

    //a többi paraméter defaultja '' vagy NIL (asize miatt lehet NIL)
    
    this:__conhandle__:=sql2.mysql._my_connect(coninfo[1],coninfo[2],coninfo[3],coninfo[4],coninfo[5],coninfo[6],coninfo[7])

// nem így kell beállítani
//  sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"set session sql_mode='ANSI_QUOTES'"))
//  sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"set session sql_mode='no_backslash_escapes'"))
// hanem így:

    sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"set session sql_mode='ANSI_QUOTES,no_backslash_escapes'"))

// a beállítások lekérdezhetők:
//  q:=con:sqlqueryNew("select @@session.sql_mode")
//  while( q:next )
//      ? q:getchar(1)
//  end

    sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"set session transaction isolation level read committed"))
    sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"set autocommit=0"))
    sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"start transaction"))

    this:__transactionid__:=0
    this:__isolationlevel__:=ISOL_COM
    this:__sessionisolationlevel__:=ISOL_COM
    this:__statementstoclose__:=array(64)

    return this

******************************************************************************
static function sqlconnection.version(this)
local v:=sql2.mysql._my_get_server_info(this:__conhandle__)
    return "MySQL "+v

******************************************************************************
static function sqlconnection.duplicate(this)
    return sqlconnectionNew(this:__coninfo__)

******************************************************************************
static function sqlconnection.sqldisconnect(this)
    sql2.mysql._my_close(this:__conhandle__)
    this:__conhandle__:=NIL

******************************************************************************
static function sqlconnection.sqlexec(this,stmt,bind)

local err
local stmidx,fldcnt
local rowcount:=0

    if( bind!=NIL )
        stmt:=sql2.mysql.sqlbind(stmt,bind)
    end

    sql2.mysql.sqldebug(stmt)

    stmidx:=sql2.mysql._my_real_query(this:__conhandle__,stmt)
    
    if( stmidx==NIL )
        //error, stmidx nincs tárolva

        err:=sql2.mysql.sqlerrorCreate(this:__conhandle__)
        err:operation:="sqlexec"
        err:args:={stmt}
        sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"rollback"))
        sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"start transaction"))
        //az itteni rollback nincs benne az sqldebug listában
        this:__transactionid__++
        break(err)
        return 0
    end
    
    fldcnt:=sql2.mysql._my_field_count(this:__conhandle__)
    if( fldcnt==0 )
        //insert, update, delete, ...
        rowcount:=sql2.mysql._my_affected_rows(this:__conhandle__)
    else
        //select
        rowcount:=0 //itt nem foglalkozunk selectekkel
    end
    sql2.mysql._my_free_result(stmidx)
    return rowcount


#ifdef EMLEKEZTETO //a Postgres automatikus abortjáról
    Hiba esetén a Postgres automatikusan és elkerülhetetlenül
    abortálja a tranzakciót, és a következő commit/rollback utasításig
    semmit sem hajt végre. Ezért jobb rögtön explicite rollbackelni.
    
    A Postgres 7.4-től kezdve nincs szerver oldali autocommit=on/off
    management, azért a kliens oldalon kell csinálni a tranzakciók
    automatikus kezdését a korábbi autocommit=off módnak megfelelően.
    
    Az Oracle úgy működik, mintha minden utasítás előtt volna
    egy implicit savepoint, és ha az utasítás sikertelen, akkor
    eddig az implicit savepointig rollbackel. A Postgresben
    azonban nincsenek savepointok.
#endif

******************************************************************************
static function sqlconnection.sqlexecx(this,stmt,bind)
local err
    begin
        this:sqlexec(stmt,bind)
    recover err <sqlerror>
    end
    return err

******************************************************************************
static function sqlconnection.sqlisolationlevel(this,numlevel,flag:=.f.)

//flag==.t. az egész sessionre
//flag==.f. egy tranzakcióra

local stmt,txtlevel:=""
local previous_level

    if( numlevel==ISOL_READ_COMMITTED )
        //compatibility
        numlevel:=ISOL_COM
    end

    if( flag )
        previous_level:=this:__sessionisolationlevel__
    else
        previous_level:=this:__isolationlevel__
    end

    if( numlevel==NIL )
        //csak lekérdezés
        return previous_level
    end

    if( 0!=numand(numlevel,ISOL_SER) )
        txtlevel+=", isolation level SERIALIZABLE"
    end
    if( 0!=numand(numlevel,ISOL_REP) )
        txtlevel+=", isolation level SERIALIZABLE"  //REPEATABLE READ rossz
    end
    if( 0!=numand(numlevel,ISOL_COM) )
        txtlevel+=", isolation level READ COMMITTED"
    end
    if( 0!=numand(numlevel,ISOL_RO) )
        txtlevel+=", READ ONLY"
    end
    if( 0!=numand(numlevel,ISOL_RW) )
        txtlevel+=", READ WRITE"
    end
    txtlevel::=substr(2) //kezdő "," levéve

    
    if( flag )
        //a session-re
        stmt:="set session transaction"+txtlevel
    else
        //egy tranzakcióra
        stmt:="set transaction"+txtlevel
    end

    //mindkét esetben ugyanaz a sorrend kell
    sqlconnection.close_pending_statements(this,"set isolation")
    sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"rollback"))
    this:sqlexec(stmt)
    sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"start transaction"))

    this:__transactionid__++

    this:__isolationlevel__:=numlevel
    if( flag )
        this:__sessionisolationlevel__:=numlevel
    end

    return previous_level

//megjegyzés:
//
//5.5-ben nem lehet megadni READ ONLY-t és READ WRITE-ot
//  tehát csak ezek lehetségesek:
//    con:sqlisolationlevel(ISOL_COM)
//    con:sqlisolationlevel(ISOL_SER)
//
//5.6-tól kezdve lehet kihasználni az itt beépített tudást
//  például
//    con:sqlisolationlevel(ISOL_SER+ISOL_RO)


******************************************************************************
static function sqlconnection.sqlcommit(this)
    sqlconnection.close_pending_statements(this,"commit transaction")
    this:sqlexec("commit")
    sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"start transaction"))
    this:__transactionid__++
    this:__isolationlevel__:=this:__sessionisolationlevel__

******************************************************************************
static function sqlconnection.sqlrollback(this)
    sqlconnection.close_pending_statements(this,"rollback transaction")
    this:sqlexec("rollback")
    sql2.mysql._my_free_result(sql2.mysql._my_real_query(this:__conhandle__,"start transaction"))
    this:__transactionid__++
    this:__isolationlevel__:=this:__sessionisolationlevel__


******************************************************************************
static function sqlconnection.__addstatementtoclose__(this,blk)
local idx,err
    for idx:=1 to len(this:__statementstoclose__)
        if( this:__statementstoclose__[idx]==NIL )
            this:__statementstoclose__[idx]:=blk
            return idx
        end
    next
    err:=sqlerrorNew()
    err:operation:="sqlconnection.__addstatementtoclose__"
    err:description:="too many statements"
    err:subsystem:="sql2.mysql"
    break(err)

******************************************************************************
static function sqlconnection.__clearstatement__(this,idx)
    this:__statementstoclose__[idx]:=NIL


******************************************************************************
static function sqlconnection.close_pending_statements(this,txt)
local idx,n:=0,err
    for idx:=1 to len(this:__statementstoclose__)
        if( this:__statementstoclose__[idx]!=NIL )
            eval(this:__statementstoclose__[idx])
            this:__statementstoclose__[idx]:=NIL
            n++
        end
    next
    if( n>0 )
        err:=sqlerrorNew()
        err:operation:="sqlconnection.close_pending_statements"
        err:description:="cannot TXT - SQL statements in progress"::strtran("TXT",txt)
        err:subsystem:="sql2.mysql"
        break(err)
    end

******************************************************************************
