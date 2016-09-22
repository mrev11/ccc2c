@echo off
call bapp_w32_.bat @parfile.bld -bccc3_xmldom
cp -pf obj$CCCBIN/*.lib  $CCCDIR/usr/lib/$CCCBIN


