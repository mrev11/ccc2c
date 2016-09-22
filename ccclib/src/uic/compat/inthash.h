
#include <stdio.h>
#include <stdlib.h>

class inthash
{
  private:
    
    int index(int key)
    {
        int xkey=abs(key)%size;
    
        while(1)
        {
            if( pkey[xkey]==0 )
            {
                return xkey;
            }
            else if( pkey[xkey]==key )
            {
                return xkey;
            }
            else if( ++xkey>=size  )
            {
                xkey=0;
            }
        }
    }

  public:

    int count;
    int size;
    int *pkey;
    int *pval;
    
    void set(int key, int val)
    {   
        int xkey=index(key);

        if(pkey[xkey]==0)
        {
            count++;
        }
        pkey[xkey]=key;
        pval[xkey]=val;
    }

    int get(int key)
    {
        return pval[index(key)];
    }


    int getx(int key)
    {
        int val=pval[index(key)];
        return  val?val:key;
    }


    int bulk( int *keys, int*vals)
    {
        for(int i=0; keys[i]!=0; i++)
        {
            set(keys[i],vals[i]);
        }
        return count;
    }


    inthash(int hashsize)
    {
        count=0;
        size=hashsize;
        pkey=(int*)calloc(size,sizeof(int));
        pval=(int*)calloc(size,sizeof(int));
    }

    inthash(int hashsize, int *keys, int*vals)
    {
        count=0;
        size=hashsize;
        pkey=(int*)calloc(size,sizeof(int));
        pval=(int*)calloc(size,sizeof(int));
        bulk(keys,vals);
    }


    ~inthash()
    {
        free(pkey);
        free(pval);
    }
};
