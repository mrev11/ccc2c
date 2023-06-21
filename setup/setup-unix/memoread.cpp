//input: memoread.ppo (4.10.0)

#include <clp2cpp.h>

extern void _clp___maxstrlen(int argno);
extern void _clp_fclose(int argno);
extern void _clp_fcreate(int argno);
extern void _clp_fopen(int argno);
extern void _clp_fread(int argno);
extern void _clp_fseek(int argno);
extern void _clp_fwrite(int argno);
extern void _clp_len(int argno);
extern void _clp_memoread(int argno);
extern void _clp_memowrit(int argno);
extern void _clp_space(int argno);

//=======================================================================
void _clp_memoread(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+4)PUSHNIL();
argno=1;
push_call("memoread",base);
//
    line(26);
    string("");
    assign(base+3);//buffer
    pop();
    line(38);
    line(28);
    push(&ZERO);
    push_symbol(base+0);//fspec
    number(64);
    _clp_fopen(2);
    assign(base+1);//hnd
    lteq();
    if(!flag()){
    push(&FALSE);
    }else{
    push(&ZERO);
    push_symbol(base+1);//hnd
    push(&ZERO);
    number(2);
    _clp_fseek(3);
    assign(base+2);//len
    lt();
    }
    if(!flag()){
    push(&FALSE);
    }else{
    push_symbol(base+2);//len
    _clp___maxstrlen(0);
    lt();
    }
    if(!flag()) goto if_1_1;
        line(32);
        push_symbol(base+2);//len
        _clp_space(1);
        assign(base+3);//buffer
        pop();
        line(33);
        push_symbol(base+1);//hnd
        push(&ZERO);
        _clp_fseek(2);
        pop();
        line(37);
        line(35);
        push(&ZERO);
        push_symbol(base+1);//hnd
        push_symbol_ref(base+3);//buffer
        push_symbol(base+2);//len
        _clp_fread(3);
        gt();
        if(!flag()) goto if_2_1;
            line(36);
            string("");
            assign(base+3);//buffer
            pop();
        if_2_1:
        if_2_0:;
    if_1_1:
    if_1_0:;
    line(39);
    push_symbol(base+1);//hnd
    _clp_fclose(1);
    pop();
    line(40);
    push_symbol(base+3);//buffer
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
void _clp_memowrit(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+4)PUSHNIL();
argno=2;
push_call("memowrit",base);
//
    line(44);
    push_symbol(base+0);//fspec
    _clp_fcreate(1);
    assign(base+2);//hnd
    pop();
    line(45);
    push_symbol(base+1);//string
    _clp_len(1);
    assign(base+3);//lng
    pop();
    line(50);
    line(47);
    push(&ZERO);
    push_symbol(base+2);//hnd
    lteq();
    if(!flag()){
    push(&FALSE);
    }else{
    push_symbol(base+3);//lng
    push_symbol(base+2);//hnd
    push_symbol(base+1);//string
    push_symbol(base+3);//lng
    _clp_fwrite(3);
    eqeq();
    }
    if(!flag()) goto if_3_1;
        line(48);
        push_symbol(base+2);//hnd
        _clp_fclose(1);
        pop();
        line(49);
        push(&TRUE);
        {*base=*(stack-1);stack=base+1;pop_call();return;}
    if_3_1:
    if_3_0:;
    line(51);
    push(&FALSE);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

