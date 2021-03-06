
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

//*******************************************************************
// objgen.ch: Macros for handling object (definition generated by
//            objccc)
// 1998-2001: Levente Csisz�r
//*******************************************************************


//*******************************************************************
#ifndef _OBJGEN_DEF_
#define _OBJGEN_DEF_

//*******************************************************************
#define class _objccc_class // Because class is reserved by ppo2ccp 4.4.00

//*******************************************************************
#ifndef OBJCCC_MA_BY_NAME
   #ifndef OBJCCC_MA_BY_INDEX
      #ifdef _CCC_
         #define OBJCCC_MA_BY_NAME
      #else
         #define OBJCCC_MA_BY_INDEX
      #endif
   #endif
#endif
   
#ifdef OBJCCC_MA_BY_INDEX
   #ifdef OBJCCC_MA_BY_NAME
      #error Object susbsystem: Mixed named and index implementation
      Object susbsystem: Mixed named and index implementation
   #endif
#endif
//*******************************************************************


#ifdef OBJCCC_MA_BY_NAME

   #xtranslate (OBJCCCN_EVALASMETHODBLOCK.(<o>):<block>)[:=<x>] => ;
                  eval(<block>,<o>[,<x>])

   #xtranslate (OBJCCCN_EVALASMETHODBLOCK.(<o>):<block>)([<p,...>])[:=<x>] => ;
                   eval(<block>,<o>[,<p>][,<x>])

#else // OBJCCC_MA_BY_NAME

   // It is the start of the attribute/method subarrays in
   // _objMAImplements.
   // '_cid' is also started from it.
   #define OBJCCCI_START_CID 3

   #xtranslate (OBJCCCI_METHOD(<cid>).(<o>):<m>)[:=<x>] => ;
                  eval((<o>)\[1\]\[(<cid>)+1\]\[<m>\],(<o>)[,<x>])

   #xtranslate (OBJCCCI_METHOD(<cid>).(<o>):<m>)([<p,...>])[:=<x>] => ;
                   eval((<o>)\[1\]\[(<cid>)+1\]\[<m>\],(<o>)[,<p>][,<x>])

   #xtranslate (OBJCCCI_ATTRIB(<cid>).(<o>):<a>) => ;
                  ((<o>)\[(<o>)\[1\]\[(<cid>)\]\[(<a>)\]\])


   #xtranslate (OBJCCCI_METHODASCLASS(<cid>,<cl>).(<o>):<m>)[:=<x>] => ;
                  eval((BEHAVIOR.(<cl>):_classExtra\[1\])\[(<cid>)+1\]\[<m>\],(<o>)[,<x>])

   #xtranslate (OBJCCCI_METHODASCLASS(<cid>,<cl>).(<o>):<m>)([<p,...>])[:=<x>] => ;
                  eval((BEHAVIOR.(<cl>):_classExtra\[1\])\[(<cid>)+1\]\[<m>\],(<o>)[,<p>][,<x>])


#endif // OBJCCC_MA_BY_NAME

//*******************************************************************
#endif // _OBJGEN_DEF_

