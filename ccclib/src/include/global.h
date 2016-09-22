
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

//Ezt a fil�t a main-be kell inklud�lni
//itt defini�ljuk a glob�lis CCC v�ltoz�kat

//---------------------------------------------------------------------------
#ifdef MULTITHREAD
  pthread_key_t thread_key;

  int thread_data::tdata_count=0;
  thread_data *thread_data::tdata_first=0;
  thread_data *thread_data::tdata_last=0;
 
#else
  TRACE tracebuf[TRACE_SIZE];     // stack a trace inf�nak
  TRACE *trace=tracebuf;

  VALUE stackbuf[STACK_SIZE];     // stack a local v�ltoz�knak
  VALUE *stack=stackbuf;

  SEQJMP seqjmpbuf[SEQJMP_SIZE];  // stack a longjump-oknak
  SEQJMP *seqjmp=seqjmpbuf;

  VALUE usingstkbuf[USINGSTK_SIZE]; // stack a using typeinfo-nak
  VALUE *usingstk=usingstkbuf;

  int siglocklev=0;
  int signumpend=0;
  int sigcccmask=0;
#endif

VALUE ststackbuf[STSTACK_SIZE]; // stack a static v�ltoz�knak
VALUE *ststack=ststackbuf;

VALUE END   = {TYPE_END   , {0.0} };   // glob�lis END
VALUE NIL   = {TYPE_NIL   , {0.0} };   // glob�lis NIL
VALUE FALSE = {TYPE_FLAG  , {0.0} };   // glob�lis FALSE
VALUE TRUE  = {TYPE_FLAG  , {0.1} };   // glob�lis TRUE
VALUE ZERO  = {TYPE_NUMBER, {0.0} };   // glob�lis 0.
VALUE ONE   = {TYPE_NUMBER, {1.0} };   // glob�lis 1.

VALUE PROTOTYPE_STRING = {TYPE_STRING};   // glob�lis prototype
VALUE PROTOTYPE_DATE   = {TYPE_DATE  };   // glob�lis prototype
VALUE PROTOTYPE_ARRAY  = {TYPE_ARRAY };   // glob�lis prototype
VALUE PROTOTYPE_BLOCK  = {TYPE_BLOCK };   // glob�lis prototype
VALUE PROTOTYPE_OBJECT = {TYPE_OBJECT};   // glob�lis prototype

int   ARGC;
char  **ARGV;

//---------------------------------------------------------------------------

