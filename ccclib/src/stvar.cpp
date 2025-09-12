
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

#include <cccapi.h>


MUTEX_CREATE(mutex);

static void verify_overflow()
{
    static int exit_flag=0;
    if( exit_flag==0 && ststack-ststackbuf>(int)STSTACK_SIZE-10 )
    {
        exit_flag=1;
        printf("\nStatic stack overflow");
        _clp_varstack(0);
        pop();
        printf("\n");
        fflush(0);
        exit(1);
    }
}
 

stvar::stvar()
{
    verify_overflow();

    MUTEX_LOCK(mutex);
    ptr=ststack;
    STPUSH(&NIL);
    MUTEX_UNLOCK(mutex);
}

stvar::stvar(char *str)
{
    verify_overflow();

    string(str);
    MUTEX_LOCK(mutex);
    ptr=ststack;
    STPUSH(TOP());
    MUTEX_UNLOCK(mutex);
    POP();
}

stvar::stvar(const char *str)
{
    verify_overflow();

    string(str);
    MUTEX_LOCK(mutex);
    ptr=ststack;
    STPUSH(TOP());
    MUTEX_UNLOCK(mutex);
    POP();
}

stvar::stvar(double d)
{
    verify_overflow();

    number(d);
    MUTEX_LOCK(mutex);
    ptr=ststack;
    STPUSH(TOP());
    MUTEX_UNLOCK(mutex);
    POP();
}
 
stvar::stvar( void (*inicode)() )
{
    verify_overflow();

    inicode();
    MUTEX_LOCK(mutex);
    ptr=ststack;
    STPUSH(TOP());
    MUTEX_UNLOCK(mutex);
    POP();
}

stvar::stvar( VALUE *v )
{
    verify_overflow();

    push_symbol(v);
    MUTEX_LOCK(mutex);
    ptr=ststack;
    STPUSH(TOP());
    MUTEX_UNLOCK(mutex);
    POP();
}

stvarloc::stvarloc( void (*inicode)(VALUE*),VALUE*base )
{
    inicode(base);
    MUTEX_LOCK(mutex);

    //ptr=ststack;
    //STPUSH(TOP());
    *ptr=*TOP(); //2011.06.28 az stvar::stvar() konstruktor már lefutott

    MUTEX_UNLOCK(mutex);
    POP();
}

