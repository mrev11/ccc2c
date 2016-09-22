
function beep()
function computername(); return "456" 
function console_type(); return "CONSOLE" 
function getkey(w); return inkey(w)
function refreshscrn()
function remote_console(); return "Y" 
function workstatid(); return "123"
function _setsl_incremental(); return .t.


**************************************************************************************
function defaultwindowcaption(c)
static caption:=NIL
local  prevcap:=if(caption==NIL,"",caption)
    if( c==NIL )
        return if(caption==NIL,exename(),caption)
    elseif( valtype(c)=="C" )
        caption:=if(c=="",NIL,c)
    end
    return prevcap


**************************************************************************************
function settermcaption( x:=defaultwindowcaption() )
    return setcaption(x)


**************************************************************************************
