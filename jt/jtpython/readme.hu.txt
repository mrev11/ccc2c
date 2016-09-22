Python interf�sz J�va termin�lhoz 

http://ok.comfirm.hu/ccc2/download/jtpython.zip

A jtpython csomag c�lja a J�va termin�l API implement�lhat�s�g�nak
demonstr�l�sa. Mindamellett a csomag gyakorlati feladatok megold�s�ra
is alkalmas.

Mi�rt �rdemes jtermin�lt haszn�lni  Tk, Qt, GTK, Wx stb. helyett?

1) A J�va termin�l �rdekesebb, mint a felsorolt toolkitek.

2) A pehelys�ly� jtpython k�nyvt�r SOKKAL EGYSZER�BB, 
   mint a felsorolt toolkitek, vagy ak�r csak azok interf�szei. 
   Ebb�l ad�d�an a jtpythonos programok STABILAK.

3) A J�va termin�lnak magasabb szint� interf�sze van, 
   ami �gyviteli programokban termel�kenyebben haszn�lhat�.

4) A szerver �s a megjelen�t� k�l�n g�pen is futhat, ez�ltal
   centraliz�lt, vagy internetes alkalmaz�s is k�sz�thet�.

5) Ha egy b�ng�sz�s �gyf�l g�p�n install�lva van a JRE, akkor
   �gy is elindul n�la az alkalmaz�sunk (klikkre), hogy soha nem 
   hallott r�lunk (a J�va Webstart technol�gia r�v�n).

 
Telep�t�s:

1) Sz�ks�g van a Python XML modulj�ra.
2) A site.py modulban encoding='ascii'-t encoding='latin-1'-re cser�lj�k.
3) A jtlib directoryt berakjuk a PYTHONPATH-ba.


Megjegyz�sek:

A program nincs felk�sz�tve Unicode/UTF-8 k�dol�sra,
hanem bedr�tozottan Latin-1-et haszn�l.

A program csak fel�letesen van tesztelve, a mell�k�gak t�bb helyen
m�g egy�ltal�n nem futottak, �gy hib�k, el�r�sok b�rhol el�ad�dhatnak. 
Ugyanakkor koncepcion�lis, vagy nehezen kijav�that� hiba val�sz�n�leg 
nincs a programban.

Bizonyos funkci�k tesztel�se az�rt maradt el, mert nem tal�ltam
megfelel� Python eszk�zt. Pl. nem tudom, hogyan lehet Pythonban 
digit�lis al��r�st ellen�rizni (nincs OpenSSL interf�sz?).

Hi�nyzik a t�blaobjektum browse, mert Pythonban nincs t�blaobjektum
k�nyvt�r.

Nincs a jtpython-nal haszn�lhat� dialog editor. A CCC eszk�z�k
haszn�lhat�k, az msk2dlg k�nnyen �talak�that� �gy, hogy CCC helyett
Python k�dot gener�ljon.

A fenti hi�nyokon t�l a jterminal haszn�lata CCC-b�l �s Python-b�l
MEGEGYEZIK. A termin�l (term�szetesen) nem �rz�keli, hogy CCC, vagy
Python szerverprogrammal �ll-e szemben.

A programokat ugyan�gy futtatjuk, mint CCC k�rnyezetben.
A tesztprogramok ind�t�s�hoz defini�ljuk a JTERMINAL k�rnyezeti v�ltoz�t, 
aminek tartalma a jterminal.jar teljes f�jlspecifik�ci�ja. 
