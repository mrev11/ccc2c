
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

namespace proba hopp1  

// A modul "proba" n�vt�rhez tartozik. 
// A namespace utas�t�s legfeljebb egyszer,
// a modul els� utas�t�sak�nt fordulhat el�.

// A n�vt�r neve ut�n felsorolt f�ggv�nyeket is
// az aktu�lis n�vt�rbem fogja keresni. Ha hopp1
// nem volna felsorolva, akkor csak �gy lehetne r�
// hivatkozni: proba.hopp1

// A f�ggv�nyeket, amik ugyanabban a prg modulban
// (teh�t ugyanabban a n�vt�rben) vannak defini�lva 
// mag�t�l megtal�lja.

function hopp()
    xx.yy.hopp()            //megtal�lja, mert azonos modulban van
    proba.xx.yy.hopp()      //megtal�lja, mert teljesen min�s�tve van
    ? "proba.hopp"
    hopp1()                 //megtal�lja a namespace lista alapj�n
    return NIL


function xx.yy.hopp()
    ? "proba.xx.yy.hopp"    //teljes n�v
    return NIL


