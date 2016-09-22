
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

//V�ltoz�t�bl�k m�ret�nek �s szem�tgy�jt�s param�tereinek fel�l�r�sa:
//
//Ezt a f�ggv�nyt vartab_ini h�vja meg az objektumt�r inicializ�l�sakor.
//Ha a f�ggv�ny t�rzse �res, akkor a variable.cpp-ben defini�lt default
//m�retekkel j�nnek l�tre a v�ltoz�t�bl�k, �s a default �rt�kekkel fog
//m�k�dni a szem�tgy�jt�s. Ha ezt egy alkalmaz�s meg akarja v�ltoztatni,
//akkor a jelen forr�sb�l lok�lisan m�solatot kell csin�lni, �s a
//kikommentezett sorokat visszat�ve be�ll�that�k a k�v�nt �rt�kek.

#include <cccapi.h>

//-------------------------------------------------------------------
void vartab_setsize( struct VARTAB_SETSIZE *vss )
{
   // *vss->oref_size=40000;
   // egyszerre ennyi objektum lehet a CCC programban

   // *vss->vref_size=5000;
   // egyszerre ennyi referencia szerint �tadott v�ltoz� lehet

   // *vss->alloc_count=40000;
   // ha az utols� szem�tgy�jt�s ut�n gy�rtott objektumok sz�ma
   // t�ll�pi alloc_count-ot, akkor beindul a szem�tgy�jt�s

   // *vss->alloc_size=0x200000L; //2MB
   // ha az utols� szem�tgy�jt�s ut�n gy�rtott objektumok �sszm�rete
   // t�ll�pi alloc_size-ot, akkor beindul a szem�tgy�jt�s
}

//-------------------------------------------------------------------

