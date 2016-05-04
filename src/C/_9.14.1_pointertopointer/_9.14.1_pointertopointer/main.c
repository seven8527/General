//
//  main.c
//  _9.14.1_pointertopointer
//
//  Created by Owen on 14-12-26.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
   char *name[]={"Follow me","BASIC","Great Wall","FORTRAN","Computer desighn"};
    char ** p;
//    *p = name;
    for (int i = 0; i < 5; i++) {
        p=name; //指向指针的指针， name 其实就是指向指针的指针，因为指针的每一项首地址都是个指针，而其内容确是个字符串，**p ,*p代表每一个指针，其实代表每一个字符串， **p则代表该二维数组的值
        puts(*(p+i));
    }
    return 0;
}

