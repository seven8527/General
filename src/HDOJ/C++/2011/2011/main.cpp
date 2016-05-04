//
//  main.cpp
//  2011
//
//  Created by Owen on 15-1-3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    int n , a ;
    double sum ;
    std::cin>>n;
    for (int i =0 ; i<n; i++) {
        std::cin>>a;
        sum = 0;
        float flag =-1.0;
        for (int j =1; j<=a; j++) {
            flag  =flag* (-1.0);
            sum += flag/j;
        }
        printf("%.2lf\n",sum);
    }
    return 0;
}

