@echo off

: 1) egyszer� listener ssl n�lk�l
:jtlisten 127.0.0.1:46000  python test-alert.py
 
: 2) egyszer� listener ssl forwardinggal (kell hozz� a server.pem fil�)
:jtlisten 46000 sslforward.exe python test-alert.py -jtdebug

 
:3) �n�ll� program ind�t�s 
python test-alert.py -jtauto


:4) sokszori ind�t�s jtstart-tal
:start /b jtstart python test-alert.py
 

 

