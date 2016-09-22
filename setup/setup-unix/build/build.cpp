//input: build.ppo (4.4.27)

#include <clp2cpp.h>

static void _blk_adddep_0(int argno);
static void _blk_build_0(int argno);
static void _blk_build_1(int argno);
static void _blk_byrules_0(int argno);
extern void _clp___quit(int argno);
extern void _clp_aadd(int argno);
extern void _clp_aclone(int argno);
static void _clp_adddep(int argno);
extern void _clp_ains(int argno);
extern void _clp_alltrim(int argno);
extern void _clp_argv(int argno);
extern void _clp_ascan(int argno);
extern void _clp_asort(int argno);
extern void _clp_at(int argno);
static void _clp_build(int argno);
static void _clp_byhand(int argno);
static void _clp_byrules(int argno);
extern void _clp_chr(int argno);
extern void _clp_directory(int argno);
extern void _clp_dirsep(int argno);
extern void _clp_dtos(int argno);
extern void _clp_empty(int argno);
extern void _clp_errorlevel(int argno);
extern void _clp_ferase(int argno);
extern void _clp_fext(int argno);
extern void _clp_file(int argno);
extern void _clp_fname(int argno);
extern void _clp_fnameext(int argno);
extern void _clp_fpath(int argno);
extern void _clp_fpath0(int argno);
static void _clp_ftime(int argno);
extern void _clp_getenv(int argno);
extern void _clp_left(int argno);
extern void _clp_len(int argno);
extern void _clp_lower(int argno);
extern void _clp_main(int argno);
static void _clp_makeexe(int argno);
static void _clp_makeexe1(int argno);
static void _clp_makelib(int argno);
static void _clp_makeobj(int argno);
static void _clp_makeso(int argno);
extern void _clp_memoread(int argno);
static void _clp_normalize(int argno);
static void _clp_params(int argno);
static void _clp_procpar(int argno);
extern void _clp_psort(int argno);
extern void _clp_putenv(int argno);
extern void _clp_qout(int argno);
extern void _clp_qqout(int argno);
static void _clp_readpar(int argno);
extern void _clp_right(int argno);
static void _clp_root(int argno);
static void _clp_ruleidx(int argno);
extern void _clp_run(int argno);
static void _clp_run1(int argno);
static void _clp_search_file(int argno);
static void _clp_search_include(int argno);
static void _clp_search_library(int argno);
extern void _clp_split(int argno);
extern void _clp_strtran(int argno);
extern void _clp_substr(int argno);
static void _clp_usage(int argno);
static void _clp_xsplit(int argno);
static void _ini__s_rules();

static VALUE* _st_s_main_ptr()
{
    static stvar _st_s_main;
    return _st_s_main.ptr;
}
static VALUE* _st_s_libnam_ptr()
{
    static stvar _st_s_libnam;
    return _st_s_libnam.ptr;
}
static VALUE* _st_s_shared_ptr()
{
    static stvar _st_s_shared;
    return _st_s_shared.ptr;
}
static VALUE* _st_s_srcdir_ptr()
{
    static stvar _st_s_srcdir;
    return _st_s_srcdir.ptr;
}
static VALUE* _st_s_incdir_ptr()
{
    static stvar _st_s_incdir;
    return _st_s_incdir.ptr;
}
static VALUE* _st_s_libdir_ptr()
{
    static stvar _st_s_libdir;
    return _st_s_libdir.ptr;
}
static VALUE* _st_s_libfil_ptr()
{
    static stvar _st_s_libfil;
    return _st_s_libfil.ptr;
}
MUTEX_CREATE(_mutex_s_quiet);
static VALUE* _st_s_quiet_ptr()
{
    SIGNAL_LOCK();
    MUTEX_LOCK(_mutex_s_quiet);
    static stvar _st_s_quiet(&FALSE);
    MUTEX_UNLOCK(_mutex_s_quiet);
    SIGNAL_UNLOCK();
    return _st_s_quiet.ptr;
}
MUTEX_CREATE(_mutex_s_version);
static VALUE* _st_s_version_ptr()
{
    SIGNAL_LOCK();
    MUTEX_LOCK(_mutex_s_version);
    static stvar _st_s_version(&FALSE);
    MUTEX_UNLOCK(_mutex_s_version);
    SIGNAL_UNLOCK();
    return _st_s_version.ptr;
}
MUTEX_CREATE(_mutex_s_debug);
static VALUE* _st_s_debug_ptr()
{
    SIGNAL_LOCK();
    MUTEX_LOCK(_mutex_s_debug);
    static stvar _st_s_debug(&FALSE);
    MUTEX_UNLOCK(_mutex_s_debug);
    SIGNAL_UNLOCK();
    return _st_s_debug.ptr;
}
MUTEX_CREATE(_mutex_s_dry);
static VALUE* _st_s_dry_ptr()
{
    SIGNAL_LOCK();
    MUTEX_LOCK(_mutex_s_dry);
    static stvar _st_s_dry(&FALSE);
    MUTEX_UNLOCK(_mutex_s_dry);
    SIGNAL_UNLOCK();
    return _st_s_dry.ptr;
}
MUTEX_CREATE(_mutex_s_primary);
static VALUE* _st_s_primary_ptr()
{
    SIGNAL_LOCK();
    MUTEX_LOCK(_mutex_s_primary);
    static stvar _st_s_primary(".y.lem.lex.prg.cpp.c.asm.tds.");
    MUTEX_UNLOCK(_mutex_s_primary);
    SIGNAL_UNLOCK();
    return _st_s_primary.ptr;
}
MUTEX_CREATE(_mutex_s_libabs);
static VALUE* _st_s_libabs_ptr()
{
    SIGNAL_LOCK();
    MUTEX_LOCK(_mutex_s_libabs);
    static stvar _st_s_libabs(&TRUE);
    MUTEX_UNLOCK(_mutex_s_libabs);
    SIGNAL_UNLOCK();
    return _st_s_libabs.ptr;
}
MUTEX_CREATE(_mutex_s_rules);
static VALUE* _st_s_rules_ptr()
{
    SIGNAL_LOCK();
    MUTEX_LOCK(_mutex_s_rules);
    static stvar _st_s_rules(_ini__s_rules);
    MUTEX_UNLOCK(_mutex_s_rules);
    SIGNAL_UNLOCK();
    return _st_s_rules.ptr;
}

static void _ini__s_rules()
{
    string(".msk");
    string(".dlg");
    array(2);
    string(".msk");
    string(".pnl");
    array(2);
    string(".mnt");
    string(".gpi");
    array(2);
    string(".cls");
    string(".och");
    array(2);
    string(".msk");
    string(".say");
    array(2);
    string(".htm");
    string(".ctm");
    array(2);
    string(".msk");
    string(".wro");
    array(2);
    string(".pge");
    string(".out");
    array(2);
    string(".pge");
    string(".wro");
    array(2);
    string(".asm");
    string(".obj");
    array(2);
    string(".c");
    string(".obj");
    array(2);
    string(".cpp");
    string(".obj");
    array(2);
    string(".tds");
    string(".obj");
    array(2);
    string(".prg");
    string(".obj");
    array(2);
    string(".y");
    string(".obj");
    array(2);
    string(".lem");
    string(".obj");
    array(2);
    string(".lex");
    string(".obj");
    array(2);
    string(".obj");
    string(".lib");
    array(2);
    string(".obj");
    string(".exe");
    array(2);
    array(19);
}
//=======================================================================
void _clp_main(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+2)PUSHNIL();
argno=0;
push_call("main",base);
//
    line(67);
    _clp_argv(0);
    _clp_aclone(1);
    assign(base+0);//opt
    pop();
    line(75);
    line(72);
    push_symbol(_st_s_quiet_ptr());//global
    topnot();
    if(!flag()) goto if_1_1;
        line(73);
        string(nls_text("CCC Program Builder "));
        string("1.3.05");
        add();
        string(" Copyright (C) ComFirm Bt.");
        add();
        _clp_qqout(1);
        pop();
        line(74);
        _clp_qout(0);
        pop();
    if_1_1:
    if_1_0:;
    line(160);
    {
    line(78);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+1);//n
    lab_2_0:
    push_symbol(base+0);//opt
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_2_2;
        line(79);
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        _clp_procpar(1);
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        assign2(idxxl());
        pop();
        line(159);
        line(81);
        string("-l");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_1;
            line(82);
            push_symbol(base+0);//opt
            push_symbol(base+1);//n
            idxr();
            number(3);
            _clp_substr(2);
            assign(_st_s_libnam_ptr());//global
            pop();
            line(83);
            push(&FALSE);
            assign(_st_s_shared_ptr());//global
            pop();
        goto if_3_0;
        if_3_1:
        line(86);
        string("-s");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_2;
            line(87);
            push_symbol(base+0);//opt
            push_symbol(base+1);//n
            idxr();
            number(3);
            _clp_substr(2);
            assign(_st_s_libnam_ptr());//global
            pop();
            line(88);
            push(&TRUE);
            assign(_st_s_shared_ptr());//global
            pop();
        goto if_3_0;
        if_3_2:
        line(91);
        string("-d");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_3;
            line(96);
            line(92);
            push_symbol(_st_s_srcdir_ptr());//global
            push(&NIL);
            eqeq();
            if(!flag()) goto if_4_1;
                line(93);
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                assign(_st_s_srcdir_ptr());//global
                pop();
            goto if_4_0;
            if_4_1:
            line(94);
                line(95);
                push_symbol(_st_s_srcdir_ptr());//global
                string(",");
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                add();
                add();
                assign(_st_s_srcdir_ptr());//global
                pop();
            if_4_2:
            if_4_0:;
        goto if_3_0;
        if_3_3:
        line(99);
        string("-i");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_4;
            line(104);
            line(100);
            push_symbol(_st_s_incdir_ptr());//global
            push(&NIL);
            eqeq();
            if(!flag()) goto if_5_1;
                line(101);
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                assign(_st_s_incdir_ptr());//global
                pop();
            goto if_5_0;
            if_5_1:
            line(102);
                line(103);
                push_symbol(_st_s_incdir_ptr());//global
                string(",");
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                add();
                add();
                assign(_st_s_incdir_ptr());//global
                pop();
            if_5_2:
            if_5_0:;
        goto if_3_0;
        if_3_4:
        line(107);
        string("-p");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_5;
            line(112);
            line(108);
            push_symbol(_st_s_libdir_ptr());//global
            push(&NIL);
            eqeq();
            if(!flag()) goto if_6_1;
                line(109);
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                assign(_st_s_libdir_ptr());//global
                pop();
            goto if_6_0;
            if_6_1:
            line(110);
                line(111);
                push_symbol(_st_s_libdir_ptr());//global
                string(",");
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                add();
                add();
                assign(_st_s_libdir_ptr());//global
                pop();
            if_6_2:
            if_6_0:;
        goto if_3_0;
        if_3_5:
        line(115);
        string("-b");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_6;
            line(120);
            line(116);
            push_symbol(_st_s_libfil_ptr());//global
            push(&NIL);
            eqeq();
            if(!flag()) goto if_7_1;
                line(117);
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                assign(_st_s_libfil_ptr());//global
                pop();
            goto if_7_0;
            if_7_1:
            line(118);
                line(119);
                push_symbol(_st_s_libfil_ptr());//global
                string(",");
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                add();
                add();
                assign(_st_s_libfil_ptr());//global
                pop();
            if_7_2:
            if_7_0:;
        goto if_3_0;
        if_3_6:
        line(123);
        string("-x");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(flag()){
        push(&TRUE);
        }else{
        string("-m");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        }
        if(!flag()) goto if_3_7;
            line(128);
            line(124);
            push_symbol(_st_s_main_ptr());//global
            push(&NIL);
            eqeq();
            if(!flag()) goto if_8_1;
                line(125);
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                assign(_st_s_main_ptr());//global
                pop();
            goto if_8_0;
            if_8_1:
            line(126);
                line(127);
                push_symbol(_st_s_main_ptr());//global
                string(",");
                push_symbol(base+0);//opt
                push_symbol(base+1);//n
                idxr();
                number(3);
                _clp_substr(2);
                add();
                add();
                assign(_st_s_main_ptr());//global
                pop();
            if_8_2:
            if_8_0:;
        goto if_3_0;
        if_3_7:
        line(131);
        string("-h");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_8;
            line(132);
            _clp_usage(0);
            pop();
            line(133);
            _clp___quit(0);
            pop();
        goto if_3_0;
        if_3_8:
        line(135);
        string("-q");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_9;
            line(136);
            push(&TRUE);
            assign(_st_s_quiet_ptr());//global
            pop();
        goto if_3_0;
        if_3_9:
        line(138);
        string("-v");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        number(2);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_10;
            line(139);
            push(&TRUE);
            assign(_st_s_version_ptr());//global
            pop();
        goto if_3_0;
        if_3_10:
        line(141);
        string("--debug");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        eqeq();
        if(!flag()) goto if_3_11;
            line(142);
            push(&TRUE);
            assign(_st_s_debug_ptr());//global
            pop();
        goto if_3_0;
        if_3_11:
        line(144);
        string("--dry");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        eqeq();
        if(!flag()) goto if_3_12;
            line(145);
            push(&TRUE);
            assign(_st_s_debug_ptr());//global
            pop();
            line(146);
            push(&TRUE);
            assign(_st_s_dry_ptr());//global
            pop();
        goto if_3_0;
        if_3_12:
        line(148);
        string("@");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        push(&ONE);
        _clp_left(2);
        eqeq();
        if(!flag()) goto if_3_13;
            line(149);
            push_symbol(base+0);//opt
            push_symbol(base+1);//n
            idxr();
            number(2);
            _clp_substr(2);
            push_symbol(base+0);//opt
            push_symbol(base+1);//n
            _clp_readpar(3);
            pop();
        goto if_3_0;
        if_3_13:
        line(151);
        string("=");
        push_symbol(base+0);//opt
        push_symbol(base+1);//n
        idxr();
        ss();
        if(!flag()) goto if_3_14;
            line(152);
            push_symbol(base+0);//opt
            push_symbol(base+1);//n
            idxr();
            _clp_putenv(1);
            pop();
        goto if_3_0;
        if_3_14:
        line(154);
            line(155);
            string(nls_text("Invalid switch: "));
            push_symbol(base+0);//opt
            push_symbol(base+1);//n
            idxr();
            _clp_qout(2);
            pop();
            line(156);
            _clp_usage(0);
            pop();
            line(157);
            push(&ONE);
            _clp_errorlevel(1);
            pop();
            line(158);
            _clp___quit(0);
            pop();
        if_3_15:
        if_3_0:;
    lab_2_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+1);//n
    add();
    assign(base+1);//n
    goto lab_2_0;
    lab_2_2:;
    }
    line(165);
    line(163);
    string("on");
    string("BUILD_DBG");
    _clp_getenv(1);
    _clp_lower(1);
    ss();
    if(!flag()) goto if_9_1;
        line(164);
        push(&TRUE);
        assign(_st_s_debug_ptr());//global
        pop();
    if_9_1:
    if_9_0:;
    line(168);
    line(166);
    string("debug");
    string("BUILD_DBG");
    _clp_getenv(1);
    _clp_lower(1);
    ss();
    if(!flag()) goto if_10_1;
        line(167);
        push(&TRUE);
        assign(_st_s_debug_ptr());//global
        pop();
    if_10_1:
    if_10_0:;
    line(172);
    line(169);
    string("dry");
    string("BUILD_DBG");
    _clp_getenv(1);
    _clp_lower(1);
    ss();
    if(!flag()) goto if_11_1;
        line(170);
        push(&TRUE);
        assign(_st_s_debug_ptr());//global
        pop();
        line(171);
        push(&TRUE);
        assign(_st_s_dry_ptr());//global
        pop();
    if_11_1:
    if_11_0:;
    line(176);
    line(174);
    push_symbol(_st_s_version_ptr());//global
    if(!flag()) goto if_12_1;
        line(175);
        _clp___quit(0);
        pop();
    if_12_1:
    if_12_0:;
    line(178);
    _clp_root(0);
    pop();
    line(179);
    _clp_params(0);
    pop();
    line(180);
    _clp_build(0);
    pop();
    line(182);
    _clp_qout(0);
    pop();
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_readpar(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,3);
while(stack<base+7)PUSHNIL();
argno=3;
push_call("readpar",base);
//
    line(187);
    push_symbol(base+0);//parfil
    _clp_memoread(1);
    assign(base+3);//par
    pop();
    line(194);
    line(189);
    push_symbol(base+3);//par
    _clp_empty(1);
    if(!flag()) goto if_13_1;
        line(193);
        string("BUILD_BAT");
        _clp_getenv(1);
        _clp_dirsep(0);
        add();
        push_symbol(base+0);//parfil
        add();
        _clp_memoread(1);
        assign(base+3);//par
        pop();
    if_13_1:
    if_13_0:;
    line(202);
    line(196);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_14_1;
        line(201);
        line(197);
        push_symbol(base+3);//par
        _clp_empty(1);
        if(!flag()) goto if_15_1;
            line(198);
            string("Build parfile empty:");
            push_symbol(base+0);//parfil
            _clp_qqout(2);
            pop();
            _clp_qout(0);
            pop();
        goto if_15_0;
        if_15_1:
        line(199);
            line(200);
            string("Build parfile:");
            push_symbol(base+0);//parfil
            _clp_qqout(2);
            pop();
            _clp_qout(0);
            pop();
        if_15_2:
        if_15_0:;
    if_14_1:
    if_14_0:;
    line(204);
    push_symbol(base+3);//par
    number(13);
    _clp_chr(1);
    string("");
    _clp_strtran(3);
    assign(base+3);//par
    pop();
    line(205);
    push_symbol(base+3);//par
    number(10);
    _clp_chr(1);
    _clp_split(2);
    assign(base+3);//par
    pop();
    line(221);
    {
    line(207);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+4);//n
    lab_16_0:
    push_symbol(base+3);//par
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_16_2;
        line(208);
        push_symbol(base+3);//par
        push_symbol(base+4);//n
        idxr();
        assign(base+5);//p
        pop();
        line(211);
        line(209);
        string("#");
        push_symbol(base+5);//p
        ss();
        if(!flag()) goto if_17_1;
            line(210);
            push_symbol(base+5);//p
            string("#");
            push_symbol(base+5);//p
            _clp_at(2);
            addnum(-1);
            _clp_left(2);
            assign(base+5);//p
            pop();
        if_17_1:
        if_17_0:;
        line(213);
        push_symbol(base+5);//p
        string(" ");
        _clp_split(2);
        assign(base+5);//p
        pop();
        line(220);
        {
        line(214);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+6);//i
        lab_18_0:
        push_symbol(base+5);//p
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_18_2;
            line(219);
            line(215);
            push_symbol(base+5);//p
            push_symbol(base+6);//i
            idxr();
            _clp_empty(1);
            topnot();
            if(!flag()) goto if_19_1;
                line(216);
                push_symbol(base+1);//opt
                push(&NIL);
                _clp_aadd(2);
                pop();
                line(217);
                push_symbol(base+1);//opt
                push_symbol(base+2);//optx
                push(&ONE);
                add();
                assign(base+2);//optx
                _clp_ains(2);
                pop();
                line(218);
                push_symbol(base+5);//p
                push_symbol(base+6);//i
                idxr();
                push_symbol(base+1);//opt
                push_symbol(base+2);//optx
                assign2(idxxl());
                pop();
            if_19_1:
            if_19_0:;
        lab_18_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+6);//i
        add();
        assign(base+6);//i
        goto lab_18_0;
        lab_18_2:;
        }
    lab_16_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+4);//n
    add();
    assign(base+4);//n
    goto lab_16_0;
    lab_16_2:;
    }
    line(222);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_procpar(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+3)PUSHNIL();
argno=1;
push_call("procpar",base);
//
    line(226);
    line(235);
    lab_20_1:
    line(228);
    push(&ZERO);
    string("$$(");
    push_symbol(base+0);//par
    _clp_at(2);
    assign(base+1);//n
    lt();
    if(!flag()) goto lab_20_2;
        line(229);
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(-1);
        _clp_left(2);
        assign(base+2);//p
        pop();
        line(230);
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(3);
        _clp_substr(2);
        assign(base+0);//par
        pop();
        line(231);
        string(")");
        push_symbol(base+0);//par
        _clp_at(2);
        assign(base+1);//n
        pop();
        line(232);
        push_symbol(base+2);//p
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(-1);
        _clp_left(2);
        string("/$(BUILD_OBJ)/");
        add();
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(-1);
        _clp_left(2);
        add();
        add();
        assign(base+2);//p
        pop();
        line(233);
        push_symbol(base+2);//p
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(1);
        _clp_substr(2);
        add();
        assign(base+2);//p
        pop();
        line(234);
        push_symbol(base+2);//p
        assign(base+0);//par
        pop();
    goto lab_20_1;
    lab_20_2:;
    line(244);
    lab_21_1:
    line(237);
    push(&ZERO);
    string("$(");
    push_symbol(base+0);//par
    _clp_at(2);
    assign(base+1);//n
    lt();
    if(!flag()) goto lab_21_2;
        line(238);
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(-1);
        _clp_left(2);
        assign(base+2);//p
        pop();
        line(239);
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(2);
        _clp_substr(2);
        assign(base+0);//par
        pop();
        line(240);
        string(")");
        push_symbol(base+0);//par
        _clp_at(2);
        assign(base+1);//n
        pop();
        line(241);
        push_symbol(base+2);//p
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(-1);
        _clp_left(2);
        _clp_getenv(1);
        add();
        assign(base+2);//p
        pop();
        line(242);
        push_symbol(base+2);//p
        push_symbol(base+0);//par
        push_symbol(base+1);//n
        addnum(1);
        _clp_substr(2);
        add();
        assign(base+2);//p
        pop();
        line(243);
        push_symbol(base+2);//p
        assign(base+0);//par
        pop();
    goto lab_21_1;
    lab_21_2:;
    line(246);
    push_symbol(base+0);//par
    string("\\");
    _clp_dirsep(0);
    _clp_strtran(3);
    assign(base+0);//par
    pop();
    line(247);
    push_symbol(base+0);//par
    string("/");
    _clp_dirsep(0);
    _clp_strtran(3);
    assign(base+0);//par
    pop();
    line(249);
    push_symbol(base+0);//par
    push(&ONE);
    _clp_left(2);
    string("=");
    eqeq();
    if(flag()){
    push_symbol(base+0);//par
    _clp_lower(1);
    }else{
    push_symbol(base+0);//par
    }
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_usage(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+0)PUSHNIL();
argno=0;
push_call("usage",base);
//
    line(254);
    string(nls_text("BUILD -xExeNam|-lLibNam -dSrcDir -iIncDir -pLibDir -bLibFil -mMain"));
    _clp_qout(1);
    pop();
    line(255);
    _clp_qout(0);
    pop();
    line(256);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_root(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+3)PUSHNIL();
argno=0;
push_call("root",base);
//
    line(262);
    line(299);
    line(264);
    string("BUILD_SRC");
    _clp_getenv(1);
    assign(base+0);//srcroot
    _clp_empty(1);
    topnot();
    if(!flag()) goto if_22_1;
        line(268);
        line(266);
        push_symbol(base+0);//srcroot
        push(&ONE);
        _clp_right(2);
        string("/\\");
        ss();
        topnot();
        if(!flag()) goto if_23_1;
            line(267);
            push_symbol(base+0);//srcroot
            _clp_dirsep(0);
            add();
            assign(base+0);//srcroot
            pop();
        if_23_1:
        if_23_0:;
        line(272);
        line(270);
        push_symbol(_st_s_srcdir_ptr());//global
        push(&NIL);
        eqeq();
        if(!flag()) goto if_24_1;
            line(271);
            string(".");
            assign(_st_s_srcdir_ptr());//global
            pop();
        if_24_1:
        if_24_0:;
        line(274);
        push_symbol(_st_s_srcdir_ptr());//global
        string(",;");
        _clp_xsplit(2);
        assign(base+1);//d
        pop();
        line(276);
        string("");
        assign(_st_s_srcdir_ptr());//global
        pop();
        line(283);
        {
        line(277);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+2);//n
        lab_25_0:
        push_symbol(base+1);//d
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_25_2;
            line(282);
            line(278);
            push_symbol(base+1);//d
            push_symbol(base+2);//n
            idxr();
            push(&ONE);
            _clp_left(2);
            string("/\\");
            ss();
            if(!flag()) goto if_26_1;
                line(279);
                push_symbol(_st_s_srcdir_ptr());//global
                push_symbol(base+1);//d
                push_symbol(base+2);//n
                idxr();
                string(";");
                add();
                add();
                assign(_st_s_srcdir_ptr());//global
                pop();
            goto if_26_0;
            if_26_1:
            line(280);
                line(281);
                push_symbol(_st_s_srcdir_ptr());//global
                push_symbol(base+0);//srcroot
                push_symbol(base+1);//d
                push_symbol(base+2);//n
                idxr();
                add();
                string(";");
                add();
                add();
                assign(_st_s_srcdir_ptr());//global
                pop();
            if_26_2:
            if_26_0:;
        lab_25_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+2);//n
        add();
        assign(base+2);//n
        goto lab_25_0;
        lab_25_2:;
        }
        line(298);
        line(286);
        push_symbol(_st_s_incdir_ptr());//global
        push(&NIL);
        neeq();
        if(!flag()) goto if_27_1;
            line(288);
            push_symbol(_st_s_incdir_ptr());//global
            string(",;");
            _clp_xsplit(2);
            assign(base+1);//d
            pop();
            line(290);
            string("");
            assign(_st_s_incdir_ptr());//global
            pop();
            line(297);
            {
            line(291);
            push(&ONE);
            int sg=sign();
            push(&ONE);
            assign(base+2);//n
            lab_28_0:
            push_symbol(base+1);//d
            _clp_len(1);
            if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_28_2;
                line(296);
                line(292);
                push_symbol(base+1);//d
                push_symbol(base+2);//n
                idxr();
                push(&ONE);
                _clp_left(2);
                string("/\\");
                ss();
                if(!flag()) goto if_29_1;
                    line(293);
                    push_symbol(_st_s_incdir_ptr());//global
                    push_symbol(base+1);//d
                    push_symbol(base+2);//n
                    idxr();
                    string(";");
                    add();
                    add();
                    assign(_st_s_incdir_ptr());//global
                    pop();
                goto if_29_0;
                if_29_1:
                line(294);
                    line(295);
                    push_symbol(_st_s_incdir_ptr());//global
                    push_symbol(base+0);//srcroot
                    push_symbol(base+1);//d
                    push_symbol(base+2);//n
                    idxr();
                    add();
                    string(";");
                    add();
                    add();
                    assign(_st_s_incdir_ptr());//global
                    pop();
                if_29_2:
                if_29_0:;
            lab_28_1:
            push(&ONE);
            dup();
            sg=sign();
            push_symbol(base+2);//n
            add();
            assign(base+2);//n
            goto lab_28_0;
            lab_28_2:;
            }
        if_27_1:
        if_27_0:;
    if_22_1:
    if_22_0:;
    line(301);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_params(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+4)PUSHNIL();
argno=0;
push_call("params",base);
//
    line(307);
    line(320);
    string("");
    assign(base+0);//txt
    pop();
    line(321);
    push_symbol(base+0);//txt
    push_symbol(_st_s_srcdir_ptr());//global
    push(&NIL);
    eqeq();
    if(flag()){
    string(".");
    }else{
    push_symbol(_st_s_srcdir_ptr());//global
    }
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(322);
    push_symbol(base+0);//txt
    push_symbol(_st_s_incdir_ptr());//global
    push(&NIL);
    eqeq();
    if(flag()){
    string("");
    }else{
    push_symbol(_st_s_incdir_ptr());//global
    }
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(323);
    push_symbol(base+0);//txt
    string("BUILD_INC");
    _clp_getenv(1);
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(324);
    push_symbol(base+0);//txt
    string("include");
    _clp_getenv(1);
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(325);
    push_symbol(base+0);//txt
    string(",");
    string(" ");
    _clp_strtran(3);
    assign(base+0);//txt
    pop();
    line(326);
    push_symbol(base+0);//txt
    string(";");
    string(" ");
    _clp_strtran(3);
    assign(base+0);//txt
    pop();
    line(328);
    push_symbol(base+0);//txt
    string(":");
    string(" ");
    _clp_strtran(3);
    assign(base+0);//txt
    pop();
    line(330);
    string("BUILD_INC=");
    push_symbol(base+0);//txt
    add();
    _clp_putenv(1);
    pop();
    line(336);
    string("");
    assign(base+0);//txt
    pop();
    line(337);
    push_symbol(base+0);//txt
    push_symbol(_st_s_libdir_ptr());//global
    push(&NIL);
    eqeq();
    if(flag()){
    string("");
    }else{
    push_symbol(_st_s_libdir_ptr());//global
    }
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(338);
    push_symbol(base+0);//txt
    string("BUILD_LPT");
    _clp_getenv(1);
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(339);
    push_symbol(base+0);//txt
    string("lib");
    _clp_getenv(1);
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(340);
    push_symbol(base+0);//txt
    string(",");
    string(" ");
    _clp_strtran(3);
    assign(base+0);//txt
    pop();
    line(341);
    push_symbol(base+0);//txt
    string(";");
    string(" ");
    _clp_strtran(3);
    assign(base+0);//txt
    pop();
    line(343);
    push_symbol(base+0);//txt
    string(":");
    string(" ");
    _clp_strtran(3);
    assign(base+0);//txt
    pop();
    line(345);
    string("BUILD_LPT=");
    push_symbol(base+0);//txt
    add();
    _clp_putenv(1);
    pop();
    line(351);
    string("");
    assign(base+0);//txt
    pop();
    line(352);
    push_symbol(base+0);//txt
    push_symbol(_st_s_libfil_ptr());//global
    push(&NIL);
    eqeq();
    if(flag()){
    string("");
    }else{
    push_symbol(_st_s_libfil_ptr());//global
    }
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(353);
    push_symbol(base+0);//txt
    string("BUILD_LIB");
    _clp_getenv(1);
    string(";");
    add();
    add();
    assign(base+0);//txt
    pop();
    line(354);
    push_symbol(base+0);//txt
    string(",");
    string(" ");
    _clp_strtran(3);
    assign(base+0);//txt
    pop();
    line(355);
    push_symbol(base+0);//txt
    string(";");
    string(" ");
    _clp_strtran(3);
    assign(base+0);//txt
    pop();
    line(356);
    string("BUILD_LIB=");
    push_symbol(base+0);//txt
    add();
    _clp_putenv(1);
    pop();
    line(359);
    line(357);
    push_symbol(_st_s_libabs_ptr());//global
    if(!flag()) goto if_30_1;
        line(358);
        string("BUILD_LIB=");
        _clp_search_library(0);
        add();
        _clp_putenv(1);
        pop();
    if_30_1:
    if_30_0:;
    line(362);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_build(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+12)PUSHNIL();
argno=0;
push_call("build",base);
//
    line(368);
    array(0);
    assign(base+0);//dir
    pop();
    line(369);
    array(0);
    assign(base+1);//obj
    pop();
    line(370);
    array(0);
    assign(base+2);//lib
    pop();
    line(371);
    array(0);
    assign(base+3);//mmd
    pop();
    line(372);
    array(0);
    assign(base+4);//todo
    pop();
    line(374);
    line(379);
    line(377);
    push_symbol(_st_s_main_ptr());//global
    push(&NIL);
    neeq();
    if(!flag()) goto if_31_1;
        line(378);
        push_symbol(_st_s_main_ptr());//global
        _clp_lower(1);
        string(",;");
        _clp_xsplit(2);
        assign(base+3);//mmd
        pop();
    if_31_1:
    if_31_0:;
    line(386);
    line(382);
    push_symbol(_st_s_srcdir_ptr());//global
    push(&NIL);
    neeq();
    if(!flag()) goto if_32_1;
        line(383);
        push_symbol(_st_s_srcdir_ptr());//global
        string(",;");
        _clp_xsplit(2);
        assign(base+0);//dir
        pop();
    goto if_32_0;
    if_32_1:
    line(384);
        line(385);
        string(".");
        array(1);
        assign(base+0);//dir
        pop();
    if_32_2:
    if_32_0:;
    line(402);
    {
    line(388);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+8);//n
    lab_33_0:
    push_symbol(base+0);//dir
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_33_2;
        line(390);
        string("");
        push_symbol(base+0);//dir
        push_symbol(base+8);//n
        idxr();
        _clp_qqout(2);
        pop();
        line(392);
        push_symbol(base+0);//dir
        push_symbol(base+8);//n
        idxr();
        _clp_dirsep(0);
        add();
        string("*.*");
        add();
        _clp_directory(1);
        assign(base+5);//d1
        pop();
        line(401);
        {
        line(394);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+9);//i
        lab_34_0:
        push_symbol(base+5);//d1
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_34_2;
            line(396);
            push_symbol(base+5);//d1
            push_symbol(base+9);//i
            idxr();
            idxr0(1);
            _clp_lower(1);
            assign(base+6);//f
            pop();
            line(400);
            line(398);
            push_symbol(base+6);//f
            _clp_fext(1);
            string(".");
            add();
            push_symbol(_st_s_primary_ptr());//global
            ss();
            if(!flag()) goto if_35_1;
                line(399);
                push_symbol(base+1);//obj
                push_symbol(base+0);//dir
                push_symbol(base+8);//n
                idxr();
                _clp_dirsep(0);
                add();
                push_symbol(base+6);//f
                add();
                _clp_aadd(2);
                pop();
            if_35_1:
            if_35_0:;
        lab_34_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+9);//i
        add();
        assign(base+9);//i
        goto lab_34_0;
        lab_34_2:;
        }
    lab_33_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+8);//n
    add();
    assign(base+8);//n
    goto lab_33_0;
    lab_33_2:;
    }
    line(403);
    _clp_qout(0);
    pop();
    line(439);
    {
    line(408);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+8);//n
    lab_36_0:
    push_symbol(base+1);//obj
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_36_2;
        line(410);
        push_symbol(base+1);//obj
        push_symbol(base+8);//n
        idxr();
        assign(base+6);//f
        pop();
        line(411);
        push_symbol(base+6);//f
        _clp_fname(1);
        assign(base+7);//o
        pop();
        line(412);
        push_symbol(base+6);//f
        _clp_memoread(1);
        assign(base+10);//txt
        pop();
        line(422);
        line(414);
        push(&ZERO);
        push_symbol(base+3);//mmd
        push_symbol_ref(base+7);//o
        block(_blk_build_0,1);
        _clp_ascan(2);
        neeq();
        if(!flag()) goto if_37_1;
        goto if_37_0;
        if_37_1:
        line(416);
        push_symbol(base+6);//f
        _clp_fext(1);
        string(".prg");
        eqeq();
        if(!flag()){
        push(&FALSE);
        }else{
        string("function main(");
        push_symbol(base+10);//txt
        ss();
        }
        if(!flag()) goto if_37_2;
            line(419);
            line(417);
            push_symbol(_st_s_main_ptr());//global
            push(&NIL);
            eqeq();
            if(!flag()) goto if_38_1;
                line(418);
                push_symbol(base+3);//mmd
                push_symbol(base+7);//o
                _clp_aadd(2);
                pop();
            if_38_1:
            if_38_0:;
        goto if_37_0;
        if_37_2:
        line(420);
            line(421);
            push_symbol(base+2);//lib
            push_symbol(base+7);//o
            _clp_aadd(2);
            pop();
        if_37_3:
        if_37_0:;
        line(424);
        push_symbol(base+7);//o
        string(".obj");
        add();
        push_symbol(base+6);//f
        array(2);
        assign(base+11);//dep
        pop();
        line(436);
        {
        line(425);
        push(&ONE);
        int sg=sign();
        number(2);
        assign(base+9);//i
        lab_39_0:
        push_symbol(base+11);//dep
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_39_2;
            line(434);
            line(426);
            push_symbol(base+9);//i
            number(2);
            eqeq();
            if(!flag()) goto if_40_1;
            goto if_40_0;
            if_40_1:
            line(428);
            push_symbol(base+9);//i
            number(128);
            gt();
            if(!flag()) goto if_40_2;
                line(429);
                string("recursive dependencies:");
                push_symbol(base+11);//dep
                _clp_qout(2);
                pop();
                line(430);
                _clp_qout(0);
                pop();
                line(431);
                _clp___quit(0);
                pop();
            goto if_40_0;
            if_40_2:
            line(432);
                line(433);
                push_symbol(base+11);//dep
                push_symbol(base+9);//i
                idxr();
                _clp_memoread(1);
                assign(base+10);//txt
                pop();
            if_40_3:
            if_40_0:;
            line(435);
            push_symbol(base+10);//txt
            push_symbol(base+11);//dep
            push_symbol(base+0);//dir
            push_symbol(base+4);//todo
            _clp_search_include(4);
            pop();
        lab_39_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+9);//i
        add();
        assign(base+9);//i
        goto lab_39_0;
        lab_39_2:;
        }
        line(438);
        push_symbol(base+4);//todo
        push_symbol(base+11);//dep
        _clp_aadd(2);
        pop();
    lab_36_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+8);//n
    add();
    assign(base+8);//n
    goto lab_36_0;
    lab_36_2:;
    }
    line(441);
    push_symbol(base+4);//todo
    _clp_normalize(1);
    pop();
    line(443);
    push_symbol(base+4);//todo
    push(&NIL);
    push(&NIL);
    block(_blk_build_1,0);
    _clp_asort(4);
    pop();
    line(455);
    line(447);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_41_1;
        line(448);
        string("main:");
        push_symbol(base+3);//mmd
        _clp_qout(2);
        pop();
        line(449);
        string("lib :");
        push_symbol(base+2);//lib
        _clp_qout(2);
        pop();
        line(450);
        _clp_qout(0);
        pop();
        line(453);
        {
        line(451);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+8);//n
        lab_42_0:
        push_symbol(base+4);//todo
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_42_2;
            line(452);
            push_symbol(base+4);//todo
            push_symbol(base+8);//n
            idxr();
            _clp_qout(1);
            pop();
        lab_42_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+8);//n
        add();
        assign(base+8);//n
        goto lab_42_0;
        lab_42_2:;
        }
        line(454);
        _clp_qout(0);
        pop();
    if_41_1:
    if_41_0:;
    line(457);
    string("error");
    _clp_ferase(1);
    pop();
    line(461);
    {
    line(459);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+8);//n
    lab_43_0:
    push_symbol(base+4);//todo
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_43_2;
        line(460);
        push_symbol(base+4);//todo
        push_symbol(base+8);//n
        idxr();
        _clp_makeobj(1);
        pop();
    lab_43_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+8);//n
    add();
    assign(base+8);//n
    goto lab_43_0;
    lab_43_2:;
    }
    line(480);
    line(465);
    push_symbol(_st_s_libnam_ptr());//global
    push(&NIL);
    neeq();
    if(!flag()) goto if_44_1;
        line(466);
        push_symbol(_st_s_libnam_ptr());//global
        push_symbol(base+2);//lib
        _clp_makelib(2);
        pop();
        line(470);
        line(468);
        push_symbol(_st_s_shared_ptr());//global
        push(&TRUE);
        eqeq();
        if(!flag()) goto if_45_1;
            line(469);
            push_symbol(_st_s_libnam_ptr());//global
            push_symbol(base+2);//lib
            _clp_makeso(2);
            pop();
        if_45_1:
        if_45_0:;
        line(474);
        {
        line(472);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+8);//n
        lab_46_0:
        push_symbol(base+3);//mmd
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_46_2;
            line(473);
            push_symbol(base+3);//mmd
            push_symbol(base+8);//n
            idxr();
            push_symbol(_st_s_libnam_ptr());//global
            _clp_makeexe1(2);
            pop();
        lab_46_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+8);//n
        add();
        assign(base+8);//n
        goto lab_46_0;
        lab_46_2:;
        }
    goto if_44_0;
    if_44_1:
    line(476);
        line(479);
        {
        line(477);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+8);//n
        lab_47_0:
        push_symbol(base+3);//mmd
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_47_2;
            line(478);
            push_symbol(base+3);//mmd
            push_symbol(base+8);//n
            idxr();
            push_symbol(base+2);//lib
            _clp_makeexe(2);
            pop();
        lab_47_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+8);//n
        add();
        assign(base+8);//n
        goto lab_47_0;
        lab_47_2:;
        }
    if_44_2:
    if_44_0:;
    line(482);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}

static void _blk_build_0(int argno)
{
VALUE *base=stack-argno;
VALUE *env=blkenv(base);
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
argno=2;
push_call("_blk_build_0",base);
//
    push_blkarg(base+1);//m
    push_blkenv(env+0);//o
    _clp_lower(1);
    eqeq();
//
{*base=*(stack-1);stack=base+1;pop_call();}
}

static void _blk_build_1(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,3);
while(stack<base+3)PUSHNIL();
argno=3;
push_call("_blk_build_1",base);
//
    push_blkarg(base+1);//x
    push_blkarg(base+2);//y
    _clp_psort(2);
//
{*base=*(stack-1);stack=base+1;pop_call();}
}
//=======================================================================
static void _clp_makeso(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+10)PUSHNIL();
argno=2;
push_call("makeso",base);
//
    line(489);
    string("BUILD_OBJ");
    _clp_getenv(1);
    _clp_dirsep(0);
    add();
    string("lib");
    add();
    push_symbol(base+0);//libnam
    add();
    string(".so");
    add();
    assign(base+2);//target
    pop();
    line(490);
    push(&FALSE);
    assign(base+6);//update
    pop();
    line(491);
    string("BUILD_BAT");
    _clp_getenv(1);
    _clp_dirsep(0);
    add();
    string("obj2so.bat");
    add();
    assign(base+7);//torun
    pop();
    line(492);
    string("BUILD_OBJ");
    _clp_getenv(1);
    assign(base+8);//objdir
    pop();
    line(499);
    line(494);
    push_symbol(base+7);//torun
    _clp_file(1);
    topnot();
    if(!flag()) goto if_48_1;
        line(495);
        string("[");
        push_symbol(base+7);//torun
        add();
        string("]");
        add();
        string(nls_text("does not exist"));
        _clp_qout(2);
        pop();
        line(496);
        _clp_qout(0);
        pop();
        line(497);
        push(&ONE);
        _clp_errorlevel(1);
        pop();
        line(498);
        _clp___quit(0);
        pop();
    if_48_1:
    if_48_0:;
    line(501);
    push_symbol(base+7);//torun
    string(" lib");
    push_symbol(base+0);//libnam
    add();
    add();
    assign(base+7);//torun
    pop();
    line(503);
    push_symbol(base+2);//target
    _clp_ftime(1);
    assign(base+3);//ttarget
    pop();
    line(506);
    line(504);
    push_symbol(base+3);//ttarget
    push(&NIL);
    eqeq();
    if(!flag()) goto if_49_1;
        line(505);
        string("");
        assign(base+3);//ttarget
        pop();
    if_49_1:
    if_49_0:;
    line(510);
    line(508);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_50_1;
        line(509);
        push_symbol(base+2);//target
        string("[");
        push_symbol(base+3);//ttarget
        add();
        string("]");
        add();
        _clp_qout(2);
        pop();
    if_50_1:
    if_50_0:;
    line(536);
    {
    line(512);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+9);//n
    lab_51_0:
    push_symbol(base+1);//object
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_51_2;
        line(514);
        push_symbol(base+1);//object
        push_symbol(base+9);//n
        idxr();
        assign(base+4);//depend
        pop();
        line(515);
        push_symbol(base+7);//torun
        string(" ");
        push_symbol(base+4);//depend
        add();
        add();
        assign(base+7);//torun
        pop();
        line(516);
        push_symbol(base+8);//objdir
        _clp_dirsep(0);
        add();
        push_symbol(base+4);//depend
        add();
        string(".obj");
        add();
        assign(base+4);//depend
        pop();
        line(517);
        push_symbol(base+4);//depend
        _clp_ftime(1);
        assign(base+5);//tdepend
        pop();
        line(531);
        line(519);
        push_symbol(base+5);//tdepend
        push(&NIL);
        eqeq();
        if(!flag()) goto if_52_1;
            line(527);
            line(520);
            push_symbol(_st_s_dry_ptr());//global
            if(!flag()) goto if_53_1;
                line(521);
                string("");
                assign(base+5);//tdepend
                pop();
            goto if_53_0;
            if_53_1:
            line(522);
                line(523);
                push_symbol(base+4);//depend
                string(nls_text("does not exist"));
                _clp_qout(2);
                pop();
                line(524);
                _clp_qout(0);
                pop();
                line(525);
                push(&ONE);
                _clp_errorlevel(1);
                pop();
                line(526);
                _clp___quit(0);
                pop();
            if_53_2:
            if_53_0:;
        goto if_52_0;
        if_52_1:
        line(529);
        push_symbol(base+3);//ttarget
        push_symbol(base+5);//tdepend
        lt();
        if(!flag()) goto if_52_2;
            line(530);
            push(&TRUE);
            assign(base+6);//update
            pop();
        if_52_2:
        if_52_0:;
        line(535);
        line(533);
        push_symbol(_st_s_debug_ptr());//global
        if(!flag()) goto if_54_1;
            line(534);
            string("  ");
            push_symbol(base+4);//depend
            string("[");
            push_symbol(base+5);//tdepend
            add();
            string("]");
            add();
            push_symbol(base+3);//ttarget
            push_symbol(base+5);//tdepend
            lt();
            if(flag()){
            string("UPDATE");
            }else{
            string("");
            }
            _clp_qout(4);
            pop();
        if_54_1:
        if_54_0:;
    lab_51_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+9);//n
    add();
    assign(base+9);//n
    goto lab_51_0;
    lab_51_2:;
    }
    line(540);
    line(538);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_55_1;
        line(539);
        _clp_qout(0);
        pop();
    if_55_1:
    if_55_0:;
    line(544);
    line(542);
    push_symbol(base+6);//update
    if(!flag()) goto if_56_1;
        line(543);
        push_symbol(base+7);//torun
        _clp_run1(1);
        pop();
    if_56_1:
    if_56_0:;
    line(546);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_makelib(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+11)PUSHNIL();
argno=2;
push_call("makelib",base);
//
    line(552);
    string("BUILD_OBJ");
    _clp_getenv(1);
    _clp_dirsep(0);
    add();
    push_symbol(base+0);//libnam
    add();
    string(".lib");
    add();
    assign(base+2);//target
    pop();
    line(553);
    push(&FALSE);
    assign(base+6);//update
    pop();
    line(554);
    string("BUILD_BAT");
    _clp_getenv(1);
    _clp_dirsep(0);
    add();
    string("obj2lib.bat");
    add();
    assign(base+7);//torun
    pop();
    line(555);
    string("BUILD_OBJ");
    _clp_getenv(1);
    _clp_lower(1);
    assign(base+8);//objdir
    pop();
    line(556);
    line(563);
    line(558);
    push_symbol(base+7);//torun
    _clp_file(1);
    topnot();
    if(!flag()) goto if_57_1;
        line(559);
        string("[");
        push_symbol(base+7);//torun
        add();
        string("]");
        add();
        string(nls_text("does not exist"));
        _clp_qout(2);
        pop();
        line(560);
        _clp_qout(0);
        pop();
        line(561);
        push(&ONE);
        _clp_errorlevel(1);
        pop();
        line(562);
        _clp___quit(0);
        pop();
    if_57_1:
    if_57_0:;
    line(565);
    push_symbol(base+7);//torun
    string(" ");
    push_symbol(base+0);//libnam
    add();
    add();
    assign(base+7);//torun
    pop();
    line(567);
    push_symbol(base+2);//target
    _clp_ftime(1);
    assign(base+3);//ttarget
    pop();
    line(570);
    line(568);
    push_symbol(base+3);//ttarget
    push(&NIL);
    eqeq();
    if(!flag()) goto if_58_1;
        line(569);
        string("");
        assign(base+3);//ttarget
        pop();
    if_58_1:
    if_58_0:;
    line(574);
    line(572);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_59_1;
        line(573);
        push_symbol(base+2);//target
        string("[");
        push_symbol(base+3);//ttarget
        add();
        string("]");
        add();
        _clp_qout(2);
        pop();
    if_59_1:
    if_59_0:;
    line(599);
    {
    line(576);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+9);//n
    lab_60_0:
    push_symbol(base+1);//object
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_60_2;
        line(578);
        push_symbol(base+1);//object
        push_symbol(base+9);//n
        idxr();
        assign(base+4);//depend
        pop();
        line(579);
        push_symbol(base+8);//objdir
        _clp_dirsep(0);
        add();
        push_symbol(base+4);//depend
        add();
        string(".obj");
        add();
        assign(base+4);//depend
        pop();
        line(580);
        push_symbol(base+4);//depend
        _clp_ftime(1);
        assign(base+5);//tdepend
        pop();
        line(594);
        line(582);
        push_symbol(base+5);//tdepend
        push(&NIL);
        eqeq();
        if(!flag()) goto if_61_1;
            line(590);
            line(583);
            push_symbol(_st_s_dry_ptr());//global
            if(!flag()) goto if_62_1;
                line(584);
                string("");
                assign(base+5);//tdepend
                pop();
            goto if_62_0;
            if_62_1:
            line(585);
                line(586);
                push_symbol(base+4);//depend
                string(nls_text("does not exist"));
                _clp_qout(2);
                pop();
                line(587);
                _clp_qout(0);
                pop();
                line(588);
                push(&ONE);
                _clp_errorlevel(1);
                pop();
                line(589);
                _clp___quit(0);
                pop();
            if_62_2:
            if_62_0:;
        goto if_61_0;
        if_61_1:
        line(592);
        push_symbol(base+3);//ttarget
        push_symbol(base+5);//tdepend
        lt();
        if(!flag()) goto if_61_2;
            line(593);
            push(&TRUE);
            assign(base+6);//update
            pop();
        if_61_2:
        if_61_0:;
        line(598);
        line(596);
        push_symbol(_st_s_debug_ptr());//global
        if(!flag()) goto if_63_1;
            line(597);
            string("  ");
            push_symbol(base+4);//depend
            string("[");
            push_symbol(base+5);//tdepend
            add();
            string("]");
            add();
            push_symbol(base+3);//ttarget
            push_symbol(base+5);//tdepend
            lt();
            if(flag()){
            string("UPDATE");
            }else{
            string("");
            }
            _clp_qout(4);
            pop();
        if_63_1:
        if_63_0:;
    lab_60_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+9);//n
    add();
    assign(base+9);//n
    goto lab_60_0;
    lab_60_2:;
    }
    line(603);
    line(601);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_64_1;
        line(602);
        _clp_qout(0);
        pop();
    if_64_1:
    if_64_0:;
    line(630);
    line(605);
    push_symbol(base+6);//update
    if(!flag()) goto if_65_1;
        line(610);
        {
        line(608);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+9);//n
        lab_66_0:
        push_symbol(base+1);//object
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_66_2;
            line(609);
            push_symbol(base+7);//torun
            string(" ");
            push_symbol(base+1);//object
            push_symbol(base+9);//n
            idxr();
            add();
            add();
            assign(base+7);//torun
            pop();
        lab_66_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+9);//n
        add();
        assign(base+9);//n
        goto lab_66_0;
        lab_66_2:;
        }
        line(629);
        push_symbol(base+7);//torun
        _clp_run1(1);
        pop();
    if_65_1:
    if_65_0:;
    line(632);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_makeexe(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+12)PUSHNIL();
argno=2;
push_call("makeexe",base);
//
    line(638);
    string("BUILD_EXE");
    _clp_getenv(1);
    _clp_dirsep(0);
    add();
    push_symbol(base+0);//exenam
    add();
    string(".exe");
    add();
    assign(base+2);//target
    pop();
    line(639);
    push(&FALSE);
    assign(base+6);//update
    pop();
    line(640);
    string("BUILD_BAT");
    _clp_getenv(1);
    _clp_dirsep(0);
    add();
    string("obj2exe.bat");
    add();
    assign(base+7);//torun
    pop();
    line(641);
    string("BUILD_OBJ");
    _clp_getenv(1);
    _clp_lower(1);
    assign(base+8);//objdir
    pop();
    line(642);
    line(649);
    line(644);
    push_symbol(base+7);//torun
    _clp_file(1);
    topnot();
    if(!flag()) goto if_67_1;
        line(645);
        string("[");
        push_symbol(base+7);//torun
        add();
        string("]");
        add();
        string(nls_text("does not exist"));
        _clp_qout(2);
        pop();
        line(646);
        _clp_qout(0);
        pop();
        line(647);
        push(&ONE);
        _clp_errorlevel(1);
        pop();
        line(648);
        _clp___quit(0);
        pop();
    if_67_1:
    if_67_0:;
    line(651);
    push_symbol(base+2);//target
    _clp_ftime(1);
    assign(base+3);//ttarget
    pop();
    line(654);
    line(652);
    push_symbol(base+3);//ttarget
    push(&NIL);
    eqeq();
    if(!flag()) goto if_68_1;
        line(653);
        string("");
        assign(base+3);//ttarget
        pop();
    if_68_1:
    if_68_0:;
    line(658);
    line(656);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_69_1;
        line(657);
        push_symbol(base+2);//target
        string("[");
        push_symbol(base+3);//ttarget
        add();
        string("]");
        add();
        _clp_qout(2);
        pop();
    if_69_1:
    if_69_0:;
    line(687);
    {
    line(660);
    push(&ONE);
    int sg=sign();
    push(&ZERO);
    assign(base+9);//n
    lab_70_0:
    push_symbol(base+1);//object
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_70_2;
        line(666);
        line(662);
        push_symbol(base+9);//n
        push(&ZERO);
        eqeq();
        if(!flag()) goto if_71_1;
            line(663);
            push_symbol(base+0);//exenam
            assign(base+4);//depend
            pop();
        goto if_71_0;
        if_71_1:
        line(664);
            line(665);
            push_symbol(base+1);//object
            push_symbol(base+9);//n
            idxr();
            assign(base+4);//depend
            pop();
        if_71_2:
        if_71_0:;
        line(668);
        push_symbol(base+8);//objdir
        _clp_dirsep(0);
        add();
        push_symbol(base+4);//depend
        add();
        string(".obj");
        add();
        assign(base+4);//depend
        pop();
        line(669);
        push_symbol(base+4);//depend
        _clp_ftime(1);
        assign(base+5);//tdepend
        pop();
        line(682);
        line(671);
        push_symbol(base+5);//tdepend
        push(&NIL);
        eqeq();
        if(!flag()) goto if_72_1;
            line(679);
            line(672);
            push_symbol(_st_s_dry_ptr());//global
            if(!flag()) goto if_73_1;
                line(673);
                string("");
                assign(base+5);//tdepend
                pop();
            goto if_73_0;
            if_73_1:
            line(674);
                line(675);
                push_symbol(base+4);//depend
                string(nls_text("does not exist"));
                _clp_qout(2);
                pop();
                line(676);
                _clp_qout(0);
                pop();
                line(677);
                push(&ONE);
                _clp_errorlevel(1);
                pop();
                line(678);
                _clp___quit(0);
                pop();
            if_73_2:
            if_73_0:;
        goto if_72_0;
        if_72_1:
        line(680);
        push_symbol(base+3);//ttarget
        push_symbol(base+5);//tdepend
        lt();
        if(!flag()) goto if_72_2;
            line(681);
            push(&TRUE);
            assign(base+6);//update
            pop();
        if_72_2:
        if_72_0:;
        line(686);
        line(684);
        push_symbol(_st_s_debug_ptr());//global
        if(!flag()) goto if_74_1;
            line(685);
            string("  ");
            push_symbol(base+4);//depend
            string("[");
            push_symbol(base+5);//tdepend
            add();
            string("]");
            add();
            push_symbol(base+3);//ttarget
            push_symbol(base+5);//tdepend
            lt();
            if(flag()){
            string("UPDATE");
            }else{
            string("");
            }
            _clp_qout(4);
            pop();
        if_74_1:
        if_74_0:;
    lab_70_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+9);//n
    add();
    assign(base+9);//n
    goto lab_70_0;
    lab_70_2:;
    }
    line(691);
    line(689);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_75_1;
        line(690);
        _clp_qout(0);
        pop();
    if_75_1:
    if_75_0:;
    line(724);
    line(693);
    push_symbol(base+6);//update
    if(!flag()) goto if_76_1;
        line(694);
        push_symbol(base+7);//torun
        string(" ");
        push_symbol(base+0);//exenam
        add();
        add();
        assign(base+7);//torun
        pop();
        line(699);
        {
        line(697);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+9);//n
        lab_77_0:
        push_symbol(base+1);//object
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_77_2;
            line(698);
            push_symbol(base+7);//torun
            string(" ");
            push_symbol(base+1);//object
            push_symbol(base+9);//n
            idxr();
            add();
            add();
            assign(base+7);//torun
            pop();
        lab_77_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+9);//n
        add();
        assign(base+9);//n
        goto lab_77_0;
        lab_77_2:;
        }
        line(723);
        push_symbol(base+7);//torun
        _clp_run1(1);
        pop();
    if_76_1:
    if_76_0:;
    line(726);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_makeexe1(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+10)PUSHNIL();
argno=2;
push_call("makeexe1",base);
//
    line(732);
    string("BUILD_EXE");
    _clp_getenv(1);
    _clp_dirsep(0);
    add();
    push_symbol(base+0);//mmod
    add();
    string(".exe");
    add();
    assign(base+2);//target
    pop();
    line(733);
    push(&FALSE);
    assign(base+6);//update
    pop();
    line(734);
    string("BUILD_BAT");
    _clp_getenv(1);
    _clp_dirsep(0);
    add();
    string("lib2exe.bat");
    add();
    assign(base+7);//torun
    pop();
    line(735);
    string("BUILD_OBJ");
    _clp_getenv(1);
    assign(base+8);//objdir
    pop();
    line(742);
    line(737);
    push_symbol(base+7);//torun
    _clp_file(1);
    topnot();
    if(!flag()) goto if_78_1;
        line(738);
        string("[");
        push_symbol(base+7);//torun
        add();
        string("]");
        add();
        string(nls_text("does not exist"));
        _clp_qout(2);
        pop();
        line(739);
        _clp_qout(0);
        pop();
        line(740);
        push(&ONE);
        _clp_errorlevel(1);
        pop();
        line(741);
        _clp___quit(0);
        pop();
    if_78_1:
    if_78_0:;
    line(744);
    push_symbol(base+2);//target
    _clp_ftime(1);
    assign(base+3);//ttarget
    pop();
    line(747);
    line(745);
    push_symbol(base+3);//ttarget
    push(&NIL);
    eqeq();
    if(!flag()) goto if_79_1;
        line(746);
        string("");
        assign(base+3);//ttarget
        pop();
    if_79_1:
    if_79_0:;
    line(751);
    line(749);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_80_1;
        line(750);
        push_symbol(base+2);//target
        string("[");
        push_symbol(base+3);//ttarget
        add();
        string("]");
        add();
        _clp_qout(2);
        pop();
    if_80_1:
    if_80_0:;
    line(754);
    push_symbol(base+0);//mmod
    assign(base+4);//depend
    pop();
    line(755);
    push_symbol(base+7);//torun
    string(" ");
    push_symbol(base+4);//depend
    add();
    add();
    assign(base+7);//torun
    pop();
    line(756);
    push_symbol(base+8);//objdir
    _clp_dirsep(0);
    add();
    push_symbol(base+4);//depend
    add();
    string(".obj");
    add();
    assign(base+4);//depend
    pop();
    line(757);
    push_symbol(base+4);//depend
    _clp_ftime(1);
    assign(base+5);//tdepend
    pop();
    line(770);
    line(759);
    push_symbol(base+5);//tdepend
    push(&NIL);
    eqeq();
    if(!flag()) goto if_81_1;
        line(767);
        line(760);
        push_symbol(_st_s_dry_ptr());//global
        if(!flag()) goto if_82_1;
            line(761);
            string("");
            assign(base+5);//tdepend
            pop();
        goto if_82_0;
        if_82_1:
        line(762);
            line(763);
            push_symbol(base+4);//depend
            string(nls_text("does not exist"));
            _clp_qout(2);
            pop();
            line(764);
            _clp_qout(0);
            pop();
            line(765);
            push(&ONE);
            _clp_errorlevel(1);
            pop();
            line(766);
            _clp___quit(0);
            pop();
        if_82_2:
        if_82_0:;
    goto if_81_0;
    if_81_1:
    line(768);
    push_symbol(base+3);//ttarget
    push_symbol(base+5);//tdepend
    lt();
    if(!flag()) goto if_81_2;
        line(769);
        push(&TRUE);
        assign(base+6);//update
        pop();
    if_81_2:
    if_81_0:;
    line(774);
    line(772);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_83_1;
        line(773);
        string("  ");
        push_symbol(base+4);//depend
        string("[");
        push_symbol(base+5);//tdepend
        add();
        string("]");
        add();
        push_symbol(base+3);//ttarget
        push_symbol(base+5);//tdepend
        lt();
        if(flag()){
        string("UPDATE");
        }else{
        string("");
        }
        _clp_qout(4);
        pop();
    if_83_1:
    if_83_0:;
    line(777);
    push_symbol(base+1);//libnam
    assign(base+4);//depend
    pop();
    line(778);
    push_symbol(base+7);//torun
    string(" ");
    push_symbol(base+4);//depend
    add();
    add();
    assign(base+7);//torun
    pop();
    line(779);
    push_symbol(base+8);//objdir
    _clp_dirsep(0);
    add();
    push_symbol(base+4);//depend
    add();
    string(".lib");
    add();
    assign(base+4);//depend
    pop();
    line(780);
    push_symbol(base+4);//depend
    _clp_ftime(1);
    assign(base+5);//tdepend
    pop();
    line(793);
    line(782);
    push_symbol(base+5);//tdepend
    push(&NIL);
    eqeq();
    if(!flag()) goto if_84_1;
        line(790);
        line(783);
        push_symbol(_st_s_dry_ptr());//global
        if(!flag()) goto if_85_1;
            line(784);
            string("");
            assign(base+5);//tdepend
            pop();
        goto if_85_0;
        if_85_1:
        line(785);
            line(786);
            push_symbol(base+4);//depend
            string(nls_text("does not exist"));
            _clp_qout(2);
            pop();
            line(787);
            _clp_qout(0);
            pop();
            line(788);
            push(&ONE);
            _clp_errorlevel(1);
            pop();
            line(789);
            _clp___quit(0);
            pop();
        if_85_2:
        if_85_0:;
    goto if_84_0;
    if_84_1:
    line(791);
    push_symbol(base+3);//ttarget
    push_symbol(base+5);//tdepend
    lt();
    if(!flag()) goto if_84_2;
        line(792);
        push(&TRUE);
        assign(base+6);//update
        pop();
    if_84_2:
    if_84_0:;
    line(797);
    line(795);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_86_1;
        line(796);
        string("  ");
        push_symbol(base+4);//depend
        string("[");
        push_symbol(base+5);//tdepend
        add();
        string("]");
        add();
        push_symbol(base+3);//ttarget
        push_symbol(base+5);//tdepend
        lt();
        if(flag()){
        string("UPDATE");
        }else{
        string("");
        }
        _clp_qout(4);
        pop();
    if_86_1:
    if_86_0:;
    line(802);
    line(800);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_87_1;
        line(801);
        _clp_qout(0);
        pop();
    if_87_1:
    if_87_0:;
    line(806);
    line(804);
    push_symbol(base+6);//update
    if(!flag()) goto if_88_1;
        line(805);
        push_symbol(base+7);//torun
        _clp_run1(1);
        pop();
    if_88_1:
    if_88_0:;
    line(808);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_makeobj(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+11)PUSHNIL();
argno=1;
push_call("makeobj",base);
//
    line(814);
    push_symbol(base+0);//deplist
    idxr0(1);
    assign(base+1);//target
    pop();
    line(815);
    push_symbol(base+0);//deplist
    idxr0(2);
    assign(base+2);//depend
    pop();
    line(816);
    string("BUILD_OBJ");
    _clp_getenv(1);
    assign(base+3);//objdir
    pop();
    line(817);
    line(818);
    push(&FALSE);
    assign(base+6);//update
    pop();
    line(819);
    line(823);
    line(821);
    push_symbol(base+1);//target
    _clp_fext(1);
    string(".obj");
    eqeq();
    if(!flag()) goto if_89_1;
        line(822);
        push_symbol(base+3);//objdir
        _clp_dirsep(0);
        add();
        push_symbol(base+1);//target
        _clp_fname(1);
        add();
        push_symbol(base+1);//target
        _clp_fext(1);
        add();
        assign(base+1);//target
        pop();
    if_89_1:
    if_89_0:;
    line(825);
    push_symbol(base+1);//target
    _clp_ftime(1);
    assign(base+4);//ttarget
    pop();
    line(828);
    line(826);
    push_symbol(base+4);//ttarget
    push(&NIL);
    eqeq();
    if(!flag()) goto if_90_1;
        line(827);
        string("");
        assign(base+4);//ttarget
        pop();
    if_90_1:
    if_90_0:;
    line(832);
    line(830);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_91_1;
        line(831);
        push_symbol(base+1);//target
        string("[");
        push_symbol(base+4);//ttarget
        add();
        string("]");
        add();
        _clp_qout(2);
        pop();
    if_91_1:
    if_91_0:;
    line(855);
    {
    line(834);
    push(&ONE);
    int sg=sign();
    number(2);
    assign(base+8);//n
    lab_92_0:
    push_symbol(base+0);//deplist
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_92_2;
        line(835);
        push_symbol(base+0);//deplist
        push_symbol(base+8);//n
        idxr();
        assign(base+2);//depend
        pop();
        line(836);
        push_symbol(base+2);//depend
        _clp_ftime(1);
        assign(base+5);//tdepend
        pop();
        line(850);
        line(838);
        push_symbol(base+5);//tdepend
        push(&NIL);
        eqeq();
        if(!flag()) goto if_93_1;
            line(846);
            line(839);
            push_symbol(_st_s_dry_ptr());//global
            if(!flag()) goto if_94_1;
                line(840);
                string("");
                assign(base+5);//tdepend
                pop();
            goto if_94_0;
            if_94_1:
            line(841);
                line(842);
                push_symbol(base+0);//deplist
                push_symbol(base+8);//n
                idxr();
                string(nls_text("does not exist"));
                _clp_qout(2);
                pop();
                line(843);
                _clp_qout(0);
                pop();
                line(844);
                push(&ONE);
                _clp_errorlevel(1);
                pop();
                line(845);
                _clp___quit(0);
                pop();
            if_94_2:
            if_94_0:;
        goto if_93_0;
        if_93_1:
        line(848);
        push_symbol(base+4);//ttarget
        push_symbol(base+5);//tdepend
        lt();
        if(!flag()) goto if_93_2;
            line(849);
            push(&TRUE);
            assign(base+6);//update
            pop();
        if_93_2:
        if_93_0:;
        line(854);
        line(852);
        push_symbol(_st_s_debug_ptr());//global
        if(!flag()) goto if_95_1;
            line(853);
            string("  ");
            push_symbol(base+2);//depend
            string("[");
            push_symbol(base+5);//tdepend
            add();
            string("]");
            add();
            push_symbol(base+4);//ttarget
            push_symbol(base+5);//tdepend
            lt();
            if(flag()){
            string("UPDATE");
            }else{
            string("");
            }
            _clp_qout(4);
            pop();
        if_95_1:
        if_95_0:;
    lab_92_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+8);//n
    add();
    assign(base+8);//n
    goto lab_92_0;
    lab_92_2:;
    }
    line(859);
    line(857);
    push_symbol(_st_s_debug_ptr());//global
    if(!flag()) goto if_96_1;
        line(858);
        _clp_qout(0);
        pop();
    if_96_1:
    if_96_0:;
    line(878);
    line(861);
    push_symbol(base+6);//update
    if(!flag()) goto if_97_1;
        line(863);
        string("BUILD_BAT");
        _clp_getenv(1);
        _clp_dirsep(0);
        add();
        assign(base+7);//torun
        pop();
        line(864);
        push_symbol(base+7);//torun
        push_symbol(base+0);//deplist
        idxr0(2);
        _clp_fext(1);
        string("2");
        add();
        push_symbol(base+0);//deplist
        idxr0(1);
        _clp_fext(1);
        add();
        string(".");
        string("");
        _clp_strtran(3);
        add();
        assign(base+7);//torun
        pop();
        line(865);
        push_symbol(base+7);//torun
        string(".bat");
        add();
        assign(base+7);//torun
        pop();
        line(872);
        line(867);
        push_symbol(base+7);//torun
        _clp_file(1);
        topnot();
        if(!flag()) goto if_98_1;
            line(868);
            string("[");
            push_symbol(base+7);//torun
            add();
            string("]");
            add();
            string(nls_text("does not exist"));
            _clp_qout(2);
            pop();
            line(869);
            _clp_qout(0);
            pop();
            line(870);
            push(&ONE);
            _clp_errorlevel(1);
            pop();
            line(871);
            _clp___quit(0);
            pop();
        if_98_1:
        if_98_0:;
        line(874);
        push_symbol(base+0);//deplist
        idxr0(1);
        _clp_fname(1);
        assign(base+9);//p1
        pop();
        line(875);
        push_symbol(base+0);//deplist
        idxr0(2);
        _clp_fpath0(1);
        assign(base+10);//p2
        pop();
        push_symbol(base+10);//p2
        _clp_empty(1);
        if(flag()){
        string(".");
        }else{
        push_symbol(base+10);//p2
        }
        assign(base+10);//p2
        pop();
        line(877);
        push_symbol(base+7);//torun
        string(" ");
        add();
        push_symbol(base+9);//p1
        add();
        string(" ");
        add();
        push_symbol(base+10);//p2
        add();
        _clp_run1(1);
        pop();
    if_97_1:
    if_97_0:;
    line(880);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_run1(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
argno=1;
push_call("run1",base);
//
    line(900);
    line(887);
    push_symbol(_st_s_dry_ptr());//global
    topnot();
    if(!flag()) goto if_99_1;
        line(889);
        push_symbol(base+0);//cmd
        _clp_run(1);
        pop();
        line(899);
        line(891);
        string("error");
        _clp_file(1);
        if(!flag()) goto if_100_1;
            line(893);
            string("cat error");
            _clp_run(1);
            pop();
            line(897);
            _clp_qout(0);
            pop();
            line(898);
            _clp___quit(0);
            pop();
        if_100_1:
        if_100_0:;
    if_99_1:
    if_99_0:;
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_ftime(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+2)PUSHNIL();
argno=1;
push_call("ftime",base);
//
    line(905);
    push_symbol(base+0);//fspec
    _clp_directory(1);
    assign(base+1);//d
    pop();
    line(908);
    line(906);
    push_symbol(base+1);//d
    _clp_len(1);
    push(&ONE);
    eqeq();
    if(!flag()) goto if_101_1;
        line(907);
        push_symbol(base+1);//d
        idxr0(1);
        idxr0(3);
        _clp_dtos(1);
        string("-");
        add();
        push_symbol(base+1);//d
        idxr0(1);
        idxr0(4);
        add();
        {*base=*(stack-1);stack=base+1;pop_call();return;}
    if_101_1:
    if_101_0:;
    line(909);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_search_include(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,4);
while(stack<base+13)PUSHNIL();
argno=4;
push_call("search_include",base);
//
    line(915);
    number(10);
    _clp_chr(1);
    assign(base+4);//nl
    pop();
    line(916);
    string("#include");
    assign(base+5);//include
    pop();
    line(917);
    push_symbol(base+5);//include
    _clp_len(1);
    assign(base+6);//lenincl
    pop();
    line(918);
    push(&ZERO);
    assign(base+8);//n2
    pop();
    line(955);
    lab_102_1:
    line(920);
    push_symbol(base+5);//include
    push_symbol(base+0);//txt
    push_symbol(base+8);//n2
    addnum(1);
    _clp_at(3);
    assign(base+7);//n1
    push(&ZERO);
    gt();
    if(!flag()) goto lab_102_2;
        line(924);
        line(922);
        push(&ZERO);
        push_symbol(base+4);//nl
        push_symbol(base+0);//txt
        push_symbol(base+7);//n1
        push_symbol(base+6);//lenincl
        add();
        _clp_at(3);
        assign(base+8);//n2
        eqeq();
        if(!flag()) goto if_103_1;
            line(923);
            push_symbol(base+0);//txt
            _clp_len(1);
            addnum(1);
            assign(base+8);//n2
            pop();
        if_103_1:
        if_103_0:;
        line(926);
        push_symbol(base+0);//txt
        push_symbol(base+7);//n1
        push_symbol(base+6);//lenincl
        add();
        push_symbol(base+8);//n2
        push_symbol(base+7);//n1
        sub();
        push_symbol(base+6);//lenincl
        sub();
        _clp_substr(3);
        assign(base+9);//line
        pop();
        line(927);
        push_symbol(base+9);//line
        number(9);
        _clp_chr(1);
        string("");
        _clp_strtran(3);
        assign(base+9);//line
        pop();
        line(928);
        push_symbol(base+9);//line
        _clp_alltrim(1);
        assign(base+9);//line
        pop();
        line(936);
        line(930);
        push_symbol(base+9);//line
        push(&ONE);
        _clp_left(2);
        string("\"");
        eqeq();
        if(!flag()) goto if_104_1;
            line(931);
            string("\"");
            assign(base+10);//delim
            pop();
        goto if_104_0;
        if_104_1:
        line(932);
        push_symbol(base+9);//line
        push(&ONE);
        _clp_left(2);
        string("<");
        eqeq();
        if(!flag()) goto if_104_2;
            line(933);
            string(">");
            assign(base+10);//delim
            pop();
        goto if_104_0;
        if_104_2:
        line(934);
            line(935);
            goto lab_102_1;//loop
        if_104_3:
        if_104_0:;
        line(940);
        line(938);
        push(&ZERO);
        push_symbol(base+10);//delim
        push_symbol(base+9);//line
        number(2);
        _clp_at(3);
        assign(base+11);//dpos
        eqeq();
        if(!flag()) goto if_105_1;
            line(939);
            goto lab_102_1;//loop
        if_105_1:
        if_105_0:;
        line(942);
        push_symbol(base+9);//line
        number(2);
        push_symbol(base+11);//dpos
        addnum(-2);
        _clp_substr(3);
        assign(base+12);//f
        pop();
        line(943);
        push_symbol(base+12);//f
        string("/");
        _clp_dirsep(0);
        _clp_strtran(3);
        assign(base+12);//f
        pop();
        line(944);
        push_symbol(base+12);//f
        string("\\");
        _clp_dirsep(0);
        _clp_strtran(3);
        assign(base+12);//f
        pop();
        line(954);
        line(946);
        push_symbol(base+12);//f
        push_symbol(base+1);//dep
        push_symbol(base+2);//dir
        push_symbol(base+3);//todo
        _clp_byrules(4);
        if(!flag()) goto if_106_1;
        goto if_106_0;
        if_106_1:
        line(949);
        push_symbol(base+12);//f
        push_symbol(base+1);//dep
        push_symbol(base+2);//dir
        push_symbol(base+3);//todo
        _clp_byhand(4);
        if(!flag()) goto if_106_2;
        goto if_106_0;
        if_106_2:
        line(952);
        if_106_3:
        if_106_0:;
    goto lab_102_1;
    lab_102_2:;
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_search_library(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+13)PUSHNIL();
argno=0;
push_call("search_library",base);
//
    line(964);
    string("BUILD_LPT");
    _clp_getenv(1);
    string(" ");
    _clp_split(2);
    assign(base+0);//dirlist
    pop();
    line(965);
    string("BUILD_LIB");
    _clp_getenv(1);
    string(" ");
    _clp_split(2);
    assign(base+1);//liblist
    pop();
    line(966);
    string("BUILD_SHR");
    _clp_getenv(1);
    _clp_lower(1);
    assign(base+2);//sharing
    pop();
    line(968);
    string("");
    assign(base+5);//txt
    pop();
    line(969);
    line(1045);
    {
    line(972);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+3);//n
    lab_107_0:
    push_symbol(base+1);//liblist
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_107_2;
        line(976);
        line(974);
        push_symbol(base+1);//liblist
        push_symbol(base+3);//n
        idxr();
        assign(base+6);//f0
        _clp_empty(1);
        if(!flag()) goto if_108_1;
            line(975);
            goto lab_107_1;//loop
        if_108_1:
        if_108_0:;
        line(988);
        line(978);
        string(".lib");
        push_symbol(base+6);//f0
        ss();
        if(flag()){
        push(&TRUE);
        }else{
        string(".a");
        push_symbol(base+6);//f0
        ss();
        }
        if(flag()){
        push(&TRUE);
        }else{
        string(".so");
        push_symbol(base+6);//f0
        ss();
        }
        if(!flag()) goto if_109_1;
            line(979);
            push_symbol(base+6);//f0
            assign(base+7);//f1
            pop();
            line(980);
            push_symbol(base+6);//f0
            assign(base+8);//f2
            pop();
            line(981);
            push_symbol(base+6);//f0
            assign(base+9);//f3
            pop();
        goto if_109_0;
        if_109_1:
        line(982);
            line(983);
            push_symbol(base+6);//f0
            string(".lib");
            add();
            assign(base+7);//f1
            pop();
            line(986);
            push_symbol(base+6);//f0
            _clp_fpath(1);
            string("lib");
            add();
            push_symbol(base+6);//f0
            _clp_fnameext(1);
            add();
            string(".a");
            add();
            assign(base+8);//f2
            pop();
            line(987);
            push_symbol(base+6);//f0
            _clp_fpath(1);
            string("lib");
            add();
            push_symbol(base+6);//f0
            _clp_fnameext(1);
            add();
            string(".so");
            add();
            assign(base+9);//f3
            pop();
        if_109_2:
        if_109_0:;
        line(1040);
        {
        line(990);
        push(&ONE);
        int sg=sign();
        push(&ZERO);
        assign(base+4);//i
        lab_110_0:
        push_symbol(base+0);//dirlist
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_110_2;
            line(1004);
            line(992);
            push_symbol(base+4);//i
            push(&ZERO);
            lteq();
            if(!flag()) goto if_111_1;
                line(993);
                push_symbol(base+7);//f1
                assign(base+10);//pf1
                pop();
                line(994);
                push_symbol(base+8);//f2
                assign(base+11);//pf2
                pop();
                line(995);
                push_symbol(base+9);//f3
                assign(base+12);//pf3
                pop();
            goto if_111_0;
            if_111_1:
            line(996);
                line(999);
                line(997);
                push_symbol(base+0);//dirlist
                push_symbol(base+4);//i
                idxr();
                _clp_empty(1);
                if(!flag()) goto if_112_1;
                    line(998);
                    goto lab_110_1;//loop
                if_112_1:
                if_112_0:;
                line(1001);
                push_symbol(base+0);//dirlist
                push_symbol(base+4);//i
                idxr();
                _clp_dirsep(0);
                add();
                push_symbol(base+7);//f1
                add();
                assign(base+10);//pf1
                pop();
                line(1002);
                push_symbol(base+0);//dirlist
                push_symbol(base+4);//i
                idxr();
                _clp_dirsep(0);
                add();
                push_symbol(base+8);//f2
                add();
                assign(base+11);//pf2
                pop();
                line(1003);
                push_symbol(base+0);//dirlist
                push_symbol(base+4);//i
                idxr();
                _clp_dirsep(0);
                add();
                push_symbol(base+9);//f3
                add();
                assign(base+12);//pf3
                pop();
            if_111_2:
            if_111_0:;
            line(1039);
            line(1010);
            string("static");
            push_symbol(base+2);//sharing
            ss();
            if(!flag()) goto if_113_1;
                line(1023);
                line(1014);
                push_symbol(base+10);//pf1
                _clp_file(1);
                if(!flag()) goto if_114_1;
                    line(1015);
                    push_symbol(base+5);//txt
                    push_symbol(base+10);//pf1
                    string(" ");
                    add();
                    add();
                    assign(base+5);//txt
                    pop();
                    line(1016);
                    goto lab_110_2;//exit
                goto if_114_0;
                if_114_1:
                line(1017);
                push_symbol(base+11);//pf2
                _clp_file(1);
                if(!flag()) goto if_114_2;
                    line(1018);
                    push_symbol(base+5);//txt
                    push_symbol(base+11);//pf2
                    string(" ");
                    add();
                    add();
                    assign(base+5);//txt
                    pop();
                    line(1019);
                    goto lab_110_2;//exit
                goto if_114_0;
                if_114_2:
                line(1020);
                push_symbol(base+12);//pf3
                _clp_file(1);
                if(!flag()) goto if_114_3;
                    line(1021);
                    push_symbol(base+5);//txt
                    push_symbol(base+12);//pf3
                    string(" ");
                    add();
                    add();
                    assign(base+5);//txt
                    pop();
                    line(1022);
                    goto lab_110_2;//exit
                if_114_3:
                if_114_0:;
            goto if_113_0;
            if_113_1:
            line(1025);
                line(1038);
                line(1029);
                push_symbol(base+12);//pf3
                _clp_file(1);
                if(!flag()) goto if_115_1;
                    line(1030);
                    push_symbol(base+5);//txt
                    push_symbol(base+12);//pf3
                    string(" ");
                    add();
                    add();
                    assign(base+5);//txt
                    pop();
                    line(1031);
                    goto lab_110_2;//exit
                goto if_115_0;
                if_115_1:
                line(1032);
                push_symbol(base+10);//pf1
                _clp_file(1);
                if(!flag()) goto if_115_2;
                    line(1033);
                    push_symbol(base+5);//txt
                    push_symbol(base+10);//pf1
                    string(" ");
                    add();
                    add();
                    assign(base+5);//txt
                    pop();
                    line(1034);
                    goto lab_110_2;//exit
                goto if_115_0;
                if_115_2:
                line(1035);
                push_symbol(base+11);//pf2
                _clp_file(1);
                if(!flag()) goto if_115_3;
                    line(1036);
                    push_symbol(base+5);//txt
                    push_symbol(base+11);//pf2
                    string(" ");
                    add();
                    add();
                    assign(base+5);//txt
                    pop();
                    line(1037);
                    goto lab_110_2;//exit
                if_115_3:
                if_115_0:;
            if_113_2:
            if_113_0:;
        lab_110_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+4);//i
        add();
        assign(base+4);//i
        goto lab_110_0;
        lab_110_2:;
        }
        line(1044);
        line(1042);
        push_symbol(base+4);//i
        push_symbol(base+0);//dirlist
        _clp_len(1);
        gt();
        if(!flag()) goto if_116_1;
            line(1043);
            push_symbol(base+5);//txt
            push_symbol(base+6);//f0
            string(" ");
            add();
            add();
            assign(base+5);//txt
            pop();
        if_116_1:
        if_116_0:;
    lab_107_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+3);//n
    add();
    assign(base+3);//n
    goto lab_107_0;
    lab_107_2:;
    }
    line(1047);
    push_symbol(base+5);//txt
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_search_file(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+4)PUSHNIL();
argno=2;
push_call("search_file",base);
//
    line(1052);
    line(1059);
    {
    line(1054);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+2);//n
    lab_117_0:
    push_symbol(base+0);//dirlist
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_117_2;
        line(1055);
        push_symbol(base+0);//dirlist
        push_symbol(base+2);//n
        idxr();
        _clp_dirsep(0);
        add();
        push_symbol(base+1);//fnamext
        add();
        assign(base+3);//pathname
        pop();
        line(1058);
        line(1056);
        push_symbol(base+3);//pathname
        _clp_file(1);
        if(!flag()) goto if_118_1;
            line(1057);
            push_symbol(base+3);//pathname
            {*base=*(stack-1);stack=base+1;pop_call();return;}
        if_118_1:
        if_118_0:;
    lab_117_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+2);//n
    add();
    assign(base+2);//n
    goto lab_117_0;
    lab_117_2:;
    }
    line(1060);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_byrules(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,4);
while(stack<base+10)PUSHNIL();
argno=4;
push_call("byrules",base);
//
    line(1071);
    push_symbol(base+0);//fil
    _clp_fname(1);
    assign(base+4);//f
    pop();
    line(1072);
    push_symbol(base+0);//fil
    _clp_fext(1);
    assign(base+5);//e
    pop();
    line(1073);
    line(1074);
    line(1075);
    line(1094);
    {
    line(1077);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+9);//i
    lab_119_0:
    push_symbol(_st_s_rules_ptr());//global
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_119_2;
        line(1093);
        line(1079);
        push_symbol(_st_s_rules_ptr());//global
        push_symbol(base+9);//i
        idxr();
        idxr0(2);
        push_symbol(base+5);//e
        eqeq();
        if(!flag()) goto if_120_1;
            line(1081);
            push_symbol(_st_s_rules_ptr());//global
            push_symbol(base+9);//i
            idxr();
            idxr0(1);
            assign(base+8);//e0
            pop();
            line(1092);
            line(1085);
            push(&NIL);
            push_symbol(base+2);//dir
            push_symbol(base+4);//f
            push_symbol(base+8);//e0
            add();
            _clp_search_file(2);
            assign(base+7);//r
            neeq();
            if(!flag()) goto if_121_1;
                line(1086);
                push_symbol(base+7);//r
                _clp_fpath(1);
                assign(base+6);//p
                pop();
                line(1087);
                push_symbol(base+1);//dep
                push_symbol(base+6);//p
                push_symbol(base+4);//f
                add();
                push_symbol(base+5);//e
                add();
                _clp_adddep(2);
                pop();
                line(1090);
                line(1088);
                push(&ZERO);
                push_symbol(base+3);//todo
                push_symbol_ref(base+6);//p
                push_symbol_ref(base+4);//f
                push_symbol_ref(base+5);//e
                block(_blk_byrules_0,3);
                _clp_ascan(2);
                eqeq();
                if(!flag()) goto if_122_1;
                    line(1089);
                    push_symbol(base+3);//todo
                    push_symbol(base+6);//p
                    push_symbol(base+4);//f
                    add();
                    push_symbol(base+5);//e
                    add();
                    push_symbol(base+6);//p
                    push_symbol(base+4);//f
                    add();
                    push_symbol(base+8);//e0
                    add();
                    array(2);
                    _clp_aadd(2);
                    pop();
                if_122_1:
                if_122_0:;
                line(1091);
                push(&TRUE);
                {*base=*(stack-1);stack=base+1;pop_call();return;}
            if_121_1:
            if_121_0:;
        if_120_1:
        if_120_0:;
    lab_119_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+9);//i
    add();
    assign(base+9);//i
    goto lab_119_0;
    lab_119_2:;
    }
    line(1095);
    push(&FALSE);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}

static void _blk_byrules_0(int argno)
{
VALUE *base=stack-argno;
VALUE *env=blkenv(base);
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
argno=2;
push_call("_blk_byrules_0",base);
//
    push_blkarg(base+1);//x
    idxr0(1);
    push_blkenv(env+0);//p
    push_blkenv(env+1);//f
    add();
    push_blkenv(env+2);//e
    add();
    eqeq();
//
{*base=*(stack-1);stack=base+1;pop_call();}
}
//=======================================================================
static void _clp_byhand(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,4);
while(stack<base+5)PUSHNIL();
argno=4;
push_call("byhand",base);
//
    line(1106);
    push_symbol(base+2);//dir
    push_symbol(base+0);//f
    _clp_search_file(2);
    assign(base+4);//pn
    pop();
    line(1111);
    line(1108);
    push_symbol(base+4);//pn
    push(&NIL);
    neeq();
    if(!flag()) goto if_123_1;
        line(1109);
        push_symbol(base+1);//dep
        push_symbol(base+4);//pn
        _clp_adddep(2);
        pop();
        line(1110);
        push(&TRUE);
        {*base=*(stack-1);stack=base+1;pop_call();return;}
    if_123_1:
    if_123_0:;
    line(1112);
    push(&FALSE);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_adddep(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
argno=2;
push_call("adddep",base);
//
    line(1119);
    line(1117);
    push(&ZERO);
    push_symbol(base+0);//dep
    push_symbol_ref(base+1);//x
    block(_blk_adddep_0,1);
    _clp_ascan(2);
    eqeq();
    if(!flag()) goto if_124_1;
        line(1118);
        push_symbol(base+0);//dep
        push_symbol(base+1);//x
        _clp_aadd(2);
        pop();
    if_124_1:
    if_124_0:;
//
stack=base;
push(&NIL);
pop_call();
}

static void _blk_adddep_0(int argno)
{
VALUE *base=stack-argno;
VALUE *env=blkenv(base);
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
argno=2;
push_call("_blk_adddep_0",base);
//
    push_blkarg(base+1);//d
    push_blkenv(env+0);//x
    eqeq();
//
{*base=*(stack-1);stack=base+1;pop_call();}
}
//=======================================================================
void _clp_psort(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+4)PUSHNIL();
argno=2;
push_call("psort",base);
//
    line(1124);
    push_symbol(base+0);//x
    idxr0(2);
    _clp_fext(1);
    push_symbol(base+0);//x
    idxr0(1);
    _clp_fext(1);
    _clp_ruleidx(2);
    assign(base+2);//ix
    pop();
    line(1125);
    push_symbol(base+1);//y
    idxr0(2);
    _clp_fext(1);
    push_symbol(base+1);//y
    idxr0(1);
    _clp_fext(1);
    _clp_ruleidx(2);
    assign(base+3);//iy
    pop();
    line(1126);
    push_symbol(base+2);//ix
    push_symbol(base+3);//iy
    eqeq();
    if(flag()){
    push_symbol(base+0);//x
    idxr0(1);
    push_symbol(base+1);//y
    idxr0(1);
    lt();
    }else{
    push_symbol(base+2);//ix
    push_symbol(base+3);//iy
    lt();
    }
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_ruleidx(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+3)PUSHNIL();
argno=2;
push_call("ruleidx",base);
//
    line(1131);
    line(1136);
    {
    line(1132);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+2);//n
    lab_125_0:
    push_symbol(_st_s_rules_ptr());//global
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_125_2;
        line(1135);
        line(1133);
        push_symbol(base+0);//e1
        push_symbol(_st_s_rules_ptr());//global
        push_symbol(base+2);//n
        idxr();
        idxr0(1);
        eqeq();
        if(!flag()){
        push(&FALSE);
        }else{
        push_symbol(base+1);//e2
        push_symbol(_st_s_rules_ptr());//global
        push_symbol(base+2);//n
        idxr();
        idxr0(2);
        eqeq();
        }
        if(!flag()) goto if_126_1;
            line(1134);
            push_symbol(base+2);//n
            {*base=*(stack-1);stack=base+1;pop_call();return;}
        if_126_1:
        if_126_0:;
    lab_125_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+2);//n
    add();
    assign(base+2);//n
    goto lab_125_0;
    lab_125_2:;
    }
    line(1137);
    push(&ZERO);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_xsplit(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+4)PUSHNIL();
argno=2;
push_call("xsplit",base);
//
    line(1142);
    line(1152);
    {
    line(1143);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+2);//n
    lab_127_0:
    push_symbol(base+1);//sep
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_127_2;
        line(1145);
        push_symbol(base+1);//sep
        push_symbol(base+2);//n
        push(&ONE);
        _clp_substr(3);
        assign(base+3);//s
        pop();
        line(1151);
        line(1147);
        push(&ZERO);
        push_symbol(base+3);//s
        push_symbol(base+0);//txt
        _clp_at(2);
        lt();
        if(!flag()) goto if_128_1;
            line(1148);
            goto lab_127_2;//exit
        goto if_128_0;
        if_128_1:
        line(1149);
            line(1150);
            push(&NIL);
            assign(base+3);//s
            pop();
        if_128_2:
        if_128_0:;
    lab_127_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+2);//n
    add();
    assign(base+2);//n
    goto lab_127_0;
    lab_127_2:;
    }
    line(1153);
    push_symbol(base+0);//txt
    push_symbol(base+3);//s
    _clp_split(2);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_normalize(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+4)PUSHNIL();
argno=1;
push_call("normalize",base);
//
    line(1162);
    line(1173);
    {
    line(1164);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+2);//n
    lab_129_0:
    push_symbol(base+0);//todo
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_129_2;
        line(1172);
        {
        line(1165);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+1);//i
        lab_130_0:
        push_symbol(base+0);//todo
        push_symbol(base+2);//n
        idxr();
        _clp_len(1);
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_130_2;
            line(1166);
            push_symbol(base+0);//todo
            push_symbol(base+2);//n
            idxr();
            push_symbol(base+1);//i
            idxr();
            assign(base+3);//x
            pop();
            line(1167);
            push_symbol(base+3);//x
            _clp_dirsep(0);
            string(".");
            add();
            _clp_dirsep(0);
            add();
            _clp_dirsep(0);
            _clp_strtran(3);
            assign(base+3);//x
            pop();
            line(1170);
            line(1168);
            push_symbol(base+3);//x
            number(2);
            _clp_left(2);
            string(".");
            _clp_dirsep(0);
            add();
            eqeq();
            if(!flag()) goto if_131_1;
                line(1169);
                push_symbol(base+3);//x
                number(3);
                _clp_substr(2);
                assign(base+3);//x
                pop();
            if_131_1:
            if_131_0:;
            line(1171);
            push_symbol(base+3);//x
            push_symbol(base+0);//todo
            push_symbol(base+2);//n
            idxr();
            push_symbol(base+1);//i
            assign2(idxxl());
            pop();
        lab_130_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+1);//i
        add();
        assign(base+1);//i
        goto lab_130_0;
        lab_130_2:;
        }
    lab_129_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+2);//n
    add();
    assign(base+2);//n
    goto lab_129_0;
    lab_129_2:;
    }
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

