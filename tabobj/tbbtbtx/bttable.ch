
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

//---------------------------------------------------------------------------
// T�bla objektum
//---------------------------------------------------------------------------

#define TAB_FHANDLE     1   // op. rendszer file handle
#define TAB_BTREE       2   // btree strukt�ra pointer
#define TAB_FLDNUM      3   // mez�k sz�ma a f�jlban (nem az objektumban)

#define TAB_RECBUF      4   // az aktu�lis rekord handlere
#define TAB_RECLEN      5   // val�di rekord hossz

#define TAB_KEYNUM      7   // Index sorsz�m (resource szerinti)
#define TAB_KEYBUF      8   // Buffer a kulcskifejez�snek
#define TAB_POSITION    9   // aktu�lis rekord sorsz�ma (recno)
#define TAB_RECPOS     10   // rekord poz�ci� (pgno/indx)
 
#define TAB_ALIAS      11   // alias n�v
#define TAB_FILE       12   // f�jln�v (path �s kiterjeszt�s n�lk�l)
#define TAB_PATH       13   // "d:\path\"
#define TAB_EXT        14   // ".dbf"

#define TAB_COLUMN     15   // oszlopok {{name,type,width,dec,pict,block},...}
#define TAB_INDEX      16   // indexek  {{name,file,{col1,...},type},...}
#define TAB_ORDER      17   // aktu�lis index (0, ha nincs �rv�nyben index)
#define TAB_OPEN       18   // open mode
#define TAB_FILTER     19   // filter block

#define TAB_MODIF      20   // m�dosult-e az aktu�lis rekord
#define TAB_MODIFKEY   21   // m�dosult-e valamelyik kulcs
#define TAB_MODIFAPP   22   // �j rekordot jelz� flag

#define TAB_LOCKLST    23   // Lockok list�ja (recno)
#define TAB_LOCKFIL    25   // Lockolt-e a file

#define TAB_EOF        26   // EOF-on �ll-e
#define TAB_FOUND      27   // tal�lt-e a seek

#define TAB_MEMOHND    28
#define TAB_MEMODEL    29

#define TAB_SLOCKCNT   30
#define TAB_SLOCKHND   31

#define TAB_TRANID     32
#define TAB_FMODE      33   // fopen()-beli nyit�si m�d

#define TAB_LOGGED     34   // kell-e logolni

#define TAB_TRANLOCK   35   // az els� tranzakci�s lock indexe
#define TAB_TRANDEL    36   // rollbackben t�rlend� rekordok list�ja
 
#define TAB_SIZEOF     37


#define COL_NAME        1   // oszlop-, �s egyben mez�n�v
#define COL_TYPE        2   // t�pus: C,N,D,L
#define COL_WIDTH       3   // mez�sz�less�g
#define COL_DEC         4   // tizedesjegyek (0, ha TYPE!=N)
#define COL_PICT        5   // mez� picture
#define COL_BLOCK       6   // mez� setget block
#define COL_KEYFLAG     7   // r�sze-e a mez� valamelyik kulcsnak
#define COL_OFFS        8   // mez� offset a rekordon bel�l 
#define COL_SIZEOF      8


#define IND_NAME        1   // index azonos�t�
#define IND_FILE        2   // indexf�jl neve (path �s kiterjeszt�s n�lk�l)
#define IND_COL         3   // az indexet alkot� oszlopok nev�nek t�mbje
#define IND_TYPE        4   // .f. �lland� index, .t. ideiglenes index
#define IND_CURKEY      5   // aktu�lis kulcs�rt�k index update-hez
#define IND_SIZEOF      5 


#define OPEN_CLOSED     0   // nincs nyitva
#define OPEN_READONLY   1   // SHARED+READONLY (!)
#define OPEN_SHARED     2   // default
#define OPEN_EXCLUSIVE  3
#define OPEN_APPEND     4


//---------------------------------------------------------------------------
// Mem�ria foglal�s
//---------------------------------------------------------------------------

#define xvfree(hnd)      hnd:=NIL
#define xvalloc(size)    space(size)

//---------------------------------------------------------------------------
// Tranzakci�k
//---------------------------------------------------------------------------

#define PUP_TABLE       1  //minden form�tumban
#define PUP_POSITION    2  //minden form�tumban 
#define PUP_RECBUF      3  //minden form�tumban 
#define PUP_CURKEY      4
#define PUP_RECPOS      5
#define PUP_MODIFKEY    6
#define PUP_MODIFAPP    7
#define PUP_MEMODEL     8

//---------------------------------------------------------------------------


 