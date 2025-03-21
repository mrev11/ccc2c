
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

function main(opt)

    // hivasi formak
    //
    // cccbn       -->  CCCx 999\n
    // cccbn  -n   -->  CCCx 999
    // cccbn  -nn  -->       999

    if( cccver()!=val(getenv("CCCVER")) )
        // ha eppen nincs cccbn
        // de a path-bol elindul egy masik verzio
        // akkor nem irunk ki semmit
        return NIL
    end

    if( opt=="-nn" )
        ?? buildnumber_ccc()::str::alltrim  // csak a szam
    elseif( opt=="-n" )
        ?? "CCC"+cccver()::str::alltrim, buildnumber_ccc()::str::alltrim // EOL nelkul
    else
        ?? "CCC"+cccver()::str::alltrim, buildnumber_ccc()::str::alltrim;? // a vegen EOL 
    end
