@echo off
del error 2>nul

call bapp_w32_ 
:Windowson nem tudja mag�t fel�l�rni
copy build.exe %CCCDIR%\usr\bin\%CCCUNAME%
del build.exe