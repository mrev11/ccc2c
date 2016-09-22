

************************************************************************
function splitx(txt:="",sep:=if(valtype(txt)=="X",a",",","))
local wlist:={}, n:=1, i

    while( 0<(i:=at(sep,txt,n)) )
        aadd(wlist,txt[n..i-1])
        n:=i+len(sep)
    end

    //ha van maradék, azt még hozzáadjuk
    //a "" (üres) stringet nem adjuk hozzá

    if( len(txt)>=n )
        aadd(wlist,txt[n..])
    end
    return wlist

************************************************************************
