@echo off
del error 2>nul

call bapp_w32_ 
move ccomp.exe %CCCDIR%\usr\bin\%CCCUNAME%