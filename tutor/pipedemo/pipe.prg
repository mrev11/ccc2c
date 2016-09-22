
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

*****************************************************************************
function main()
local p:=pipe() //p[1] olvashat�, p[2] �rhat�
local th:=thread_create({||olvas(p[1])})   
    //sleep(1000)
    fwrite(p[2],memoread("pipe.prg"))
    //sleep(1000)
    fclose(p[2])
    thread_join(th)
    ?
    return NIL


*****************************************************************************
static function olvas(fd)    

local bs:=32, nb
local buf:=space(bs)

    while( 0<(nb:=fread(fd,@buf,bs)) )
        //blokkolva olvas
        //0-val t�r vissza, ha a pipe m�sik v�g�t lez�rt�k
        //UNIX-on select-tel vizsg�lhat�, hogy van-e olvasnival�
    
        //? "<"+alltrim(str(nb))+">"
        ?? left(buf,nb)
        sleep(100)
    end

    return NIL

*****************************************************************************
    