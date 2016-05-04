//
//  main.cpp
//  1002
//
//  Created by Owen on 14-12-30.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{
    int n, tmp;
    char a[1000], b[1000];
    scanf("%d", &n);
    for (int x = 1 ; x<=n; x++) {
        scanf("%s %s", a , b);
        printf("Case %d:\n", x);
        tmp = 0;
        if( strlen(a)>strlen(b))
        {
            int lena = (int)strlen(a);
            int lenb = (int)strlen(b);
            char sum[lena+1];
            sum[lena]='\0';
            for (int i =1; i<=lena  ; i++ ) {
                
                if(lena == lenb)
                {
                    sum[lena-i] =  a[lena-i]+b[lenb-i]-48+tmp;
                }
                else{
                    if (lenb-i>=0) {
                        sum[lena-i] =  a[lena-i]+b[lenb-i]-48+tmp;
                    }
                    else
                        sum[lena-i] =  a[lena-i]+tmp;
                }
                
                if(sum[lena-i]>9+48)
                {
                    tmp = 1;
                    sum[lena-i] = ((int)sum[lena-i]-48)%10+48;
                }
                else
                {
                    tmp = 0;
                }
            }
            if(tmp==0)
                printf("%s + %s = %s\n", a, b, sum);
            else
                printf("%s + %s = %d%s\n", a, b, tmp,sum);
            
        }else{
            int lena = (int)strlen(a);
            int lenb = (int)strlen(b);
            char sum[lenb+1];
            sum[lenb]='\0';
            for (int i =1; i<=lenb  ; i++ ) {
                
                if(lena == lenb)
                {
                    sum[lenb-i] =  a[lena-i]+b[lenb-i]-48+tmp;
                }
                else{
                    if (lena-i>=0) {
                        sum[lenb-i] =  a[lena-i]+b[lenb-i]-48+tmp;
                    }
                    else
                        sum[lenb-i] =  b[lenb-i]+tmp;
                }
                
                if(sum[lenb-i]>9+48)
                {
                    tmp = 1;
                    sum[lenb-i] = ((int)sum[lenb-i]-48)%10+48;
                }
                else
                {
                    tmp = 0;
                }
            }
            if(tmp==0)
                printf("%s + %s = %s\n", a, b, sum);
            else
                printf("%s + %s = %d%s\n", a, b, tmp,sum);
        }
        if(x!=n)putchar('\n');
    }
    return 0;
}

