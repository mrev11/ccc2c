@echo off
call bapp_w320  -d. -dwindows -d../sckutil -lccc2_sslsocket

copy obj%cccbin%\*.lib  %cccdir%\usr\lib\%cccbin%
