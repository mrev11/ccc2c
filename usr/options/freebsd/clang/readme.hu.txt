----------------------------------------------------------------------------
CLANG <-> GCC ford�t�si opci�k 

  Meg kell csin�lni az al�bbi linkek egyik�t
    ln -s compile-gcc.opt compile.opt 
        vagy
    ln -s compile-clang.opt compile.opt 
 
  clang optimaliz�l�s
    -O2-t kell haszn�lni 

    Az -O4-es objecteket csak az LLVM linker�vel lehetne linkelni
    (ami linkel�s k�zben optimaliz�l), az ld nem ismeri a form�tumot.
    -O2-es objecteket a r�gi (c++/ld) linkerrel is lehet linkelni.

  clang warningok (gcc nem ismeri)
    -Wno-empty-body
    -Wno-constant-logical-operand
    -Wno-invalid-source-encoding  (sz�lna pl. a dobozrajzol�k miatt)   

----------------------------------------------------------------------------
Linkel�s FreeBSD-n

1)  libdl.so

  FreeBSD-ben nincs libdl.so.


2)  -rpath  (r�gen kellett, most nem)

  FreeBSD-ben a linkernek meg kell adni az

  -rpath $CCCDIR/usr/lib/$CCCBIN  
    
  opci�t. A k�rnyezeti v�ltoz�k helyettes�t�s�t az envsubst
  programmal lehet elv�gezni, pl:
    
  cat $CCCDIR/usr/options/$CCCBIN/link.opt | envsubst >>$RSPLNK
    
----------------------------------------------------------------------------
