@echo off
call bapp_w320 -lccc2_crypto
copy obj%CCCBIN%\*.lib  %CCCDIR%\usr\lib\%CCCBIN%
 
 