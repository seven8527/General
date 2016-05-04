//
//  main.cpp
//  2003
//
//  Created by Owen on 14-12-31.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{
    double a;
    while (std::cin>>a) {
        a =  a>0? a : (a*-1);
        printf("%.2lf\n", a);
    }
   
    return 0;
}

