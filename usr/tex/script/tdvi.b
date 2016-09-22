#!/bin/bash

FNAME=`basename $1 .tex`

if test -f $FNAME.tex; then 
    
    mkdir dvi 2>/dev/null

    cwi2lat.exe  <$SCRIPT/setdvi.tex     >dvi/$FNAME.tmp
    
    if test -f $2; then
        cwi2lat.exe  <$2                >>dvi/$FNAME.tmp
    fi

    echo '\begin{document}'             >>dvi/$FNAME.tmp
    cwi2lat.exe  <$FNAME.tex            >>dvi/$FNAME.tmp
    echo '\end{document}'               >>dvi/$FNAME.tmp

    cd dvi

    latex $FNAME.tmp
    
    if test -f $FNAME.dvi; then
        rm $FNAME.tmp
        dvips $FNAME.dvi 
        
        if ! test -f dview; then
            $SCRIPT/dview.b  $FNAME.dvi &
        fi

    else
        echo 'NO OUTPUT'
    fi

    cd ..
 
else
    echo 'Usage: t FILE.TEX'
fi    

