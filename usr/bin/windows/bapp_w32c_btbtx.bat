@echo off
call %cccdir%\usr\bin\%cccuname%\__common
call %cccdir%\usr\bin\%cccuname%\__%cccbin% c

set BUILD_LIB=ccc2_btbtx,ccc2_btbtxui,ccc2,ccc2_uic
 
build %1 %2 %3 %4 %5 %6 %7 %8 %9

 
