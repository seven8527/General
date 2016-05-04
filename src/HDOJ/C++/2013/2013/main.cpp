//
//  main.cpp
//  2013
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{
    int x ,sum;
    while (std::cin>>x) {
        sum =1;
        for (int i = 1 ; i<x; i++) {
            sum = (sum+1)*2;
        }
        std::cout<<sum<<std::endl;
    }
   
    return 0;
}

