
static x:=0
static y:=0

#include "color.say"



********************************************************************************
function main()
    editmask()


********************************************************************************
static function editmask()
local bload:={|*|load(*)}
local bread:={|*|readmodal(*)}
local bstore:={||.t.}
local msk:=mskCOLORcreate(bLoad,bRead,bStore)
    mskReplace(msk,x+=2,y+=2)
    mskLoop(msk)
    return lastkey()


********************************************************************************
static function load(getlist)
    g_push:varput("<EztNyomdMeg>")
    g_push:execblock:= {||editmask(),.t.}
    // ha az execblock empty-t ad vissza, akkor a maszk kil�p


    g_get1:varput("Holnap lesz f�c�n.")
    g_get2:varput("Vanaki forr�n szereti.") ;g_get2:bright:=.t.
    g_get3:varput("Meggyv�g�.")             ;g_get3::get.behave_as_label
    g_get4:varput("Feny�pinty.")            ;g_get4:bright:=.t.; g_get4::get.behave_as_label

    g_lab1:varput("Rozsdafark�")
    g_lab2:varput("Pr�ba szerencse")        ;g_lab2:bright:=.t.

    getlist::aeval({|g|g:display})


********************************************************************************






