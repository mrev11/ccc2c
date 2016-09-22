
function _getnew(var,name,pict,valid,when)
local g:=getnew(row(),col(),{|x|if(x==NIL,var,var:=x)},name,pict)

    if( valtype(valid)=="B" )
        g:postBlock:=valid
    end

    if( valtype(when)=="B" )
        g:preBlock:=when
    end

    return g
