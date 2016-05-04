//
//  main.c
//  _8.3.2_Define(a, b)
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
#define  XX(x)  x*x //宏定义的时候。参数必须或者尽量括起来。不然替换的时候有可能出错哦

#define  X(x) (x)*(x)

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");\n,
    
    int x ;
    puts("plase input a value : ");
    scanf("%d", &x);
    printf("%d^%d is %d\n", x,x,XX(x+1));
    printf("%d^%d is %d\n", x,x,X(x+1));
    return 0;
}

