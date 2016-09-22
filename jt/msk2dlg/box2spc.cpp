
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

//eredeti Clipper (CWI) box karakterek cseréje space-re
//enélkül a régi msk-kat nem lehet változatlan formában használni



#include <stdio.h>
#include <string.h>
#include <cccapi.h>
 

static char box[] =
{
    (char)179, (char)180, (char)181, (char)182, (char)183, (char)184, (char)185, (char)186, 
    (char)187, (char)188, (char)189, (char)190, (char)191, (char)192, (char)193, (char)194, 
    (char)195, (char)196, (char)197, (char)198, (char)199, (char)200, (char)201, (char)202, 
    (char)203, (char)204, (char)205, (char)206, (char)207, (char)208, (char)209, (char)210, 
    (char)211, (char)212, (char)213, (char)214, (char)215, (char)216, (char)217, (char)218, 
    (char)176, (char)177, (char)178, (char)219,
    0 
};
 


void _clp_box2spc(int argno)
{
    CCC_PROLOG("box2spc",1);
    
    int len=_parclen(1);
    char *p=_parc(1);
    char *q=stringl(len);  //TOP
    
    for( int i=0; i<len; i++ )  
    {
        unsigned char c=*(p+i);

        if( strchr(box,c) )
        {
            c=' ';
        }

        *(q+i)=c;
    }
    
    _rettop();

    CCC_EPILOG();
}

