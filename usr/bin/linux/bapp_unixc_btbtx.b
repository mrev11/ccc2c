#!/bin/bash
. $CCCDIR/usr/bin/linux/__unix.b
export BUILD_LIB=ccc2_btbtx,ccc2_btbtxui,ccc2,ccc2_uic

build.exe "$@"
 