
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

//C integer types

#ifndef _INTTYPES_H_
#define _INTTYPES_H_

//A t�pusokat a rendszernek megfelel�en kell be�ll�tani �gy, 
//hogy a bit sz�mok egyezzenek, �s v�ltozatlanok maradjanak. 
//A C ford�t�k n�melyike tartalmaz hasonl� tartalm� header f�jlt, 
//de ezek nem szabv�nyosak, �s gyakorlatilag nem lehet k�t egyforma 
//megval�s�t�st tal�lni.

typedef short           c_int16_t;
typedef unsigned short  c_uint16_t;

typedef int             c_int32_t;
typedef unsigned        c_uint32_t;

#endif
