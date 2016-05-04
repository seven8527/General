//
//  main.cpp
//  2006
//
//  Created by Owen on 15-1-3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
//    std::cout << "Hello, World!\n";
    long n,x, sum;
    
    while (std::cin>>n) {
        sum = 1;
        for (int i =0; i<n; i++) {
            std::cin>>x;
            sum =x%2==0? sum :sum*x;
        }
        std::cout<<sum<<std::endl;
    }
    return 0;
}

