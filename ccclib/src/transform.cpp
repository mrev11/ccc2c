
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
#include <ctype.h>
#include <cccapi.h>

static const char *templatech="ANX9#LY!";

//--------------------------------------------------------------------------
void _clp_transform(int argno)
{
VALUE *base=stack-argno;
stack=base+min(argno,2);
while(stack<base+2)PUSHNIL();
push_call("_clp_transform",base);
//
    VALUE *vexp=base;
    VALUE *vpict=base+1;

    if( vpict->type!=TYPE_STRING )
    {
        if( vpict->type==TYPE_NIL )
        {
            POP();
            string("");
        }
        else
        {
            error_arg("transform",base,2);
        }
    }

    switch( vexp->type )
    {
        case TYPE_STRING:
            trn_string(vexp,vpict);
            break;

        case TYPE_FLAG:
            trn_flag(vexp,vpict);
            break;

        case TYPE_NUMBER:
            trn_number(vexp,vpict);
            break;

        case TYPE_DATE:
            trn_date(vexp,vpict);
            break;

        case TYPE_NIL:
            string("NIL");
            break;

        default:
            error_arg("transform",base,2);
    }
//    
pop_call();
RETURN(base);
}

//--------------------------------------------------------------------------
char *ParsePicture(VALUE*vp, int*tf)
{
    //vp a feldolgozand� picture
    
    //visszaadja a picture template stringj�t (vagy NULL-t)

    //tf-ben kapja vissza a h�v� a transform
    //function-stringj�b�l kiolvasott flageket
    //tf hossza legal�bb TRANSFORM_FLAGS


    for(int i=0;i<TRANSFORM_FLAGS;i++)
    {
        tf[i]=0;
    }
    
    int len;
    
    if( vp->type!=TYPE_STRING || !(len=STRINGLEN(vp)) )
    {
        return NULL;
    }
    
    char *pict=STRINGPTR(vp);
    
    if( *pict=='@' )
    {
        char f;

        while( ((f=*++pict)!=' ') && f )
        {
            switch(f)
            {
                case 'B': tf[TRANSFORM_B]=1; break;
                case 'Z': tf[TRANSFORM_Z]=1; break;
                case '!': tf[TRANSFORM_U]=1; break;
                case 'A': tf[TRANSFORM_A]=1; break;
                case 'K': tf[TRANSFORM_K]=1; break;
                case '*': tf[TRANSFORM_P]=1; break;
                case 'S':
                {
                    char buf[8];
                    int width=0;
                    int i;

                    for(i=0; (i<7) && isdigit(*(pict+1)); i++ )
                    {
                        buf[i]=*++pict;
                    }
                    if( i>0 )
                    {
                        buf[i]=0;
                        sscanf(buf,"%d",&width);
                    }
                    
                    tf[TRANSFORM_S]=width;
                    break;
                }
            }
        }
        
        while( *pict==' ' ) pict++;
    }
    
    return (*pict) ? pict : 0; //template string vagy NULL
}

//--------------------------------------------------------------------------
void trn_string(VALUE *vs,VALUE *vp) //  --- string
{
    int tf[TRANSFORM_FLAGS];
    char *tempstr=ParsePicture(vp,tf);

    if( !tempstr )
    {
        // �res a template string,
        // vs v�ltozatlan form�ban a kimenet
        
        push_symbol(vs);
        if( tf[TRANSFORM_U] )
        {
            _clp_upper(1);
        }
        return;
    }

    int len=STRINGLEN(vs);
    const char *s=len?STRINGPTR(vs):""; //form�zand� string

    //n�lunk a kimenet hossza mindig egyenl� lesz a template hossz�val,
    //a Clipperben a kimenet hossz�t a form�zand� string hat�rozza meg
    
    int tlen=strlen(tempstr);
    char *p=stringl(tlen); // �j objektum a stacken
    int upper=tf[TRANSFORM_U];
    int i;
    
    for( i=0; i<tlen; i++ )
    {
        char c, t=*(tempstr+i);

        if( strchr(templatech,t) )
        {
            if( 0!=(c=*s) )
            {
                *(p+i)=(upper||(t=='!')?toupper(c):c);
                s++;
            }
            else
            {
                *(p+i)=' ';
            }
        }
        else
        {
            *(p+i)=t;
        }
    }
    *(p+i)=0;

    if( tf[TRANSFORM_S] )
    {
        number( tf[TRANSFORM_S] );
        _clp_padr(2);
    }
}

//--------------------------------------------------------------------------
void trn_flag(VALUE *vs,VALUE *vp) //  --- string
{
    int tf[TRANSFORM_FLAGS];
    char *tempstr=ParsePicture(vp,tf);
    int flag=vs->data.flag;

    if(!tempstr||(*tempstr=='L')) string(flag?"T":"F");
    else if( *tempstr=='Y' )      string(flag?"Y":"N");
    else if( *tempstr=='I' )      string(flag?"I":"N");
    else                          string(flag?"T":"F");
}

//--------------------------------------------------------------------------
void trn_date(VALUE *vs,VALUE *vp) //  --- string
{
    push_symbol(vs);
    _clp_dtoc(1);
}

//--------------------------------------------------------------------------
void trn_number(VALUE *vs,VALUE *vp) //  --- string
{
    int tf[TRANSFORM_FLAGS];
    char *tempstr=ParsePicture(vp,tf);
    
    if( !tempstr )
    {
        push_symbol(vs);
        _clp_str(1);
        return;
    }
    
    if( tf[TRANSFORM_Z] && !vs->data.number )
    {
        number((double)(unsigned long long)strlen(tempstr));
        _clp_space(1);
        return;
    }
    
    int tlen=strlen(tempstr);
    char *decpoint=strchr(tempstr,'.');
    int decimal=decpoint?tlen-(decpoint-tempstr)-1:0;

    char *out=stringl(tlen); //m�solat a template stringr�l
    memcpy(out,tempstr,tlen);

    char buf[32],frm[16];
    sprintf(frm,"%c31.%df",'%',decimal); //format string
    sprintf(buf,frm,vs->data.number);
    
    //eg�sz r�sz
    //tizedespontt�l balra az els� karakter 

    int i=30-decimal-(decimal?1:0); 
    int j=tlen-1-decimal-(decimal?1:0);
    
    while( (i>=0) && (j>=0) )
    {
        if( strchr(templatech,*(out+j)) || (*(buf+i)=='-') )
        {
            *(out+j--)=*(buf+i--); 
        }
        else if( (i<0) || (*(buf+i)==' ') )
        {
            *(out+j--)=' ';
        }
        else 
        {
            j--;
        }
    }

    if( (i>=0) && (*(buf+i)!=' ') )  // nem f�rt bele
    {
        memset(out,'*',tlen);
        return;
    }
    
    while( j>=0 )
    {
        *(out+j--)=' ';
    }
    
    //decim�lis r�sz
    //tizedespontt�l jobbra az els� karakter 

    i=30-decimal+1; 
    j=tlen-decimal;

    while( j<tlen ) 
    {
        if( strchr(templatech,*(out+j)) )
        {
            *(out+j++)=(i<31?*(buf+i++):'0');
        }
        else
        {
            j++;
        }
    }
  
    *(out+tlen)=0;
    
    if( tf[TRANSFORM_B] )
    {
        _clp_ltrim(1);
        number( (double)(unsigned long long) strlen(tempstr));
        _clp_padr(2);
    }
}

//--------------------------------------------------------------------------

