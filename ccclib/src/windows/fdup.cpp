
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

// fdup Windowsra
// Vermes M., 2003. szeptember
//
// fdup(oldfd)            k�z�ns�ges (libc) dup
// fdup(oldfd,newfd)      k�z�ns�ges (libc) dup2
// fdup(oldfd,inherit)    dup, �r�kl�d�s be�ll�tva
//
// Megjegyz�sek:
//
// 1) _get_osfhandle() �s _open_osfhandle() ANSI C f�ggv�nyek,
//    benne vannak az MSVC, Borland, MinGW k�nyvt�rakban.
//
// 2) A C k�nyvt�rbeli dup-ot hasonl�an lehetne implement�lni
//    _get_osfhandle, DuplicateHandle, _open_osfhandle-val,
//    azonban a k�nyvt�r visszafejt�se azt mutatja, 
//    hogy a k�nyvt�rbeli dup alcsonyabb szint�. 
//    Nem ismert, hogy ennek van-e oka, �s van-e k�l�nbs�g.
//    
// 3) Hib�s ez a logika:
//
//      int oldfd=_parni(1);
//      int newfd=_parni(2);
//      int inherit=_parl(3);
//
//      long oldhandle=_get_osfhandle(oldfd);
//      long newhandle;
//
//      DuplicateHandle( GetCurrentProcess(), 
//                       (HANDLE)oldhandle, 
//                       GetCurrentProcess(), 
//                       (HANDLE*)&newhandle, 
//                       0, 
//                       inherit,
//                       DUPLICATE_SAME_ACCESS );
//
//      int tmpfd=_open_osfhandle(newhandle,0);
//      _retni( dup2(tmpfd,newfd) );  //ROSSZ
//      close(tmpfd);
//
//    ui. az utols� dup2 mindig �r�k�lhet�v� teszi newfd-t.
//
// 4) Windowson is, Linuxon is a libc-beli dup/dup2 MINDIG 
//    �r�k�lhet� fil� descriptort gy�rt (programmal kipr�b�lva). 
//    Ugyanez�rt setcloexecflag() tov�bbra sem implement�lhat� 
//    Windowson. (Ki lehetne er�lk�dni �gy, hogy elfogyasztunk
//    minden newfd-n�l kisebb descriptort.) 
//
// 5) Az stdin �r�kl�d�s�t �gy lehet letiltani fdup-pal: 
//
//    tmp=fdup(0); fclose(0); fdup(tmp,.f.); fclose(tmp)
//
//    Ez azon alapszik, hogy fdup mindig az els� szabad helyre
//    teszi az �j descriptort.


#include <io.h>
#include <fcntl.h>
#include <stdio.h>
#include <cccapi.h>


//--------------------------------------------------------------------------
void _clp_fdup(int argno) 
{

    //fdup(fd)          : k�z�ns�ges dup
    //fdup(fd1,.f.)     : dup, az �j fd nem �r�kl�dik
    //fdup(fd1,.f.,.t)  : dup, az �j fd nem �r�kl�dik, a r�gi lez�r�dik
    //fdup(fd1,fd2)     : k�z�ns�ges dup2
    //fdup(fd1,fd2,.t.) : dup2, a r�gi fd lez�r�dik 
    
    // A CCC mindenhol bin�ris m�dban olvassa a fil�ket,
    // ezzel szemben a borlandos dup �tv�lt text m�dba.
    // Ezt megel�zend� bin�risra �ll�tjuk a defaultot
    // (_fmode mindh�rom t�mogatott ford�t�ban l�tezik).

    _fmode=O_BINARY;
 

    CCC_PROLOG("fdup",3);

    int oldfd=_parni(1);
    int closeflag=ISNIL(3)?0:_parl(3);
    
    if( ISNIL(2) )  //k�z�ns�ges dup 
    {
        _retni( dup(oldfd) );
    }

    else if( ISNUMBER(2) ) //k�z�ns�ges dup2 
    {

        int newfd=_parni(2);
        _retni( dup2(oldfd,newfd) );
    }

    else //dup + �r�kl�d�s 
    {
        int inheritflag=_parl(2);
        long oldhandle=_get_osfhandle(oldfd);
        long newhandle;

        DuplicateHandle( GetCurrentProcess(), 
                         (HANDLE)oldhandle, 
                         GetCurrentProcess(), 
                         (HANDLE*)&newhandle, 
                         0, 
                         inheritflag,
                         DUPLICATE_SAME_ACCESS );

        _retni( _open_osfhandle(newhandle,0) );
    }
    
    if( closeflag )
    {
        close(oldfd);
    }
    
 
    CCC_EPILOG();
}


//--------------------------------------------------------------------------
void _clp_hdup(int argno) 
{
    CCC_PROLOG("hdup",3);
    
    int oldhandle   = _parni(1);
    int inheritflag = ISNIL(2)?1:_parl(2);
    int closeflag   = ISNIL(3)?0:_parl(3);
 
    int newhandle;

    DuplicateHandle( GetCurrentProcess(), 
                     (HANDLE)oldhandle, 
                     GetCurrentProcess(), 
                     (HANDLE*)&newhandle, 
                     0, 
                     inheritflag,
                     DUPLICATE_SAME_ACCESS );
                     
    if( closeflag )
    {
        CloseHandle( (HANDLE)oldhandle );
    }

    _retni( newhandle );
 
    CCC_EPILOG();
}

 
//--------------------------------------------------------------------------
