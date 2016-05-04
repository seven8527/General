//
//  main.c
//  _9.11.1_functionPointer
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
void swap(int *a , int *b)
{
    int  x;
    x = *a;
    *a = *b ;
    *b = x;
}
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int *a , *b , x ,y ;
    a = &x;
    b = &y; //这个方法写得有点烂， 不对a,b指针进行初始化，也就是不给他们分配指向的地址。他们是不能用得。
    //然而这里的x, y 就有点无用了
    void (*Func)(int * , int*); // (*Func) 是函数指针，返回值为 int 参数为空 该指针其实是指向函数的指针.该函数不能实现的哦。
    Func =swap;
    puts("plase input two value : ");
    scanf("%d, %d", a, b  );
    Func(a, b);
    printf("a = %d, b = %d\n", *a , *b );
    return 0;
}

