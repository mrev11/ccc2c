A ccctools directoryban azok a programok vannak,
amik a standard CCC ford�t�sban haszn�latosak:

build:
    Vez�rli a ford�t�st, projekt gener�tor �s make egyben.

ccomp:
    A MinGW eszk�z�k nem tudj�k a param�tereiket egy fil�b�l
    beolvasni (@parfile). UNIX-on erre nincs is sz�ks�g, �m
    a Windowsos shell gyatra. A hi�ny p�tl�s�ra szolg�l ccomp.

mklink:
    Az exe fil�khez csin�l egy exe n�lk�li symlinket,
    �gy UNIX-on �s Windowson is el�g a kiterjeszt�s n�lk�li
    nevet g�pelni.

pack:
    CCC zip csomagot k�sz�t� programok:
    copyright - mindenhova be�rja az LGPL licenszet
    datename - a fil�nevet kieg�sz�ti a d�tummal
    pack-ccc2 - �sszegy�jti a csomagoland� fil�ket

ppo2cpp:
    Clipper (ppo) --> C++ ford�t�.

prg2ppo:
    A Clipper preprocesszor CCC-s v�ltozata.
   
removecr:
    Leszedi a sorok v�g�r�l a CR-et. A Flex �s a Bison nem
    m�k�dik CR-eket tartalamz� fil�kkel.   

 