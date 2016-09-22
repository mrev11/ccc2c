@echo off

:Ha ezeket megtartod:
:
:  d.bat
:  xddict.dbf
:  xddict.dbm
:
:‚s minden m st let”r”lsz,
:akkor d.bat elind¡t s val
:‚s a ddict2 beli programgener l ssal
:minden £jra elk‚sz¡thet“

ddict2 . xddict /s-
bapp_w32c -lxddict
