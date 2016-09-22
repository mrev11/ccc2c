A ccctools directoryban azok a programok vannak,
amik a standard CCC fordításban használatosak:

build:
    Vezérli a fordítást, projekt generátor és make egyben.

ccomp:
    A MinGW eszközök nem tudják a paramétereiket egy filébõl
    beolvasni (@parfile). UNIX-on erre nincs is szükség, ám
    a Windowsos shell gyatra. A hiány pótlására szolgál ccomp.

mklink:
    Az exe filékhez csinál egy exe nélküli symlinket,
    így UNIX-on és Windowson is elég a kiterjesztés nélküli
    nevet gépelni.

pack:
    CCC zip csomagot készítõ programok:
    copyright - mindenhova beírja az LGPL licenszet
    datename - a filénevet kiegészíti a dátummal
    pack-ccc2 - összegyûjti a csomagolandó filéket

ppo2cpp:
    Clipper (ppo) --> C++ fordító.

prg2ppo:
    A Clipper preprocesszor CCC-s változata.
   
removecr:
    Leszedi a sorok végérôl a CR-et. A Flex és a Bison nem
    mûködik CR-eket tartalamzó filékkel.   

 