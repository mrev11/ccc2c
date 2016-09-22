
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

//DBEDIT.CH for CCC

#ifndef _DBEDIT_CH_
#define _DBEDIT_CH_
 
// User function entry modes

#define DE_IDLE         0      // Idle
#define DE_HITTOP       1      // Attempt to cursor past top of file
#define DE_HITBOTTOM    2      // Attempt to cursor past bottom of file
#define DE_EMPTY        3      // No records in work area
#define DE_EXCEPT       4      // Key exception


// User function return codes

#define DE_ABORT        0      // Abort DBEDIT()
#define DE_CONT         1      // Continue DBEDIT()
#define DE_REFRESH      2      // Force reread/redisplay of all data rows

#endif

