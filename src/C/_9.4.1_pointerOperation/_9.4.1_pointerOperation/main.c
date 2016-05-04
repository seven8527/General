//
//  main.c
//  _9.4.1_pointerOperation
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int a, b, *pa, *pb, sum, t;
    
    puts("plase input two integer : ");
    scanf("%d %d",&a, &b);
    pa = &a;
    pb = &b;
    sum = *pa+*pb;
    t = *pa * *pb;
    printf("%d + %d = %d\n", *pa ,*pb, sum);
    printf("%d * %d = %d\n", a, b, t);
    
    return 0;
}

