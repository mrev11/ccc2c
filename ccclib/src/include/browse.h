
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

#define BR_SCREEN        1
#define BR_MENU          2
#define BR_SHORTCUT      3
#define BR_CURRENT       4
#define BR_MENUNAME      5
#define BR_ESCAPE        6
#define BR_APPLYKEY      7
#define BR_ONSTABLE      8
#define BR_VISIBLE       9
#define BR_FRAMETYPE    10
#define BR_FRAMECOLOR   11
#define BR_HIGHLIGHT    12
#define BR_CAPTION      13
#define BR_MINIMIZE     14
#define BR_MOVEFLAG     15
#define BR_ARRAY        16
#define BR_ARRAYPOS     17
#define BR_MENUROW      18
#define BR_MENUCOL      19
#define BR_POPUP        20
#define BR_FOOTING      21

#define BR_SLOTS        21



#define FOOT         if(empty(browse:cargo[BR_FOOTING]),0,1) //miért volna 2?
#define BROWSERECT   browse:nTop-5,browse:nLeft-1,browse:nBottom+FOOT+1,browse:nRight+1
#define STEPBYSTEP   //a browse lassítására


#define HELP_HEIGHT    fixedfont_height()
#define HEADING_HEIGHT    fixedfont_height()
#define FOOTING_HEIGHT    fixedfont_height()


#define MENUID_BUTTON    2048
