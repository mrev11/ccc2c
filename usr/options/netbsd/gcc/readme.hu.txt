Linkel�s FreeBSD-n

1)  libdl.so

  FreeBSD-ben nincs libdl.so.


2)  -rpath

  FreeBSD-ben a linkernek meg kell adni az

  -rpath $CCCDIR/usr/lib/$CCCBIN  
    
  opci�t. A k�rnyezeti v�ltoz�k helyettes�t�s�t az envsubst
  programmal lehet elv�gezni, pl:
    
  cat $CCCDIR/usr/options/$CCCBIN/link.opt | envsubst >>$RSPLNK
    
