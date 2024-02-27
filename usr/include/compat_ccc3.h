
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
 
#ifndef _COMPAT_CCC3_H_
#define _COMPAT_CCC3_H_

#undef  CHAR
#define CHAR                char
#undef  BYTE
#define BYTE                char


#define MAXBINLEN           MAXSTRLEN
#define BINARYPTR0(x)       STRINGPTR0(x)
#define BINARYPTR(x)        STRINGPTR(x)
#define BINARYLEN(x)        STRINGLEN(x)
#define TYPE_BINARY         TYPE_STRING
#define ISBINARY            ISSTRING
#define REFBINPTR(i)        REFSTRPTR(i)
#define REFBINLEN(i)        REFSTRLEN(i)
#define PARB(x)             PARC(x)
#define PARBLEN(x)          PARCLEN(x)

#define binptr              chrptr
#define binary              string

#define stringnb(x)         stringn(x)
#define stringsb(x,y)       strings(x,y)
#define binaryn(x)          stringn(x)
#define binaryl(x)          stringl(x)
#define binarys(x,y)        strings(x,y)

#define _parb(x)            _parc(x)
#define _parcb(x)           _parc(x)
#define _parblen(x)         _parclen(x)

#define _retb(x)            _retc(x)
#define _retcb(x)           _retc(x)
#define _retblen(x,y)       _retclen(x,y)
#define _retcblen(x,y)      _retclen(x,y)

#define bin2str(x)          (x)
#define str2bin(x)          (x)


#endif
