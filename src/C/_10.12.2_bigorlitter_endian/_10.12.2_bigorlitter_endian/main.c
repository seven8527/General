//
//  main.c
//  _10.12.2_bigorlitter_endian
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
typedef unsigned char TYPE;

/* 看看0x1234abcd 在内存中怎样表示的
        0x0001 0x0002 0x0003 0x0004
big     0x12   0x34   0xab   0xcd
letter  0xcd   0xab   0x34   0x12
*/
void test_endian1() //利用指针，对大端小端进行判断
{
    int num =0 , *p; //定义个指针，指向整形
    p = &num;
    *(TYPE *)p =0xff; //将指针的首地址赋值为：0xff
    if(num ==0xff) //如果是正向增长的就是大端
    {
        puts("cpu big endian model !");
    }else{ //num == 0xff000000 反向增长则是小端
        puts("cpu litter endiam model !");
    }
    
}

void test_endian2() //通过联合体的特性来判断大端小端
{
    union uns{
        int ia;
        char ch;
    } uns;
    uns.ia = 0;
    uns.ch = 1; //由于公用的是相同的内存地址，这样以来可以ch其实占用了ia得首地址，打印出ia就可以看出他是真么增长的
    if (uns.ia == 1) {
        puts("cpu big endian model !");
    }
    else{
        puts("cpu litter endian model !");
    }
}

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    test_endian1();
    test_endian2();
    return 0;
}

