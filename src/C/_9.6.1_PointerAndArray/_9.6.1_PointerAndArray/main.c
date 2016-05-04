//
//  main.c
//  _9.6.1_PointerAndArray
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

void printfArray1(int a[])
{
    puts("use a[]\n");
    for (int i = 0 ; i<7 ; i++) {
        printf("a[%d] = %d \n", i , a[i]); //普通数组的查找方式
    }
}

void printfArray2(int a[])
{
    int *p =a;
    puts("use *p ; p=a\n");
    for (int i = 0 ; i< 7; i++) {
        printf("a[%d] = %d \n", i, *(p+i)); //通过数组的指针查找元素
    }
}

void printfArray3(int a[])
{
    puts("use *a\n"); //通过数组的名字。也就是首地址来查找数组元素
    for (int i =0 ; i <7 ; i++) {
        printf("a[%d] = %d \n", i , *(a+i));
    }
}
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int  a [] ={1,2,3,4,5,6,7 }; //定义数组并初始化。
    
    printfArray1(a);
    printfArray2(a);
    printfArray3(a);
    
    /*
    
    3) 从上例可以看出，虽然定义数组时指定它包含10个元素，但指针变量可以指到数组以后的内存单元，系统并不认为非法。
    
    4) *p++，由于++和*同优先级，结合方向自右而左，等价于*(p++)。
    
    5) *(p++)与*(++p)作用不同。若p的初值为a，则*(p++)等价a[0]，*(++p)等价a[1]。
    
    6) (*p)++表示p所指向的元素值加1。
    
    7) 如果p当前指向a数组中的第i个元素，则：
    *(p--)相当于a[i--]；
    *(++p)相当于a[++i]；
    *(--p)相当于a[--i]。
*/
    return 0;
}

