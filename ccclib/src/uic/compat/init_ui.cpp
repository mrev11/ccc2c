
#include <locale.h>
#include <stdio.h>
#include <string.h>
#include <cccapi.h>

extern void initialize_terminal();
extern void setcaption(char*,int);



void _clp_init_ui(int argno)
{
    CCC_PROLOG("init_ui",0);


    if( !setlocale(LC_CTYPE,"") )
    {
        //fprintf(stderr,"setlocale failed\n");
    }



    initialize_terminal();
    setcaption(ARGV[0],strlen(ARGV[0]));

    stringnb("");_clp_qqout(1);pop();


    CCC_EPILOG();
}

