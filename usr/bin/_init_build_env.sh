#!/bin/bash
#set -x

. _cpp_version.sh

lptadd() #vegere
{
    ADD="$1"
    X=$(echo ";$BUILD_LPT;" | sed  "s^;${ADD};^;^")
    X="$X;${ADD}"
    X=$(echo "$X" | sed  "s^;;^;^")
    X=$(echo "$X" | sed  "s^;;^;^")
    export BUILD_LPT="$X"
}

addlpt() #elejere
{
    ADD="$1"
    X=$(echo ";$BUILD_LPT;" | sed  "s^;${ADD};^;^")
    X="${ADD};$X"
    X=$(echo "$X" | sed  "s^;;^;^")
    X=$(echo "$X" | sed  "s^;;^;^")
    export BUILD_LPT="$X"
}

export BUILD_OBJ=object
export BUILD_BAT=$CCCDIR/usr/build
export BUILD_OPT=compile.opt
export BUILD_INC=$CCCDIR/usr/include

lptadd $CCCDIR/usr/lib

if [ ${CCCUNAME} == "linux" ]; then

    lptadd /usr/local/lib
    lptadd /usr/lib
    lptadd /lib

elif [ ${CCCUNAME} == "termux" ]; then
    # Android Termux
    lptadd $PREFIX/lib

elif [ ${CCCUNAME} == "raspi" ]; then
    # Raspberry Pi
    lptadd /usr/lib/arm-linux-gnueabihf
    lptadd /usr/local/lib
    lptadd /usr/lib
    lptadd /lib

elif [ ${CCCUNAME} == "freebsd" ]; then
    lptadd /usr/local/lib
    lptadd /usr/lib
    lptadd /lib

elif [ ${CCCUNAME} == "netbsd" ]; then
    lptadd /usr/pkg/lib
    lptadd /usr/lib
    lptadd /lib

elif [ ${CCCUNAME} == "solaris" ]; then
    lptadd /usr/lib/amd64
    lptadd /usr/lib
    lptadd /lib

elif [ ${CCCUNAME} == "msys2" ]; then
    # Windows
    lptadd ${MSYS64}${MSYSTEM_PREFIX}/lib

else
    echo CCCUNAME environment variable not set!
    exit 1
fi

if [ -n "" ];then
    # debug
    echo @@@ BUILD_LPT $BUILD_LPT 
    echo @@@ BUILD_BAT $BUILD_BAT 
    echo @@@ BUILD_OPT $BUILD_OPT 
    echo @@@ BUILD_INC $BUILD_INC 
    echo @@@ BUILD_OBJ $BUILD_OBJ 
    echo @@@ BUILD_EXE $BUILD_EXE 
fi

