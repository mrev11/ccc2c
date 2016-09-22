
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

// A main k�telez�en a global namespace-ben van.
// Mivel a namespace csak egyszer, �s csak a prg modul els�
// utas�t�sak�nt fordulhat el�, az�rt a main-t tartalmaz� modul
// mindig a global n�vt�rben van.

// Az opcion�lis namespace utas�t�s ut�n j�hetnek a using-ok.
// Egy using utas�t�s mindig egyetlen Clipper sorban van, ha ez 
// t�l hossz� volna, akkor haszn�lhat� a ';' folytat�sor.

using proba=p;
    hopp hopp1
    
using szerencse=s
    
// A using sz�t k�vet� els� szimb�lum a k�ls� n�vt�r neve.
// Az ezut�n felsorolt f�ggv�nyneveket nem kell min�s�teni,
// mert a ford�t� automatikusan min�s�t. 


function main()
    hopp()                  //automatikusan min�s�t: proba.hopp
    hopp1()                 //automatikusan min�s�t: proba.hopp1
    proba.hopp2()           //explicit min�s�t�s (n�vt�r megad�s)
    s.print()               //explicit n�vt�r megad�s alias haszn�lattal
    proba.xx.yy.hopp()      //explicit min�s�t�s (n�vt�r megad�s)
    ? errorNew():subcode    //objektumok m�k�dnek
    ?
    return NIL
    
