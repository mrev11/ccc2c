
#define LOWER(x) (x)


******************************************************************************
function dirdirmake(path)
local dir:="",tok,bslash

    while( !empty(path) )

        if( (bslash:=at(dirsep(),path))>0 )
             tok:=left(path,bslash-1)
             path:=substr(path,bslash+1)
        else
             tok:=path
             path:=""
        end
        
        if( !empty(dir+=tok) )
        
            if( !empty(directory(LOWER(dir),"D")) )
                //alert("Létezik:"+LOWER(dir))
            else
                dirmake( LOWER(dir) ) 
            end
        end

        dir+=dirsep()
    end


****************************************************************************
