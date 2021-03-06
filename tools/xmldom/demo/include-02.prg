
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

static remark:=<<REMARK>>
  <include file="fspec"/> alakú include, az eredmény dom-ot egybeépíti

  ha rootflag==.t. (compatibility-default, ellentmond a szabványnak)
    akkor az inkludált rétegek közé egy #ROOT héj kerül
    az xmlout kimenetében nem látszanak a #ROOT node-ok

  ha rootflag==.f. (szabványos, de külön be kell állítani)
    akkor a végeredményen nem látszik, hogy több fájlból jött össze
  
  az inkludált fájlok különböző kódolásúak
    x.xml UTF-8
    y.xml ISO-859-2
    z.xml UTF-8
    belső kódolás Unicode (bemenettől függetlenül)
    xmlout eredménye UTF-8 (bemenettől függetlenül)

  Működés:
    a contentblock helyettesíti az include node-ot  
    az include fájl elemzésből kapott node-dal
      
  Megjegyzés:
    a parser:copy-val vigyázni kell
    ha a blokkokban refes változók is vannak
    ezért pl. a (deprecated) processblock belerefesített
    parser objektummal nem jól működik

<<REMARK>>


****************************************************************************
function main()

local p,dom

    ? remark

    p:=xmlparser2New()  //vagy p:rootflag:=.f.

    p:file:="z.xml"
    p:infosize:=20

    p:nodebeginblock:={|prs,ni|nodebegin(prs,ni)}
    p:nodeendblock:={|prs,ni,node|nodeend(prs,ni,node)}
    p:contentblock:={|prs,node|content(prs,node)}
    
    ? "rootflag",p:rootflag
    
    dom:=p:parse
    ?
    
    printnode(dom)
    ?
    
    dom:xmlout 
    ?

****************************************************************************
function nodebegin(prs,ni) //parser, nodeinfo
    ? ">>>", ni:fullpath
    

****************************************************************************
function nodeend(prs,ni,node)  //parser, nodeinfo, node/NIL
    ? "<<<", ni:fullpath //, node


****************************************************************************
function content(prs,node)
local p,dom

    if( node:type=="include" )
        p:=prs:copy
        p:file:=node:getattrib("file")

        dom:=p:parse //#ROOT típusú

        //részfa bekapcsolás
        node:type:=dom:type
        node:content:=dom:content
        node:attrib:=dom:attrib
    end
    
    return .t.


****************************************************************************
