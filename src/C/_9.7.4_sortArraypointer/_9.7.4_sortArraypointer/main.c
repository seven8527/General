//
//  main.c
//  _9.7.4_sortArraypointer
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int * sort(int *, int);
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int p[10], n=10, *s ;// or p[10]
    //puts("plase input a number : ");
    //scanf("%d", &n);
    puts("plase input you array : ");
    for (int i = 0 ; i <n ; i++) {
        scanf("%d",p+i);
    }
    s  = sort(p, n);
    for ( int *x = s;  x< n+s; x++) { //利用指针进行循环运算
        printf("at index %ld = %d\n", (x-s), *x); //x-s 为索引下标值
    }
    
    return 0;
}

int * sort(int *p , int n ) //or int * sort(int p[], int n)
{
    int *x, *j;
    for (x = p  ;  x < n+p-1; x++) {
        for (j = x+1; j<n+p ; j++) {
            if (*x<*j) {
                int a;
                a = *x;
                *x = *j;
                *j = a;
            }
        }
        
    }
    
    return p;
}