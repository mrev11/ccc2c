@echo off
del error 2>nul

call bapp_w32_ 
:Windowson nem tudja magát felülírni
copy build.exe %CCCDIR%\usr\bin\%CCCUNAME%
del build.exe