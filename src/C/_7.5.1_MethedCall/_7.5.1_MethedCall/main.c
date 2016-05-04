//
//  main.c
//  _7.5.1_MethedCall
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
// 计算公式 2^2!+3^2!
long f1(long i)// 求平方
{
    return i*i;
}

long f2(long i)//求阶乘
{
    int k=1 ;
    for (int j = 1; j<=i; j++) {
        k*=j;
        
    }
    return  k;
}

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    long sum =0;
    for (int i = 2 ; i<=3; i++) {
        sum += f2(f1(i));
    }
    printf("sum is %ld\n", sum );
    
    return 0;
}


