
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

// K�s�rleti program. Azt demonstr�lja, hogyan lehet(ne) fdup-pal 
// szab�lyozni az �r�kl�d�st, �s ez�ltal korrekten kommunik�lni egy 
// child processzel (UNIX-on �s Windowson egyform�n, fork n�lk�l).


*****************************************************************************
function main()
 
local p1:=pipe() // p1[1] <---< p1[2]
local p2:=pipe() // p2[2] >---> p2[1]

local fd0,fd1
local pr,pw
local tr,tw 

    pr:=fdup(p1[1],.f.); fclose(p1[1]) //parent oldali v�g (nem �r�kl�dik)
    pw:=fdup(p2[2],.f.); fclose(p2[2]) //parent oldali v�g (nem �r�kl�dik)
    //setcloexecflag(pw:=p2[2],.t.)
    //UNIX-on mindk�t v�ltozat j�, Windowson csak az fdup-os
 
    fd0:=fdup(0,.f.); fdup(p2[1],0); fclose(p2[1]) //stdin: ment, �tir�ny�t
    fd1:=fdup(1,.f.); fdup(p1[2],1); fclose(p1[2]) //stdout: ment, �tir�ny�t 

#ifdef SPAWN 
    //biztons�gos, de csak Windowson van
    spawn(.f.,"child.exe") 
#else
    //men biztons�gos, mert a child lassan indul
    thread_create({||run("child.exe")}) 
    sleep(100) //hogyan kellene megv�rni child t�nyleges elindul�s�t?
#endif    

    fdup(fd0,0); fclose(fd0) //stdin: vissza�ll�t
    fdup(fd1,1); fclose(fd1) //stdout: vissza�ll�t 
    
    tr:=thread_create({||read(pr)}) //ez el�bb lefuthat, mint child elindul
    tw:=thread_create({||write(pw)})
 
    thread_join(tw); fclose(pw)
    thread_join(tr); fclose(pr)
    

    // Azt hiszem, ez "korrekt", abban az �rtelemben, 
    // hogy minden fil� a megfelel� helyen le van z�rva.
    // A lez�r�s elmulaszt�sa m�k�d�sk�ptelens�get okoz:
    //
    // Ha pw-t nem z�rjuk le, akkor child �r�kre blokkol�dik fread-ben,
    // mi�ltal a read-thread �ltal olvasott pipe �rhat� v�ge sem z�r�dik le,
    // ez�rt a read-thread is blokkol�dik a fread-ben.
    //
    // Ha pw �r�kl�d�s�t nem tiltjuk le, akkor azt child �r�kli,
    // �s ott nyitva marad, ez�rt az olvas�sok megint blokkol�dnak.
    
    return NIL


*****************************************************************************
static function write( fd ) //�runk child stdin-j�be

local x:=memoread("child.prg"), n

    ? "write-1"
 
    for n:=1 to len(x)
        fwrite(fd,substr(x,n,1))
        sleep(10)
    next

    ? "write-2"
    return NIL


*****************************************************************************
static function read( fd ) //echo-zzuk (+upper) child stdout-j�t 
 
local bs:=32,nb
local buf:=space(bs)

    ? "read-1"
 
    while( 0<(nb:=fread(fd,@buf,bs)) )
        ?? upper(left(buf,nb))
    end
 
    ? "read-2"
    return NIL


*****************************************************************************
 