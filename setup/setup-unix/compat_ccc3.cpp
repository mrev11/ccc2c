
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

//input: compat_ccc3.ppo (4.4.27)

#include <clp2cpp.h>

extern void _clp_bin(int argno);
extern void _clp_bin2str(int argno);
extern void _clp_chr(int argno);
extern void _clp_gc(int argno);
extern void _clp_split(int argno);
extern void _clp_str2bin(int argno);
extern void _clp_vartab_rebuild(int argno);
extern void _clp_wordlist(int argno);

//=======================================================================
void _clp_bin(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
argno=1;
push_call("bin",base);
//
    line(23);
    push_symbol(base+0);//x
    _clp_chr(1);
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
void _clp_str2bin(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
argno=1;
push_call("str2bin",base);
//
    line(26);
    push_symbol(base+0);//x
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
void _clp_bin2str(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
argno=1;
push_call("bin2str",base);
//
    line(29);
    push_symbol(base+0);//x
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
void _clp_split(int argno)
{
VALUE *base=stack-argno;
while(stack<base+argno+0)PUSHNIL();
push_call("split",base);
//
    line(32);
    {int argc=0+1-1;
    {int i;for(i=0;i<argno;i++){argc++;push(base+i);}}
    _clp_wordlist(argc);
    };
    {*base=*(stack-1);stack=base+1;pop_call();return;}
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================
void _clp_gc(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+0)PUSHNIL();
argno=0;
push_call("gc",base);
//
    line(35);
    _clp_vartab_rebuild(0);
    pop();
//
stack=base;
push(&NIL);
pop_call();
}
//=======================================================================

