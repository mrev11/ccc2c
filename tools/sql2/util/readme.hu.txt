
bt2tds
    bt2ted.exe

    BT t�bl�hoz tableentity defin�ci�s fil�t (ted) k�sz�t.
    Az eredm�nyt �ltal�ban m�g k�zzel edit�lni kell, 
    ui. nincsenek benne az opcion�lis select met�dusok.
    Nem mindig van olyan index, ami megfelel primarykey-nek.
    
    bt2tds.exe

    L�nyeg�ben ugyanaz, mint a r�gebbi bt2ted,
    csak nem XML szintaktik�j� ted kimenetet k�sz�t,
    hanem az olvashat�bb table definition scriptet (tds).
    

btimport (�tker�lt a test-be)
    Egy bt (dat/dbf) t�bl�t �tt�lt SQL adatb�zisba.
    Csak olyan t�bl�kra m�k�dik, amik benne vannak egy entitylib
    k�nyvt�rban (l�sd mkentitylib-et). Az entitylib k�nyvt�rat
    bele kell linkelni a btimport programba.
    
    Megjegyz�s: 
    Az import�land� t�bl�khoz csin�lunk egy entitylib k�nyvt�rat
    (a bt2tds, tds2prg �s mkentitylib utilitykkel), 
    �s ennek a k�nyvt�rnak a linkel�s�vel csin�lunk egy speci�lis, 
    az adott import feladathoz alkalmas btimport.exe-t. Azaz nem 
    param�terehzet�, hogy mit import�lunk, hanem alkalmank�nt el 
    kell v�gezni a bedr�toz�st.


mkentitylib
    Az aktu�lis directory *.tds �s *.ted fil�ire lefuttatja
    tsd2prg-t vagy ted2prg-t, azaz elk�sz�ti bel�l�k a prg-t.
    (A prg-kb�l tem�szetesen a Builddel k�nyvt�rat k�sz�t�nk.)
    Ha meg van adva egy argumentum, akkor hozz�rak egy tov�bbi
    f�ggv�nyt (entitylib.arg(name,con)), amivel n�v szerint is
    meg lehet kapni a k�nyvt�r tableentity oszt�lyait.


tds2prg
    tds2prg.exe: Tableentity Definition Scriptb�l prg-t k�sz�t.
    ted2prg.exe: TableEntity Definition XML-b�l prg-t k�sz�t.
