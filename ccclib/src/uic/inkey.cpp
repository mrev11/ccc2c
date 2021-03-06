
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

#include <string.h>
#include <wchar.h>
#include <termapi.h>
#include <cccapi.h>
#include <inkey.ch>

//------------------------------------------------------------------------
#define TYPEAHEAD  128

static int keyboard_buffer[TYPEAHEAD];
static int kbmax=0;
static int kbact=0;

static int lastkey=0;


//------------------------------------------------------------------------
void _clp_inkey(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
//
    int key=0;

    if( kbact<kbmax )
    {
        key=keyboard_buffer[kbact++];
    }
    else if( base->type==TYPE_NUMBER )
    {
        double wait=base->data.number;
        if( wait<=0 )
        {
            key=getkey(-1);
        }
        else
        {
            key=getkey( (int)(wait*1000) );
        }
    }
    else
    {
        key=getkey(0);
    }

    stack=base;
    number(lastkey=key);
}


//------------------------------------------------------------------------
void _clp_nextkey(int argno)
{
    stack-=argno;

    if( kbact<kbmax )
    {
        number( keyboard_buffer[kbact] );
        return;
    }
    
    int save_lastkey=lastkey;

    _clp_inkey(0);

    lastkey=save_lastkey;
    
    int keycode=D2INT(TOP()->data.number);
    if( keycode )
    {
        kbact=0;
        kbmax=1;
        keyboard_buffer[0]=keycode;
    }
}

//------------------------------------------------------------------------
void _clp_lastkey(int argno)
{
    stack-=argno;
    number(lastkey);
}

//------------------------------------------------------------------------
void _clp___keyboard(int argno)
{
VALUE *base=stack-argno;
push_call("__keyboard",base);
//
    
    while(getkey(0)); //clear typeahead

    kbmax=0;
    kbact=0;

    for( VALUE *v=base; v<stack; v++ )
    {
        if( v->type==TYPE_BINARY )
        {
            bin2str(v);
        }
        
        if( v->type==TYPE_STRING )
        {
            for(unsigned int i=0; i<STRINGLEN(v) && kbmax<TYPEAHEAD; i++ )
            {
                keyboard_buffer[kbmax]=(int)(STRINGPTR(v)[i]);
                kbmax++;
            }
        }
        else if( v->type==TYPE_NUMBER )
        {
            if( kbmax<TYPEAHEAD )
            {
                keyboard_buffer[kbmax]=D2INT(v->data.number);
                kbmax++;
            }
        }
    }
//
stack=base;
push(&NIL);
pop_call();
}

//------------------------------------------------------------------------
void _clp_setctrlinkey(int argno)
{
    extern int get_ctrl_inkey_mode();
    extern void set_ctrl_inkey_mode(int);

    CCC_PROLOG("setctrlinkey",1);
    int prevmode=get_ctrl_inkey_mode();
    if( !ISNIL(1) )
    {
        int mode=_parl(1);
        set_ctrl_inkey_mode(mode);
    }
    _retl(prevmode);
    CCC_EPILOG();
}

//------------------------------------------------------------------------
void _clp_inkey_nav2ctrl(int argno)
{
    CCC_PROLOG("inkey_nav2ctrl",1);
    int code=_parni(1);

    switch( code )
    {
        // visszakonvertál a 
        // K_UP==^E, K_DOWN==^X ... módra

        case K_NAV_UP:    code=K_UP;    break;
        case K_NAV_DOWN:  code=K_DOWN;  break;
        case K_NAV_LEFT:  code=K_LEFT;  break;
        case K_NAV_RIGHT: code=K_RIGHT; break;
        case K_NAV_HOME:  code=K_HOME;  break;
        case K_NAV_END:   code=K_END;   break;
        case K_NAV_PGUP:  code=K_PGUP;  break;
        case K_NAV_PGDN:  code=K_PGDN;  break;
        case K_NAV_INS:   code=K_INS;   break;
        case K_NAV_DEL:   code=K_DEL;   break;
    }
    _retni(code); 
    CCC_EPILOG();
}

//------------------------------------------------------------------------
