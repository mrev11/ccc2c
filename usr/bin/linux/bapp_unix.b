#!/bin/bash
. $CCCDIR/usr/bin/linux/__unix.b
export BUILD_LIB=ccc2,ccc2_uid
build.exe "$@"

