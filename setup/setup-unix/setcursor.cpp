//input: setcursor.ppo (4.5.1)

#include <clp2cpp.h>

extern void _clp_setcursor(int argno);

//=======================================================================
void _clp_setcursor(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+0)PUSHNIL();
argno=0;
push_call("setcursor",base);
//
    line(22);
    push(&NIL);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

