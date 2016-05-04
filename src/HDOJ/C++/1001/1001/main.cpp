//
//  main.cpp
//  1001
//
//  Created by Owen on 14-12-30.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>
using namespace std;

int main(int argc, const char * argv[])
{
    unsigned a, sum;
    while(scanf("%d", &a)!=EOF)
    {
        sum = 0;
        for (int i = 0 ; i <= a ; i++) {
            sum+=i;
        }
        printf("%d\n\n", sum);
    }
    return 0;
}

