
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

#ifndef _PCRE2_H
#define _PCRE2_H

#define PCRE2_ANCHORED                      0x80000000
#define PCRE2_NO_UTF_CHECK                  0x40000000
#define PCRE2_ALLOW_EMPTY_CLASS             0x00000001
#define PCRE2_ALT_BSUX                      0x00000002
#define PCRE2_AUTO_CALLOUT                  0x00000004
#define PCRE2_CASELESS                      0x00000008
#define PCRE2_DOLLAR_ENDONLY                0x00000010
#define PCRE2_DOTALL                        0x00000020
#define PCRE2_DUPNAMES                      0x00000040
#define PCRE2_EXTENDED                      0x00000080
#define PCRE2_FIRSTLINE                     0x00000100
#define PCRE2_MATCH_UNSET_BACKREF           0x00000200
#define PCRE2_MULTILINE                     0x00000400
#define PCRE2_NEVER_UCP                     0x00000800
#define PCRE2_NEVER_UTF                     0x00001000
#define PCRE2_NO_AUTO_CAPTURE               0x00002000
#define PCRE2_NO_AUTO_POSSESS               0x00004000
#define PCRE2_NO_DOTSTAR_ANCHOR             0x00008000
#define PCRE2_NO_START_OPTIMIZE             0x00010000
#define PCRE2_UCP                           0x00020000
#define PCRE2_UNGREEDY                      0x00040000
#define PCRE2_UTF                           0x00080000
#define PCRE2_NEVER_BACKSLASH_C             0x00100000
#define PCRE2_ALT_CIRCUMFLEX                0x00200000
#define PCRE2_ALT_VERBNAMES                 0x00400000
#define PCRE2_USE_OFFSET_LIMIT              0x00800000
#define PCRE2_JIT_COMPLETE                  0x00000001
#define PCRE2_JIT_PARTIAL_SOFT              0x00000002
#define PCRE2_JIT_PARTIAL_HARD              0x00000004
#define PCRE2_NOTBOL                        0x00000001
#define PCRE2_NOTEOL                        0x00000002
#define PCRE2_NOTEMPTY                      0x00000004
#define PCRE2_NOTEMPTY_ATSTART              0x00000008
#define PCRE2_PARTIAL_SOFT                  0x00000010
#define PCRE2_PARTIAL_HARD                  0x00000020
#define PCRE2_DFA_RESTART                   0x00000040
#define PCRE2_DFA_SHORTEST                  0x00000080
#define PCRE2_SUBSTITUTE_GLOBAL             0x00000100
#define PCRE2_SUBSTITUTE_EXTENDED           0x00000200
#define PCRE2_SUBSTITUTE_UNSET_EMPTY        0x00000400
#define PCRE2_SUBSTITUTE_UNKNOWN_UNSET      0x00000800
#define PCRE2_SUBSTITUTE_OVERFLOW_LENGTH    0x00001000

#define PCRE2_NEWLINE_CR                    1
#define PCRE2_NEWLINE_LF                    2
#define PCRE2_NEWLINE_CRLF                  3
#define PCRE2_NEWLINE_ANY                   4
#define PCRE2_NEWLINE_ANYCRLF               5
#define PCRE2_BSR_UNICODE                   1
#define PCRE2_BSR_ANYCRLF                   2

#define PCRE2_ERROR_NOMATCH                 (-1)
#define PCRE2_ERROR_PARTIAL                 (-2)
#define PCRE2_ERROR_UTF8_ERR1               (-3)
#define PCRE2_ERROR_UTF8_ERR2               (-4)
#define PCRE2_ERROR_UTF8_ERR3               (-5)
#define PCRE2_ERROR_UTF8_ERR4               (-6)
#define PCRE2_ERROR_UTF8_ERR5               (-7)
#define PCRE2_ERROR_UTF8_ERR6               (-8)
#define PCRE2_ERROR_UTF8_ERR7               (-9)
#define PCRE2_ERROR_UTF8_ERR8              (-10)
#define PCRE2_ERROR_UTF8_ERR9              (-11)
#define PCRE2_ERROR_UTF8_ERR10             (-12)
#define PCRE2_ERROR_UTF8_ERR11             (-13)
#define PCRE2_ERROR_UTF8_ERR12             (-14)
#define PCRE2_ERROR_UTF8_ERR13             (-15)
#define PCRE2_ERROR_UTF8_ERR14             (-16)
#define PCRE2_ERROR_UTF8_ERR15             (-17)
#define PCRE2_ERROR_UTF8_ERR16             (-18)
#define PCRE2_ERROR_UTF8_ERR17             (-19)
#define PCRE2_ERROR_UTF8_ERR18             (-20)
#define PCRE2_ERROR_UTF8_ERR19             (-21)
#define PCRE2_ERROR_UTF8_ERR20             (-22)
#define PCRE2_ERROR_UTF8_ERR21             (-23)
#define PCRE2_ERROR_UTF16_ERR1             (-24)
#define PCRE2_ERROR_UTF16_ERR2             (-25)
#define PCRE2_ERROR_UTF16_ERR3             (-26)
#define PCRE2_ERROR_UTF32_ERR1             (-27)
#define PCRE2_ERROR_UTF32_ERR2             (-28)
#define PCRE2_ERROR_BADDATA                (-29)
#define PCRE2_ERROR_MIXEDTABLES            (-30)
#define PCRE2_ERROR_BADMAGIC               (-31)
#define PCRE2_ERROR_BADMODE                (-32)
#define PCRE2_ERROR_BADOFFSET              (-33)
#define PCRE2_ERROR_BADOPTION              (-34)
#define PCRE2_ERROR_BADREPLACEMENT         (-35)
#define PCRE2_ERROR_BADUTFOFFSET           (-36)
#define PCRE2_ERROR_CALLOUT                (-37)
#define PCRE2_ERROR_DFA_BADRESTART         (-38)
#define PCRE2_ERROR_DFA_RECURSE            (-39)
#define PCRE2_ERROR_DFA_UCOND              (-40)
#define PCRE2_ERROR_DFA_UFUNC              (-41)
#define PCRE2_ERROR_DFA_UITEM              (-42)
#define PCRE2_ERROR_DFA_WSSIZE             (-43)
#define PCRE2_ERROR_INTERNAL               (-44)
#define PCRE2_ERROR_JIT_BADOPTION          (-45)
#define PCRE2_ERROR_JIT_STACKLIMIT         (-46)
#define PCRE2_ERROR_MATCHLIMIT             (-47)
#define PCRE2_ERROR_NOMEMORY               (-48)
#define PCRE2_ERROR_NOSUBSTRING            (-49)
#define PCRE2_ERROR_NOUNIQUESUBSTRING      (-50)
#define PCRE2_ERROR_NULL                   (-51)
#define PCRE2_ERROR_RECURSELOOP            (-52)
#define PCRE2_ERROR_RECURSIONLIMIT         (-53)
#define PCRE2_ERROR_UNAVAILABLE            (-54)
#define PCRE2_ERROR_UNSET                  (-55)
#define PCRE2_ERROR_BADOFFSETLIMIT         (-56)
#define PCRE2_ERROR_BADREPESCAPE           (-57)
#define PCRE2_ERROR_REPMISSINGBRACE        (-58)
#define PCRE2_ERROR_BADSUBSTITUTION        (-59)
#define PCRE2_ERROR_BADSUBSPATTERN         (-60)
#define PCRE2_ERROR_TOOMANYREPLACE         (-61)
                                         
#endif                                         
                                         
                                         