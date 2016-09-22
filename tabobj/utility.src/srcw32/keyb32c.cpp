
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
#include <cccapi.h>
#include <termapi.h>

extern short virtual2inkey(int i,int j);
extern void _clp_repositioncursorbymouseclick(int argno);  
 
#define PRESSED_CTRL(ib)  ((LEFT_CTRL_PRESSED|RIGHT_CTRL_PRESSED)&ib.Event.KeyEvent.dwControlKeyState)
#define PRESSED_ALT(ib)   ((LEFT_ALT_PRESSED|RIGHT_ALT_PRESSED)&ib.Event.KeyEvent.dwControlKeyState)
#define PRESSED_SHIFT(ib) (SHIFT_PRESSED&ib.Event.KeyEvent.dwControlKeyState)
#define ON_CAPSLOCK(ib)   (CAPSLOCK_ON&ib.Event.KeyEvent.dwControlKeyState)

#define kbhit() (GetNumberOfConsoleInputEvents(hConsole,&nofr)&&nofr)
 
//-----------------------------------------------------------------------
SHORT STDCALL local_getkey(ULONG wait_time)
{

    DWORD begin=GetTickCount();
    HANDLE hConsole=GetStdHandle(STD_INPUT_HANDLE);
    INPUT_RECORD inpbuf;
    DWORD nofr;
    

    DWORD dwInputMode;
    GetConsoleMode(hConsole,&dwInputMode);
    SetConsoleMode(hConsole, dwInputMode|ENABLE_MOUSE_INPUT);
 

    while( kbhit() || ((GetTickCount()-begin)<wait_time) )
    {
        while( kbhit() )
        {
            BOOL result=ReadConsoleInput(hConsole,&inpbuf,1,&nofr);
            
            if( !result )
            {
                //sikertelen
            }
            
            else if( (inpbuf.EventType==MOUSE_EVENT) && (inpbuf.Event.MouseEvent.dwButtonState&1) )
            {
                //COORD pos=inpbuf.Event.MouseEvent.dwMousePosition;
                //number(pos.X);
                //number(pos.Y);
                //_clp_repositioncursorbymouseclick(2); 
                //pop();
            }

            else if( (inpbuf.EventType==KEY_EVENT) && inpbuf.Event.KeyEvent.bKeyDown)
            {
                //printf("\n----------------------------------------------------");
                //printf("\nwVirtualKeyCode    %d   ",inpbuf.Event.KeyEvent.wVirtualKeyCode);
                //printf("\nAsciiChar          %d   ",inpbuf.Event.KeyEvent.uChar.AsciiChar);
                //printf("\ndwControlKeyState  %08lx",inpbuf.Event.KeyEvent.dwControlKeyState);
                    
                int i=0;
                short inkeycode=0;
                short key=(short)inpbuf.Event.KeyEvent.wVirtualKeyCode;

                while( virtual2inkey(i,0)<key )
                {
                    i++;
                }

                if( virtual2inkey(i,0)==key )
                {
                    if( PRESSED_ALT(inpbuf) )
                        inkeycode=virtual2inkey(i,4); //ALT

                    else if( PRESSED_CTRL(inpbuf) )
                        inkeycode=virtual2inkey(i,3); //CTRL

                    else if( PRESSED_SHIFT(inpbuf) )
                        inkeycode=virtual2inkey(i,2); //upper

                    else
                        inkeycode=virtual2inkey(i,1); //lower
                }
                
                //int printcode=inkeycode;
                //if( (printcode<32) || (255<printcode) )
                //{
                //    printcode=32;
                //}
                //printf("\nInkeyCode=%d [%c]",inkeycode,printcode);flushall();

                
                if( inkeycode )
                {
                    return inkeycode;
                }
            }
        }

        Sleep(20);
    }
    return 0;
}

//-----------------------------------------------------------------------
