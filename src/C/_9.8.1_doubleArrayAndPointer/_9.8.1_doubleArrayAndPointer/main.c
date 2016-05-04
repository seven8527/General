//
//  main.c
//  _9.8.1_doubleArrayAndPointer
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int a[2][3] = {1,2,3, 5,6,9};
    
    printf("%d\n", a[0][0]); //利用下标取 0 0 位置的值
    printf("%d\n", *(a[0]+0)); // 利用指针去0 0位置的值 ,其中a[0] 为第一行的首地址
    printf("%d\n", *(*(a+0)+0)); //a是整个二维数组的首地址， *(a+0) 是二维数组第一维的首地址，*(*(a+0)+0)是二维数组第一维的第一个地址
    
//    总之，数组不管有多少维，通过数组的名称能找到该数组的首地址， 每一维的首地址都可以用a[]表示，然后通过加下标来找到该数组
    
    printf("%d\n", *(*(a+1)+1)); // a[1][1]的值
    printf("%d\n", *(a[1]+1)); // a[1][1]的值
    printf("%d\n", *(&a[1][1])); // a[1][1]的值
    
    puts("------------address  P----------");
    //二维数组的首地址
    printf("%d\n", a);  //a[0][]的地址
    printf("%d\n", a+1); // a+1 实际上是给a 增加维度地址 1代表每个一维数组的长度
    printf("%d\n", *a); //代表a[0][0]的地址
    printf("%d\n", *a+1);//*a+1 实际上是给a增加经度   1 代表一维数组每个元素的长度
    printf("%d\n", &a); // 实际上是取a[][]的地址
    printf("%d\n", &a+1);// 增加维度和经度 实际上后面的1，代表整个数组的长度
    
    
     puts("------------address array----------");
    //取地址
    printf("%d\n", a[0]); //地址 a[0][0]的地址
   // printf("%d\n", *a[1]);
    printf("%d\n", &a[0]);// 取a[0][]的地址
    printf("%d\n", &a[0][0]);//取 a[0][0]的地址
    
    
    printf("%d\n", a+1); // 实际上是a[1][0]的地址
    printf("%d\n", *(a+1));// 等同于a[1][0]的地址
    printf("%d\n", a[1]);//a[1][0]的地址
    printf("%d\n", &a[1]);// 实际上是a[1][]的地址
    printf("%d\n", &a[1][0]);// a[1][0]的地址
    
    printf("%d\n", *(*(a+1)+1)); //实际上等于 a[1][1]的值
    
    printf("%d\n", a[1]); // a[1][0] 地址
    printf("%d\n", a[1]+1);// a[1][1] 的地址
    printf("%d\n", &a[1][1]); //
    printf("%d\n", &a[1]+1);// a[1] 实际上是a[1][0]的地址，其后加1代表一维数组的一个元素长度4， 而&a[1] 是a[1]的地址。但是后面的长度确是整个一维数组的长度，所以加1后 实际上是加上了整个一维数组的长度12
    
    return 0;
}

