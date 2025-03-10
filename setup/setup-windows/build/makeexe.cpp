//input: ppo/makeexe.ppo (4.11.0.1)

#include <clp2cpp.h>

extern void _clp___quit(int argno);
extern void _clp_buildenv_bat(int argno);
extern void _clp_buildenv_bindir(int argno);
extern void _clp_buildenv_exe(int argno);
extern void _clp_buildenv_obj(int argno);
extern void _clp_dirsep(int argno);
extern void _clp_empty(int argno);
extern void _clp_endofline(int argno);
extern void _clp_errorlevel(int argno);
extern void _clp_ferase(int argno);
extern void _clp_file(int argno);
extern void _clp_filecopy(int argno);
extern void _clp_ftime(int argno);
extern void _clp_len(int argno);
extern void _clp_makeexe(int argno);
extern void _clp_memowrit(int argno);
extern void _clp_qout(int argno);
extern void _clp_right(int argno);
extern void _clp_run1(int argno);
extern void _clp_s_batext(int argno);
extern void _clp_s_debug(int argno);
extern void _clp_s_libspec(int argno);
extern void _clp_verifdep(int argno);

//=======================================================================
void _clp_makeexe(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+13)PUSHNIL();
argno=2;
push_call("makeexe",base);
//
    line(28);
    _clp_buildenv_exe(0);
    _clp_dirsep(0);
    add();
    push_symbol(base+0);//exenam
    add();
    string(".exe");
    add();
    assign(base+2);//target
    pop();
    line(29);
    push(&FALSE);
    assign(base+6);//update
    pop();
    line(30);
    _clp_buildenv_bat(0);
    _clp_dirsep(0);
    add();
    string("obj2exe");
    add();
    _clp_s_batext(0);
    add();
    assign(base+7);//torun
    pop();
    line(31);
    _clp_buildenv_obj(0);
    assign(base+8);//objdir
    pop();
    line(32);
    _clp_buildenv_bindir(0);
    assign(base+10);//bindir
    pop();
    line(33);
    line(40);
    line(35);
    push_symbol(base+7);//torun
    _clp_file(1);
    topnot();
    if(!flag()) goto if_1_1;
        line(36);
        string("[");
        push_symbol(base+7);//torun
        add();
        string("]");
        add();
        string(nls_text("does not exist"));
        _clp_qout(2);
        pop();
        line(37);
        _clp_qout(0);
        pop();
        line(38);
        push(&ONE);
        _clp_errorlevel(1);
        pop();
        line(39);
        _clp___quit(0);
        pop();
    if_1_1:
    if_1_0:;
    line(42);
    push_symbol(base+2);//target
    _clp_ftime(1);
    assign(base+3);//ttarget
    pop();
    line(45);
    line(43);
    push_symbol(base+3);//ttarget
    push(&NIL);
    eqeq();
    cmp_284:;
    if(!flag()) goto if_2_1;
        line(44);
        string("");
        assign(base+3);//ttarget
        pop();
    if_2_1:
    if_2_0:;
    line(49);
    line(47);
    _clp_s_debug(0);
    if(!flag()) goto if_3_1;
        line(48);
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
    line(61);
    {
    line(51);
    push(&ONE);
    int sg=sign();
    push(&ZERO);
    assign(base+9);//n
    lab_4_0:
    push_symbol(base+1);//object
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_4_2;
        line(57);
        line(53);
        push_symbol(base+9);//n
        push(&ZERO);
        eqeq();
        cmp_390:;
        if(!flag()) goto if_5_1;
            line(54);
            push_symbol(base+0);//exenam
            assign(base+4);//depend
            pop();
        goto if_5_0;
        if_5_1:
        line(55);
            line(56);
            push_symbol(base+1);//object
            push_symbol(base+9);//n
            idxr();
            assign(base+4);//depend
            pop();
        if_5_2:
        if_5_0:;
        line(59);
        push_symbol(base+8);//objdir
        _clp_dirsep(0);
        add();
        push_symbol(base+4);//depend
        add();
        string(".obj");
        add();
        assign(base+4);//depend
        pop();
        line(60);
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
    {
    line(63);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+9);//n
    lab_6_0:
    _clp_s_libspec(0);
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_6_2;
        line(67);
        line(64);
        _clp_s_libspec(0);
        push_symbol(base+9);//n
        idxr();
        number(4);
        _clp_right(2);
        string(".lib");
        eqeq();
        cmp_550:;
        if(!flag()) goto if_7_1;
            line(65);
            _clp_s_libspec(0);
            push_symbol(base+9);//n
            idxr();
            assign(base+4);//depend
            pop();
            line(66);
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
        if_7_1:
        if_7_0:;
    lab_6_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+9);//n
    add();
    assign(base+9);//n
    goto lab_6_0;
    lab_6_2:;
    }
    line(72);
    line(70);
    _clp_s_debug(0);
    if(!flag()) goto if_8_1;
        line(71);
        _clp_qout(0);
        pop();
    if_8_1:
    if_8_0:;
    line(103);
    line(74);
    push_symbol(base+6);//update
    if(!flag()) goto if_9_1;
        line(75);
        push_symbol(base+7);//torun
        string(" ");
        push_symbol(base+0);//exenam
        add();
        add();
        assign(base+7);//torun
        pop();
        line(86);
        string("");
        assign(base+11);//objlist
        pop();
        line(93);
        {
        line(87);
        push(&ONE);
        int sg=sign();
        push(&ZERO);
        assign(base+9);//n
        lab_10_0:
        push_symbol(base+1);//object
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_10_2;
            line(89);
            push_symbol(base+8);//objdir
            _clp_dirsep(0);
            add();
            assign(base+12);//xobj
            pop();
            line(90);
            push_symbol(base+12);//xobj
            push_symbol(base+9);//n
            push(&ZERO);
            eqeq();
            cmp_738:;
            if(flag()){
            push_symbol(base+0);//exenam
            }else{
            push_symbol(base+1);//object
            push_symbol(base+9);//n
            idxr();
            }
            add();
            assign(base+12);//xobj
            pop();
            line(91);
            push_symbol(base+12);//xobj
            string(".obj");
            add();
            assign(base+12);//xobj
            pop();
            line(92);
            push_symbol(base+11);//objlist
            push_symbol(base+12);//xobj
            _clp_endofline(0);
            add();
            add();
            assign(base+11);//objlist
            pop();
        lab_10_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+9);//n
        add();
        assign(base+9);//n
        goto lab_10_0;
        lab_10_2:;
        }
        line(94);
        push_symbol(base+8);//objdir
        _clp_dirsep(0);
        add();
        string("objects-");
        add();
        push_symbol(base+0);//exenam
        add();
        push_symbol(base+11);//objlist
        _clp_memowrit(2);
        pop();
        line(97);
        push_symbol(base+7);//torun
        _clp_run1(1);
        pop();
        line(102);
        line(99);
        push_symbol(base+10);//bindir
        _clp_empty(1);
        topnot();
        if(!flag()) goto if_11_1;
            line(100);
            push_symbol(base+10);//bindir
            _clp_dirsep(0);
            add();
            push_symbol(base+0);//exenam
            add();
            string(".exe");
            add();
            _clp_ferase(1);
            pop();
            line(101);
            push_symbol(base+2);//target
            push_symbol(base+10);//bindir
            _clp_dirsep(0);
            add();
            push_symbol(base+0);//exenam
            add();
            string(".exe");
            add();
            _clp_filecopy(2);
            pop();
        if_11_1:
        if_11_0:;
    if_9_1:
    if_9_0:;
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

