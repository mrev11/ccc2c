
/*
 *  CCC - The Clipper to C++ Compiler
 *  Copyright (C) 2005 ComFirm BT.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

//#define CURSES        // ncurses hivassal
#define IOCTL         // ioctl hivassal
//#define CTRLSEQ       // escape szekvenciaval

//#define MSGOUT
#include <msgout.h>

//----------------------------------------------------------------------------------------
#ifdef CURSES    // probalom kihagyni az ncurses konyvtarat
//----------------------------------------------------------------------------------------

#if  defined _LINUX_
    #include <ncursesw/ncurses.h>
#elif defined _NETBSD_
    #include <ncursesw/ncurses.h>
    extern "C" int  waddnwstr(WINDOW*,wchar_t*,int);
#elif defined _FREEBSD_
    #include <ncurses/cursesw.h>
    extern "C" int  waddnwstr(WINDOW*,wchar_t*,int);
#else
    #include <ncursesw/ncurses.h>
#endif


void screensize(int *y, int*x)  // lekerdezi a terminal meretet
{
    int wheight=25;
    int wwidth=80;

    initscr();
    getmaxyx(stdscr,wheight,wwidth); // ncurses macro
    endwin();

    *y=wheight;
    *x=wwidth;

    msgout("\nCURSES screensize(%d,%d)\n",*y,*x);        
}

#endif


//----------------------------------------------------------------------------------------
#ifdef  IOCTL // egyszerunek tunik, de mukodik-e mindig
//----------------------------------------------------------------------------------------

#include <unistd.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>


void screensize(int *y, int *x)  // lekerdezi a terminal meretet
{
    struct winsize ws;

    if ( ioctl( 0, TIOCGWINSZ, &ws ) != 0 &&
         ioctl( 1, TIOCGWINSZ, &ws ) != 0 &&
         ioctl( 2, TIOCGWINSZ, &ws ) != 0 )
    {
        fprintf( stderr,"ioctl() failed (%d): %s\n", errno, strerror(errno));

        *y=80;
        *x=25;
    }
    else
    {
        *y=ws.ws_row;
        *x=ws.ws_col;
    }

    msgout("\nIOCTL screensize(%d,%d)\n",*y,*x);        
}

#endif


//----------------------------------------------------------------------------------------
#ifdef CTRLSEQ // vacakolni kell a canonical moddal
//----------------------------------------------------------------------------------------

#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <ctype.h>

static termios set_term(int fd)
{
    termios t0;
    termios t1;

    tcgetattr(fd,&t0); 
    tcgetattr(fd,&t1);

    t1.c_iflag &= 0;
    t1.c_lflag &= ~(ICANON|ECHO);
    tcsetattr(fd,TCSANOW,&t1);

    return t0;
}

static void reset_term(int fd, termios t)
{
    tcsetattr(fd,TCSANOW,&t);
}


//----------------------------------------------------------------------------------------
static int query_term(char *query, char *buffer, unsigned buflen)
{
    int result=0;
    termios t=set_term(1);
    printf("%s\n",query);

    char c=0;
    unsigned len=0;
    while( len<buflen-1 && 1==read(1,&c,1) )
    {
        buffer[len++]=c;
        if( isalpha(c) )
        {
            result=1;
            break;
        }
    }
    buffer[len]=0;
    reset_term(1,t);
    return result;   // 1 sekeres, 0 sikertelen
}


//----------------------------------------------------------------------------------------
void screensize(int *y, int*x)  // lekerdezi a terminal meretet
{
    char query[32];
    char response[32];
    sprintf(query,"%c[18t",27);
    if( query_term(query,response,sizeof(response)) )
    {
        sscanf(response+1, "[8;%d;%dt",y,x);
    }
    else
    {
        *y=25;
        *x=80;
    }
    msgout("\nCTRLSEQ screensize(%d,%d)\n",*y,*x);        
}    

//----------------------------------------------------------------------------------------
#endif


