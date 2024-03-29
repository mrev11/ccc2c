

// draw_ccc_color.exe <rgb>  =>  colorindex


******************************************************************************************
function main(color:="123")

local bg

    ? '"'+color+'"', "->", bg:=colorstring_to_colorindex(color)::str::alltrim

    ? chr(27)+"[48;5;"+bg+"m                        "+chr(27)+"[m"
    ? chr(27)+"[48;5;"+bg+"m                        "+chr(27)+"[m"
    ? chr(27)+"[48;5;"+bg+"m                        "+chr(27)+"[m"
    ?? ansi_colors( bg::val+1 )::rgb

    ?


******************************************************************************************
static function rgb(rgb)
local x:=" ["

    x+=" "+rgb[1]::l2hex::padl(2,"0")
    x+=" "+rgb[2]::l2hex::padl(2,"0")
    x+=" "+rgb[3]::l2hex::padl(2,"0")
    x+=" ] "

    return x

******************************************************************************************



