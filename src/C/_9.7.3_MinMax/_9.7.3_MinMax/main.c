//
//  main.c
//  _9.7.3_MinMax
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

//void max_min_value(int *p, int n)//指针为参数
void max_min_value(int p[], int n)//数组为参数
{
    extern Max, Min; //声明外部变量
    
    int *x , *array_end;
    array_end = p+n;
    Max = Min = *p;
    for (x = p; x < array_end; x++) {
        Max = *x>Max? *x :Max;
        Min = *x<Min? *x :Min;
    }
    
}

int main(int argc, const char * argv[])
{
    extern Max, Min; //声明外部变量
    // insert code here...
//    printf("Hello, World!\n");
    int a[10], n;
    puts("plase input 10 integer value : ");
    for (int i = 0; i <10 ;  i++) {
        scanf("%d",a+i);// or &a[i]
    }
    max_min_value(a, 10);
    printf("Max = %d, Min = %d \n", Max, Min);
    
    return 0;
}




int Max, Min; //外部变量