//
//  main.c
//  _9.3.2_sortABCbyPointer
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

void swap(int *a, int *b)
{
    int x;
    x = *a;
    *a = *b;
    *b = x;
}

void change(int *a, int *b, int *c )
{
    if(*a<*b) swap(a, b);// 先对比数字大小。在进行交换
    if(*b<*c) swap(b, c);
    if(*a<*c) swap(a, c);
}

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int a, b, c;
    puts("plase input a, b, c :");
    scanf("%d, %d, %d",&a, &b,&c );
    
    change(&a, &b, &c);
    
    printf("sort :%d, %d, %d\n", a, b, c);
    
    return 0;
}

