//
//  main.c
//  _9.15.1_printMain
//
//  Created by Owen on 14-12-26.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>


/*****************总结指针*************************
int i;	 定义整型变量i
int *p	 p为指向整型数据的指针变量
int a[n];	 定义整型数组a，它有n个元素
int *p[n];	 定义指针数组p，它由n个指向整型数据的指针元素组成
int (*p)[n];	 p为指向含n个元素的一维数组的指针变量
int f();	 f为带回整型函数值的函数
int *p();	 p为带回一个指针的函数，该指针指向整型数据
int (*p)();	 p为指向函数的指针，该函数返回一个整型值
int **p;	 P是一个指针变量，它指向一个指向整型数据的指针变量

**********************************************/
//c语言的main函数被规定：包括两个参数 一个int 值 一个char类型的指针数组
//argc 代表参数的个数， argv[]代表存放 参数的指针数组
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    //如何来打印main 函数的参数呢？
    
//    哈哈牛B的地方来了@@@
    while (argc-->1) {
        puts(*argv++);
    }
    
    //草，看不懂了吗？
//    1，哈哈，argc-- 代表运算完成后argc自减一，如果其大于1 继续打印
//    2，打印argv的值，通过指针的运算找出地址先，然后*取其值打印。
//    3，至于为什么要先进行自增呢？好吧，被娱乐了，放在后面++才是对的。
    return 0;
}

