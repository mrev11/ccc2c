
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

static int lat[]={
    245,251,
    213,219,
    //box
    182,191,164,172,
    178,179,206,181,183,165,207,180,177,
    186,188,174,190,192,171,187,189,173,
    198,195,175,185,203,168,202,197,169,
    199,194,176,184,204,166,200,196,170,
    //tail
    254,249,159,157,0};

static int ucs[]={
    337,369,
    336,368,
    //box
    9472,9552,9474,9553,
    9492,9524,9496,9500,9532,9508,9484,9516,9488,
    9562,9577,9565,9568,9580,9571,9556,9574,9559,
    9561,9576,9564,9567,9579,9570,9555,9573,9558,
    9560,9575,9563,9566,9578,9569,9554,9572,9557,
    //tail
    0x2588,0x2593,0x2592,0x2591,0};


static inthash hash_lat2ucs(256,lat,ucs);
static inthash hash_ucs2lat(256,ucs,lat);


int convtab_lat2ucs(int lat)
{
    return hash_lat2ucs.getx(lat);
}


int convtab_ucs2lat(int ucs)
{
    return hash_ucs2lat.getx(ucs);
}


