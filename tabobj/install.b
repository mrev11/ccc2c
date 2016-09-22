#!/bin/bash


pushd tbbtbtx && install.b; popd 

if  test -e ctree/lib/$CCCBIN/libctreestd.a; then

#  Megjegyzés:
#  A libctreestd.a filé "magától" nem létezik, hanem egyes
#  esetekben létezhet olyan platform specifikus filé, amit
#  libctreestd.a-ra átnevezve mûködik az installáció.

   pushd tbdatidx && install.b; popd 
   pushd tbdbfctx && install.b; popd 
fi

pushd tbwrapper && install.b; popd 

