//input: ppo/cloutput.ppo (4.11.0.1)

#include <clp2cpp.h>

static void _blk_outputregister_0(int argno);
static void _blk_outputregister_1(int argno);
static void _blk_outputregister_2(int argno);
static void _blk_outputregister_3(int argno);
static void _blk_outputregister_4(int argno);
extern void _clp_array(int argno);
extern void _clp_asize(int argno);
extern void _clp_classattrib(int argno);
extern void _clp_classmethod(int argno);
extern void _clp_classregister(int argno);
extern void _clp_len(int argno);
extern void _clp_objectclass(int argno);
extern void _clp_objectnew(int argno);
static void _clp_outputadd(int argno);
static void _clp_outputbuf(int argno);
extern void _clp_outputclass(int argno);
static void _clp_outputclear(int argno);
static void _clp_outputini(int argno);
static void _clp_outputlen(int argno);
extern void _clp_outputnew(int argno);
static void _clp_outputregister(int argno);
extern void _clp_valtype(int argno);

class _method6_buffer: public _method6_{public: _method6_buffer():_method6_("buffer"){};}; static _method6_buffer _o_method_buffer;
class _method6_bufidx: public _method6_{public: _method6_bufidx():_method6_("bufidx"){};}; static _method6_bufidx _o_method_bufidx;
class _method6_bufinc: public _method6_{public: _method6_bufinc():_method6_("bufinc"){};}; static _method6_bufinc _o_method_bufinc;
class _method6_initialize: public _method6_{public: _method6_initialize():_method6_("initialize"){};}; static _method6_initialize _o_method_initialize;

static VALUE* _st_clid_output_ptr()
{
    static stvar _st_clid_output;
    static int _ini_clid_output=[=](){
        _clp_outputregister(0);
        assign(_st_clid_output.ptr);
        pop();
        return 1;
    }();
    return _st_clid_output.ptr;
}
//=======================================================================
void _clp_outputclass(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+0)PUSHNIL();
argno=0;
push_call("outputclass",base);
//
    line(36);
    push_symbol(_st_clid_output_ptr());//global
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_outputregister(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+1)PUSHNIL();
argno=0;
push_call("outputregister",base);
//
    line(40);
    string("output");
    _clp_objectclass(0);
    _clp_classregister(2);
    assign(base+0);//clid
    pop();
    line(41);
    push_symbol(base+0);//clid
    string("initialize");
    block(_blk_outputregister_0,0);
    _clp_classmethod(3);
    pop();
    line(42);
    push_symbol(base+0);//clid
    string("add");
    block(_blk_outputregister_1,0);
    _clp_classmethod(3);
    pop();
    line(43);
    push_symbol(base+0);//clid
    string("len");
    block(_blk_outputregister_2,0);
    _clp_classmethod(3);
    pop();
    line(44);
    push_symbol(base+0);//clid
    string("buf");
    block(_blk_outputregister_3,0);
    _clp_classmethod(3);
    pop();
    line(45);
    push_symbol(base+0);//clid
    string("clear");
    block(_blk_outputregister_4,0);
    _clp_classmethod(3);
    pop();
    line(46);
    push_symbol(base+0);//clid
    string("buffer");
    _clp_classattrib(2);
    pop();
    line(47);
    push_symbol(base+0);//clid
    string("bufidx");
    _clp_classattrib(2);
    pop();
    line(48);
    push_symbol(base+0);//clid
    string("bufinc");
    _clp_classattrib(2);
    pop();
    line(49);
    push_symbol(base+0);//clid
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}

static void _blk_outputregister_0(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,3);
while(stack<base+3)PUSHNIL();
argno=3;
push_call("_blk_outputregister_0",base);
//
    push_symbol(base+1);//this
    push_symbol(base+2);//s
    _clp_outputini(2);
//
{*base=*(stack-1);stack=base+1;pop_call();}
}

static void _blk_outputregister_1(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,3);
while(stack<base+3)PUSHNIL();
argno=3;
push_call("_blk_outputregister_1",base);
//
    push_symbol(base+1);//this
    push_symbol(base+2);//t
    _clp_outputadd(2);
//
{*base=*(stack-1);stack=base+1;pop_call();}
}

static void _blk_outputregister_2(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
argno=2;
push_call("_blk_outputregister_2",base);
//
    push_symbol(base+1);//this
    _clp_outputlen(1);
//
{*base=*(stack-1);stack=base+1;pop_call();}
}

static void _blk_outputregister_3(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
argno=2;
push_call("_blk_outputregister_3",base);
//
    push_symbol(base+1);//this
    _clp_outputbuf(1);
//
{*base=*(stack-1);stack=base+1;pop_call();}
}

static void _blk_outputregister_4(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
argno=2;
push_call("_blk_outputregister_4",base);
//
    push_symbol(base+1);//this
    _clp_outputclear(1);
//
{*base=*(stack-1);stack=base+1;pop_call();}
}
//=======================================================================
void _clp_outputnew(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+2)PUSHNIL();
argno=1;
push_call("outputnew",base);
//
    line(54);
    _clp_outputclass(0);
    assign(base+1);//clid
    pop();
    line(55);
    push_symbol(base+1);//clid
    _clp_objectnew(1);
    push_symbol(base+0);//incsize
    _o_method_initialize.eval(2);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_outputini(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
argno=2;
push_call("outputini",base);
//
    line(64);
    push_symbol(base+0);//this
    push_symbol(base+1);//size
    push(&NIL);
    neeq();
    cmp_487:;
    if(flag()){
    push_symbol(base+1);//size
    }else{
    number(32);
    }
    _o_method_bufinc.eval(2);
    pop();
    line(65);
    push_symbol(base+0);//this
    push_symbol(base+0);//this
    _o_method_bufinc.eval(1);
    _clp_array(1);
    _o_method_buffer.eval(2);
    pop();
    line(66);
    push_symbol(base+0);//this
    push(&ONE);
    _o_method_bufidx.eval(2);
    pop();
    line(68);
    push_symbol(base+0);//this
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_outputadd(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+6)PUSHNIL();
argno=2;
push_call("outputadd",base);
//
    line(74);
    push_symbol(base+1);//t
    _clp_valtype(1);
    assign(base+3);//typt
    pop();
    line(82);
    line(76);
    push_symbol(base+3);//typt
    string("A");
    eqeq();
    cmp_606:;
    if(!flag()) goto if_1_1;
        line(77);
        push_symbol(base+1);//t
        _clp_len(1);
        assign(base+4);//lent
        pop();
        line(78);
        push(&TRUE);
        assign(base+5);//arrflg
        pop();
    goto if_1_0;
    if_1_1:
    line(79);
        line(80);
        push(&ONE);
        assign(base+4);//lent
        pop();
        line(81);
        push(&FALSE);
        assign(base+5);//arrflg
        pop();
    if_1_2:
    if_1_0:;
    line(86);
    line(84);
    push_symbol(base+0);//this
    _o_method_bufidx.eval(1);
    push_symbol(base+4);//lent
    add();
    push_symbol(base+0);//this
    _o_method_buffer.eval(1);
    _clp_len(1);
    gt();
    cmp_689:;
    if(!flag()) goto if_2_1;
        line(85);
        push_symbol(base+0);//this
        _o_method_buffer.eval(1);
        push_symbol(base+0);//this
        _o_method_bufidx.eval(1);
        push_symbol(base+4);//lent
        add();
        push_symbol(base+0);//this
        _o_method_bufinc.eval(1);
        add();
        _clp_asize(2);
        pop();
    if_2_1:
    if_2_0:;
    line(96);
    line(88);
    push_symbol(base+5);//arrflg
    if(!flag()) goto if_3_1;
        line(92);
        {
        line(89);
        push(&ONE);
        int sg=sign();
        push(&ONE);
        assign(base+2);//n
        lab_4_0:
        push_symbol(base+4);//lent
        if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_4_2;
            line(90);
            push_symbol(base+1);//t
            push_symbol(base+2);//n
            idxr();
            push_symbol(base+0);//this
            _o_method_buffer.eval(1);
            push_symbol(base+0);//this
            _o_method_bufidx.eval(1);
            assign2(idxxl());
            pop();
            line(91);
            push_symbol(base+0);//this
            _o_method_bufidx.eval(1);
            dup();
            push(&ONE);
            add();
            push_symbol(base+0);//this
            swap();
            _o_method_bufidx.eval(2);
            pop();
            pop();
        lab_4_1:
        push(&ONE);
        dup();
        sg=sign();
        push_symbol(base+2);//n
        add();
        assign(base+2);//n
        goto lab_4_0;
        lab_4_2:;
        }
    goto if_3_0;
    if_3_1:
    line(93);
        line(94);
        push_symbol(base+1);//t
        push_symbol(base+0);//this
        _o_method_buffer.eval(1);
        push_symbol(base+0);//this
        _o_method_bufidx.eval(1);
        assign2(idxxl());
        pop();
        line(95);
        push_symbol(base+0);//this
        _o_method_bufidx.eval(1);
        dup();
        push(&ONE);
        add();
        push_symbol(base+0);//this
        swap();
        _o_method_bufidx.eval(2);
        pop();
        pop();
    if_3_2:
    if_3_0:;
    line(98);
    push_symbol(base+1);//t
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_outputlen(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
argno=1;
push_call("outputlen",base);
//
    line(103);
    push_symbol(base+0);//this
    _o_method_bufidx.eval(1);
    addnum(-1);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_outputbuf(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
argno=1;
push_call("outputbuf",base);
//
    line(108);
    push_symbol(base+0);//this
    _o_method_buffer.eval(1);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
static void _clp_outputclear(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
argno=1;
push_call("outputclear",base);
//
    line(113);
    push_symbol(base+0);//this
    push_symbol(base+0);//this
    _o_method_bufinc.eval(1);
    _clp_array(1);
    _o_method_buffer.eval(2);
    pop();
    line(114);
    push_symbol(base+0);//this
    push(&ONE);
    _o_method_bufidx.eval(2);
    pop();
    line(115);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

