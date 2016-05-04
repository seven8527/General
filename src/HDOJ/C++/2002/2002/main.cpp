//
//  main.cpp
//  2002
//
//  Created by Owen on 14-12-31.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>
#define PI 3.1415927


int main(int argc, const char * argv[])
{
    
    double a, area;
    while (std::cin>>a) {
        area =(PI*a*a*a*4)/3;
        printf("%.3lf\n", area);
    }
    return 0;
}

