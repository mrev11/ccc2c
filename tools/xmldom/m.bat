@echo on
call bapp_w320  -lccc2_xmldom
copy obj%CCCBIN%\*.lib  %CCCDIR%\usr\lib\%CCCBIN%
 