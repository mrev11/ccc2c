

#include "alt.say"

function main()
    alt({|*|load(*)},{|*|readmodal(*)},{||.t.})



function load(getlist)
    g_alt:alternatives:="Pr�ba/Szerencse"    
    g_mehet:execblock:={||alert(g_alt:varget)}
    getlist::aeval({|g|g:display})