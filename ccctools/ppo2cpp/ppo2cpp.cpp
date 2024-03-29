
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

#include <stdlib.h>
#include <stdio.h>

#include <lexer.h>
#include <parser.h>
#include <decllist.h>
#include <parsenode.h>
#include <nodetab.h>

#include <fcntl.h> //sorrend (Sun/Solaris)

extern void* ParseAlloc(void*(*)(size_t)); 
extern void  ParseFree(void*,void(*)(void*)); 
extern void  ParseTrace(FILE*,const char*); 
extern void  Parse(void*,int,parsenode*);  //3th arg: %token_type {parsenode*} 

static const char *version_number="4.11.0.1";

ppo2cpp_lexer *lexer;

FILE *diag;
FILE *code;
int debug=0;

nodetab *nodetab_globstat=new nodetab();     //k�ls� static v�ltoz�k
nodetab *nodetab_locstat=new nodetab();      //bels� static v�ltoz�k
nodetab *nodetab_local=new nodetab();        //local v�ltoz�k

nodetab *nodetab_blkarg=new nodetab();       //k�dblokk argumentumok
nodetab *nodetab_blkenv=new nodetab();       //k�dblokk v�ltoz�k
nodetab *nodetab_block=new nodetab();        //k�dblokkok


char *current_namespace=0;
char *inner_namespace=0;

//----------------------------------------------------------------------------
int main(int argc, char**argv)
{

    int fd=0;
    char input[256]="";
    char output[256]="";
    char ppo2cpp_code[256]="";
    char ppo2cpp_diag[256]="";
    char ppo2cpp_meth[256]="";
    lexer=new ppo2cpp_lexer(fd);
    int quiet=0, veronly=0;

    int i;
    for( i=1; i<argc; i++ )
    {
        if( *argv[i]=='-' )
        {
            //opci�k;

            if( argv[i][1]=='d' )
            {
                debug=1;
                lexer->setdebugflag(1);
            }

            else if( argv[i][1]=='o' )
            {
                strcpy(output,&argv[i][2]);
            }

            else if( argv[i][1]=='v' )
            {
                veronly=1; //csak verzi�sz�m
            }

            else if( argv[i][1]=='q' )
            {
                quiet=1; //nem �rja ki a verzi�sz�ot
            }

            else if( argv[i][1]=='x' )
            {
                veronly=1; //csak verzi�sz�m
                quiet=1; //nem �rja ki a verzi�sz�ot
            }
        }
        else
        {
            strcpy(input,argv[i]);
            lexer->setinputfspec(argv[i]);
        }
    }
    
    if( !quiet )
    {
        printf("Clipper/C++ Compiler %s Copyright (C) ComFirm Bt.\n",version_number);
    }

    if( veronly )
    {
        exit(0);
    }
    
    if( *input )
    {
        fd=open(input,0);
        if( fd<0 )
        {
            fprintf(stderr,"\nInput (%s) not found.",input);
            exit(1); 
        }
        lexer->setinputfd(fd);
    
        if( !*output )
        {
            char *p;
            strcpy(output,input);
            if( (0!=(p=strrchr(output,'.'))) && 
                (0==strchr(p,'\\')) && 
                (0==strchr(p,'/')) )
            {
                *p=0x00;
            }
            strcat(output,".cpp");
        }

//        strcpy(ppo2cpp_code,input);strcat(ppo2cpp_code,".code");
//        strcpy(ppo2cpp_diag,input);strcat(ppo2cpp_diag,".diag");
//        strcpy(ppo2cpp_meth,input);strcat(ppo2cpp_meth,".meth");

        {//code
            char *p;
            strcpy(ppo2cpp_code,input);
            if( (0!=(p=strrchr(ppo2cpp_code,'.'))) && 
                (0==strchr(p,'\\')) && 
                (0==strchr(p,'/')) )
            {
                *p=0x00;
            }
            strcat(ppo2cpp_code,".code");
        }

        {//diag
            char *p;
            strcpy(ppo2cpp_diag,input);
            if( (0!=(p=strrchr(ppo2cpp_diag,'.'))) && 
                (0==strchr(p,'\\')) && 
                (0==strchr(p,'/')) )
            {
                *p=0x00;
            }
            strcat(ppo2cpp_diag,".diag");
        }

        {//meth
            char *p;
            strcpy(ppo2cpp_meth,input);
            if( (0!=(p=strrchr(ppo2cpp_meth,'.'))) && 
                (0==strchr(p,'\\')) && 
                (0==strchr(p,'/')) )
            {
                *p=0x00;
            }
            strcat(ppo2cpp_meth,".meth");
        }
    }

    code=fopen(ppo2cpp_code,"w");
    diag=fopen(ppo2cpp_diag,"w");

    fundecl_ini();
    flddecl_ini();
    metdecl_ini();

    void *parser=ParseAlloc(malloc); 

    if(debug)
    {
        ParseTrace(diag,">> ");
    }
    
    parsenode *node;
    while( 0!=(node=lexer->getnext()) )
    {
        Parse(parser,node->tokenid,node);
    }

    Parse(parser,0,0);
    ParseFree(parser,free);
    delete lexer;

    fclose(diag);
    fclose(code);

    // 2009.12.10
    // eloszor kell kiirni fundecl_list-et
    // azutan  kell kiirni metdecl_list-et
    // csakhogy metdecl_list-nek jaruleka van fundecl_list-ben
    // ezert ketszer kell futtatni (az elso kimenet ppo2cpp.meth-be)
    void *retcode=freopen(ppo2cpp_meth,"w+",stdout); //warning: ignoring return value
    metdecl_list();


    if( *output )
    {
        void *retcode=freopen(output,"w+",stdout);
    }


    printf("//input: %s (%s)\n\n",input,version_number);
    printf("#include <clp2cpp.h>\n");

    fundecl_list();
    flddecl_list();
    metdecl_list();

    code=fopen(ppo2cpp_code,"r");
    namespace_begin(current_namespace,stdout);
    int c;
    while( EOF!=(c=fgetc(code)) )
    {
        putchar(c);
    }
    namespace_end(current_namespace,stdout);
    putchar('\n');
    
    fclose(code);
    
    if( !debug )
    {
        remove(ppo2cpp_code);
        remove(ppo2cpp_diag);
        remove(ppo2cpp_meth);
    }

    return 0;
}

//----------------------------------------------------------------------------

