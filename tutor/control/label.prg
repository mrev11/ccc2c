

#include "label.say"

******************************************************************************************
function main()
    label({|*|load(*)},{|*|readmodal(*)},{||.t.})


******************************************************************************************
function load(getlist)
    g_get1:varput("Some Like It Hot")
    g_lab:varput("Marilyn Monroe")
    g_lab:fgcolor:="rg+"
    g_push:execblock:={||push(getlist)}
    aeval(getlist,{|g|g:display})


******************************************************************************************
function push(getlist)
local text:=g_get1:varget
    g_lab:varput(text)
    g_lab:display
    return .t. // do not exit


******************************************************************************************











