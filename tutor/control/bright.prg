


#define DISPLAY aeval(getlist,{|g|g:display})


#include "bright.say"

******************************************************************************************
function main()
    bright({|*|load(*)},{|*|readmodal(*)},{|*|.t.},)
    ?


******************************************************************************************
function load(getlist) 

    ? g_get1:colorspec   
    ? g_lab1:colorspec   

    g_lab1:varput("Egyszer hopp, m�skor kopp.")
    g_lab2:varput("Van, aki forr�n szereti.")
    
    g_get1:varput("Pr�ba szerencse!")
    g_get2:varput("H�ny meggymag megy ma Magyra?")
    g_get3:varput("Mit s�tsz kis sz�cs?")

    g_alt:alternatives("Kutya/Macska/Ny�l")


    g_lab2:bright:=.t.
    g_get2:bright:=.t.
 
    DISPLAY
    
******************************************************************************************

    