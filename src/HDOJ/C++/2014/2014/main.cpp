//
//  main.cpp
//  2014
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{
    int n ;
    double avge,max = 0.0, min = 0.0, x;
    while (std::cin>>n) {
        avge = 0;
        for (int i =0; i < n ; i++) {
            std::cin>>x;
            if(i ==0)
            {
                max = min = x;
            }
            else{
                max = max<x ? x:max;
                min = min>x ? x:min;
            }
            avge += x;
        }
        avge = (avge - max - min)/(n-2);
        printf("%.2lf\n", avge);
    }
    return 0;
}

