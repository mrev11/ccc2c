//input: filecopy.ppo (4.10.0)

#include <clp2cpp.h>

extern void _clp___copyfile(int argno);
extern void _clp_convertfspec2nativeformat(int argno);
extern void _clp_ferror(int argno);
extern void _clp_filecopy(int argno);
extern void _clp_filemove(int argno);
extern void _clp_frename(int argno);
extern void _clp_stat_st_size(int argno);

//=======================================================================
void _clp_filecopy(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+6)PUSHNIL();
argno=2;
push_call("_clp_filecopy",base);
//
    line(26);
    push_symbol(base+0);//xf1
    _clp_convertfspec2nativeformat(1);
    assign(base+2);//f1
    pop();
    line(27);
    push_symbol(base+1);//xf2
    _clp_convertfspec2nativeformat(1);
    assign(base+3);//f2
    pop();
    line(28);
    push_symbol(base+2);//f1
    push_symbol(base+3);//f2
    _clp___copyfile(2);
    assign(base+4);//ok
    pop();
    line(29);
    push_symbol(base+4);//ok
    if(flag()){
    push_symbol(base+3);//f2
    _clp_stat_st_size(1);
    }else{
    number(-1);
    }
    assign(base+5);//result
    pop();
    line(30);
    push_symbol(base+4);//ok
    if(flag()){
    push(&ZERO);
    }else{
    number(-1);
    }
    _clp_ferror(1);
    pop();
    line(31);
    push_symbol(base+5);//result
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
void _clp_filemove(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+4)PUSHNIL();
argno=2;
push_call("filemove",base);
//
    line(36);
    push_symbol(base+0);//xf1
    _clp_convertfspec2nativeformat(1);
    assign(base+2);//f1
    pop();
    line(37);
    push_symbol(base+1);//xf2
    _clp_convertfspec2nativeformat(1);
    assign(base+3);//f2
    pop();
    line(38);
    push_symbol(base+2);//f1
    push_symbol(base+3);//f2
    _clp_frename(2);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

