
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

//input: directory.ppo (4.4.27)

#include <clp2cpp.h>

extern void _clp___closedir(int argno);
extern void _clp___opendir(int argno);
extern void _clp___readdir(int argno);
extern void _clp_array(int argno);
extern void _clp_asize(int argno);
extern void _clp_convertfspec2nativeformat(int argno);
extern void _clp_directory(int argno);
extern void _clp_get_dosconv(int argno);
extern void _clp_len(int argno);
extern void _clp_like(int argno);
extern void _clp_lstat_st_mode(int argno);
extern void _clp_numand(int argno);
extern void _clp_ostime2dati(int argno);
extern void _clp_rat(int argno);
extern void _clp_s_isdir(int argno);
extern void _clp_s_islnk(int argno);
extern void _clp_stat(int argno);
extern void _clp_substr(int argno);
extern void _clp_thread_mutex_init(int argno);
extern void _clp_thread_mutex_lock(int argno);
extern void _clp_thread_mutex_unlock(int argno);
extern void _clp_upper(int argno);
static void _ini_directory_mutex(VALUE*);

//=======================================================================
void _clp_directory(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+19)PUSHNIL();
argno=2;
push_call("directory",base);
//
    line(44);
    number(32);
    _clp_array(1);
    assign(base+2);//dlist
    pop();
    push(&ZERO);
    assign(base+3);//dlist_size
    pop();
    line(45);
    _clp_get_dosconv(0);
    number(512);
    _clp_numand(2);
    push(&ZERO);
    neeq();
    assign(base+4);//fname_upper
    pop();
    line(46);
    _clp_get_dosconv(0);
    number(1024);
    _clp_numand(2);
    push(&ZERO);
    neeq();
    assign(base+5);//fspec_asterix
    pop();
    line(47);
    line(48);
    push(&FALSE);
    assign(base+15);//adddir
    pop();
    line(49);
    push(&TRUE);
    assign(base+17);//addlnk
    pop();
    line(51);
    static stvarloc _st_mutex(_ini_directory_mutex,base);
    line(57);
    line(53);
    push_symbol(base+0);//mask
    push(&NIL);
    eqeq();
    if(!flag()) goto if_1_1;
        line(54);
        string("*");
        assign(base+0);//mask
        pop();
    goto if_1_0;
    if_1_1:
    line(55);
    push_symbol(base+0);//mask
    string("");
    eqeq();
    if(!flag()) goto if_1_2;
        line(56);
        string("*");
        assign(base+0);//mask
        pop();
    if_1_2:
    if_1_0:;
    line(59);
    push_symbol(base+0);//mask
    _clp_convertfspec2nativeformat(1);
    assign(base+0);//mask
    pop();
    line(70);
    line(61);
    push(&ZERO);
    string("/");
    push_symbol(base+0);//mask
    _clp_rat(2);
    assign(base+14);//i
    eqeq();
    if(!flag()) goto if_2_1;
        line(62);
        string(".");
        assign(base+6);//dirspec
        pop();
        line(63);
        push_symbol(base+0);//mask
        assign(base+7);//fmask
        pop();
    goto if_2_0;
    if_2_1:
    line(64);
    push_symbol(base+14);//i
    push(&ONE);
    eqeq();
    if(!flag()) goto if_2_2;
        line(65);
        string("/");
        assign(base+6);//dirspec
        pop();
        line(66);
        push_symbol(base+0);//mask
        number(2);
        _clp_substr(2);
        assign(base+7);//fmask
        pop();
    goto if_2_0;
    if_2_2:
    line(67);
        line(68);
        push_symbol(base+0);//mask
        push(&ONE);
        push_symbol(base+14);//i
        addnum(-1);
        _clp_substr(3);
        assign(base+6);//dirspec
        pop();
        line(69);
        push_symbol(base+0);//mask
        push_symbol(base+14);//i
        addnum(1);
        _clp_substr(2);
        assign(base+7);//fmask
        pop();
    if_2_3:
    if_2_0:;
    line(74);
    line(72);
    push_symbol(base+5);//fspec_asterix
    if(!flag()){
    push(&FALSE);
    }else{
    push_symbol(base+7);//fmask
    string("*.*");
    eqeq();
    }
    if(!flag()) goto if_3_1;
        line(73);
        string("*");
        assign(base+7);//fmask
        pop();
    if_3_1:
    if_3_0:;
    line(79);
    line(76);
    push_symbol(base+1);//type
    push(&NIL);
    neeq();
    if(!flag()) goto if_4_1;
        line(77);
        string("-D");
        push_symbol(base+1);//type
        _clp_upper(1);
        ss();
        topnot();
        if(!flag()){
        push(&FALSE);
        }else{
        string("D");
        push_symbol(base+1);//type
        _clp_upper(1);
        ss();
        }
        assign(base+15);//adddir
        pop();
        line(78);
        string("-L");
        push_symbol(base+1);//type
        _clp_upper(1);
        ss();
        topnot();
        assign(base+17);//addlnk
        pop();
    if_4_1:
    if_4_0:;
    line(81);
    push_symbol(_st_mutex.ptr);//directory
    _clp_thread_mutex_lock(1);
    pop();
    line(127);
    line(83);
    push(&ZERO);
    push_symbol(base+6);//dirspec
    _clp___opendir(1);
    eqeq();
    if(!flag()) goto if_5_1;
        line(126);
        lab_6_1:
        line(85);
        push(&NIL);
        _clp___readdir(0);
        assign(base+8);//fname
        neeq();
        if(!flag()) goto lab_6_2;
            line(125);
            line(87);
            push_symbol(base+8);//fname
            push_symbol(base+8);//fname
            _clp_convertfspec2nativeformat(1);
            eqeq();
            if(!flag()){
            push(&FALSE);
            }else{
            push_symbol(base+7);//fmask
            push_symbol(base+8);//fname
            _clp_like(2);
            }
            if(!flag()) goto if_7_1;
                line(89);
                push_symbol(base+6);//dirspec
                string("/");
                add();
                push_symbol(base+8);//fname
                add();
                assign(base+9);//dfname
                pop();
                line(90);
                push_symbol(base+9);//dfname
                _clp_stat(1);
                assign(base+11);//st
                pop();
                line(91);
                push_symbol(base+9);//dfname
                _clp_lstat_st_mode(1);
                assign(base+12);//lsm
                pop();
                line(124);
                line(93);
                push(&NIL);
                push_symbol(base+11);//st
                eqeq();
                if(flag()){
                push(&TRUE);
                }else{
                push(&NIL);
                push_symbol(base+12);//lsm
                eqeq();
                }
                if(!flag()) goto if_8_1;
                goto if_8_0;
                if_8_1:
                line(96);
                push_symbol(base+11);//st
                idxr0(3);
                _clp_s_isdir(1);
                assign(base+16);//isdir
                if(!flag()){
                push(&FALSE);
                }else{
                push_symbol(base+15);//adddir
                topnot();
                }
                if(!flag()) goto if_8_2;
                goto if_8_0;
                if_8_2:
                line(99);
                push_symbol(base+12);//lsm
                _clp_s_islnk(1);
                assign(base+18);//islnk
                if(!flag()){
                push(&FALSE);
                }else{
                push_symbol(base+17);//addlnk
                topnot();
                }
                if(!flag()) goto if_8_3;
                goto if_8_0;
                if_8_3:
                line(102);
                    line(104);
                    push_symbol(base+11);//st
                    idxr0(12);
                    _clp_ostime2dati(1);
                    assign(base+13);//dati
                    pop();
                    line(106);
                    string("");
                    assign(base+10);//ftype
                    pop();
                    line(109);
                    line(107);
                    push_symbol(base+16);//isdir
                    if(!flag()) goto if_9_1;
                        line(108);
                        push_symbol(base+10);//ftype
                        string("D");
                        add();
                        assign(base+10);//ftype
                        pop();
                    if_9_1:
                    if_9_0:;
                    line(112);
                    line(110);
                    push_symbol(base+18);//islnk
                    if(!flag()) goto if_10_1;
                        line(111);
                        push_symbol(base+10);//ftype
                        string("L");
                        add();
                        assign(base+10);//ftype
                        pop();
                    if_10_1:
                    if_10_0:;
                    line(116);
                    line(114);
                    push_symbol(base+3);//dlist_size
                    push_symbol(base+2);//dlist
                    _clp_len(1);
                    gteq();
                    if(!flag()) goto if_11_1;
                        line(115);
                        push_symbol(base+2);//dlist
                        push_symbol(base+3);//dlist_size
                        addnum(32);
                        _clp_asize(2);
                        pop();
                    if_11_1:
                    if_11_0:;
                    line(118);
                    push_symbol(base+4);//fname_upper
                    if(flag()){
                    push_symbol(base+8);//fname
                    _clp_upper(1);
                    }else{
                    push_symbol(base+8);//fname
                    }
                    push_symbol(base+11);//st
                    idxr0(8);
                    push_symbol(base+13);//dati
                    idxr0(1);
                    push_symbol(base+13);//dati
                    idxr0(2);
                    push_symbol(base+10);//ftype
                    array(5);
                    push_symbol(base+2);//dlist
                    push_symbol(base+3);//dlist_size
                    push(&ONE);
                    add();
                    assign(base+3);//dlist_size
                    assign2(idxxl());
                    pop();
                if_8_4:
                if_8_0:;
            if_7_1:
            if_7_0:;
        goto lab_6_1;
        lab_6_2:;
    if_5_1:
    if_5_0:;
    line(128);
    _clp___closedir(0);
    pop();
    line(129);
    push_symbol(_st_mutex.ptr);//directory
    _clp_thread_mutex_unlock(1);
    pop();
    line(131);
    push_symbol(base+2);//dlist
    push_symbol(base+3);//dlist_size
    _clp_asize(2);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}

static void _ini_directory_mutex(VALUE* base)
{
    _clp_thread_mutex_init(0);
}
//=======================================================================

