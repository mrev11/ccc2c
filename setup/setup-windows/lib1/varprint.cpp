
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

#include <stdio.h>
#include <string.h>
#include <cccapi.h>

extern void stack_print(void);
extern void var_print(VALUE *);
 
#define OUTSTR(x)  string(x);_clp_qqout(1);pop()
#define OUTNUM(x)  number(x);_clp_str(1);_clp_alltrim(1);_clp_qqout(1);pop()
#define OUTDAT(x)  date(x);_clp_dtos(1);_clp_qqout(1);pop()
#define OUTFLG(x)  logical(x);_clp_qqout(1);pop()
#define OUTPTR(x)  pointer((void*)x);_clp_qqout(1);pop()
#define OUTOREF(x) OUTSTR(" oref=");if(x){OUTPTR(x);}else{OUTSTR("NULL");}

//---------------------------------------------------------------------------
void stack_print(void)
{

    OUTSTR("\n-----------------------------------------------------------");
    OUTSTR("\n Variable Stack");
    OUTSTR("\n-----------------------------------------------------------");

    // static változók

    int n;

    for( n=0; &ststackbuf[n]<ststack; n++ )
    {
        OUTSTR("\n"); OUTNUM(n); OUTSTR(": ");
        var_print( &ststackbuf[n] );
    }

    // local változók

    TRACE *tr=&tracebuf[1];

    for( n=0; &stackbuf[n]<stack; n++ )
    {
        while( (tr<=trace) && (tr->base<=&stackbuf[n]) )
        {
            OUTSTR("\n***** function ");
            OUTSTR(tr->func);
            tr++;
        }

        OUTSTR("\n"); OUTNUM(n); OUTSTR(": ");
        var_print( &stackbuf[n] );
    }

    OUTSTR("\n-----------------------------------------------------------");
}

//---------------------------------------------------------------------------
void var_print(VALUE *v)
{
    switch( v->type )
    {
        case TYPE_NIL:
            OUTSTR("NIL");
            break;

        case TYPE_NUMBER:
            OUTSTR("NUMBER "); OUTNUM(v->data.number);
            break;

        case TYPE_DATE:
            OUTSTR("DATE "); OUTDAT(v->data.date);
            break;

        case TYPE_POINTER:
            OUTSTR("POINTER "); OUTPTR(v->data.pointer);
            break;

        case TYPE_FLAG:
            OUTSTR("FLAG "); OUTFLG(v->data.flag);
            break;

        case TYPE_STRING:
        {
            OUTSTR("STRING length=");
            OUTNUM((double)STRINGLEN(v));
            OUTOREF(v->data.string.oref);
            
            if(STRINGPTR0(v)==0)
            {
                OUTSTR(" (null)");
            }
            else
            {
                OUTSTR(" \"");
                unsigned len=min(STRINGLEN(v),32);
                if( len>0 )
                {
                    char buf[64];
                    memcpy(buf,STRINGPTR(v),len);

                    unsigned int i;
                    for(i=0; i<len; i++)
                    {
                        if( (255&(*(buf+i)))<0x20 )
                            *(buf+i)='^';
                    }

                    *(buf+len)=0x00;

                    if(len<STRINGLEN(v))
                    {
                        strcat(buf," ... ");
                    }
        
                    OUTSTR(buf);
                }
                OUTSTR("\"");
            }
            break;
        }

        case TYPE_ARRAY:
            OUTSTR("ARRAY length="); 
            OUTNUM(ARRAYLEN(v));
            OUTOREF(v->data.array.oref);
            break;

        case TYPE_BLOCK:
            OUTSTR("BLOCK");
            OUTOREF(v->data.block.oref);
            break;

        case TYPE_OBJECT:
            OUTSTR("OBJECT subtype="); 
            OUTNUM(v->data.object.subtype);
            OUTOREF(v->data.object.oref);
            break;

        case TYPE_REF:
            OUTSTR("REF");
            var_print(&v->data.vref->value);
            break;

    }
}


//---------------------------------------------------------------------------
void debug(const char *text)
{
    PUSH(&TRUE); _clp_setconsole(1); pop();
    string("DEBUG:"); string(text); add(); _clp_qout(1); pop();
    stack_print();
    fflush(0);
}
 
//---------------------------------------------------------------------------
