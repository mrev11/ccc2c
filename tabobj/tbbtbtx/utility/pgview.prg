

static pgtype:={"FREE","INTERNAL","BLEAF","DATA","MEMO"}

#define ISMEMO(p) (p[5..8]::hex::len==10.and.p[5..8]::hex>="0x8")


******************************************************************************************
function main(btfile,pgno:="0")

local fd:=fopen(btfile)
local map:=filemap.open(fd)
local PGSIZE
local offset
local page
local type
local nords,n
local lower,upper
local pos,len,rec
local recpos,npg,ndx,memo
local mid

    fclose(fd)

    PGSIZE:=map[9..12]::num

    if( pgno::left(1)=="0" )
        pgno::=hex2l/PGSIZE    
    else
        pgno::=hex2l
    end

    offset:=pgno*PGSIZE
    page:=map::substr(offset+1,PGSIZE) // 1-based

    if( empty(page) )
        ? "out of bound"
        ?
        quit
    end
    memowrit("log-PAGE",page)
    
    set printer on
    set printer to log-pgview

    ? btfile

    if( offset==0 )
        ? "magic    :", page[ 1.. 4]::hex
        ? "version  :", page[ 5.. 8]::hex
        ? "pagesize :", page[ 9..12]::num , page[ 9..12]::hex
        ? "nrecords :", page[13..16]::num , page[13..16]::hex
        ? "free     :", page[17..20]::num , page[17..20]::hex
        ? "lastdata :", page[21..24]::num , page[21..24]::hex
        ? "memo     :", page[25..28]::num , page[25..28]::hex
        ? "norders  :", page[29..32]::num , page[29..32]::hex


        nords:=page[29..32]::num
        for n:=1 to nords
            offset:=32*n
            ? page[offset+17..offset+32]::strtran(bin(0),bin(32)),;
             "root="+page[offset+1..offset+4]::hex,;
             "last="+page[offset+5..offset+8]::hex,;
             "flags="+page[offset+9..offset+12]::hex
        next

    elseif( ISMEMO(page) ) 

        type:="MEMO"

        ? "pgno", "0x"+pgno::l2hex, page[1..4]::reverse::bin2hex::padl(8,"0"), crc32(page[5..])::l2hex::padl(8,"0")
        ?? "  offset", "0x"+offset::l2hex

        ? "link",   page[ 5.. 8]::hex
        ? "lower",  page[ 9..12]::hex
        ? "upper",  page[13..16]::hex

        lower:=page::substr(9,4)::num    // elso szabad pozicio
        upper:=page::substr(13,2)::num   // elso nemszabad pozicio
        ? "space", upper-lower

        ? "type",   type

        offset:=16
        while( offset<lower )
            mid:=page::substr(offset+ 1,4)         // memo-id

            pos:=page::substr(offset+ 5,2)::num     // memo ertek pozicioja a memo lapon
            len:=page::substr(offset+ 7,2)::num     // memo ertek hossza

            npg:=page::substr(offset+ 9,4)::num     // next page number
            ndx:=page::substr(offset+13,4)::num     // next index (on next page)

            ? offset::l2hex::padl(3,"0")

            if( mid!=x"0000000000000000" )
                ?? mid::bin2hex::transform(" rec[999999-9] ")
            else
                ?? " rec[        ] "
            end
            
            if( npg!=0 )
                ?? "->",npg::l2hex::padl(7,"0")+"-"+ndx::l2hex::padl(3,"0") 
            else
                ?? space(14)
            end

            ?? len::transform(" 9999")

            memo:=page::substr(pos+1,len)
            if( len(memo)>64 )
                memo:=memo::left(30)+a'....'+memo::right(30)
            end
            ?? "", a"["+memo+a"]"

            offset+=16
        end

    else
        // INTERNAL
        // BLEAF
        // DATA

        type:=pgtype[ page[17..20]::num+1 ]

        ? "pgno", "0x"+pgno::l2hex, page[1..4]::reverse::bin2hex::padl(8,"0"), crc32(page[5..])::l2hex::padl(8,"0")
        ?? " offset", "0x"+offset::l2hex

        ? "link", page[5..8]::hex
        ? "prev", page[9..12]::hex
        ? "next", page[13..16]::hex
        ? "type", type:=pgtype[ page[17..20]::num+1 ]
        ? "lower", page[21..22]::hex
        ? "upper", page[23..24]::hex

        lower:=page::substr(21,2)::num              // elso szabad pozicio
        upper:=page::substr(23,2)::num              // elso nemszabad pozicio

        ? "space", upper-lower

        offset:=24
        while( offset<lower )
            pos:=page::substr(offset+1,2)::num      // itt kezdodik a rekord
            ? "0x"+pos::l2hex::padr(4) 
            
            len:=page::substr(pos+1,4)::num         // rekordhossz 4 byteon
            rec:=page::substr(pos+5,len)            // delflg + rekord adatok
            ?? len::str::alltrim::padl(4)
            ?? "", a"["+rec+a"]"

            offset+=2
        end
    end

    ?
    ?

******************************************************************************************
static function num(x)  // N tipus
    return x::dec::val


******************************************************************************************
static function dec(x)  // C tipus decimalisan
    if( len(x)==2 )
        x+=x"0000"
    end
    return x::bin2u::str::alltrim


******************************************************************************************
static function hex(x)  // C tipus hexa
    if( len(x)==2 )
        x+=x"0000"
    end
    return "0x"+x::bin2u::l2hex


******************************************************************************************
static function reverse(x)
local r:=a"",n
    for n:=len(x) to 1 step -1
        r+=x[n]
    next
    return r 


******************************************************************************************