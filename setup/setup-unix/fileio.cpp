
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

#ifdef _UNIX_

#include <sys/stat.h>
#include <unistd.h>
#include <ctype.h>
#include <string.h>

#else  //Windows

#include <io.h>
#include <sys\stat.h>
#include <sys\locking.h>
#include <share.h>

#endif

#include <string.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>

#include <fileio.ch>  //Clipper
#include <cccapi.h>

//----------------------------------------------------------------------------
void _clp_fclose(int argno) //Clipper
{
    CCC_PROLOG("fclose",1);
    int fd=_parni(1);
    if( fd<0 )
    {
       errno=EBADF;
       _retl(0);
    }
    else
    {
        errno=0;
        _retl( 0==close(fd) );
    }
    CCC_EPILOG();
}

//----------------------------------------------------------------------------
void _clp_fwrite(int argno) //Clipper
{
    CCC_PROLOG("fwrite",3);
    int fd=_parni(1);
    char *buf=_parc(2);
    binarysize_t cnt=_parclen(2);
    if( ISNUMBER(3) )
    {
        double dcnt=_parnd(3);
        cnt=min(cnt, D2ULONGX(dcnt) );
    }
    errno=0;
    _retni( write(fd,buf,cnt) );
    CCC_EPILOG();
}

//----------------------------------------------------------------------------
void _clp_fread(int argno) //Clipper
{
    CCC_PROLOG("fread",3);

    int fd=_parni(1);
    char *buf=REFSTRPTR(2);
    unsigned long buflen=REFSTRLEN(2);
    unsigned long cnt=_parnu(3);

    if( buflen<cnt )
    {
        error_siz("fread",base,3);
    }

    //bufból másolatot csinálumk
    char *buf1=stringl(buflen);
    memmove(buf1,buf,buflen);
    (base+1)->data.vref->value=*TOP();

    errno=0;
    _retni( read(fd,buf1,cnt) );
    CCC_EPILOG();
}

//----------------------------------------------------------------------------
#ifdef NEM_CLIPPER_KOMPATIBILIS

//Ez a korábbi, hibás változat,
//ami közvetlenül beleír a bufferbe,
//ezzel elronthatja más változók értékét.

void _clp_fread(int argno) //Clipper
{
    CCC_PROLOG("fread",3);
    int fd=_parni(1);
    char *buf=REFSTRPTR(2);
    unsigned cnt=_parnu(3);
    if( REFSTRLEN(2)<cnt )
    {
        error_siz("fread",base,3);
    }
    errno=0;
    _retni( read(fd,buf,cnt) );
    CCC_EPILOG();
}

#endif
 
//----------------------------------------------------------------------------
void _clp_ferror(int argno) //Clipper (bõvítve errno beállításával)
{
    if( argno>0 )
    {
        VALUE *base=stack-argno;
        if( base->type==TYPE_NUMBER )
        {
            errno=D2INT(base->data.number);
        }
    }
    stack-=argno;
    number(errno);
}    
 
//----------------------------------------------------------------------------
