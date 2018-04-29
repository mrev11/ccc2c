
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
#include <charconv.ch>
#include <chartab.h>

//---------------------------------------------------------------------
char *charconv_selecttab(int tab)
{
    switch( tab )
    {
        case CHARTAB_CCC2CWI      : return chartab_ccc2cwi;
        case CHARTAB_CWI2CCC      : return chartab_cwi2ccc;
        case CHARTAB_CCC2LAT      : return chartab_ccc2lat;
        case CHARTAB_LAT2CCC      : return chartab_lat2ccc;
        case CHARTAB_CCC2WIN      : return chartab_ccc2win;
        case CHARTAB_LOWER2UPPER  : return chartab_lower2upper;  //ékezetes!
        case CHARTAB_UPPER2LOWER  : return chartab_upper2lower;  //ékezetes! 
        default                   : return NULL;
    }
}    

//---------------------------------------------------------------------

