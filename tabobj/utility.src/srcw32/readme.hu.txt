
Mi a kl”nbs‚g az itteni ‚s a standard k”nyvt ri modulok k”z”tt?
================================================================

KEYB32C.CPP

   Kl”n van v‚ve bel“le a virtual key --> inkey t bla.

   Nem veszi figyelembe, hogy a rendszer milyen ASCI ‚rt‚ket
   tulajdon¡t a billenty–knek, hanem mindig a v2i t bla alapj n
   dolgozik, ez‚rt a kl”nf‚le billenty– driverek hat stalanok.
   
   Nem haszn lja a capslock billenty–t. Ha ezt ‚rtelmezni akarn nk,
   akkor azt is meg k‚ne oldani, hogy bekapcsolt capslockkal
   a kurzor mozgat sa ne csin ljon kijel”l‚st, ki lehessen l‚pni
   escappel, stb. Nem ‚ri meg a f rads got.


   Bal eg‚rgombbal kattintva v ltoztathat¢ a kurzorpoz¡ci¢.
   Ezt nem volna szerencs‚s bevezetni az alapk”nyvt rban.


V2I.CPP
   
   A kl”nvett virtual-->inkey t bla az eredetihez k‚pest 
   kis m¢dos¡t sokkal:
   
   A magyar ‚kezetes bet–k szabv nyos hely‚n l‚v“ billenty–ket ALT-tal 
   ‚s CTRL-lal nyomva el“ ll¡that¢k a CWI ‚kezetes k¢dok, pl.:
   
   ALT('") ->    CTRL('") -> 
   ALT(;:) -> ‚  CTRL(;:) -> , stb.
   
   A SHIFT-kurzormozgat s billenty–kombin ci¢khoz az inkey.ch-ban
   nincs szimb¢lum rendelve, ez‚rt a v2i t bla ezekre is az
   ALT-kurzormozgat s kombin ci¢ k¢dj t adja, ennek eredm‚nyek‚ppen
   a programban a kijel”l‚s egyform n m–k”dik az ALT ‚s SHIFT
   billenty–kkel.
   
   Megjegyz‚s: ha valakinek a CWI k¢drendszer nem felel meg, 
   akkor vagy a keymap.z-ben kell olyan lek‚pez‚st alkalmazni,
   ami a k¡v nt k¢dot adja, vagy ki kell cser‚lni v2i.cpp-t.
   

A z editor a fenti v ltoztat sok n‚lkl is m–k”d“k‚pes, 
pl. Linuxon egyszer–en nem kell beford¡tani az srcw32 alatti
programokat, ‚s pr¡m n m–k”d“ editort kapunk.
