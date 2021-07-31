//input: like.ppo (4.7.0)

#include <clp2cpp.h>

extern void _clp_len(int argno);
extern void _clp_like(int argno);
extern void _clp_substr(int argno);

//=======================================================================
void _clp_like(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+5)PUSHNIL();
argno=2;
push_call("like",base);
//
    line(24);
    line(52);
    {
    line(26);
    push(&ONE);
    int sg=sign();
    push(&ONE);
    assign(base+2);//i
    lab_1_0:
    push_symbol(base+1);//str
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_1_2;
        line(51);
        line(28);
        push_symbol(base+0);//minta
        push_symbol(base+2);//i
        push(&ONE);
        _clp_substr(3);
        string("?");
        eqeq();
        if(!flag()) goto if_2_1;
        goto if_2_0;
        if_2_1:
        line(31);
        push_symbol(base+0);//minta
        push_symbol(base+2);//i
        push(&ONE);
        _clp_substr(3);
        string("*");
        eqeq();
        if(!flag()) goto if_2_2;
            line(33);
            push_symbol(base+0);//minta
            push_symbol(base+2);//i
            addnum(1);
            _clp_substr(2);
            assign(base+4);//w
            pop();
            line(37);
            line(35);
            push_symbol(base+4);//w
            _clp_len(1);
            push(&ZERO);
            eqeq();
            if(!flag()) goto if_3_1;
                line(36);
                push(&TRUE);
                {*base=*(stack-1);stack=base+1;pop_call();return;}
            if_3_1:
            if_3_0:;
            line(43);
            {
            line(39);
            push(&ONE);
            int sg=sign();
            push_symbol(base+2);//i
            assign(base+3);//j
            lab_4_0:
            push_symbol(base+1);//str
            _clp_len(1);
            if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_4_2;
                line(42);
                line(40);
                push_symbol(base+4);//w
                push_symbol(base+1);//str
                push_symbol(base+3);//j
                _clp_substr(2);
                _clp_like(2);
                if(!flag()) goto if_5_1;
                    line(41);
                    push(&TRUE);
                    {*base=*(stack-1);stack=base+1;pop_call();return;}
                if_5_1:
                if_5_0:;
            lab_4_1:
            push(&ONE);
            dup();
            sg=sign();
            push_symbol(base+3);//j
            add();
            assign(base+3);//j
            goto lab_4_0;
            lab_4_2:;
            }
            line(44);
            push(&FALSE);
            {*base=*(stack-1);stack=base+1;pop_call();return;}
        goto if_2_0;
        if_2_2:
        line(46);
        push_symbol(base+0);//minta
        push_symbol(base+2);//i
        push(&ONE);
        _clp_substr(3);
        push_symbol(base+1);//str
        push_symbol(base+2);//i
        push(&ONE);
        _clp_substr(3);
        eqeq();
        if(!flag()) goto if_2_3;
        goto if_2_0;
        if_2_3:
        line(49);
            line(50);
            push(&FALSE);
            {*base=*(stack-1);stack=base+1;pop_call();return;}
        if_2_4:
        if_2_0:;
    lab_1_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+2);//i
    add();
    assign(base+2);//i
    goto lab_1_0;
    lab_1_2:;
    }
    line(58);
    line(54);
    push_symbol(base+1);//str
    _clp_len(1);
    push_symbol(base+0);//minta
    _clp_len(1);
    gt();
    if(!flag()) goto if_6_1;
        line(55);
        push(&FALSE);
        {*base=*(stack-1);stack=base+1;pop_call();return;}
    goto if_6_0;
    if_6_1:
    line(56);
    push_symbol(base+1);//str
    _clp_len(1);
    push_symbol(base+0);//minta
    _clp_len(1);
    eqeq();
    if(!flag()) goto if_6_2;
        line(57);
        push(&TRUE);
        {*base=*(stack-1);stack=base+1;pop_call();return;}
    if_6_2:
    if_6_0:;
    line(67);
    {
    line(63);
    push(&ONE);
    int sg=sign();
    push_symbol(base+1);//str
    _clp_len(1);
    addnum(1);
    assign(base+2);//i
    lab_7_0:
    push_symbol(base+0);//minta
    _clp_len(1);
    if( ((sg>=0)&&greaterthan()) || ((sg<0)&&lessthan())) goto lab_7_2;
        line(66);
        line(64);
        push_symbol(base+0);//minta
        push_symbol(base+2);//i
        push(&ONE);
        _clp_substr(3);
        string("*");
        eqeq();
        topnot();
        if(!flag()) goto if_8_1;
            line(65);
            push(&FALSE);
            {*base=*(stack-1);stack=base+1;pop_call();return;}
        if_8_1:
        if_8_0:;
    lab_7_1:
    push(&ONE);
    dup();
    sg=sign();
    push_symbol(base+2);//i
    add();
    assign(base+2);//i
    goto lab_7_0;
    lab_7_2:;
    }
    line(69);
    push(&TRUE);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

