#!/bin/bash


pushd tbbtbtx && install.b; popd 

if  test -e ctree/lib/$CCCBIN/libctreestd.a; then

#  Megjegyzes:
#  A libctreestd.a file "magatol" nem letezik, hanem egyes
#  esetekben letezhet olyan platform specifikus file, amit
#  libctreestd.a-ra atnevezve mukodik az installacio.

   pushd tbdatidx && install.b; popd 
   pushd tbdbfctx && install.b; popd 
fi

pushd tbwrapper && install.b; popd 

