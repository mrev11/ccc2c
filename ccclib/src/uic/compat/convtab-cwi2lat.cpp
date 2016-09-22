

#include <inthash.h>

static int cwi[]={
    160, 130, 161, 162, 148, 147, 244, 163, 129, 150,     
    143, 144, 140, 141, 149, 153, 167, 212, 151, 154, 152, 0};

static int lat[]={
    225, 233, 237, 243, 246, 245, 245, 250, 252, 251,
    193, 201, 205, 205, 211, 214, 213, 213, 218, 220, 219 ,0};


static inthash hash_cwi2lat(256,cwi,lat);

int convtab_cwi2lat(int cwi)
{
    return hash_cwi2lat.getx(cwi);
}

