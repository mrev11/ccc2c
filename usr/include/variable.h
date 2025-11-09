
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

const int TYPE_END        = -1;    // array end/size
const int TYPE_NIL        =  0;    // 'U'
const int TYPE_NUMBER     =  1;    // 'N'
const int TYPE_DATE       =  2;    // 'D'
const int TYPE_FLAG       =  3;    // 'L'
const int TYPE_POINTER    =  4;    // 'P'
const int TYPE_STRING     =  5;    // 'C'
const int TYPE_ARRAY      =  6;    // 'A'
const int TYPE_BLOCK      =  7;    // 'B'
const int TYPE_OBJECT     =  8;    // 'O'
const int TYPE_REF        =  9;    // 'R'

//Lenyeges a konstansok nagysag szerinti sorrendje!

const int TYPE_GARBAGE = TYPE_STRING; // (v.type<TYPE_GARBAGE) => v-nek nincs oref-je
const int TYPE_SCALAR  = TYPE_STRING; // (v.type<=TYPE_SCALAR) => ha v-nek van oref-je, abban nincs VALUE



static const int COLOR_WHITE        = 0;
static const int COLOR_GRAY         = 1;
static const int COLOR_BLACK        = 2;

static const int COLOR_LOCKED       = 3;
static const int COLOR_RESERVED     = COLOR_BLACK;


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
            OREF *oref; // a slotokbol felepitett array
            int subtype; // az objektum tipusa
        } object;

        struct
        {
            OREF *oref; // kornyezeti valtozok
            void (*code)(int); // block fuggveny
        } block;

        VREF *vref;

    } data;

    VALUE &operator=(VALUE &v); // defines in variable.cpp

};


struct OREF
{
    union
    {
        char *chrptr;
        VALUE *valptr;
    } ptr;
    int length;
    int color;
    int link;
};


struct VREF
{
    VALUE value;
    int color;
    int link;
};


struct VARTAB_SETSIZE 
{
    unsigned int *oref_size;
    unsigned int *vref_size;
    unsigned int *alloc_count;
    unsigned long *alloc_size;
};


extern OREF* oref_new(VALUE*,void*,int);
extern VREF* vref_new(VALUE*);

extern void  vartab_ini(void);
extern void  vartab_setsize( struct VARTAB_SETSIZE *vss );
extern void  vartab_rebuild(void);
extern VALUE *newValue(unsigned int len);
extern void  deleteValue(VALUE*);
extern char  *newChar(unsigned int len);
extern void  valuecopy(VALUE*,VALUE*);
extern void  valuecopy(VALUE*,VALUE*,int);
extern void  valuecopy_lk(VALUE*,VALUE*);
extern void  valuecopy_lk(VALUE*,VALUE*,int);
extern void  oref_gray(OREF*);

//---------------------------------------------------------------------------

#endif

