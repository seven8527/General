//
//  main.c
//  _9.9.1_pointerString
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

void print1();
void print2();
void print3();

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    print1();
    print2();
    print3(5);
    return 0;
}

void print1()
{
    char a[] = "hello china!"; //字符串常量可以直接赋值给 char类型的 数组
    puts(a);
}

void print2()
{
    char *pStr ;
    pStr = "hello china too!"; //字符串常量可以直接赋值给 指针，
    puts(pStr);
}

void print3(int n ) //输出字符串前n个字符以后的字符
{
    char *pStr ="hello china again, guys!";
    char a[] = "hello china i`m coming !";
    char *pTmp = a;
    
    pStr +=n;
    puts(pStr);
    
    puts(pTmp+n);

}