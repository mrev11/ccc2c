
// libcat
//
// Ez egy linkert helyettesito utility.
// Igazi linkeles helyett csak osszecsomagolja
// a statikus linkeleshez szukseges komponenseket,
// amikkel indulaskor a program automatikusan
// osszelinkelodik:
//
// [1] autolink.exe  : elindul -> linkel ->  exec
// [2] rsplink       : a linkelest leiro script
// [3] OBJECT-1      : elso object
// [4] OBJECT-2      : masodik object
//
//  stb. (lib vagy obj mindegy)

#command ?  [ <list,...> ]   => outerr( <list>, chr(10))
#command ?? [ <list,...> ]   => outerr( <list> )

#command !?  [ <list,...> ]  => outerr( <list>, chr(10)) ;outstd( <list>, chr(10))
#command !?? [ <list,...> ]  => outerr( <list> )         ;outstd( <list> )


#include "fileio.ch"

static delimeter:=replicate(a"zxcvbnm",10)

***********************************************************************************
function main(rsplink)

local fd:=fopen(rsplink,FO_READ)
local rl:=readlineNew(fd),ln,op
local out,fdout
local rsp:=a""
local objdir:="obj"+getenv("CCCBIN")
local object:={},n
local autolink

    errorlevel(1) //ha nem tud lefutni, ez marad

    if(fd<0)
        ? "cannot read rsplink file", rsplink
        quit
    end

    if( file(autolink()) )
        autolink:=memoread(autolink(),.t.)
        if( empty(autolink) )
            ? "cannot read", autolink()
            quit
        else
            !? "use:", autolink()
        end

    elseif( file(defautolink())  )
        autolink:=memoread(defautolink(),.t.)
        if( empty(autolink) )
            ? "cannot read", defautolink()
            quit
        else
            !? "use:", defautolink()
        end

    else
        ? "no autolink.exe or CCC_AUTOLINK variable not set"
        quit
    end
   
    ln:=rl:readline 
    while( ln!=NIL )
        if( ln[1..2]==a"-o" )
            out:=ln[4..]
            out::=strtran(x"0d",x"")
            out::=strtran(x"0a",x"")
            out::=alltrim
            rsp+=a"-o EXECUTABLE"+x"0d0a"

        elseif( at(objdir,ln)==1 )
            //az objdirben levo objecteket es libeket
            //kell belepakkolni az autolinkes exebe 

            ln::=strtran(x"0d",x"")
            ln::=strtran(x"0a",x"")
            aadd(object,memoread(ln,.t.))
            if( atail(object)::empty )
                ? "cannot read object or library file", ln
                quit
            end
            rsp+=a"OBJECT-"+object::len::str::alltrim::str2bin+x"0d0a"

        elseif( ln[1]==a".")
            //atnyulkalas helyett abszolut path
            ln:=dirname()+dirsep()+ln
            rsp+=ln

        else
            rsp+=ln
        end
        ln:=rl:readline 
    end
    rsp::=strtran(a"\",a"/")
    
    fdout:=fopen(out,FO_CREATE+FO_TRUNCATE+FO_READWRITE)

    if( fdout<0 )
        ? "cannot write to", out, "errno", ferror()
        quit
    end
    
    fwrite(fdout,autolink)          //[1] autolink
    fwrite(fdout,delimeter)
    fwrite(fdout,rsp)               //[2] rsplink
    for n:=1 to len(object)
        fwrite(fdout,delimeter)
        fwrite(fdout,object[n])     //[n+2] object-n
    next

    chmod(out,0b111101101)
    
    errorlevel(0)


***********************************************************************************
function autolink() //ez kerul a csomag elejere
    return getenv("CCC_AUTOLINK")

***********************************************************************************
function defautolink()  //ez kerul a csomag elejere
static cccdir:=getenv("CCCDIR")+dirsep()
static usrbin:="usr"+dirsep()+"bin"+dirsep()+getenv("CCCUNAME")+dirsep()
    return cccdir+usrbin+"autolink.exe"


***********************************************************************************

    