
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

//TARTALOM  : "DBM Format 1.0" mem�fil�k kezel�se
//STATUS    : k�z�s utility
//
//function memoCreate(fname,blksiz)        //mem�fil� l�trehoz�sa
//function memoOpen(fname)                 //mem� megnyit�sa
//function memoClose(hnd)                  //mem� lez�r�sa
//function memoBlockSize(size)             //default blokkm�ret be�ll�t�sa
//function memoGetBlockSize(hnd)           //aktu�lis blokkm�ret lek�rdez�se
//function memoGetDataSize(hnd)            //adatok m�rete egy blokkban
//function memoGetHeaderSize()             //header m�rete
//function memoGetFormat()                 //format string
//function memoAddValue(hnd,value)         //�rt�k be�r�sa a mem�ba
//function memoGetValue(hnd,offset)        //�rt�k kiolvas�sa
//function memoDeleteValue(hnd,offset)     //�rt�k t�rl�se


#include "fileio.ch"
#include "error.ch"

// probl�m�k:
//
// byte-sorrend �rz�keny a form�tum
// little endian lesz a platformf�ggetlen form�tum
// �t k�ne t�rni az xvalloc/xvread/xvwrite API-ra
// Clipperben marad a mostani program


/*
memoError(1,"memoCreate","writeerror")
memoError(2,"memoAddValue","writeerror")
memoError(3,"memoGetValue","invalidmemooffset")
memoError(4,"memoGetValue","invalidmemochain")
memoError(5,"memoGetValue","invaliddatasizeinmemoblock")
memoError(6,"memoGetValue","invalidendofmemolist")
memoError(7,"memoGetValue","invalidmemofileformat/readerror")
memoError(8,"memoDeleteValue","readerror")
memoError(9,"memoDeleteValue","readerror")
memoError(10,"memoDeleteValue","invalidmemooffset")
memoError(11,"memoDeleteValue","writeerror")
memoError(12,"memoDeleteValue","writeerror")
memoError(13,"memoDeleteValue","writeerror")
memoError(14,"getfreeblocks","readerror")
memoError(15,"getfreeblocks","readerror")
memoError(16,"getfreeblocks","writeerror")
memoError(17,"getfreeblocks","writeerror")
memoError(18,"memoOpen","read error")
memoError(19,"memoOpen","read error")
memoError(20,"memoOpen","unknown format")
memoError(21,"memoOpen","read error")
*/


***************************************************************************    
static blocksize:={}                             //dbm fil�nk�nt k�l�n blocksize
static formatstr:="DBM Format 1.0"               //form�tum azonos�t� string

#define MEMO_BLKSIZ   blocksize[hnd+1]           //blokkm�ret
#define MEMO_HDRSIZ   10                         //header m�ret
#define MEMO_DATSIZ   (MEMO_BLKSIZ-MEMO_HDRSIZ)  //adatter�let

#ifdef _DBFNTX_
#define sleep(x) inkey(x/1000)
#endif


***************************************************************************    
//blokk: nnnnllllbb ... adatok ...
//       12345678901
//
// nnnn : a next blokk offsete, az utols� blokkban 0
// llll : az els� blokkban az utols� blokk offsete, egy�bk�nt 0
// bb   : az adott blokkban t�rolt byteok sz�ma (0 is lehet)

static function ndatabyte(buf)
    //return bin2w(substr(buf,9,2))
    return xvgetlit16(buf,8)
 
static function getdata(buf,ndat)
    return substr(buf,11,ndat)

static function getnextoffs(buf)
    //return bin2l(substr(buf,1,4))
    return xvgetlit32(buf,0)
 
static function getlastoffs(buf)
    //return bin2l(substr(buf,5,4))
    return xvgetlit32(buf,4)
    
static function compileheader(noffs,loffs,ndat)    
local hdr:=space(MEMO_HDRSIZ)
    //return l2bin(noffs)+l2bin(loffs)+i2bin(ndat)
    xvputlit32(hdr,0,noffs)
    xvputlit32(hdr,4,loffs)
    xvputlit16(hdr,8,ndat)
    return hdr
 

***************************************************************************    
static function memoError(code,oper,desc)

local err

    err:=memoerrorNew()
    //err:cargo:=
    //err:filename:=
    err:severity:=ES_ERROR
    err:subsystem:="MEMO"
    err:subcode:=code
    //err:canretry:=.f.
    //err:candefault:=.f.
    err:operation:=oper
    err:description:=desc
    break(err)
    return NIL



***************************************************************************    
function memoCreate(fname,blksiz)

local hnd:=fcreate(fname)
local header, nb

    if( hnd>=0 )

        if( blksiz==NIL )
            blksiz:=memoBlockSize()
        end
        blksiz:=max(64,blksiz)

        header:=replicate(chr(0),16)
        header+=padr(formatstr,16,chr(0))
        header+=padr(str(blksiz,8),16,chr(0))
        header:=padr(header,blksiz,chr(0))
    
        nb:=fwrite(hnd,header,blksiz)
        if( nb!=blksiz )
            memoError(1,"memoCreate","write error")
        end
        
        fclose(hnd)
        return .t.
    end
    return .f.


***************************************************************************    
function memoOpen(fname)

local hnd:=fopen(fname,FO_READWRITE+FO_SHARED) 
local buffer:=space(16), nb

    if( hnd>=0 )
        #ifdef _UNIX_
            setcloexecflag(hnd,.t.)
        #else
            hnd:=fdup(hnd,.f.,.t.) //nem �r�kl�dik 
        #endif
    
        if( len(blocksize)<hnd+1 )
            asize(blocksize,hnd+1)
        end

        nb:=fread(hnd,@buffer,16)
        if( nb!=16 )
            memoError(18,"memoOpen","read error")
        end

        nb:=fread(hnd,@buffer,16)
        if( nb!=16 )
            memoError(19,"memoOpen","read error")
        end

        if( buffer!=formatstr )
            memoError(20,"memoOpen","unknown format")
        end
        
        nb:=fread(hnd,@buffer,16)
        if( nb!=16 )
            memoError(21,"memoOpen","read error")
        end
        
        MEMO_BLKSIZ:=val(buffer)
        //alert(str(MEMO_BLKSIZ))
    end
    return hnd
    

***************************************************************************    
function memoClose(hnd)
    return fclose(hnd)


***************************************************************************    
function memoBlockSize(size)  

static blksiz:=256
local prev:=blksiz

    if( size!=NIL )
        blksiz:=max(64,size)
    end
    return prev


***************************************************************************    
function memoGetBlockSize(hnd) 
    return MEMO_BLKSIZ


***************************************************************************    
function memoGetDataSize(hnd)  
    return MEMO_DATSIZ


***************************************************************************    
function memoGetHeaderSize()  
    return MEMO_HDRSIZ


***************************************************************************    
function memoGetFormat()
    return formatstr


***************************************************************************    
function memoAddValue(hnd,value)

local lvalue:=len(value)
local rest:=lvalue%MEMO_DATSIZ
local nblock:=(lvalue-rest)/MEMO_DATSIZ+if(rest==0,0,1) //ennyi block kell
local header, block, nextofs, lastofs
local written:=0, towrite, nb
local offset, n
 
    //? nblock, offset
    
    set signal disable
    
    offset:=getfreeblocks(hnd,nblock) 

    for n:=1 to nblock
        towrite:=min(MEMO_DATSIZ,lvalue-written)
        nextofs:=if(n<nblock,offset[n+1],0)
        lastofs:=if(n==1,atail(offset),0)
        header:=compileheader(nextofs,lastofs,towrite)
        block:=padr(header+substr(value,written+1,towrite),MEMO_BLKSIZ)

        fseek(hnd,offset[n],FS_SET)
        nb:=fwrite(hnd,block)
        if( nb!=MEMO_BLKSIZ )
            memoError(2,"memoAddValue","write error")
        end

        written+=towrite
    next

    set signal enable
 
    return offset[1]


***************************************************************************    
function memoGetValue(hnd,offset)

local value:=""
local buffer:=space(MEMO_BLKSIZ)
local nbrd,ndat,nofs,lofs
local blknum:=0

    fseek(hnd,offset,FS_SET)

    while( (nbrd:=fread(hnd,@buffer,MEMO_BLKSIZ))==MEMO_BLKSIZ )
    
        nofs:=getnextoffs(buffer) //next blokk offset
        ndat:=ndatabyte(buffer) //adatbyteok sz�ma a blokkban

        //a l�ncok els� elem�ben a lastoffs mez�
        //k�telez�en ki kell legyen t�ltve, a t�bbi
        //elemben k�telez�en nulla, ezt ellen�rz�m,
        //hogy megel�zzem a nem el�lr�l t�rt�n�
        //olvas�st �s t�rl�st, vagy a t�ves kapcsol�d�st
        
        if( blknum++==0 )
            lofs:=getlastoffs(buffer) //last block offset

            if( lofs==0 )

                //runtime error
                //val�sz�n�leg nem az els� elem�t�l
                //akarja olvasni a list�t
                memoError(3,"memoGetValue","invalid memo offset")
            end
        else

            if( getlastoffs(buffer)!=0 )

                //runtime error
                //nem az els� listaelem,
                //m�gis ki van t�ltve a lastoffs mez�
                //tal�n belet�vedt�nk egy m�sik list�ba,
                //vagy hurkot tal�ltunk

                memoError(4,"memoGetValue","invalid memo chain")
            end
        end
        
        
        if( ndat<0 .or. MEMO_DATSIZ<ndat )
            //runtime error
            memoError(5,"memoGetValue","invalid data size in memo block")

        elseif( nofs==0 ) //utols� blokk
            value+=getdata(buffer,ndat)

            if( offset!=lofs )
                //runtime error
                //a lista nem ott v�gz�dik, 
                //ahol az els� elem�ben tal�lt lastoffs
                //mez� szerint kellene
                memoError(6,"memoGetValue","invalid end of memo list")
            end

            return value

        else
            value+=getdata(buffer,ndat)
            fseek(hnd,offset:=nofs,FS_SET)
        end
    end

    //runtime error
    memoError(7,"memoGetValue","invalid memo file format/read error")

    return NIL


***************************************************************************    
function memoDeleteValue(hnd,offset)

//az offset kezdet� list�t
//be kell tenni a szabad lista elej�re

local header:=space(MEMO_HDRSIZ)
local buffer:=space(MEMO_HDRSIZ)
local lastoffs,nextoffs
local nb

    //a memo fil�t lockoljuk
    while( 0!=fsetlock(hnd,0,MEMO_BLKSIZ) )
        sleep(200)
    end

    fseek(hnd,0,FS_SET)
    nb:=fread(hnd,@header,MEMO_HDRSIZ)
    if( nb!=MEMO_HDRSIZ )
        memoError(8,"memoDeleteValue","read error")
    end

    fseek(hnd,offset,FS_SET)
    nb:=fread(hnd,@buffer,MEMO_HDRSIZ)
    if( nb!=MEMO_HDRSIZ )
        memoError(9,"memoDeleteValue","read error")
    end
    
    //itt ellen�rz�s c�lj�b�l
    //v�gig lehetne menni a list�n
    
    lastoffs:=getlastoffs(buffer)
    if( lastoffs==0 )
        //runtime error
        //val�sz�n�leg nem az els� elem�t�l
        //akarja t�r�lni a list�t
        memoError(10,"memoDeleteValue","invalid memo offset")
    end
    
    set signal disable

    if( lastoffs!=offset )
        nextoffs:=getnextoffs(buffer)
        buffer:=compileheader(nextoffs,0,0)

        fseek(hnd,offset,FS_SET)
        nb:=fwrite(hnd,buffer,MEMO_HDRSIZ)
        if( nb!=MEMO_HDRSIZ )
            memoError(11,"memoDeleteValue","write error")
        end
    end
    
    fseek(hnd,lastoffs,FS_SET)
    nb:=fwrite(hnd,header,MEMO_HDRSIZ)
    if( nb!=MEMO_HDRSIZ )
        memoError(12,"memoDeleteValue","write error")
    end
    
    header:=compileheader(offset,0,0)

    fseek(hnd,0,FS_SET)
    nb:=fwrite(hnd,header,MEMO_HDRSIZ)
    if( nb!=MEMO_HDRSIZ )
        memoError(13,"memoDeleteValue","write error")
    end

    set signal enable
 
    //a memo fil� lockj�t elengedj�k
    funlock(hnd,0,MEMO_BLKSIZ)

    return NIL


***************************************************************************    
static function getfreeblocks(hnd,nblock)

local blocks:={}
local buffer:=space(MEMO_HDRSIZ)
local noffs:=0
local nb

    //a memo fil�t lockoljuk
    while( 0!=fsetlock(hnd,0,MEMO_BLKSIZ) )
        sleep(200)
    end

    //a szabad lista elej�r�l vesz�nk blokkokat

    while( len(blocks)<nblock )

        fseek(hnd,noffs,FS_SET)
        nb:=fread(hnd,@buffer,MEMO_HDRSIZ)
        if( nb!=MEMO_HDRSIZ )
            memoError(14,"getfreeblocks","read error")
        end

        noffs:=getnextoffs(buffer)
        
        if( noffs==0 )
            exit
        else
            aadd(blocks,noffs)
        end
    end

    //a szabad lista elej�t �t�ll�tjuk
    
    if( noffs!=0 )

        fseek(hnd,noffs,FS_SET)
        nb:=fread(hnd,@buffer,MEMO_HDRSIZ)
        if( nb!=MEMO_HDRSIZ )
            memoError(15,"getfreeblocks","read error")
        end

        noffs:=getnextoffs(buffer)
    end
    
    fseek(hnd,0,FS_SET)
    buffer:=compileheader(noffs,0,0)
    nb:=fwrite(hnd,buffer,MEMO_HDRSIZ)
    if( nb!=MEMO_HDRSIZ )
        memoError(16,"getfreeblocks","write error")
    end


    //a tov�bbi sz�ks�ges blokkokat l�trehozzuk
    
    while( len(blocks)<nblock )
        noffs:=fseek(hnd,0,FS_END)
        nb:=fwrite(hnd,replicate(chr(0),MEMO_BLKSIZ),MEMO_BLKSIZ)
        if( nb!=MEMO_BLKSIZ )
            memoError(17,"getfreeblocks","write error")
        end
        aadd(blocks,noffs)
    end

    //a memo fil� lockj�t elengedj�k
    funlock(hnd,0,MEMO_BLKSIZ)
    
    return blocks


***************************************************************************    
