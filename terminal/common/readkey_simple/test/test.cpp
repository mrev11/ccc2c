
#include <stdio.h>
#include <utf8conv.h>

extern int readkey();


int main()
{
    while(1)
    {
        int ch=readkey();
        if( ch )
        {
            printf("inkey %d\r\n", ch);
        }
        if( ch==27 )
        {
            break;
        }
    }
    return 0;
}

