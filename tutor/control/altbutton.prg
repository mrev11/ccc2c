

#include "altbutton.say"

function main()
    altbutton({|*|load(*)},{|*|readmodal(*)},{||.t.})



function load(getlist)
    g_alt:alternatives:="Próba/Szerencse"    
    g_mehet:execblock:={||alert(g_alt:varget)}
    getlist::aeval({|g|g:display})


    