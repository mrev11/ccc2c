
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

//MEMOEDIT.CH for CCC

#ifndef _MEMOEDIT_CH_
#define _MEMOEDIT_CH_
 

// User function entry modes

#define ME_IDLE       0      // idle, all keys processed
#define ME_UNKEY      1      // unknown key, memo unaltered
#define ME_UNKEYX     2      // unknown key, memo altered
#define ME_INIT       3      // initialization mode


// User function return codes

#define ME_DEFAULT       0      // perform default action
#define ME_IGNORE       32      // ignore unknown key
#define ME_DATA         33      // treat unknown key as data
#define ME_TOGGLEWRAP   34      // toggle word-wrap mode
#define ME_TOGGLESCROLL 35      // toggle scrolling mode
#define ME_WORDRIGHT   100      // perform word-right operation
#define ME_BOTTOMRIGHT 101      // perform bottom-right operation


#endif
