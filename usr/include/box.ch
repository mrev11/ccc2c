
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

//BOX.CH for CCC

#ifndef _BOX_CH_
#define _BOX_CH_

#ifdef _CCC_ 

//Csiszár féle permutált box karakterek

#define B_HS    chr(182)
#define B_HD    chr(191)
#define B_VS    chr(164)
#define B_VD    chr(172)
 
#define B_SS1   chr(178)
#define B_SS2   chr(179)
#define B_SS3   chr(206)
#define B_SS4   chr(181)
#define B_SS5   chr(183)
#define B_SS6   chr(165)
#define B_SS7   chr(207)
#define B_SS8   chr(180)
#define B_SS9   chr(177)
 
#define B_DD1   chr(186)
#define B_DD2   chr(188)
#define B_DD3   chr(174)
#define B_DD4   chr(190)
#define B_DD5   chr(192)
#define B_DD6   chr(171)
#define B_DD7   chr(187)
#define B_DD8   chr(189)
#define B_DD9   chr(173)

#define B_SD1   chr(198)
#define B_SD2   chr(195)
#define B_SD3   chr(175)
#define B_SD4   chr(185)
#define B_SD5   chr(203)
#define B_SD6   chr(168)
#define B_SD7   chr(202)
#define B_SD8   chr(197)
#define B_SD9   chr(169)

#define B_DS1   chr(199)
#define B_DS2   chr(194)
#define B_DS3   chr(176)
#define B_DS4   chr(184)
#define B_DS5   chr(204)
#define B_DS6   chr(166)
#define B_DS7   chr(200)
#define B_DS8   chr(196)
#define B_DS9   chr(170)
 
#else

//CWI box karakterek a régi Clipperhez

#define B_HS    chr(196)
#define B_HD    chr(205)
#define B_VS    chr(179)
#define B_VD    chr(186)
 
#define B_SS1   chr(192)
#define B_SS2   chr(193)
#define B_SS3   chr(217)
#define B_SS4   chr(195)
#define B_SS5   chr(197)
#define B_SS6   chr(180)
#define B_SS7   chr(218)
#define B_SS8   chr(194)
#define B_SS9   chr(191)
 
#define B_DD1   chr(200)
#define B_DD2   chr(202)
#define B_DD3   chr(188)
#define B_DD4   chr(204)
#define B_DD5   chr(206)
#define B_DD6   chr(185)
#define B_DD7   chr(201)
#define B_DD8   chr(203)
#define B_DD9   chr(187)
 
#define B_SD1   chr(211)
#define B_SD2   chr(208)
#define B_SD3   chr(189)
#define B_SD4   chr(199)
#define B_SD5   chr(215)
#define B_SD6   chr(182)
#define B_SD7   chr(214)
#define B_SD8   chr(210)
#define B_SD9   chr(183)

#define B_DS1   chr(212)
#define B_DS2   chr(207)
#define B_DS3   chr(190)
#define B_DS4   chr(198)
#define B_DS5   chr(216)
#define B_DS6   chr(181)
#define B_DS7   chr(213)
#define B_DS8   chr(209)
#define B_DS9   chr(184)
 
#endif 

#define B_SINGLE         (B_SS7+B_HS+B_SS9+B_VS+B_SS3+B_HS+B_SS1+B_VS)
#define B_DOUBLE         (B_DD7+B_HD+B_DD9+B_VD+B_DD3+B_HD+B_DD1+B_VD)
#define B_SINGLE_DOUBLE  (B_SD7+B_HS+B_SD9+B_VD+B_SD3+B_HS+B_SD1+B_VD)
#define B_DOUBLE_SINGLE  (B_DS7+B_HD+B_DS9+B_VS+B_DS3+B_HD+B_DS1+B_VS)
 
#endif
