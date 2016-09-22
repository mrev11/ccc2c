#!/bin/bash
export OREF_SIZE=8000000
export LIST=z.exe

if [ $CCC_TERMINAL == "term" ]; then
  savex.exe "$@"  '@savex.par'
else
  savex.exe "$@"  '@savex.par' &
fi
 