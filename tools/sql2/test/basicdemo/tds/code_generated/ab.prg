//Created by dom2prg 1.3.03


static mutex:=thread_mutex_init()

function localtds.ab.tableEntityNew(connection,tablist)
local parentclid:=connection:__tableentityclass__
local parentname:=classname(parentclid)
local classname:=parentname+".localtds.ab"
local clid
    signal_lock()
    thread_mutex_lock(mutex)
    clid:=classidbyname(classname)
    if( clid==0 )
        clid:=localtds.ab.tableEntityRegister(connection)
    end
    thread_mutex_unlock(mutex)
    signal_unlock()
    return objectNew(clid):initialize(connection,tablist)



static function localtds.ab.tableEntityIni(this,connection,tablist)
local parentclid:=connection:__tableentityclass__
local initmethod:=getmethod(parentclid,"initialize")
    eval(initmethod,this,connection)
    this:tablist:=if(tablist==NIL,{"konto.a=a","konto.b=b"},tablist)
    return this



static function localtds.ab.tableEntityRegister(connection)
local parentclid:=connection:__tableentityclass__
local parentname:=classname(parentclid)
local classname:=parentname+".localtds.ab"
local clid:=classRegister(classname,{parentclid})
local dummy:=objectNew(clid),c,x

local rowclassid
local buffersize
local memocount
local selectlist
local tabjoin
local columnlist:={}
local indexlist:={}
local primarykey:={}
local filterlist:={}

    classMethod(clid,"initialize",{|this,c,t|localtds.ab.tableEntityIni(this,c,t)})
    classMethod(clid,"version",{||"2"})
    classMethod(clid,"__rowclassname__",{||connection:driver+".rowentity.localtds.ab"})
    classMethod(clid,"__rowclassid__",{|t,x|if(rowclassid==NIL,rowclassid:=x,rowclassid)})
    classMethod(clid,"__buffersize__",{|t,x|if(buffersize==NIL,buffersize:=x,buffersize)})
    classMethod(clid,"__memocount__",{|t,x|if(memocount==NIL,memocount:=x,memocount)})
    classMethod(clid,"__selectlist__",{|t|if(selectlist==NIL,selectlist:=eval(getmethod(parentclid,"__selectlist__"),t),selectlist)})
    classMethod(clid,"__tabjoin__",{||tabjoin})
    classMethod(clid,"__indexlist__",{|this|indexlist})
    classMethod(clid,"__primarykey__",{||primarykey})
    classMethod(clid,"__filterlist__",{||filterlist})
    classMethod(clid,"columnlist",{||columnlist})

    aadd(columnlist,c:=dummy:__columndefnew__("id_a",'a.id',"N4"))
    aadd(columnlist,c:=dummy:__columndefnew__("name",'name',"C10"))
    aadd(columnlist,c:=dummy:__columndefnew__("datum",'datum',"D"))
    aadd(columnlist,c:=dummy:__columndefnew__("flag",'flag',"L"))
    aadd(columnlist,c:=dummy:__columndefnew__("val_a",'a.value',"N19.2"))
    aadd(columnlist,c:=dummy:__columndefnew__("id_b",'b.id',"N4"))
    aadd(columnlist,c:=dummy:__columndefnew__("val_b",'b.value',"N6"))

    tabjoin:='a full join b on a.id=b.id'


    aadd(filterlist,{"select","",""})
    classMethod(clid,"select",{|this,bnd,lck|this:__select__(,,bnd,lck)})
    aadd(filterlist,{"selord",,'a.id'})
    classMethod(clid,"selord",{|this,bnd,lck|this:__select__(,'a.id',bnd,lck)})

    dummy:__registerrowentityclass__
    return clid
