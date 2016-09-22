@echo off

:futtatashoz szukseges
set CCC_AUTOCACHE=c:\autocache


:ha nincs kesz exe, ujralinkel
:del %CCC_AUTOCACHE%\*.exe


:CCC_AUTOCACHE nelkul nem fut
:set CCC_AUTOCACHE=


xbrwarr.exe
