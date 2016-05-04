//
//  main.cpp
//  2001
//
//  Created by Owen on 14-12-31.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>
#include <math.h>

int main(int argc, const char * argv[])
{

   
    float x1, y1, x2, y2, sum;
    while (std::cin>>x1>>y1 >>x2 >>y2) {
        sum =sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
        printf("%.2f\n", sum);
    }
    return 0;
}

