
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

function main(a,*)
    ? a,{*}  //az elsõ paraméter + az összes egy arrayben.
    test(*)  //átadja az összes paramétert (a-t is).
    ?

function test(*)
    //varstack()

    test1(*)    // sok paraméter
    test1("X")  // kevés paraméter
    test2(*)    // sok paraméter
    test2("X")  // kevés paraméter
    test3(*)    // sok paraméter
    test3("X")  // kevés paraméter
    ?
    test4(*)
    ?
    test4("X")  // kevés paraméter
    ?
    test5(*)
    ?
    test5("X")  // kevés paraméter
    ?
    test6(*)  
    test6("X")  // kevés paraméter
    ?

******************************************************************************
function test1(a,b,c)
local x:="test1"
    ? x, len({*}),  '<mindig 3'

function test2(*)
local x:="test2"
    ? x, len({*}),  '<amennyit ténylegesen megadtak'

function test3(a,b,*)
local x:="test3"
    ? x, len({*}),  '<amennyit ténylegesen megadtak, de legalább 2'


******************************************************************************
function test4(a,b,*) //helyettesítések

local x:="test4"
local o:=xxNew()
local e

    ? x,a,b, '<név szerint is ismert paraméterek'

    begin
        ? {*}[1], '<egy elem elõvétele'
        ? {*}[10], '<túlnyúlt, ez nem íródik ki'
    recover e
        ? e, '<elszáll, ha túlnyúl'
    end

    ? {x,*,,*}, '<helyettesítés arrayben'
    ? getargs("1",*,"2",*), '<helyettesítés függvényhívásban'
    ? o:initialize(*), '<helyettesítés metódushívásban'


******************************************************************************
function test5(x,y,*) //helyettesítések blokkban
local o
local a
local blk1:={|p1,p2,p3,p4|a:={*,*}} //itt * p1,p2,p3,p4-et jelenti
local blk2:={|p1,p2,p3,p4|getargs(*,,*)} //itt * p1,p2,p3,p4-et jelenti
local blk3:={|p1,p2,p3,p4|o:=xxNew(*)} //itt * p1,p2,p3,p4-et jelenti
local blk4:={|p1,p2,p3,p4|o:=xxNew(),o:initialize(*)} //itt * p1,p2,p3,p4-et jelenti

    ? eval(blk1,"test5/1",*), "<blokkargumentumok helyettesítve arraybe"
    ? eval(blk2,"test5/2",*), "<blokkargumentumok helyettesítve függvényhívásba"
    ? eval(blk3,"test5/3",*), "<blokkargumentumok helyettesítve függvényhívásba"
    ? eval(blk4,"test5/4",*), "<blokkargumentumok helyettesítve metódushívásba"
    
    //varstack()

******************************************************************************
function test6(*)
local x:="test6"
    ? getargs(x,getargs(*),*), '<csillagok eltérõ szinten'
    ? {x,{*},*}, '<csillagok eltérõ szinten'

******************************************************************************
function getargs(*)
    return {*}

******************************************************************************
class xx(object)
    attrib a1
    attrib a2
    attrib a3
    attrib a4
    method initialize

static function xx.initialize(this,a1,a2,a3,a4)
    this:a1:=a1
    this:a2:=a2
    this:a3:=a3
    this:a4:=a4
    return this

******************************************************************************
