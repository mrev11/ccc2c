
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

function meth()

local o,a,b,c,d

    o:loop                          //a régi is tudja
    a:method
    a:method()
    a:method:=b
    a:method(b)
    a:method():=b
    a:method(b,c)
    a:method(b):=c

    a:(clsname)method
    a:(clsname)method()
    a:(clsname)method:=b
    a:(clsname)method(b)
    a:(clsname)method():=b
    a:(clsname)method(b,c)
    a:(clsname)method(b):=c
    //a:(clsname)step(b):=c         //a régi ezt nem tudja a kulcsszó miatt

    a:(parent@clsname)method
    a:(parent@clsname)method()
    a:(parent@clsname)method:=b
    a:(parent@clsname)method(b)
    a:(parent@clsname)method():=b
    a:(parent@clsname)method(b,c)
    a:(parent@clsname)method(b):=c
    //a:(parent@clsname)exit(b):=c  //a régi ezt nem tudja

    a:(super@clsname)method
    a:(super@clsname)method()
    a:(super@clsname)method:=b
    a:(super@clsname)method(b)
    a:(super@clsname)method():=b
    a:(super@clsname)method(b,c)
    a:(super@clsname)method(b):=c
    //a:(super@clsname)loop(b):=c   //a régi ezt nem tudja


    o:metnam
    o:metnam+=1
    o:metnam-=1
    o:metnam*=1
    o:metnam/=1
    o:metnam--
    o:metnam++
    --o:metnam
    ++o:metnam
    

    //az alábbiakat a régi fordító nem tudja
    //nehéz nekik valódi értelmet tulajdonítani
    //az új fordító is kizárja azokat az eseteket,
    //amikor a metódushívásnak paraméterlistája van

    //o:metnam()+=1
    //o:metnam(1,2,3)+=1

    //o:(clsname)metnam+=1
    //o:(parent@clsname)metnam+=1
    //o:(super@clsname)metnam+=1

    //o:metnam(x,y,z)
    //o:metnam(x,y,z)+=1
    //o:(clsname)metnam(x,y,z)+=1
    //o:(parent@clsname)metnam(x,y,z)+=1
    //o:(super@clsname)metnam(x,y,z)+=1


    return NIL


