
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
#include <unistd.h>
#include <sys/wait.h>
#include <cccapi.h>

#include <spawn.ch>

//Windows spawn emul�ci� UNIX-on
// a processz fork-ol
// a fork child �ga exec-kel ind�tja a spawn-ban megadott programot
// a fork parent �ga a wait/nowait param�ternek megfelel�en v�r

//hiba: 
// nem lehet egyszerre path-b�l ind�tani �s environment-et megadni,
// mert a UNIX-os exec v�ltozatok k�z�l hi�nyzik execvpe (mi�rt??)

//megj: 
// spawn( flag,prog,arg1,arg2,...{env}      )
// exec (      prog,arg1,arg2,...{env},flag )
// _clp_exec() h�v�sakor eggyel feljebb toljuk a stacket
 
//--------------------------------------------------------------------------
void _clp_spawn(int argno)
{
    VALUE *base=stack-argno;
    push_call("spawn",base);

    if( argno<1 )
    {
        ARGERROR();
    }
    else if( ISFLAG(1) )
    {
        logical( 0 ); //path flag
    }
    else if( ISNUMBER(1) )
    {
        logical( SPAWN_PATH & _parni(1) ); //path flag 
    }
    else
    {
        ARGERROR();
    }
    
    int result=0;
    int childpid=fork();

    if( 0==childpid )
    {
        //printf("child\n");
        extern void _clp_exec(int argno);
        _clp_exec(argno); //nem j�n vissza
        exit(1);
    }
    else if( (ISNUMBER(1)&&(_parni(1)&SPAWN_WAIT)) || (ISFLAG(1)&&_parl(1)) )
    {
        //printf("parent wait %d\n",childpid);
        waitpid(childpid,&result,0);
    }
    else
    {
        //printf("parent nowait %d\n",childpid);
        //waitpid(0,&result,WNOHANG);
        result=childpid;
    }

    stack=base;
    number(result);
    pop_call();
}

//--------------------------------------------------------------------------

