
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


static int key2[]={
    //ctrl_up -> alt_pgdn
    397,401, 26,  2, 29, 23, 31, 30,408,416,411,413,407,415,409,417,

    //alt keys
    286,304,302,288,274,289,290,291,279,292,293,294,306,305,280,281,272,275,287,276,278,303,273,301,277,300,

    //function
     28, -1, -2, -3, -4, -5, -6, -7, -8, -9,-40,-41,
    -10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-42,-43,
    -20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-44,-45,
    -30,-31,-32,-33,-34,-35,-36,-37,-38,-39,-46,-47,0
};



static int key3[]={
    //ctrl_up -> alt_pgdn
    -121,-122,-123,-124,-125,-126,-127,-128,-131,-132,-133,-134,-135,-136,-137,-138,

    //alt keys
    -1, -2, -3, -4, -5, -6, -7, -8, -9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,

    //function
    -201,-202,-203,-204,-205,-206,-207,-208,-209,-210,-211,-212,
    -301,-302,-303,-304,-305,-306,-307,-308,-309,-310,-311,-312,
    -401,-402,-403,-404,-405,-406,-407,-408,-409,-410,-411,-412,
    -501,-502,-503,-504,-505,-506,-507,-508,-509,-510,-511,-512,0
};


static inthash hash_inkey32(512,key3,key2);
static inthash hash_inkey23(512,key2,key3);



int convtab_inkey2_to_inkey3(int key2)
{
    int key3=hash_inkey23.getx(key2);
    extern int convtab_lat2ucs(int);
    return convtab_lat2ucs(key3);
}


int convtab_inkey3_to_inkey2(int key3)
{
    int key2=hash_inkey32.getx(key3);
    extern int convtab_ucs2lat(int);
    return convtab_ucs2lat(key2);
}










