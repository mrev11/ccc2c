#!/bin/bash


pushd tbbtbtx && install.b; popd 

if  test -e ctree/lib/$CCCBIN/libctreestd.a; then

#  Megjegyz�s:
#  A libctreestd.a fil� "mag�t�l" nem l�tezik, hanem egyes
#  esetekben l�tezhet olyan platform specifikus fil�, amit
#  libctreestd.a-ra �tnevezve m�k�dik az install�ci�.

   pushd tbdatidx && install.b; popd 
   pushd tbdbfctx && install.b; popd 
fi

pushd tbwrapper && install.b; popd 

