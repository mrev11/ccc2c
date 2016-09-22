
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

***********************************************************************
function _clp_day(dat)
    if( !empty(dat) )
        return val(right(dtos(dat),2))
    end
    return 0


***********************************************************************
function _clp_dow(dat)
    if( !empty(dat) )
        return (__dat2num(dat)+6)%7+1 //vasárnap=1! 1998.10.02 
    end
    return 0

***********************************************************************
function _clp_cdow(dat)
//static d:={"","vasárnap","hétfõ","kedd","szerda","csütörtök","péntek","szombat"}
static d:={"","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
    return d[1+dow(dat)]  //vasárnap=1! 1998.10.02 


***********************************************************************
function _clp_month(dat)
    if( !empty(dat) )
        return val(substr(dtos(dat),5,2))
    end
    return 0

***********************************************************************
function _clp_cmonth(dat)
//static m:={"január","február","március","április","május","június",;
//           "július","augusztus","szeptember","október","november","december"}
static m:={"","January","February","March","April","May","June",;
              "July","August","September","October","November","December"}
    return m[1+month(dat)]


***********************************************************************
function _clp_year(dat)
    if( !empty(dat) )
        return val(left(dtos(dat),4))
    end
    return 0


***********************************************************************
function _clp_ctod(datstr)

local s:=ctos(datstr)

    if( len(s)!=8 )
        s:="00000000"
    end
    return stod(s)


***********************************************************************
static function ctos(datstr)  //dátum string -> yyyymmdd

local dform:=setdateformat()
local lform:=len(dform)
local ldate:=len(datstr)
local y:="",m:="",d:="",n,c,s,lm

    if( lform+2==ldate )
        dform:=strtran(dform,"yy","yyyy")
        lform:=len(dform)
    elseif( lform==ldate+2 )
        dform:=strtran(dform,"yyyy","yy")
        lform:=len(dform)
    end

    lm:=min(lform,ldate)

    for n:=1 to lm
        c:=substr(dform,n,1)
        if( c=="y" )
            y+=substr(datstr,n,1)
        elseif( c=="m" )
            m+=substr(datstr,n,1)
        elseif( c=="d" )
            d+=substr(datstr,n,1)
        end
    next
    
    if( len(y)==2 )
        y:=if(y<"54","20","19")+y
    end

    return y+m+d
    
    
***********************************************************************
function _clp_dtoc(dat)

local s,y,m,d
local dform

    if( empty(dat) )
        return _date_emptycharvalue() 
    end

    s:=dtos(dat)
    dform:=setdateformat()
 
    if( __setcentury() )
        dform:=strtran(dform,"yyyy",left(s,4))
    else
        dform:=strtran(dform,"yy",substr(s,3,2))
    end
    
    dform:=strtran(dform,"mm",substr(s,5,2))
    dform:=strtran(dform,"dd",substr(s,7,2))
    
    return dform



***********************************************************************
function _date_emptycharvalue() 
local dform:=setdateformat()
    dform:=strtran(dform,"y"," ")
    dform:=strtran(dform,"m"," ")
    dform:=strtran(dform,"d"," ")
    return dform


***********************************************************************
function _date_templatestring() 
local dform:=setdateformat()
    dform:=strtran(dform,"y","9")
    dform:=strtran(dform,"m","9")
    dform:=strtran(dform,"d","9")
    return dform


***********************************************************************
    
