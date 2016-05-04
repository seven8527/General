//
//  main.c
//  _9.4.2_MaxAndMin
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int a, b, c, *pMin, *pMax;
    puts("plase input a, b, c :");
    scanf("%d %d %d", &a, &b, &c);
    
    pMax = a>b ? &a : &b; //将较大的赋值给Pmax ，地址哦
    pMin = a<b ? &a : &b; //将较小的地址赋值给pMin

    pMax = *pMax>c ? pMax :&c;
    pMin = *pMin<c ? pMin :&c;  //在次比较，因为不是两个数在比较
    
    printf("Max = %d, Min = %d \n", *pMax, *pMin);
    
    return 0;
}

