
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
#include <process.h>
#include <cccapi.h>

//MSVC-ben �s MinGW-ben a spawn �ltal visszaadott pid egyben
//Win32 HANDLE, amire v�rni lehet WaitForSingleObject-tel,
//pl. thread_mutex_lock( spawn(.f.,"program.exe") ) v�r.
//
//Borland-ban a pid NEM HANDLE, az�rt a fenti v�rakoz�s nem megy.
//Borlandban implement�lva van a teszt�leges childra v�r� wait,
//ami MSVC-b�l �s MinGW-b�l hi�nyzik. Ezek pid=0-val sem tudnak v�rni.
//
//Windowson nincs implement�lva a WNOHANG funkci�, ami nem v�r,
//csak jelzi, hogy kil�pett-e m�r a child (�s takar�tja a zombikat).
//
//Windowson waitpid() harmadik param�tere nincs haszn�latban.

//--------------------------------------------------------------------------
void _clp_wait(int argno)  

// Csak Borland-dal m�k�dik
//
// wait()          v�r, m�g egy child kil�p
// wait(@status)   v�r, m�g egy child kil�p + plusz exit inf�

{
    CCC_PROLOG("wait",1);
    int status = 0; //kimenet

    #ifdef BORLAND
        int result = wait(&status); //OK, j� cwait(&status,0,0) is
    #endif
    #ifdef MSVC
        int result = _cwait(&status,0,0); //rossz, wait nincs
    #endif
    #ifdef MINGW
        int result = _cwait(&status,0,0); //rossz, wait nincs 
    #endif
    
    number(status);
    assign(PARPTR(1));
    _retni( result ) ;
    CCC_EPILOG();
}

//--------------------------------------------------------------------------
void _clp_waitpid(int argno)  

// waitpid(pid)             v�r, m�g pid kil�p
// waitpid(pid,@status,0)   v�r, m�g pid kil�p + plusz exit inf� 
 
{
    CCC_PROLOG("waitpid",3);
    int pid    = ISNUMBER(1)?_parni(1):0;
    int status = 0; //kimenet
    int mode   = ISNUMBER(3)?_parni(3):0;

    #ifdef BORLAND
        int result = cwait(&status,pid,mode);
    #endif
    #ifdef MSVC
        int result = _cwait(&status,pid,mode);
    #endif
    #ifdef MINGW
        int result = _cwait(&status,pid,mode);
    #endif
    
    //a harmadik (mode) param�ter hat�stalan
    //Windowson mindig v�r (nincs WNOHANG m�d)

    number(status);
    assign(PARPTR(2));
    _retni( result ) ;
    CCC_EPILOG();
}
 
//--------------------------------------------------------------------------

 