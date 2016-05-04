//
//  main.c
//  _9.2.1_Pointer
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
    
    //变量的指针 和指针变量
    //int *p = &a; p 为指向地址为：&a的指针变量，指向的类型为：int ，p为a变量的指针

    // insert code here...
//    printf("Hello, World!\n");
    int a, b ;
    
    int *pA , *pB;//指向int类型的指针变量  ，所指向的地址为pA， 所指向的值为：*pA
    
    a  =100;
    b = 200;
    pA = &a;
    pB = &b;
    printf("a is %d\nb is %d\n", a, b);
    printf("pA is %d\npB is %d\n", *pA, *pB);
    
    return 0;
}

