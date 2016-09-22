
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

#ifndef _VARIABLE_H_
#define _VARIABLE_H_

//---------------------------------------------------------------------------

const unsigned int  MAXSTRLEN=0x4000000;  //64MB


const int TYPE_END        =-1;    // array end/size
const int TYPE_NIL        = 0;    // 'U'
const int TYPE_NUMBER     = 1;    // 'N'
const int TYPE_DATE       = 2;    // 'D'
const int TYPE_FLAG       = 3;    // 'L'
const int TYPE_POINTER    = 4;    // 'P'
const int TYPE_STRING     = 5;    // 'C'
const int TYPE_ARRAY      = 6;    // 'A'
const int TYPE_BLOCK      = 7;    // 'B'
const int TYPE_OBJECT     = 8;    // 'O'
const int TYPE_REF        = 9;    // 'R'

//Lényeges a konstansok nagyság szerinti sorrendje!

const int  NEXT_UNKNOWN   = 0;
const int  NEXT_RESERVED  =-1;
const int  NEXT_LOCKED    =-2;


struct OREF;
struct VREF;

typedef size_t binarysize_t;

struct VALUE
{
    int type;

    union DATA
    {
        double number;
        long date;
        long size;
        void* pointer;
        int flag;

        struct
        {
            OREF *oref; // string
            //unsigned long len; // hossz
            binarysize_t len; // hossz
        } string;

        struct
        {
            OREF *oref; // array
        } array;

        struct
        {
            OREF *oref; // a slotokból felépített array
            int subtype; // az objektum típusa
        } object;

        struct
        {
            OREF *oref; // környezeti változók
            void (*code)(int); // block függvény
        } block;

        VREF *vref;

    } data;

#ifdef MULTITHREAD
    VALUE operator=(VALUE v);
    //többszálú esetben speciális értékadás
    //variable.cpp-ben van definiálva
#endif

};


struct OREF
{
    union
    {
        char *chrptr;
        VALUE *valptr;
    } ptr;
    int length;
    int next;
};


struct VREF
{
    VALUE value;
    int next;
};


struct VARTAB_SETSIZE 
{
    int *oref_size;
    int *vref_size;
    int *alloc_count;
    long *alloc_size;
};


extern VREF* vref_new(void);
extern OREF* oref_new(void);
extern void  vartab_ini(void);

extern void  vartab_setsize( struct VARTAB_SETSIZE *vss );
extern void  vartab_rebuild(void);
extern VALUE *newValue(unsigned int len);
extern char  *newChar(unsigned int len);

//---------------------------------------------------------------------------

#endif

