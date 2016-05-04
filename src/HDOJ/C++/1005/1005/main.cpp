//
//  main.cpp
//  1005
//
//  Created by Owen on 14-12-31.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>
int static a, b ,x[100];

int main(int argc, const char * argv[])
{

    int n, sums;
    while (std::cin>>a>>b>>n) {
        if (a==0&&b==0&&n==0) {
            break;
        }
        
        x[1]=x[2]=1;
        int t = 3;
        for (t; t<100;t++) {
            x[t] = (a*x[t-1]+b*x[t-2])%7;
            if (x[t]==x[2] && x[t-1]==x[1]) break;
                
        }
        n = n%(t-2);
        
        
        if(n ==0)
            sums= x[t-2];
        else
            sums=   x[n];
       printf("%d\n",sums);
        
    }
    return 0;
}
