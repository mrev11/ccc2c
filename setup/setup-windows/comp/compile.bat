@echo off 
:: egyesevel fordit
echo comp %1
c++ -c -O0 -DMINGW -D_CCC_ -D_CCC2_ -DWIN32 -DWINDOWS -DMULTITHREAD -funsigned-char -mms-bitfields -I . -I %CCCDIR%\usr\include %1
