//
//  main.cpp
//  2020
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>
#include <math.h>
int main(int argc, const char * argv[])
{

    int x[100], n ;
    while (std::cin>>n) {
        if (n ==0) {
            break;
        }
        for (int i =0; i<n; i++) {
            std::cin>>x[i];
            for (int j = 0; j<i; j++) {
                if(abs(x[i])>abs(x[j]))
                {
                    int t = x[i];
                    for (int z =i; z>j; z--) {
                        x[z]=x[z-1];
                    }
                    x[j]=t;
                }
            }
            
        }
        for (int i = 0 ; i<n; i++) {
            if (i !=0) {
                std::cout<<" ";
            }
            std::cout<<x[i];
        }
        std::cout<<std::endl;
    }
    return 0;
}

