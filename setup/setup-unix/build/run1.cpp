//input: run1.ppo (4.10.0)

#include <clp2cpp.h>

extern void _clp_alltrim(int argno);
extern void _clp_at(int argno);
static void _clp_bash(int argno);
extern void _clp_buildenv_bat(int argno);
extern void _clp_ferase(int argno);
extern void _clp_file(int argno);
extern void _clp_memoread(int argno);
extern void _clp_qqout(int argno);
extern void _clp_run(int argno);
extern void _clp_run1(int argno);
extern void _clp_s_dry(int argno);
extern void _clp_spawn(int argno);
extern void _clp_str(int argno);
extern void _clp_strtran(int argno);
extern void _clp_thread_mutex_init(int argno);
extern void _clp_thread_mutex_lock(int argno);
extern void _clp_thread_mutex_unlock(int argno);

//=======================================================================
void _clp_run1(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+3)PUSHNIL();
argno=1;
push_call("run1",base);
//
    line(26);
    static stvar _st_mutex_out;
    static int _ini_mutex_out=[=](){
        _clp_thread_mutex_init(0);
        assign(_st_mutex_out.ptr);
        pop();
        return 1;
    }();
    line(27);
    static stvar _st_count((double)0);
    line(28);
    line(61);
    line(30);
    _clp_s_dry(0);
    topnot();
    if(!flag()) goto if_1_1;
        line(32);
        push_symbol(_st_mutex_out.ptr);//run1
        _clp_thread_mutex_lock(1);
        pop();
        line(33);
        string("log-runtmp");
        push_symbol(_st_count.ptr);//run1
        push(&ONE);
        add();
        assign(_st_count.ptr);//run1
        _clp_str(1);
        _clp_alltrim(1);
        add();
        assign(base+1);//runtmp
        pop();
        line(34);
        push_symbol(_st_mutex_out.ptr);//run1
        _clp_thread_mutex_unlock(1);
        pop();
        line(42);
        line(36);
        string("msys2");
        _clp_buildenv_bat(0);
        ss();
        if(!flag()) goto if_2_1;
            line(38);
            push_symbol(base+0);//cmd
            string(" >");
            add();
            push_symbol(base+1);//runtmp
            add();
            _clp_bash(1);
            pop();
        goto if_2_0;
        if_2_1:
        line(39);
            line(41);
            push_symbol(base+0);//cmd
            string(" >");
            add();
            push_symbol(base+1);//runtmp
            add();
            _clp_run(1);
            pop();
        if_2_2:
        if_2_0:;
        line(44);
        push_symbol(base+1);//runtmp
        _clp_memoread(1);
        assign(base+2);//out
        pop();
        line(45);
        push_symbol(base+1);//runtmp
        _clp_ferase(1);
        pop();
        line(47);
        push_symbol(_st_mutex_out.ptr);//run1
        _clp_thread_mutex_lock(1);
        pop();
        line(48);
        push_symbol(base+2);//out
        _clp_qqout(1);
        pop();
        line(49);
        push_symbol(_st_mutex_out.ptr);//run1
        _clp_thread_mutex_unlock(1);
        pop();
        line(60);
        line(51);
        string("error");
        _clp_file(1);
        if(!flag()) goto if_3_1;
            line(53);
            string("cat error");
            _clp_run(1);
            pop();
            line(59);
            push(&TRUE);
            _clp_s_dry(1);
            pop();
        if_3_1:
        if_3_0:;
    if_1_1:
    if_1_0:;
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_bash(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
argno=1;
push_call("bash",base);
//
    line(66);
    push_symbol(base+0);//cmd
    string("\\");
    string("/");
    _clp_strtran(3);
    assign(base+0);//cmd
    pop();
    line(69);
    line(67);
    string(":/");
    push_symbol(base+0);//cmd
    _clp_at(2);
    number(2);
    eqeq();
    if(!flag()) goto if_4_1;
        line(68);
        string("/");
        push_symbol(base+0);//cmd
        idxr0(1);
        add();
        push_symbol(base+0);//cmd
        number(3);
        push(&NIL);
        slice();
        add();
        assign(base+0);//cmd
        pop();
    if_4_1:
    if_4_0:;
    line(70);
    number(3);
    string("bash.exe");
    string("-c");
    string("\"");
    push_symbol(base+0);//cmd
    add();
    string("\"");
    add();
    _clp_spawn(4);
    pop();
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

