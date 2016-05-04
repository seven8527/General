//
//  main.c
//  _8.3.1_compareABuseDefine
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
#define  MAX(a, b) a>b?a:b
#define PU puts
#define SC scanf
#define PR printf

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int a, b;
    
    PU("plase input two value : ");
    SC("%d,%d", &a, &b);
    PR("%d and %d Max is %d\n", a, b ,MAX(a, b));
    
    return 0;
}

