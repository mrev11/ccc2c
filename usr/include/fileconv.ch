
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

#ifndef _FILECONV_CH_
#define _FILECONV_CH_

// Windows<->UNIX konverzi�s flagek
// Clipper-be �s C-be is inklud�l�dik
 
//----------------------------------------------------------------------------
// convertfspec2nativeformat-hoz val� flagek
// convertfspec2nativeformat() mindig megh�v�dik, 
// amikor fil�nevet adunk �t az os-nek
//----------------------------------------------------------------------------
 
#define DOSCONV_BS2SLASH         1  // bslash -> slash
#define DOSCONV_DRIVE2PATH       2  // drive: -> megadott path
#define DOSCONV_FNAME2LOWER      4  // a fil�nevet kisbet�re
#define DOSCONV_FNAMERTRIM       8  // a fil�nevet trimeli
#define DOSCONV_PATH2LOWER      16  // a path-t kisbet�re
#define DOSCONV_ENCODEFNAME     32  // �kezetes bet�k �tk�dol�sa a fil�n�vben
#define DOSCONV_ENCODEPATH      64  // �kezetes bet�k �tk�dol�sa a pathban
#define DOSCONV_FNAMETO8PLUS3  128  // fil�n�v csonkol�sa 8+3 alak�ra
#define DOSCONV_PATHTO8PLUS3   256  // a path elemeinek csonkol�sa 8+3 alak�ra
#define FDOSCONV_ALL           511

// csak a k�vetkez�k t�mogatottak:
// DOSCONV_BS2SLASH, DOSCONV_FNAMERTRIM,  
// DOSCONV_FNAME2LOWER, DOSCONV_PATH2LOWER 


//----------------------------------------------------------------------------
// directory() m�k�d�s�t szab�lyoz� flag-ek
//----------------------------------------------------------------------------
 
#define DOSCONV_FNAME_UPPER    512  // directory() nagybet�s�ti a fil�neveket
#define DOSCONV_FSPEC_ASTERIX 1024  // directory() a *.*-ot lecser�li *-ra
#define DDOSCONV_ALL          1536

//----------------------------------------------------------------------------
// fopen(), fcreate() m�k�d�s�t szab�lyoz� flag-ek
//----------------------------------------------------------------------------
 
#define DOSCONV_SPECDOSDEV    2048  // DOS eszk�z�k (LPTn, PRN, CON, null)
#define DOSCONV_FILESHARE     4096  // exclusive/shared m�d emul�l�s
#define ODOSCONV_ALL          6144

// getenv(), setenv(), putenv() m�k�d�s�t szab�lyoz� flag-ek

#define DOSCONV_ENVVAR2UPPER  8192  // nagybet�re konvert�l
#define EDOSCONV_ALL          8192

//----------------------------------------------------------------------------
// defaultok
//----------------------------------------------------------------------------
 
#define FDOSCONV_DEFAULT (DOSCONV_BS2SLASH+DOSCONV_FNAME2LOWER+DOSCONV_FNAMERTRIM+DOSCONV_PATH2LOWER)
#define DDOSCONV_DEFAULT (DOSCONV_FNAME_UPPER+DOSCONV_FSPEC_ASTERIX)
#define ODOSCONV_DEFAULT (DOSCONV_SPECDOSDEV+DOSCONV_FILESHARE)
#define EDOSCONV_DEFAULT (DOSCONV_ENVVAR2UPPER)

#define DOSCONV_DEFAULT (FDOSCONV_DEFAULT+DDOSCONV_DEFAULT+ODOSCONV_DEFAULT+EDOSCONV_DEFAULT)

#endif

