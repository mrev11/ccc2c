
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

 
#include <stdio.h>
#include <unistd.h>
#include <inkey.ch>

extern int readkey();
extern int readkey__called_from_learnkey;


struct KEYMAP
{
  char const *name;
  int code;
} keymap[]={ 

{"K_ALT_UP      ",K_ALT_UP      },
{"K_ALT_DOWN    ",K_ALT_DOWN    },
{"K_ALT_LEFT    ",K_ALT_LEFT    },
{"K_ALT_RIGHT   ",K_ALT_RIGHT   },
{"K_ALT_HOME    ",K_ALT_HOME    },
{"K_ALT_END     ",K_ALT_END     },
{"K_ALT_PGUP    ",K_ALT_PGUP    },
{"K_ALT_PGDN    ",K_ALT_PGDN    },

{0,0}};

//---------------------------------------------------------------------------
int main(int argc, char**argv)
{
    readkey__called_from_learnkey=1;

    int i=0;
    while( 1 )
    {
        if( keymap[i].name==0 )
        {
            return 0;
        }

        printf("%s",keymap[i].name);
        fflush(0);
        while( 0==readkey() );
        printf(",%d\n",keymap[i].code);

        i++;
    }
}

//---------------------------------------------------------------------------



