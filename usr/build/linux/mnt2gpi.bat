#!/bin/bash
echo MNT2GPI.BAT $1 $2
# echo "PARAMS:" $@
# set -x


BASENAME="$1"
DIRNAME="$2"
FDIRNAME=$(cd "$DIRNAME" && pwd -P)

MNT=$DIRNAME/$BASENAME.mnt
GPI=$DIRNAME/$BASENAME.gpi

FMNT=$FDIRNAME/$BASENAME.mnt
FGPI=$FDIRNAME/$BASENAME.gpi

WDIR=$(pwd)/ppo/eg$$
mkdir -p $WDIR

WEDITWRK="$WDIR/editwrk"
WGPI="$WDIR/$BASENAME.gpi"

set -e
rm -f "$GPI" "$WEDITWRK" "$WGPI"

(set -e
cd "$WDIR"
echo "// Generalva a(z) $MNT alapjan."                          >  "$WGPI"
echo "// Csak a(z) $MNT modositasaval szabad megvaltoztatni!"   >> "$WGPI"

LANG=C awk '
# Az input file formatuma:
#   %nev function fgNev(..)
#   =mezoNev getNev [![defPict|nev]]
#   ![defPict|nev]
# A !nev kezdetu sorokat az fgNev nevu fuggvenybe teszi.
# A fuggvenyt egy !nev return .. sorral kell lezarni.
# A ! az xSetCPicts-et jeloli. Ezt nem kell return-al lezarni.


# function feldolgoz(): A $0-t dolgozza fel, Eloszol elmegy az
# elso !-ig, majd megnezi, hogy az a !defPict-e, ha igen, akkor
# a defPict-et beleteszi az outputba.
# Ha nem, akkor megnezi milyen azonosito van a ! utan es
# az annak megfelelo filebe teszi a a !azon utani reszt.
function feldolgoz() {
   $0=substr($0,index($0,"!"));
   if (length($0)==0)
      return 0;
   # printf("rem %s\n",$1);
   if ($1=="!defPict")
   {
      printf("   %-12s:picture:=defaultPicture(valtype(%s),len(%s:varGet()))\n",
                 get,                                  mezo,   get) >> fgNevek[3];
      return 0;
   }
   w=substr($0,length($1)+1)
   if ($1=="!")
   {
      printf(w,get,get,get,get,get) >> fgNevek[3];
      printf("\n")                  >> fgNevek[3];
      return 0;
   }
   else if ((w1=sprintf("fg%s",substr($1,2))) in fgNevek)
   {
      printf(w,get,get,get,get,get) >> fgNevek[w1];
      printf("\n")                  >> fgNevek[w1];
      close(fgNevek[w1]);
   }
   return 0;
}


function filePrint(fName) { while((getline s <fName)==1) {print s;} return 0;}

BEGIN  {
          fejLec="*********************************************************************\n";
          # fgNevek="";
          w=fgNevek[0]="fg000.awf";
          printf(fejLec) >w;
          printf("static function xStore(getlist)\n") >>w;
          w=fgNevek[1]="fg001.awf"
          printf(fejLec) >w;
          printf("static function xLoad(getlist)\n") >>w;
          w=fgNevek[2]="fg002.awf"
          printf(fejLec) >w;
          printf("static function xLoadEmpty(getlist)\n") >>w;
          w=fgNevek[3]="fg003.awf"
          printf(fejLec) >w;
          printf("static function xSetCPicts(getlist)\n") >>w;
          fgNum=4;
       }
/^%/   {
          split($0,w_s);
          fgNevek[w1=sprintf("fg%s",substr(w_s[1],2))]=sprintf("fg%03d.awf",fgNum);
          # printf("Filenev: %s: %s\n",w1,fgNevek[w1]);
          printf(fejLec) > fgNevek[w1];
          printf("%s\n",substr($0,index($0,"!")+1)) >> fgNevek[w1];
          close(fgNevek[w1])
          fgNum++;
          # $0="a b c d";
          # printf("$0: %s, $1: %s, $2: %s, $3: %s, $4: %s\n",$0,$1,$2,$3,$4);
       }
/^=/   {  ment=$0
          # $0=substr($0,2);
          mezo=substr($1,2);get=$2;
          if (length(mezo)!=0 && length(get)!=0)
          {
             printf("   %-20s:=%s:varGet()\n",mezo,get)         >>fgNevek[0];
             printf("   %-12s:varPut(%s)\n",get,mezo)           >>fgNevek[1]
             printf("   %-12s:varPut(emptyVal(%s))\n",get,mezo) >>fgNevek[2];
          }
          feldolgoz();
          $0=ment;
       }
/^!/   {
          feldolgoz();
       }
END    {
          printf("return nil\n\n") >>fgNevek[0];
          printf("return nil\n\n") >>fgNevek[1];
          printf("return nil\n\n") >>fgNevek[2];
          printf("return nil\n\n") >>fgNevek[3];
          for(i in fgNevek)
          {
             printf("cat %s >>$1\n",fgNevek[i]);
             printf("rm %s\n",fgNevek[i]);
             #printf("%s: %s\n",i,fgNevek[i]);
             #w=fgNevek[i];
             #close(w);
             #filePrint(fgNevek[i]);
          }
       }
' <"$FMNT" |sort>"$WEDITWRK"
#read
. "$WEDITWRK" "$WGPI"
)

# Should not use cp -af here.
cat "$WGPI" >"$GPI"
rm -rf $WDIR

echo ----------------------------------------------------------------
