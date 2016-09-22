
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


//----------------------------------------------------------------------------
void _clp_sat(int argno) //compatibility
{
    _clp_at(argno);
}

#ifdef NOT_DEFINED
    olyan f�ggv�ny, mint at(), 
    de megadhat�, hogy honnan kezdje a keres�st 

    result:=sat(c,txt,n)

    txt n-edik karakter�t�l keresi c els� el�fordul�s�t,
    result>=n, ha c megtal�lhat� txt-ben,
    result=0, ha c nincs txt-ben
    
    A CCC3-ban nincs sat (felesleges), mivel az at kieg�sz�lt 
    egy harmadik param�terrel, ami �gy bet�lti sat szerep�t is.
    A CCC2-be is �t lett hozva a 3 param�teres at.
    A kompatibilit�s �rdek�ben CCC2-ben megmarad a sat is.
#endif

//----------------------------------------------------------------------------
