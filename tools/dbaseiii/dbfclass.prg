
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

//2005.06.20  srukt�r�lt kiv�telkezel�s
//2003.08.01  user interface lev�lasztva
//2003.02.03  little/big endian t�mogat�s
//2001.08.01  dbstruct normaliz�lva
//2001.07.07  �j met�dus: editrecord
//jav�tva 2001.01.29

#include "fileio.ch"


#define CL_NAME   1
#define CL_ID     2
#define CL_STRU   3

static s_clid:={}

****************************************************************************
function dbaseiiiClass(name) 

local clname,clid,n

    if( name==NIL )
        clname:="dbaseiii"
    else
        clname:="dbaseiii_"+lower(alltrim(name))
    end
    
    n:=ascan(s_clid,{|x|x[CL_NAME]==clname})

    if( n==0 )
        clid:=classRegister(clname,{objectClass()})
        
        aadd(s_clid,{clname,clid,NIL})
    
        classMethod(clid,"initialize" ,{|this,n|dbaseiiiIni(this,n) })
        classMethod(clid,"open"       ,{|this,f,m,b|_dbaseiii_open(this,f,m,b) })
        classMethod(clid,"close"      ,{|this|_dbaseiii_close(this) })
        classMethod(clid,"goto"       ,{|this,n|_dbaseiii_goto(this,n) })
        classMethod(clid,"gotop"      ,{|this|_dbaseiii_gotop(this) })
        classMethod(clid,"gobottom"   ,{|this|_dbaseiii_gobottom(this) })
        classMethod(clid,"skip"       ,{|this,n|_dbaseiii_skip(this,n) })
        classMethod(clid,"deleted"    ,{|this|_dbaseiii_deleted(this) })
        classMethod(clid,"evalcolumn" ,{|this,n,x| _dbaseiii_evalcolumn(this,n,x) })

        //Ezek k�l�nv�ve (tagf�ggv�nyk�nt megsz�ntek)
        //classMethod(clid,"browse"     ,{|this,t,l,b,r,d| dbBrowse(this,t,l,b,r,d) })
        //classMethod(clid,"editrecord" ,{|this,o,f| dbEditRecord(this,o,f) })
 
        classAttrib(clid,"fspec")
        classAttrib(clid,"fhandle")
        classAttrib(clid,"hdrlen")
        classAttrib(clid,"reclen")
        classAttrib(clid,"reccnt")
        classAttrib(clid,"fldcnt")

        classAttrib(clid,"structname")
        classAttrib(clid,"dbstruct")
        classAttrib(clid,"fldblk")
        classAttrib(clid,"buffer")

        classAttrib(clid,"filter")
        classAttrib(clid,"recno")
        classAttrib(clid,"eof")

    else
        clid:=s_clid[n][CL_ID]
    end

    return clid


****************************************************************************
function dbaseiiiNew(name) 
local clid:=dbaseiiiClass(name)
    return objectNew(clid):initialize(name)


****************************************************************************
function dbaseiiiIni(this,name) 
    objectIni(this)
    clIni(this)
    if( name!=NIL )
        this:structname:=lower(alltrim(name))
    end
    return this


**************************************************************************** 
static function clIni(this)
    this:fspec:=""
    this:fhandle:=NIL
    this:reclen:=0
    this:hdrlen:=0
    this:reccnt:=0
    this:fldcnt:=0
    this:eof:=.t.
    this:recno:=0
    this:buffer:=NIL
    this:filter:=NIL
    this:dbstruct:={}
    this:fldblk:={}
    return NIL


**************************************************************************** 
static function clStruct(this) //mez�ki�rt�kel� met�dusok 

local err,fld,i
local clid:=getclassid(this)
local n:=ascan(s_clid,{|x|x[CL_ID]==clid})
    
    if( n==0 )

        err:=invalidstructerrorNew()
        err:operation:="dbaseiii:clstruct"
        err:description:="no registered class"
        err:filename:=this:fspec
        break(err)
    
    elseif( this:structname==NIL )

        //nem kell csin�lni semmit

    elseif( s_clid[n][CL_STRU]==NIL )

        //el�sz�r ny�lik meg,
        //elt�roljuk a strukt�r�t,
        //l�trehozzuk a mez� met�dusokat

        s_clid[n][CL_STRU]:=_arr2chr(this:dbstruct)
        
        for i:=1 to len(this:dbstruct)
            fld:=this:structname+"_"+lower(alltrim(this:dbstruct[i][1]))
            //classMethod(clid,fld,evalfldblk(this,i)) ROSSZ!!
            classMethod(clid,fld,evalfldblk(i))  //jav�t�s 2001.01.29
        next

    elseif( !s_clid[n][CL_STRU]==_arr2chr(this:dbstruct) )

        err:=invalidstructerrorNew()
        err:operation:="dbaseiii:clstruct"
        err:description:="incompatible dbstruct"
        err:filename:=this:fspec
        break(err)
    end
    return NIL


****************************************************************************
static function evalfldblk(n)  //jav�t�s 2001.01.29 
    return {|t|eval(t:fldblk[n])} 

//static function evalfldblk(this,n)   ROSSZ!!
//    return this:fldblk[n]
 

****************************************************************************
static function _dbaseiii_open(this,fspec,mode,ublk)

local hnd, buffer:=space(32)
local hdrlen,reclen,reccnt,fldcnt
local name,type,length,dec
local n,l,blk,offs:=2 //els� byte deleted flag
local err

    this:close()
    

    this:fspec:=lower(alltrim(fspec))
    this:fhandle:=hnd:=fopen(this:fspec,if(mode==NIL,FO_READ,mode))

    if( hnd<0 )
        err:=fnferrorNew()
        err:operation:="dbaseiii:open"
        err:description:="open failed"
        err:filename:=this:fspec
        if( ublk!=NIL )
            eval(ublk,err)
        else
            break(err)
        end
    end

    if( 32>fread(hnd,@buffer,32) )
        err:=invalidformaterrorNew()
        err:operation:="dbaseiii:open"
        err:description:="invalid dbf header"
        err:filename:=this:fspec
        break(err)
    end

    //this:reccnt:=reccnt:=bin2l(substr(buffer,5))
    //this:hdrlen:=hdrlen:=bin2i(substr(buffer,9))
    //this:reclen:=reclen:=bin2i(substr(buffer,11))
    //this:fldcnt:=fldcnt:=(hdrlen-32-(hdrlen%32))/32

    this:reccnt:=reccnt:=xvgetlit32(buffer,4,0)  
    this:hdrlen:=hdrlen:=xvgetlit16(buffer,8,0)  
    this:reclen:=reclen:=xvgetlit16(buffer,10,0) 
    this:fldcnt:=fldcnt:=(hdrlen-32-(hdrlen%32))/32
 
    this:buffer:=space(reclen)

    for n:=1 to fldcnt

        if( 32!=fread(hnd,@buffer,32) )
            err:=invalidformaterrorNew()
            err:operation:="dbaseiii:open"
            err:description:="read error in dbf header"
            err:filename:=this:fspec
            break(err)
        end

        l:=at(chr(0),buffer)-1

        name   := upper(padr(substr(buffer,1,l),10)) //normaliz�l�s 
        type   := upper(substr(buffer,12,1)) //normaliz�l�s 
        length := asc(substr(buffer,17,1))
        dec    := asc(substr(buffer,18,1))


        if( type=="C" )
            length+=256*dec
            dec:=0  //normaliz�l�s
            blk:=blkchar(this,offs,length)
 
        elseif( type=="N" )
            blk:=blknumber(this,offs,length)

        elseif( type=="D" )
            dec:=0  //normaliz�l�s 
            blk:=blkdate(this,offs,length)
 
        elseif( type=="L" )
            dec:=0  //normaliz�l�s 
            blk:=blkflag(this,offs,length)
 
        else
            blk:={||NIL}
        end
        
        aadd(this:fldblk,blk)
        aadd(this:dbstruct,{name,type,length,dec})
        offs+=length
    next

    if( offs-1!=reclen )
        err:=invalidformaterrorNew()
        err:operation:="dbaseiii:open"
        err:description:="invalid dbf header length"
        err:filename:=this:fspec
        break(err)
    end
    
    clStruct(this)

    return NIL


*************************************************************************
static function blkchar(this,offs,length)
    return {||xvgetchar(this:buffer,offs-1,length)}

static function blknumber(this,offs,length)
    return {||val(xvgetchar(this:buffer,offs-1,length))}

static function blkdate(this,offs,length)
    return {||stod(xvgetchar(this:buffer,offs-1,length))}

static function blkflag(this,offs,length)
    return {||"T"==xvgetchar(this:buffer,offs-1,1)}


*************************************************************************
static function _dbaseiii_close(this)
    if( valtype(this:fhandle)=="N" .and. 0<=this:fhandle )
        fclose(this:fhandle)
    end
    clIni(this)
    return NIL


*************************************************************************
static function dbGoeof(this)
    xvputfill(this:buffer,0,this:reclen,32) //space
    this:eof:=.t.
    this:recno:=0
    return NIL


*************************************************************************
static function _dbaseiii_goto(this,n) //minden mozg�s ezzel t�rt�nik

    n:=round(n,0)

    if( n<1 .or. this:reccnt<n )
        dbGoeof(this)

    else

        fseek(this:fhandle,this:hdrlen+(n-1)*this:reclen,FS_SET) 

        if( this:reclen==xvread(this:fhandle,this:buffer,0,this:reclen) )
            this:eof:=.f.
            this:recno:=n
        else
            dbGoeof(this)
        end
    end
    return !this:eof


*************************************************************************
function _dbaseiii_gotop(this)
    return this:goto(1)


*************************************************************************
function _dbaseiii_gobottom(this)
    return this:goto(this:reccnt)


*************************************************************************
function _dbaseiii_skip(this,n)

//Ugyanaz a modell, mint a t�blaobjektumban:
//Van a fil� v�g�n egy virtu�lis EOF rekord, amir�l h�trafel� BOTTOM-ra l�p.
//Ilyen rekord a fil� elej�n nincs, ha neki�tk�zik a fil� elej�nek, akkor
//�jrapoz�cion�lja mag�t gotop-pal, de be�ll�tja eof-ot .t.-re.

local skp:=0

    if( n==NIL )
        n:=1
    end
    
    //itt egyes�vel l�pked�nk,
    //hogy k�s�bb (esetleg) a filtert is kezelhess�k

    if( n>0 ) //el�re

        while( n>0 )
            if( this:recno==0 )
                exit //eof==.t.,recno==0 (virtu�lis EOF)
            
            elseif( _dbaseiii_goto(this,this:recno+1) )
                n--
                skp++
            end
        end
    
    elseif( n<0 ) //h�tra
    
        if( this:recno==0 ) //virtu�lis EOF-r�l el�sz�r BOTTOM-ra

            if( _dbaseiii_gobottom(this) )
                n++
                skp--
            else
                n:=0 //eof==.t.,recno==0 (virtu�lis EOF)
            end
        end
    
        while( n<0  )

            if( _dbaseiii_goto(this,this:recno-1) )
                n++
                skp--

            elseif( _dbaseiii_gotop(this) )
                this:eof:=.t.
                exit //eof==.t., recno==1 (TOP-ra poz�cion�l)

            else
                exit //eof==.t.,recno==0 (virtu�lis EOF)

            end
        end

    else //csak �jraolvas
    
        _dbaseiii_goto(this,this:recno)
    end

    return skp  //h�nyat l�pett (el�jeles)



*************************************************************************
static function _dbaseiii_deleted(this)
    return left(this:buffer,1)=="*"


*************************************************************************
static function _dbaseiii_evalcolumn(this,n,x)
    return eval(this:fldblk[n],x)


*************************************************************************
 

 