//
//  main.c
//  _7.6.1_Factorial
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
long f1(int);

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int  n;
    long sum;
    
    puts("plase input a integer value : ");
    scanf("%d",&n);
    sum =f1(n);
    printf("%d! is : %ld\n", n, sum);
    
    return 0;
}

long f1(int n )
{
    if(n==1)
        return 1;
    else
        return f1(n-1)*n;
}