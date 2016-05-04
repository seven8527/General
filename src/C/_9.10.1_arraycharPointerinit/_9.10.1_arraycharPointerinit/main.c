//
//  main.c
//  _9.10.1_arraycharPointerinit
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    char a[] = "helllo ", *p = "china", strch[]={"guys"}, testch[20];
//    testch ={"sdd "}; //字符串数组不能这样赋值
//    testch = "sdfsldf  ";//然而字符串数组也不能自己用常量字符串赋值
//    testch = {'1','e','e'};//也不能这样赋值了，
    //究其原因，字符串数组的地址其实是const 的类型，一旦分配后就不能改变其内容了。只能往其开辟的内存中填充数据
    
    puts(a);
    puts(p);
    puts(strch);
    puts(testch);
    return 0;
}

