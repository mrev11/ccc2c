
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
#include <cccapi.h>

#define MAXLEN 256

#define PTR(v)         STRINGPTR(v) 
#define LEN(v)         STRINGLEN(v) 
#define STRPTR(v,def)  ((LEN(v))?(PTR(v)):(def))


//------------------------------------------------------------------------
void _clp___copyfile(int argno)
{
    CCC_PROLOG("__copyfile",3);
    char *src=_parc(1);
    char *trg=_parc(2);
    int flag=ISFLAG(3)?_parl(3):0;
    _retl( CopyFile(src,trg,flag) );
    CCC_EPILOG();
 
} 

//------------------------------------------------------------------------
void _clp_getvolumeinformation(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
push_call("getvolumeinformation",base);
//
    VALUE *root=base;

    char  *rootName=NULL;
    char  volumeName[MAXLEN];
    DWORD volumeSerialNumber;
    DWORD maxNameLength;
    DWORD fileSystemFlags;
    char  fileSystemName[MAXLEN];

    if( (root->type==TYPE_STRING) && (LEN(root)>0) )
    {
        number(1);
        _clp_left(2);
        string(":\\");
        add();
        rootName=STRPTR(root,NULL);
    }
    
    int success=GetVolumeInformation
            (
                rootName,
                volumeName,
                MAXLEN,
                &volumeSerialNumber,
                &maxNameLength,
                &fileSystemFlags,
                fileSystemName,
                MAXLEN
            );
            
            
    if( success )        
    {
        stringn(volumeName);
        number(volumeSerialNumber);
        number(maxNameLength);
        number(fileSystemFlags);
        stringn(fileSystemName);
        array(5);
        pop_call();
        RETURN(base);
    }
    
    pop_call();
    stack=base;
    push(&NIL);
}

//------------------------------------------------------------------------
void _clp_getdrivetype(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
push_call("getdrivetype",base);
//
    VALUE *root=base;
    
    char  *rootName=NULL;

    if( (root->type==TYPE_STRING) && (LEN(root)>0) )
    {
        number(1);
        _clp_left(2);
        string(":\\");
        add();
        rootName=STRPTR(root,NULL);
    }

    number(GetDriveType(rootName));
    pop_call();
    RETURN(base);
}

//------------------------------------------------------------------------
void _clp_getdiskfreespace(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,1);
while(stack<base+1)PUSHNIL();
push_call("getdiskfreespace",base);
//
    VALUE *root=base;

    char  *rootName=NULL;
    DWORD sectorsPerCluster=0;
    DWORD bytesPerSector=0;
    DWORD freeClusters=0;
    DWORD totalClusters=0;
    
    if( (root->type==TYPE_STRING) && (STRINGLEN(root)>0) )
    {
        number(1);
        _clp_left(2);
        string(":\\");
        add();
        rootName=STRINGPTR(root);
    }
    
    int success=GetDiskFreeSpace
            (
                rootName,
                &sectorsPerCluster,
                &bytesPerSector,
                &freeClusters,
                &totalClusters
            );

    if( success )        
    {
        number(sectorsPerCluster);
        number(bytesPerSector);
        number(freeClusters);
        number(totalClusters);
        array(4);
        pop_call();
        RETURN(base);
    }
    
    pop_call();
    stack=base;
    push(&NIL);
}

//------------------------------------------------------------------------
void _clp_getlogicaldrives(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,0);
while(stack<base+0)PUSHNIL();
push_call("getlogicaldrives",base);
//
    int x,cnt=0;
    DWORD drives=GetLogicalDrives();
    
    for(x=0; x<26; x++)
    {
        if( drives&1 )
        {
            cnt++;
            number( 'A'+x );
            _clp_chr(1);
            string(":\\");
            add();
        }
        drives=drives>>1;
    }
    
    if( cnt>0 )
    {
        array(cnt);
    }
    else
    {
        array0(0);
    }
    
    pop_call();
    RETURN(base);
}


//------------------------------------------------------------------------
