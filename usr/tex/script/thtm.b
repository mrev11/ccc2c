#!/bin/bash

BROWSER=firefox
#BROWSER=mozilla

FNAME=`basename $1 .tex`

if test -f $FNAME.tex; then 

    mkdir html 2>/dev/null

    cwi2lat.exe  <$SCRIPT/sethtm.tex      >html/$FNAME.tmp

    if test -f $2; then
        cwi2lat.exe  <$2                 >>html/$FNAME.tmp
    fi

    echo         '\begin{document}'      >>html/$FNAME.tmp
    echo         '\beforeany'            >>html/$FNAME.tmp
    cwi2lat.exe   <$FNAME.tex            >>html/$FNAME.tmp
    echo         '\afterany'             >>html/$FNAME.tmp
    echo         '\end{document}'        >>html/$FNAME.tmp

    cd html
    
    latex $FNAME.tmp

    if test -f $FNAME.toc; then 
       mv $FNAME.toc $FNAME.toc1
       toc2lat.exe <$FNAME.toc1 >$FNAME.toc
       rm $FNAME.toc1 
    fi

    cat <$SCRIPT/head.html >$FNAME.html    
    tth -v -L$FNAME <$FNAME.tmp 2>outtth | tth2htm.exe >>$FNAME.html 
    cat <$SCRIPT/foot.html >>$FNAME.html    
 
    rm $FNAME.tmp
    rm $FNAME.dvi

    if ! $BROWSER -remote "openFile($(pwd)/$FNAME.html)"  >/dev/null 2>&1 ; then
        $BROWSER file://$(pwd)/$FNAME.html  >/dev/null 2>&1 &
    fi

    cd ..
 
else
    echo 'Usage: t FILE.TEX'
fi    

 