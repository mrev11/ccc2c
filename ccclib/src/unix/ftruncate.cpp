
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

#include <cccapi.h>

//----------------------------------------------------------------------------
void _clp_ftruncate(int argno)
{
    CCC_PROLOG("ftruncate",3);

    int fd=_parni(1);
    off_t length=0;

    if( argno==2 ) 
    {
        length = _parnuw(2); 
    }
    else if( argno==3 ) //large file support 
    {
        off_t low,high;
        low    = _parnuw(2); 
        high   = _parnuw(3); 
        length = (high<<32)+low;
    }
    else
    {
        ARGERROR();
    }

    _retni( ftruncate(fd,length) );  //0 OK, -1 error

    CCC_EPILOG();
}

//----------------------------------------------------------------------------
 
