
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

// Ez a header inkludálódik a clp2cpp.exe 
// (YACC) által készített C++ programokba

#ifndef _CLP2CPP_H_
#define _CLP2CPP_H_

#ifdef WIN32
#ifdef comment // hibát okoz, ha definiálva van (msxml.h)
  #error DEFINED_comment 
#endif
#include <windows.h>
#undef TRUE
#undef FALSE
#undef TEXT
#ifndef strcasecmp
  #define strcasecmp  stricmp
#endif
#ifndef wcscasecmp
  #define wcscasecmp  wcsicmp
#endif
#endif

#ifdef UNIX
#include <unistd.h>
#endif

#include <signal.h>
#include <setjmp.h>
#include <stdlib.h>
#include <stdio.h>


#include <pthread.h>

extern pthread_key_t thread_key;
class thread_data;
#define thread_data_ptr ((thread_data*)pthread_getspecific(thread_key))


#include <variable.h>

//------------------------------------------------------------

extern int  ARGC;
extern char **ARGV;
 
//------------------------------------------------------------
unsigned const int TRACE_SIZE=256;

typedef struct 
{
    const char *func;
    VALUE *base;
    int line;
} TRACE;


#define trace    (thread_data_ptr->_trace)
#define tracebuf (thread_data_ptr->_tracebuf)
 
//#define push_call(f,b)  (++trace,trace->func=f,trace->base=b,trace->line=0)
extern void push_call(const char*, VALUE*);
#define pop_call()      (--trace)
#define line(l)         (trace->line=(l))

//------------------------------------------------------------
unsigned const int STACK_SIZE=2048;
unsigned const int STSTACK_SIZE=2048;

#define stack     (thread_data_ptr->_stack)
#define stackbuf  (thread_data_ptr->_stackbuf)
 
extern VALUE *ststack;
extern VALUE ststackbuf[];
 
#define PUSHNIL()  (stack->type=TYPE_NIL,stack->data.pointer=0,stack++)
#define PUSHFLG()  (stack->type=TYPE_FLAG,stack++)
#define PUSHDAT()  (stack->type=TYPE_DATE,stack++)
#define PUSHPTR()  (stack->type=TYPE_POINTER,stack++)
#define PUSHNUM()  (stack->type=TYPE_NUMBER,stack++)
#define PUSH(v)    (*stack=*(v),stack++)

//Több szál esetén a pop()-> felhasználása tilos,
//ezért pop() visszatérése VALUE*-ról void-ra változott.
//Hogy a compiler kiszûrhesse a rossz POP()-> használatot,
//ideiglenesen POP-ot pop-ra preprocesszáljuk.

#define POP()      (pop())
//#define POP()      (--stack)
#define POP2()     (stack-=2)
#define POP3()     (stack-=3)

#define TOP0()     (stack)      // a stack tetején az elsõ szabad hely
#define TOP()      (stack-1)    // a stack tetején lévõ érték
#define TOP2()     (stack-2)    // a stack tetején a második érték
#define TOP3()     (stack-3)    // a stack tetején a harmadik érték
#define TOP4()     (stack-4)

#define DUP()      (PUSHNIL(),(*TOP()=*TOP2()))
#define DUP2()     (PUSHNIL(),(*TOP()=*TOP3()))
#define DUP3()     (PUSHNIL(),(*TOP()=*TOP4()))

#define RETURN(bs) {*bs=*TOP();stack=bs+1;return;}

#define STPUSH(v)  (*ststack=*(v),ststack++)

extern void push(VALUE*);
extern void push_symbol(VALUE*);
extern void push_blkenv(VALUE*);
extern void push_symbol_ref(VALUE*);

#define push_blkarg(v) push_symbol(v)
#define push_blkarg_ref(v) push_symbol_ref(v)
#define push_blkenv_ref(v) push_symbol_ref(v)

extern void pop();
extern void dup(); 
extern void swap(); 
 
extern void debug(const char*); // varstack teszteléséhez

//------------------------------------------------------------
unsigned const int SEQJMP_SIZE=64;
unsigned const int USINGSTK_SIZE=512;


typedef struct
{
    VALUE       *jmp_stack;         // local stack állása
    TRACE       *jmp_trace;         // callstack (trace info) állása
    VALUE       *jmp_usingstk;      // using typeinfo stack állása;
    jmp_buf     jmpb;               // programregisztrek
} SEQJMP;

 
#define seqjmp      (thread_data_ptr->_seqjmp)
#define seqjmpbuf   (thread_data_ptr->_seqjmpbuf)
#define usingstk    (thread_data_ptr->_usingstk)
#define usingstkbuf (thread_data_ptr->_usingstkbuf)

//------------------------------------------------------------

class stvar
{
  public:
    VALUE *ptr;
    stvar();
    stvar(char *str);
    stvar(const char *str);
    stvar(double number);
    stvar(void (*inicode)());
    stvar(VALUE *);
};

class stvarloc :public stvar
{
  public:
    stvarloc(void (*inicode)(VALUE*),VALUE*base);
};

//------------------------------------------------------------

#undef TRUE
#undef FALSE

extern VALUE END;
extern VALUE NIL;
extern VALUE TRUE;
extern VALUE FALSE;
extern VALUE ZERO;
extern VALUE ONE;

extern VALUE PROTOTYPE_STRING;
extern VALUE PROTOTYPE_DATE;
extern VALUE PROTOTYPE_ARRAY;
extern VALUE PROTOTYPE_BLOCK;
extern VALUE PROTOTYPE_OBJECT;

//------------------------------------------------------------
extern void eqeq();             // ==
extern void neeq();             // !=
extern void gteq();             // >=
extern void lteq();             // <=
extern void gt();               // >
extern void lt();               // <
extern void ss();               // $

extern void mul();              // felsõ két elem szorzata
extern void add();              // felsõ két elem összege
extern void addnum(double);     // szám hozzáadása a verem tetejéhez
extern void mulnum(double);     // szám hozzászorzása a verem tetejéhez
extern void addneg(double);     // szám hozzáadása a verem tetejéhez + negálás
extern void sub();              // felsõ két elem különbsége
extern void div();              // felsõ két elem hányadosa
extern void modulo();           // felsõ két elem modulója
extern void power();            // felsõ két elem hatványa
extern void signpos();          // unary plus
extern void signneg();          // unary minus

extern VALUE* idxl();           // indexkifejezés címe obsolete
extern VALUE* idxxl();          // indexkifejezés címe
extern void idxr();             // indexkifejezés értéke
extern VALUE* idxl0(double);    // indexkifejezés címe (konstans index) obsolete
extern VALUE* idxxl0(double);   // indexkifejezés címe (konstans index)
extern void idxr0(double);      // indexkifejezés értéke (konstans index)
extern void idxr0nil(double);   // mint idxr0, kivetel helyett NIL-t ad
extern void assign(VALUE*); 
extern void assign2(VALUE*); 
extern void block(void(*code)(int),int); 
extern VALUE *blkenv(VALUE*);

extern void slice(void);
extern void sliceright(void);
extern void sliceleft(void);

extern void method(int argno,int msg);
extern void method_set(int argno,int msg);

extern void string(char const*);            // új példány rámutatással (new nélkül)
extern void stringn(char const*);           // új pédány másolással (new-val)
extern void strings(char const*, unsigned long); // substring másolás new-val
extern char* stringl(unsigned long);        // inicializálatlan string new-val
extern void stringx(char const*);           // hexadecimális string
extern char const* nls_text(char const*);   // lokalizáció (fordítás)

extern void array(int len);     // array stackrõl vett elemekbõl
extern VALUE* array0(int len);  // array NIL elemekbõl

extern void number(double);     // szám létrehozása
extern void logical(int);       // flag létrehozása
extern void date(long);         // dátum létrehozása
extern void pointer(void*);     // pointer létrehozása

extern VALUE prototype_object(void);
extern void  _clp_break(int);
extern void  _clp_break0(int);
extern void  _clp_breakblock(int);
extern void  begseqpop_ret(void);
extern void  begseqpop_loop(void);
extern void  begseqpop_exit(void);

extern void topnot();           // a stack felsõ elemének tagadása
extern int  flag();             // a stack felsõ elemének logikai értéke
extern int  sign();             // a stack felsõ elemének elõjele
extern int  lessthan();         // a stack felsõ két elemének összehasonlítása
extern int  greaterthan();      // a stack felsõ két elemének összehasonlítása
extern int  equalto();          // a stack felsõ két elemének összehasonlítása
extern int  notequal();         // a stack felsõ két elemének összehasonlítása
extern int  stdcmp(VALUE*,VALUE*,int mode=0);
extern long stod(const char*);

//------------------------------------------------------------
#undef min
#undef max
#undef mod

#define min(x,y)   ((x)<(y)?(x):(y))
#define max(x,y)   ((x)>(y)?(x):(y))
#define mod(x,y)   ((x)-((x)/(y))*(y))

//unsigned >  signed
//unsigned >= signed
#define GTUS(u,s)  ((s)<0 || (u) >  (unsigned)(s))
#define GEUS(u,s)  ((s)<0 || (u) >= (unsigned)(s))
#define minUS(u,s) ((s)<0 ? (s) : min(u,(unsigned)s))
#define maxUS(u,s) ((s)<0 ? (u) : max(u,(unsigned)s))

#define D2INT(x)   ((x)>0?(int)((x)+0.5):(int)((x)-0.5))
#define D2UINT(x)  ((x)>0?(unsigned)((x)+0.5):(unsigned)((x)-0.5))
#define D2LONG(x)  ((x)>0?(long)((x)+0.5):(long)((x)-0.5))
#define D2ULONG(x) ((x)>0?(unsigned long)((x)+0.5):(unsigned long)((x)-0.5)) 

#define ROUND(x)    ((x)+((x)>0?0.5:-0.5))
#define UROUND(x)   ((x)>0?(x)+0.5:0)
#define D2LONGW(x)  ((long long)ROUND(x))
#define D2ULONGW(x) ((unsigned long long)ROUND(x))
#define D2ULONGX(x) ((unsigned long long)UROUND(x))

 
//------------------------------------------------------------
//#define DEVOUT_WIDTH       128
//#define DEVOUT_HEIGHT       32

//------------------------------------------------------------
#define TRANSFORM_B          0  // LeftNumber
#define TRANSFORM_Z          1  // ZeroBlank
#define TRANSFORM_U          2  // Uppercase (!)
#define TRANSFORM_A          3  // AlfaNumeric
#define TRANSFORM_K          4  // Clear
#define TRANSFORM_S          5  // Scroll
#define TRANSFORM_P          6  // PassWord (*)
#define TRANSFORM_FLAGS      7

//------------------------------------------------------------
#ifndef CLASS_DBFIELD
class dbfield
{
    const char *alias;
    const char *field;
    int  ftabidx;
    int  ninsert;
    void fsearch(void);

  public:
    dbfield(char*a,char*f);
    dbfield(const char*a,const char*f);
    void fget(void);
    void fput(void);
};

#define CLASS_DBFIELD
#endif


//------------------------------------------------------------
//memória foglalás 99.07.06

#ifdef WIN32

#define MEMALLOC(x)   GlobalAlloc(GMEM_FIXED,x)
#define MEMFREE(x)    GlobalFree(x)

#else

#define MEMALLOC(x)   malloc(x)
#define MEMFREE(x)    free(x)

#endif


//------------------------------------------------------------
typedef short SHORT;
typedef long  LONG;
typedef unsigned short USHORT;
typedef unsigned long ULONG;
typedef USHORT FLAG;


//------------------------------------------------------------
#ifdef UNIX
#define wcsicmp(s1,s2)  wcscasecmp(s1,s2)
#define stricmp(s1,s2)  strcasecmp(s1,s2)
#define flushall()  fflush(NULL)
#endif
 
//------------------------------------------------------------

#define MUTEX_CREATE(x)    static pthread_mutex_t x=PTHREAD_MUTEX_INITIALIZER
#define MUTEX_DESTROY(x)   pthread_mutex_destroy(&x)
#define MUTEX_DECLARE(x)   pthread_mutex_t x
#define MUTEX_INIT(x)      pthread_mutex_init(&x,0)
#define MUTEX_LOCK(x)      pthread_mutex_lock(&x)
#define MUTEX_UNLOCK(x)    pthread_mutex_unlock(&x)

#include <thread_data.h>

extern void vartab_lock();
extern void vartab_unlock();
extern void vartab_lock0();
extern void vartab_unlock0();
#define VARTAB_LOCK()     vartab_lock()  
#define VARTAB_UNLOCK()   vartab_unlock()  

extern int signal_raise(int);
extern int signal_send(int,int);
#define SIGNAL_LOCK()     (++siglocklev)
#define SIGNAL_UNLOCK()   ((--siglocklev==0)&&(signumpend!=0)?signal_raise(signumpend):0)

#define CHRLIT(x)         x  // "literal" -> "literal"

extern void error_arg(const char *operation, VALUE *base, int argno);

//------------------------------------------------------------
#include <xmethod.h>
#include <xmethod3.h>
#include <xmethod6.h>
//------------------------------------------------------------
#endif // _CLP2CPP_H_


