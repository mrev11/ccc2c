//input: ppo/makeexe1.ppo (4.11.0.1)

#include <clp2cpp.h>

extern void _clp___quit(int argno);
extern void _clp_buildenv_bat(int argno);
extern void _clp_buildenv_bindir(int argno);
extern void _clp_buildenv_exe(int argno);
extern void _clp_buildenv_obj(int argno);
extern void _clp_dirsep(int argno);
extern void _clp_empty(int argno);
extern void _clp_errorlevel(int argno);
extern void _clp_ferase(int argno);
extern void _clp_file(int argno);
extern void _clp_filecopy(int argno);
extern void _clp_filemove(int argno);
extern void _clp_ftime(int argno);
extern void _clp_len(int argno);
extern void _clp_makeexe1(int argno);
extern void _clp_qout(int argno);
extern void _clp_right(int argno);
extern void _clp_run1(int argno);
extern void _clp_s_batext(int argno);
extern void _clp_s_debug(int argno);
extern void _clp_s_libspec(int argno);
extern void _clp_verifdep(int argno);

//=======================================================================
void _clp_makeexe1(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+12)PUSHNIL();
argno=2;
push_call("makeexe1",base);
//
    line(25);
    _clp_buildenv_exe(0);
    _clp_dirsep(0);
    add();
    push_symbol(base+0);//mmod
    add();
    string(".exe");
    add();
    assign(base+2);//target
    pop();
    line(26);
    push(&FALSE);
    assign(base+6);//update
    pop();
    line(27);
    _clp_buildenv_bat(0);
    _clp_dirsep(0);
    add();
    string("lib2exe");
    add();
    _clp_s_batext(0);
    add();
    assign(base+7);//torun
    pop();
    line(28);
    _clp_buildenv_obj(0);
    assign(base+8);//objdir
    pop();
    line(29);
    _clp_buildenv_bindir(0);
    assign(base+10);//bindir
    pop();
    line(30);
    line(37);
    line(32);
    push_symbol(base+7);//torun
    _clp_file(1);
    topnot();
    if(!flag()) goto if_1_1;
        line(33);
        string("[");
        push_symbol(base+7);//torun
        add();
        string("]");
        add();
        string(nls_text("does not exist"));
        _clp_qout(2);
        pop();
        line(34);
        _clp_qout(0);
        pop();
        line(35);
        push(&ONE);
        _clp_errorlevel(1);
        pop();
        line(36);
        _clp___quit(0);
        pop();
    if_1_1:
    if_1_0:;
    line(39);
    push_symbol(base+2);//target
    _clp_ftime(1);
    assign(base+3);//ttarget
    pop();
    line(42);
    line(40);
    push_symbol(base+3);//ttarget
    push(&NIL);
    eqeq();
    cmp_276:;
    if(!flag()) goto if_2_1;
        line(41);
        string("");
        assign(base+3);//ttarget
        pop();
    if_2_1:
    if_2_0:;
    line(46);
    line(44);
    _clp_s_debug(0);
    if(!flag()) goto if_3_1;
        line(45);
        push_symbol(base+2);//target
        string("[");
        push_symbol(base+3);//ttarget
        add();
        string("]");
        add();
        _clp_qout(2);
        pop();
    if_3_1:
    if_3_0:;
    line(49);
    push_symbol(base+0);//mmod
    assign(base+4);//depend
    pop();
    line(50);
    push_symbol(base+7);//torun
    string(" ");
    push_symbol(base+4);//depend
    add();
    add();
    assign(base+7);//torun
    pop();
    line(51);
    push_symbol(base+8);//objdir
    _clp_dirsep(0);
    add();
    push_symbol(base+4);//depend
    add();
    string(".obj");
    add();
    assign(base+4);//depend
    pop();
    line(52);
    push_symbol(base+3);//ttarget
    push_symbol(base+4);//depend
    _clp_verifdep(2);
    if(flag()){
    push(&TRUE);
    }else{
    push_symbol(base+6);//update
    }
    assign(base+6);//update
    pop();
    line(54);
    push_symbol(base+1);//libnam
    assign(base+4);//depend
    pop();
    line(55);
    push_symbol(base+7);//torun
    string(" ");
    push_symbol(base+4);//depend
    add();
    add();
    assign(base+7);//torun
    pop();
    line(56);
    push_symbol(base+8);//objdir
    _clp_dirsep(0);
    add();
    push_symbol(base+4);//depend
    add();
    string(".lib");
    add();
    assign(base+4);//depend
    pop();
    line(57);
    push_symbol(base+3);//ttarget
    push_symbol(base+4);//depend
    _clp_verifdep(2);
    if(flag()){
    push(&TRUE);
    }else{
    push_symbol(base+6);//update
    }
    assign(base+6);//update
    pop();
    line(64);
    {
    line(59);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+9);//n
    lab_4_0:
    _clp_s_libspec(0);
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_4_2;
        line(63);
        line(60);
        _clp_s_libspec(0);
        push_symbol(base+9);//n
        idxr();
        number(4);
        _clp_right(2);
        string(".lib");
        eqeq();
        cmp_569:;
        if(!flag()) goto if_5_1;
            line(61);
            _clp_s_libspec(0);
            push_symbol(base+9);//n
            idxr();
            assign(base+4);//depend
            pop();
            line(62);
            push_symbol(base+3);//ttarget
            push_symbol(base+4);//depend
            _clp_verifdep(2);
            if(flag()){
            push(&TRUE);
            }else{
            push_symbol(base+6);//update
            }
            assign(base+6);//update
            pop();
        if_5_1:
        if_5_0:;
    lab_4_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+9);//n
    add();
    assign(base+9);//n
    goto lab_4_0;
    lab_4_2:;
    }
    line(68);
    line(66);
    _clp_s_debug(0);
    if(!flag()) goto if_6_1;
        line(67);
        _clp_qout(0);
        pop();
    if_6_1:
    if_6_0:;
    line(79);
    line(70);
    push_symbol(base+6);//update
    if(!flag()) goto if_7_1;
        line(71);
        push_symbol(base+7);//torun
        _clp_run1(1);
        pop();
        line(78);
        line(73);
        push_symbol(base+10);//bindir
        _clp_empty(1);
        topnot();
        if(!flag()) goto if_8_1;
            line(74);
            push_symbol(base+10);//bindir
            _clp_dirsep(0);
            add();
            push_symbol(base+0);//mmod
            add();
            string(".exe");
            add();
            assign(base+11);//trginst
            pop();
            line(75);
            push_symbol(base+11);//trginst
            _clp_ferase(1);
            pop();
            line(76);
            push_symbol(base+2);//target
            push_symbol(base+11);//trginst
            string(".tmp");
            add();
            _clp_filecopy(2);
            pop();
            line(77);
            push_symbol(base+11);//trginst
            string(".tmp");
            add();
            push_symbol(base+11);//trginst
            _clp_filemove(2);
            pop();
        if_8_1:
        if_8_0:;
    if_7_1:
    if_7_0:;
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

