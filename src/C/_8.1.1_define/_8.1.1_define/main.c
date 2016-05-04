//
//  main.c
//  _8.1.1_define
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

#define  M (X*X*X*3)
#define  G 4
#define PU puts
#define SC scanf
#define PR printf

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    
    
    int sum , X;
    PU("plase input a vaule : ");
    SC("%d", &X);
    sum = G*M+M*M;
    PR("sum is %d\n", sum );
    
    return 0;
}

