@echo off
call bapp_w320 -ldbaseiii

copy  obj%CCCBIN%\*.lib %CCCDIR%\usr\lib\%CCCBIN%

 