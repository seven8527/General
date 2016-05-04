//
//  main.cpp
//  2018
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>
#define MAXN    (56)

#define DB  /##/

int can[MAXN] = {0, 1, 1, 1, 1}, cow[MAXN] ;

int main(int argc, const char * argv[])
{

    
    int i, n ;
    // 计算第i年有多少头可生育的母牛
    for (i = 5 ; i <= 55 ; ++i)
        can[i] = can[i-1] + can[i-3] ;
    
    // 根据今年可生育的母牛数，和上一年的总牛数，可以算出今年的总牛数。
    cow[0] = 0 ;
    for (i = 1 ; i <= 55 ; ++i)
        cow[i] = cow[i-1] + can[i] ;
    while (scanf("%d", &n), n)
    {
        printf ("%d\n", cow[n]) ;
    }
    return 0 ;

    return 0;
}

