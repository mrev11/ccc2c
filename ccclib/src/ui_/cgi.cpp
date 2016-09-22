
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

#include <stdio.h>
#include <string.h>
#include <cccapi.h>

//------------------------------------------------------------------------
void _clp_cgigetinput(int argno)
{
VALUE *base=stack-argno;
//
    char *requestmethod=getenv("REQUEST_METHOD");

    if( requestmethod==NULL ) 
    {
        //hibás, NIL    
    }
    else if( strcmp(requestmethod,"POST")==0 ) 
    {
        char *clength=getenv("CONTENT_LENGTH");
        int length=0;

        if( clength!=NULL )
        {
            sscanf(clength,"%d",&length);

            if( length>0 )
            {
                stack=base;

                int  c,i;
                char *buf=stringl(length); //uj string a stacken
        
                for(i=0; i<length; i++)
                {
                    c=getc(stdin);

                    if( c!=EOF )
                    {
                        buf[i]=c;
                    }
                    else
                    {
                        while( i<length )
                        {
                            buf[i++]=' ';
                        }
                    }
                }
                return;
            }
        }
    }
    else if( strcmp(requestmethod,"GET")==0 ) 
    {
        char *qs=getenv("QUERY_STRING"); 
        if (qs==NULL)
            string("");
        else
            string(qs);
        return;
    }
//
stack=base;
PUSH(&NIL);
}

//------------------------------------------------------------------------
