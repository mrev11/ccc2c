
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

function main()
    x1.x2.x3.x4.x5.fun()        //teljesen min�s�tett
    x2.x3.fun()                 //teljesen min�s�tett
    //x3.fun()                  //nincs ilyen
    return NIL

function x1.fun()
    ? "x1.fun()"

function x1.x2.fun()
    ? "x1.x2.fun()"

function x1.x2.x3.fun()
    ? "x1.x2.x3.fun()"

function x1.x2.x3.x4.fun()
    ? "x1.x2.x3.x4.fun()"


function x1.x2.x3.x4.x5.fun()

    x1.fun()                    //teljesen min�s�tett
    x1.x2.fun()                 //teljesen min�s�tett
    x1.x2.x3.fun()              //teljesen min�s�tett
    x1.x2.x3.x4.fun()           //teljesen min�s�tett
    //x1.x2.x3.x4.x5.fun()      //v�gtelen rekurzi� volna

    //fun()                     //v�gtelen rekurzi� volna (mint az el�z�)
    .fun()                      //teljesen min�s�tett
    x2.fun()                    //a C ford�t� x1.x2.fun-t tal�lja meg
    x2.x3.fun()                 //a C ford�t� x1.x2.x3.fun-t tal�lja meg
    .x2.x3.fun()                //teljesen min�s�tett
    x2.x3.x4.fun()              //a C ford�t� x1.x2.x3.x4.fun-t tal�lja meg

    x3.fun()                    //a C ford�t� x1.x2.x3.fun-t tal�lja meg
    x3.x4.fun()                 //a C ford�t� x1.x2.x3.x4.fun-t tal�lja meg

    return NIL


function fun()
    ? "GLOBAL.fun()"

function x2.x3.fun()
    ? "GLOBAL.x2.x3.fun()"


