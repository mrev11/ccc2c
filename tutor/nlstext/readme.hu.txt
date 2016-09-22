Stringek automatikus cser�je t�bbnyelv� programokban
====================================================

Egyel�re csak a prg-beli stringekr�l van sz�.

A forr�sban be kell jel�lni a ford�tand� sz�vegeket, egy�ttal 
angolra kell ford�tani, hogy k�dol�sf�ggetlen, semleges platformr�l 
indulhasson a lokaliz�l�s. Ha minden sz�veg�nk angol, akkor ASCII 
�s UTF-8 editorban egyform�n kezelhet� a program. (Sajnos sok magyar 
komment van, azokat is angolra kellene ford�tani.)

A ford�tand� stringek kijel�l�se �gy t�rt�nik:

    @"Some like hot"

A "ordinary text" ki�rt�kel�se (veremre rak�sa):

    string("ordinary text");

A lokaliz�land� string veremre rak�sa:    

    string(nls_text("text to localize"));

Az �j ppo2cpp ezekhez t�mogat�st ad. 

1) Ha be van �ll�tva a CCC_STRING_TAB k�rnyezeti v�ltoz� 
(egy fil�specifik�ci�ra), akkor a nem bejel�lt stringeket 
list�zza ebbe a fil�be.

2) Ha be van �ll�tva a CCC_NLSTEXT_TAB k�rnyezeti v�ltoz� 
(egy fil�specifik�ci�ra), akkor a ford�t�sra kijel�lt stringeket 
list�zza  ebbe a fil�be.

A lista form�tuma:

"Some like hot"<<"" from  ./proba.prg  (8)

A sor a ford�tand� (angol) sz�veggel kezd�dik,
ut�na egy '<<' azt jelk�pezi, hogy ami itt j�n,
az fogja helyettes�teni az angol sz�veget, ezut�n "" j�n, 
ezek k�z� kell majd (a tran fil�ben) be�rni a ford�t�st.
V�g�l komment j�n, ami nem tartalmazhat '"' karaktert.
Az eg�sz szigor�an egy sor.

Amikor a ppo2cpp csin�lja ezt a fil�t, akkor  mindig
append m�dban nyitja meg, teh�t ak�rmennyi gy�jt�s eredm�nye
felhalmoz�dik a fil�ben, pl. az eg�sz CCC k�nyvt�r stringjei.

Az �gy k�sz�lt fil�t �tm�soljuk egy tran kiterjeszt�s�
fil�be, ebben dolgozik a ford�t�: <<"ide be�rogatja a ford�t�st"
mondjuk oroszul, term�szetesen UTF-8-ban.

A stringek gy�jt�s�t, �s az �jak (vagy megv�ltozottak)
hozz�ad�s�t a tran fil�khez programmal kell t�mogatni.
A legfontosabb, hogy a tran fil�kben lev� �l�munka ne vesszen el.

Tfh, valahogy megvan a tran fil�.
A tran2cpp utility a tran-b�l k�sz�t egy olyan C++ programot,
ami az egym�snak megfelel� sz�vegp�rokat berakja egy hasht�bl�ba.
Egyetlen f�ggv�ny k�sz�l, aminek neve: hashtable_fill.
Minden lokaliz�lt k�nyvt�rhoz �s minden alkalmaz�shoz
nyelvenk�nt k�sz�l egy so, ami csak ezt a hashtable_fill
f�ggv�nyt tartalmazza.

A lokaliz�lt program elej�n be kell t�lteni a ford�t�sokat,
p�ld�ul:

    nls_load_translation("sql2") //nincs m�g ilyen
    nls_load_translation("nlstext-test")

Tfh, a CCC_LANG=hu be�ll�t�s van �rv�nyben, akkor a

    libsql2.hu.so
    libnlstext-test.hu.so

k�nyvt�rakban tal�lhat� ford�t�sok t�lt�dnek be.    

A nls_text() f�ggv�ny megpr�b�lja helyettes�teni az argumentum�t
a leford�tott sz�veggel. Ha az nls_text() nem tal�lja meg a ford�t�st,
pl. nincs meg a k�nyvt�r, vagy nincs meg a keresett string,
akkor az eredeti angol sz�veg jelenik meg.

A p�ld�ban angol sz�veget ford�tok ISO-8859-2 magyarra,
de a ford�t�s szempontj�b�l most mindegy a k�dol�s.

A ford�t�sk�nyvt�r k�sz�t�sekor �s a CCC_LANG v�ltoz�ban
a nyelv mellett megadhat� a k�dol�s, pl: hu.UTF-8.

M�sik alkalmaz�si lehet�s�g: Az eredeti forr�sba nem angol
sz�veget �runk, hanem egy kulcsot, pl. �kezetlen�tett
magyar sz�veget, a program angol v�ltozat�hoz pedig
csin�lunk egy xxx.en.so ford�t�sk�nyvt�rat.
