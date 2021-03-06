
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
 
#ifdef _UNIX_

void _clp_crlf(      int argno ) { stack-=argno; string("\r\n"); }
void _clp_endofline( int argno ) { stack-=argno; string("\n"); }
void _clp_dirsep(    int argno ) { stack-=argno; string("/"); }
void _clp_pathsep(   int argno ) { stack-=argno; string(":"); }
void _clp_fullmask(  int argno ) { stack-=argno; string("*"); }

#else

void _clp_crlf(      int argno ) { stack-=argno; string("\r\n"); }
void _clp_endofline( int argno ) { stack-=argno; string("\r\n"); }
void _clp_dirsep(    int argno ) { stack-=argno; string("\\"); }
void _clp_pathsep(   int argno ) { stack-=argno; string(";"); }
void _clp_fullmask(  int argno ) { stack-=argno; string("*.*"); }

#endif

