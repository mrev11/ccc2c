
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
#include <string.h>
#include <cccapi.h>

//----------------------------------------------------------------------
void _clp___gpf(int argno)
{
    CCC_PROLOG("__gpf",0);
    
    char *txt=NULL;
    int  c=*txt;

    printf("\nNULL pointer haszn�lat GPF sz�nd�kos el�id�z�se c�lj�b�l!");
    fflush(0);
    printf("%d",c);
    fflush(0);
    
    _ret();
    CCC_EPILOG();
}


//----------------------------------------------------------------------
