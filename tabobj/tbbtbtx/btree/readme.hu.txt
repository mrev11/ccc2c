
FreeBSD-n rosszul linkel�d�tt �ssze a C �s C++ k�d,
amikor a k�nyvt�rat a ccc2_tbwrapper-b�l dlopen t�lt�tte be. 
L�tsz�lag hib�tlan linkel�s, dlopen, dlsym ut�n a C++ modulb�l 
(_db_open) nem lehetett megh�vni a C modult (__bt_open): nem �rkezett 
meg a vez�rl�s, �s a program nemdeterminisztukusan SIGSEGV-zett.
Ugyanaz a program j�l m�k�d�tt, ha a ccc2_btbtx.so k�nyvt�rat
k�zvetlen�l linkeltem, �s nem a ccc2_tbwrapper-b�l t�lt�ttem be.

Ez val�sz�n�leg a dlopen (loader) hib�ja. A hiba elker�l�se �rdek�ben 
�t�rtam a C r�szeket C++-ra,  ezzel egy�bk�nt is el�bbre vagyunk.
