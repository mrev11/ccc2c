
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

//rövidítések 
#define L_T_R_B  USHORT left,USHORT top,USHORT right,USHORT bottom 
#define X_Y      USHORT x,USHORT y 
#define STDP     __stdcall*
#define STDCALL  __stdcall
#define GPR(n)   getproc(dll,n)

//argumentum listák
#define ARG_setcursortype  (SHORT type)
#define ARG_setcursorpos   ()
#define ARG_maxrow         ()
#define ARG_maxcol         ()
#define ARG_wherex         ()
#define ARG_wherey         ()
#define ARG_gotoxy         (X_Y)
#define ARG_scroll         (L_T_R_B,SHORT step,USHORT attr)
#define ARG_gettext        (L_T_R_B,USHORT destin[])
#define ARG_puttext        (L_T_R_B,USHORT source[])
#define ARG_print          (char*txt)
#define ARG_getkey         (ULONG wait_time)
#define ARG_open           (USHORT fp,char*fname,char*mode)
#define ARG_close          (USHORT fp)
#define ARG_fputs          (USHORT fp, char*txt)
#define ARG_fwrite         (USHORT fp, char*txt, int datalen)
#define ARG_workstatid     (USHORT*len,char*id)
#define ARG_computername   (USHORT*len,char*id)
 

extern "C" { //lokális implementáció
extern SHORT STDCALL local_setcursortype ARG_setcursortype;
extern SHORT STDCALL local_setcursorpos  ARG_setcursorpos;
extern SHORT STDCALL local_maxrow        ARG_maxrow;
extern SHORT STDCALL local_maxcol        ARG_maxcol;
extern SHORT STDCALL local_wherex        ARG_wherex;
extern SHORT STDCALL local_wherey        ARG_wherey;
extern SHORT STDCALL local_gotoxy        ARG_gotoxy;
extern SHORT STDCALL local_scroll        ARG_scroll;
extern SHORT STDCALL local_gettext       ARG_gettext;
extern SHORT STDCALL local_puttext       ARG_puttext;
extern SHORT STDCALL local_print         ARG_print;
extern SHORT STDCALL local_getkey        ARG_getkey;
extern SHORT STDCALL local_open          ARG_open;
extern SHORT STDCALL local_close         ARG_close;
extern SHORT STDCALL local_fputs         ARG_fputs;
extern SHORT STDCALL local_fwrite        ARG_fwrite;
extern SHORT STDCALL local_workstatid    ARG_workstatid;
extern SHORT STDCALL local_computername  ARG_computername;
}

extern "C" { //függvénytábla deklaráció
extern SHORT (STDP conapi_setcursortype) ARG_setcursortype;
extern SHORT (STDP conapi_setcursorpos)  ARG_setcursorpos;
extern SHORT (STDP conapi_maxrow)        ARG_maxrow;
extern SHORT (STDP conapi_maxcol)        ARG_maxcol;
extern SHORT (STDP conapi_wherex)        ARG_wherex;
extern SHORT (STDP conapi_wherey)        ARG_wherey;
extern SHORT (STDP conapi_gotoxy)        ARG_gotoxy;
extern SHORT (STDP conapi_scroll)        ARG_scroll;
extern SHORT (STDP conapi_gettext)       ARG_gettext;
extern SHORT (STDP conapi_puttext)       ARG_puttext;
extern SHORT (STDP conapi_print)         ARG_print;
extern SHORT (STDP conapi_getkey)        ARG_getkey;
extern SHORT (STDP conapi_open)          ARG_open;
extern SHORT (STDP conapi_close)         ARG_close;
extern SHORT (STDP conapi_fputs)         ARG_fputs;
extern SHORT (STDP conapi_fwrite)        ARG_fwrite;
extern SHORT (STDP conapi_workstatid)    ARG_workstatid;
extern SHORT (STDP conapi_computername)  ARG_computername;
}

 
#define setcursortype   conapi_setcursortype
#define setcursorpos    conapi_setcursorpos
#define maxrow          conapi_maxrow
#define maxcol          conapi_maxcol 
#define wherex          conapi_wherex
#define wherey          conapi_wherey
#define gotoxy          conapi_gotoxy
#define scroll          conapi_scroll 
#define gettext         conapi_gettext 
#define puttext         conapi_puttext 
#define getkey          conapi_getkey 


