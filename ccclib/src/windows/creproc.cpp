
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
 
//------------------------------------------------------------------------
void _clp_createprocess(int argno) 

//createprocess(
//  wait,
//  cmdline, 
//  inherit,
//  console,
//  {env1,env2,...},
//  curdir
//)

{
    CCC_PROLOG("createprocess",6);

    int    wait = ISNIL(1)? 0   : _parl(1);
    char * cmd  =                 _parc(2);
    int    inh  = ISNIL(3)? 1   : _parl(3);
    char * con  = ISNIL(4)? 0   : _parc(4);    //D:detach, C:create
    int    env  = ISNIL(5)? 0   : _paralen(5);
    char * cur  = ISNIL(6)? 0   : _parc(6);
    
    DWORD creflg=0;
    if( con && (*con=='D') ) { creflg|=DETACHED_PROCESS; }
    if( con && (*con=='C') ) { creflg|=CREATE_NEW_CONSOLE; }

    char *envir=0;
    if( !ISNIL(5) )
    {
        string("");
        int n;    
        for( n=0; n<env; n++ )
        {
            PUSH( _parax(5,n) );  //env
            number(0);            //env,0
            _clp_chr(1);          //env,'0'
            add();                //env0
            add();
        }
        number(0);
        _clp_chr(1);
        add();
        envir=STRINGPTR(TOP());
    }

    PROCESS_INFORMATION pinf;
    STARTUPINFO sinf; 
    GetStartupInfo(&sinf);

    BOOL result=CreateProcess(
        0,                     //lpApplicationName
        cmd,                   //lpCommandLine
        0,                     //lpProcessAttributes
        0,                     //lpThreadAttributes
        inh,                   //bInheritHandles
        creflg,                //dwCreationFlags
        envir,                 //lpEnvironment (NULL=inherit)
        cur,                   //lpCurrentDirectory
        &sinf,                 //lpStartupInfo
        &pinf                  //lpProcessInformation
        );

    if( result && wait )    
    {
        WaitForSingleObject(pinf.hProcess,INFINITE);
    }
        
    _retl( result );
    CCC_EPILOG();
}

//------------------------------------------------------------------------


