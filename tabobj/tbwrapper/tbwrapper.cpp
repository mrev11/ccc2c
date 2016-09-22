
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

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dlfcn.h>
#include <cccapi.h>

extern void _clp__tbwrapper_error(int);

static char *tablib=0;

static const char *libnames[4];
static void *libhandles[4];
 
//-------------------------------------------------------------------------
void _clp__tbwrapper_tablib(int argno)
{
    CCC_PROLOG("_tbwrapper_tablib",1);
    char *str=_parc(1); //-Wno-nonnull
    tablib=strdup(str);
    _ret();
    CCC_EPILOG();
}

//-------------------------------------------------------------------------
static int libload()
{
    char *env=((tablib!=0)?tablib:getenv("CCC_TABLIB")); 
    
    extern void _clp_console_type(int);
    _clp_console_type(0); 
    int ctype=(int)*STRINGPTR(TOP());
    POP();
 
    if( 0==env || 0==strcasecmp(env,"btbtx") )
    {
        libnames[0]="libccc2_btbtx.so";
        if( ctype )
        {
            libnames[1]="libccc2_btbtxui.so";
        }
        libnames[2]=0;
    }
    else if(0==strcasecmp(env,"datidx")) 
    {
        libnames[0]="libccc2_datidx.so";
        if( ctype )
        {
            libnames[1]="libccc2_datidxui.so";
        }
        libnames[2]=0;
    }
    else if(0==strcasecmp(env,"dbfctx")) 
    {
        libnames[0]="libccc2_dbfctx.so";
        if( ctype )
        {
            libnames[1]="libccc2_dbfctxui.so";
        }
        libnames[2]=0;
    }
    else                                 
    { 
        string("libname");                     //operation
        string("Unknown driver name");         //description
        string(" ["); add();
        string(env); add();
        string("]"); add();
        _clp__tbwrapper_error(2);
        exit(1);
    }
    
    for( int n=0; libnames[n]; n++ )
    {
        libhandles[n]=dlopen(libnames[n],RTLD_NOW|RTLD_GLOBAL); 
        
        if( !libhandles[n] )
        {
            fprintf(stderr,"Error: %s\n",dlerror());
        }
        else
        {
            //fprintf(stderr,"Loaded: %s\n",libnames[n]);
        }
    }
    
    if( !libhandles[0] )
    {
        string("libload");                   //operation
        string("Library not found");         //description
        string(libnames[0]);                 //filename
        _clp__tbwrapper_error(3);
        exit(1);
    }
    
    return 0;
}

//-------------------------------------------------------------------------
static void *symload(const char *pname)
{
    static int libinit=libload();

    int i=0;
    void *paddr=0;
    while( paddr==0 && libhandles[i]!=0  )
    {
        paddr=dlsym(libhandles[i],pname);  
        i++;
    }

    if( paddr==0 )
    {
        string("symload");                   //operation
        string("Symbol not found");          //description
        string(" ["); add();
        string(pname); add();
        string("]"); add();
        string(libnames[0]);                 //filename
        _clp__tbwrapper_error(3);
        exit(1);
    }

    return paddr;
}

//-------------------------------------------------------------------------
#include <symbols.h>

//-------------------------------------------------------------------------
