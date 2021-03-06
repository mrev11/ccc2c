
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

namespace sql2.db2

#include "db2.ch"
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
    method  driver              {||"sql2.db2"}
    method  version
    method  duplicate
    method  sqldisconnect
    method  sqlexecx
    method  sqlexec
    method  sqlisolationlevel
    method  sqlcommit
    method  sqlrollback
    method  sqlquerynew         {|this,stmt,bind|sql2.db2.sqlqueryNew(this,stmt,bind)}
    method  sqlsequencenew      {|this,name|sql2.db2.sqlsequenceNew(this,name)}
    method  __tableentityclass__{|this|sql2.db2.tableentityClass()}

******************************************************************************
static function sqlconnection.initialize(this,coninfo)

local usr,psw,dbs

    if( coninfo==NIL )
        coninfo:=getenv("DB2_CONNECT")
    end

    this:__coninfo__:=coninfo

    //DB2_CONNECT szintaktikája ua. mint az Oracle-nél
    //coninfo = "user@database/password"
    //coninfo = "user/password@database"
    //coninfo = "@database"  (ha nem kell user és password)
    
    //megj.
    //a db2-nek nincs user nyilvántartása, hanem az OS usereket használja
    //a db2 az OS userekhez és groupokhoz rendel jogosultságokat
    //a database-t nem (host,port)-tal kell megadni, hanem
    //a catalog paranccsal kell 'katalogizálni' a node-okat és db-ket
    //
    // CATALOG NODE ...
    // CATALOG DATABASE ...
    // UNCATALOG NODE ...
    // UNCATALOG DATABASE ...
    // LIST NODE DIRECTORY
    // LIST DB DIRECTORY
    //
    // CATALOG NODE egy node nevet rendel egy (host,port)-hoz
    // CATALOG DATABASE egy alias nevet rendel egy node-on levő db-hez
    // ezt az alias nevet kell megadni a coninfo-ban database helyén


    coninfo::=parseconstr
    usr:=coninfo[1]
    dbs:=coninfo[2]
    psw:=coninfo[3]

    this:__conhandle__:=sql2.db2._db2_connect(dbs,usr,psw)

    sql2.db2._db2_setautocommit(this:__conhandle__,.f.)
    sql2.db2._db2_setisolation(this:__conhandle__,ISOL_COM)

    this:__transactionid__:=0
    this:__isolationlevel__:=ISOL_COM
    this:__sessionisolationlevel__:=ISOL_COM
    this:__statementstoclose__:=array(64)

    return this


******************************************************************************
static function parseconstr(constr) // -> {usr,dbs,psw}

// constr:  user@database/password
// constr:  user/password@database

local x:=constr::strtran("@",",@,")::strtran("/",",/,")::split,n
local usr:="",dbs:="",psw:=""

    for n:=1 to len(x)
        if(x[n]=="@")
            dbs:=x[++n]
        elseif(x[n]=="/")
            psw:=x[++n]
        elseif(n==1)
            usr:=x[n]
        end
    end
    return {usr,dbs,psw}

******************************************************************************
//static function sqlconnection.version(this)
//local v
//local stmt:="select service_level from sysibmadm.env_inst_info"
//local stmidx:=sql2.db2._db2_execdirect(this:__conhandle__,stmt)
//    sql2.db2._db2_fetch(stmidx)
//    v:=sql2.db2._db2_getdata(stmidx,1)
//    sql2.db2._db2_closestatement(stmidx)
//    return bin2str(v)
//
//ideiglenesen, amíg nincs query

******************************************************************************
static function sqlconnection.version(this)
local q:=this:sqlqueryNew("select service_level from sysibmadm.env_inst_info")
local v:=(q:next,q:getchar(1))
    q:close
    return v

******************************************************************************
static function sqlconnection.duplicate(this)
    return sqlconnectionNew(this:__coninfo__)

******************************************************************************
static function sqlconnection.sqldisconnect(this)
    sql2.db2._db2_disconnect(this:__conhandle__)
    this:__conhandle__:=NIL

******************************************************************************
static function sqlconnection.sqlexec(this,stmt,bind)

local stmidx
local retcode
local fldcount:=0
local rowcount:=0
local err

    if( bind!=NIL )
        stmt:=sql2.db2.sqlbind(stmt,bind)
    end

    sql2.db2.sqldebug(stmt)

    stmidx:=sql2.db2._db2_execdirect(this:__conhandle__,stmt)
    retcode:=sql2.db2._db2_retcode(stmidx)
    if( retcode!=SQL_SUCCESS )
        err:=sql2.db2.sqlerror_create(stmidx)
        err:operation:="sqlexec"
        err:args:={stmt}
        sql2.db2._db2_closestatement(stmidx)
        //az itteni rollback nincs benne az sqldebug listában
        sql2.db2._db2_endtran(this:__conhandle__,SQL_ROLLBACK)
        this:__transactionid__++
        break(err)
    end

    //fldcount:=sql2.db2._db2_numresultcols(stmidx)    
    rowcount:=sql2.db2._db2_rowcount(stmidx)

    if( rowcount>=0 )
        //insert, update, delete
    else
        rowcount:=0 //egyéb, pl. select
    end

    sql2.db2._db2_closestatement(stmidx)

    return rowcount

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
        txtlevel+=", isolation level SERIALIZABLE"
    end
    if( 0!=numand(numlevel,ISOL_COM) )
        txtlevel+=", isolation level READ COMMITTED"
    end
    if( 0!=numand(numlevel,ISOL_RO) )
        //txtlevel+=", READ ONLY"   
    end
    if( 0!=numand(numlevel,ISOL_RW) )
        //txtlevel+=", READ WRITE"
    end
    txtlevel::=substr(2) //kezdő "," levéve
  
// ezek a szintek volnának:
//
//  stmt:="set current isolation level ur" //uncomitted read  
//  stmt:="set current isolation level cs" //cursor stability   = ANSI read committed
//  stmt:="set current isolation level rs" //read stability     = ANSI repeatable read
//  stmt:="set current isolation level rr" //repeatable read    = ANSI serializable
//
// nincs használható, cs-nél erősebb
// nincs megkülönböztetett session és tranasction level
// a 'current' szó opcionális, nincs megkülönböztető jelentése
// nincs semmilyen összefüggésben a tranzakcióhatárokkal
// az érték lekérdezhető: con:sqlqueryNew("values current isolation")

    sqlconnection.close_pending_statements(this,"set isolation")
    this:sqlexec("rollback")
    this:__transactionid__++
    
    if( !empty(txtlevel) )
        this:sqlexec("set"+txtlevel)
    end

    this:__isolationlevel__:=numlevel
    if( flag )
        this:__sessionisolationlevel__:=numlevel
    end

    return previous_level

******************************************************************************
static function sqlconnection.sqlcommit(this)
    sqlconnection.close_pending_statements(this,"commit transaction")
    this:sqlexec("commit")
    this:__transactionid__++

    if( this:__isolationlevel__!=this:__sessionisolationlevel__ )
        //sql2.db2._db2_setisolation(this:__conhandle__,this:__sessionisolationlevel__)
        if( this:__sessionisolationlevel__==ISOL_COM )
            this:sqlexec("set isolation level read committed")
        elseif( this:__sessionisolationlevel__==ISOL_SER ) 
            this:sqlexec("set isolation level serializable")
        end
        this:__isolationlevel__:=this:__sessionisolationlevel__
    end

******************************************************************************
static function sqlconnection.sqlrollback(this)
    sqlconnection.close_pending_statements(this,"rollback transaction")
    this:sqlexec("rollback")
    this:__transactionid__++

    if( this:__isolationlevel__!=this:__sessionisolationlevel__ )
        //sql2.db2._db2_setisolation(this:__conhandle__,this:__sessionisolationlevel__)
        if( this:__sessionisolationlevel__==ISOL_COM )
            this:sqlexec("set isolation level read committed")
        elseif( this:__sessionisolationlevel__==ISOL_SER ) 
            this:sqlexec("set isolation level serializable")
        end
        this:__isolationlevel__:=this:__sessionisolationlevel__
    end


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
    err:subsystem:="sql2.db2"
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
        err:subsystem:="sql2.db2"
        break(err)
    end

******************************************************************************

