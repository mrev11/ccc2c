

#include "pushbutton.say"


function main()
    pushbutton({|*|load(*)},{|*|readmodal(*)},{||.t.})


function load(getlist)

    g_push:varput("<EztNyomdMeg>")

    g_push:execblock:= {|| alert("Pr�ba Szerencse",{"Kil�p","Marad"})>1 }
    // ha az execblock empty-t ad vissza, akkor a maszk kil�p

    getlist::aeval({|g|g:display})











