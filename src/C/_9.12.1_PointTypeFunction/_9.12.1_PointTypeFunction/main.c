//
//  main.c
//  _9.12.1_PointTypeFunction
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
char * get_day(int);

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int n;
    puts("plase input a value in 1-7");
    scanf("%d", &n);
    char * ch = get_day(n);
    puts(ch);
    
    return 0;
}

char * get_day(int n){
    static  char *name[]  //可以这样理解。这个数组里面装着好多的指针
//    static char name[][]//问题来了。不知道霉个数组的元素个数，怎么办，用指针吧，爱多少个多少个。
    ={"error day", "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"};
    //*name[] 指针类型的字符串数组。 当然其实是个二维数组。可以表示成这样 name[][]的形式
    
//    return (n>7||n<1)? *name: *(name+n); //通过地址获取数组中的元素name 是该数组的首地址，*name 直接获取第一个元素， name+n 直接获取第n个元素的地址，然后通过* 取得其值 
    return (n>7 || n<1)? name[1]: name[n]; //通过下标获取元素
    
}

