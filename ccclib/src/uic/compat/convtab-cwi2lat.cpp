
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

#include <inthash.h>

static int cwi[]={
    160, 130, 161, 162, 148, 147, 244, 163, 129, 150,     
    143, 144, 140, 141, 149, 153, 167, 212, 151, 154, 152, 0};

static int lat[]={
    225, 233, 237, 243, 246, 245, 245, 250, 252, 251,
    193, 201, 205, 205, 211, 214, 213, 213, 218, 220, 219 ,0};


static inthash hash_cwi2lat(256,cwi,lat);

int convtab_cwi2lat(int cwi)
{
    return cwi;
    return hash_cwi2lat.getx(cwi);
}

