
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

//Ezt a filet a main-be kell inkludalni
//itt definialjuk a globalis CCC valtozokat

//---------------------------------------------------------------------------

pthread_key_t thread_key;

int thread_data::tdata_count=0;
thread_data *thread_data::tdata_first=0;
thread_data *thread_data::tdata_last=0;
 

VALUE ststackbuf[STSTACK_SIZE]; // stack a static valtozoknak
VALUE *ststack=ststackbuf;

VALUE END   = {TYPE_END   , {0.0} };   // globalis END
VALUE NIL   = {TYPE_NIL   , {0.0} };   // globalis NIL
VALUE FALSE = {TYPE_FLAG  , {0.0} };   // globalis FALSE
VALUE TRUE  = {TYPE_FLAG  , {0.1} };   // globalis TRUE
VALUE ZERO  = {TYPE_NUMBER, {0.0} };   // globalis 0.
VALUE ONE   = {TYPE_NUMBER, {1.0} };   // globalis 1.

VALUE PROTOTYPE_BINARY = {TYPE_BINARY};   // globalis prototype
VALUE PROTOTYPE_STRING = {TYPE_STRING};   // globalis prototype
VALUE PROTOTYPE_DATE   = {TYPE_DATE  };   // globalis prototype
VALUE PROTOTYPE_ARRAY  = {TYPE_ARRAY };   // globalis prototype
VALUE PROTOTYPE_BLOCK  = {TYPE_BLOCK };   // globalis prototype
VALUE PROTOTYPE_OBJECT = {TYPE_OBJECT};   // globalis prototype

int   ARGC;
char  **ARGV;

//---------------------------------------------------------------------------

