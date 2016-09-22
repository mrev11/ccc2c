
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
#include <stdlib.h>
#include <string.h>

#include <cccapi.h>

//-------------------------------------------------------------------------
void _clp_isbit(int argno) //CA-Tools
{
    CCC_PROLOG("isbit",2);
    
    long n=0;
    long m=1;
    
    if( ISSTRING(1) )
    {
        sscanf(_parc(1),"%lx",&n);
    }
    else
    {
        n=_parnu(1);    
    }
    
    if( ISNUMBER(2) )
    {
        int b=_parni(2);
        
        if( b<0 )
        {
            m=0;
        }
        else if( b==0 )
        {
            m=1;
        }
        else if( b<=32 )
        {
            m=1<<(b-1);
        }
        else
        {
            m=0;
        }
    }

    _retl( n&m );

    CCC_EPILOG();
}    


//-------------------------------------------------------------------------
void _clp_setbit(int argno)  //CA-Tools 
{
VALUE *base=stack-argno;
push_call("setbit",base);

    if( argno<1 )
    {
        error_arg("setbit",base,argno);
    }

    unsigned long n=0;

    if( ISSTRING(1) )
    {
        sscanf(_parc(1),"%lx",&n);
    }
    else
    {
        n=_parnu(1);    
    }
    
    int i;
    for( i=2; i<=argno; i++ )
    {
        int m=_parni(i);
        
        if( (1<=m) && (m<=32) )
        {
            n|=(1<<(m-1));
        }
        else
        {
            pop_call();
            stack=base;
            number(-1);
            return;
        }
    }

    pop_call();
    stack=base;
    number(n);
}


//-------------------------------------------------------------------------
void _clp_clearbit(int argno)  //CA-Tools 
{
VALUE *base=stack-argno;
push_call("setbit",base);

    if( argno<1 )
    {
        error_arg("clearbit",base,argno);
    }

    unsigned long n=0;

    if( ISSTRING(1) )
    {
        sscanf(_parc(1),"%lx",&n);
    }
    else
    {
        n=_parnu(1);    
    }
    
    int i;
    for( i=2; i<=argno; i++ )
    {
        int m=_parni(i);
        
        if( (1<=m) && (m<=32) )
        {
            n&=~(1<<(m-1));
        }
        else
        {
            pop_call();
            stack=base;
            number(-1);
            return;
        }
    }

    pop_call();
    stack=base;
    number(n);
}

 
//-------------------------------------------------------------------------
void _clp_numand(int argno)  //CA-Tools 
{
VALUE *base=stack-argno;
push_call("numand",base);

    if( argno<2 )
    {
        error_arg("numand",base,argno);
    }
 
    unsigned long n=0;
    
    if( ISSTRING(1) )
    {
        sscanf(_parc(1),"%lx",&n);
    }
    else
    {
        n=_parnu(1);    
    }

    int i;

    for( i=2; i<=argno; i++ )
    {
        unsigned long m=0;
        
        if( ISSTRING(i) )
        {
            sscanf(_parc(i),"%lx",&m);
        }
        else
        {
            m=_parnu(i);    
        }

        n&=m;
    }

    pop_call();
    stack=base;
    number(n);
}


//-------------------------------------------------------------------------
void _clp_numor(int argno)  //CA-Tools 
{
VALUE *base=stack-argno;
push_call("numor",base);

    if( argno<2 )
    {
        error_arg("numor",base,argno);
    }
 
    unsigned long n=0;
    
    if( ISSTRING(1) )
    {
        sscanf(_parc(1),"%lx",&n);
    }
    else
    {
        n=_parnu(1);    
    }

    int i;

    for( i=2; i<=argno; i++ )
    {
        unsigned long m=0;
        
        if( ISSTRING(i) )
        {
            sscanf(_parc(i),"%lx",&m);
        }
        else
        {
            m=_parnu(i);    
        }

        n|=m;
    }

    pop_call();
    stack=base;
    number(n);
}


//-------------------------------------------------------------------------
void _clp_numxor(int argno)  //CA-Tools 
{
    CCC_PROLOG("numxor",2);

    unsigned long n=0,m=0;

    if( ISSTRING(1) )
    {
        sscanf(_parc(1),"%lx",&n);
    }
    else
    {
        n=_parnu(1);    
    }

    if( ISSTRING(2) )
    {
        sscanf(_parc(2),"%lx",&m);
    }
    else
    {
        m=_parnu(2);    
    }

    _retnl(  n^m );
    CCC_EPILOG();
}

 
//-------------------------------------------------------------------------
void _clp_numnot(int argno)  //CA-Tools 
{
    CCC_PROLOG("numnot",1);

    unsigned long n=0;

    if( ISSTRING(1) )
    {
        sscanf(_parc(1),"%lx",&n);
    }
    else
    {
        n=_parnu(1);    
    }

    _retnl( ~n ); //Clipper csak az alsó 16 bitet adja!

    CCC_EPILOG();
}
 
//-------------------------------------------------------------------------
