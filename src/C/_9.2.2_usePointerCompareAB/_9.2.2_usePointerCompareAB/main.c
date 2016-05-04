//
//  main.c
//  _9.2.2_usePointerCompareAB
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    
    int a , b , *pA , *pB, *p;//分配内存，该内存分配在栈上
    
    puts("plase input a and b : ");
    scanf("%d, %d", &a, &b);
    pA = &a; // 赋值
    pB = &b;

    if(a<b) // 判断a 和 b的大小, 如果a小于b 将pa 和pb 的地址进行交换，也就是pa 和pb所指向的内容交换了。
    {
        p= pA;
        pA = pB;
        pB = p;
        
    }
    
    printf("you intput two value is : %d %d\n", a, b);
    printf("Max is %d Min is %d\n", *pA,*pB);
    
    return 0;
}

