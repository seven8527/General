//
//  main.c
//  _9.9.2_findacharK
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

void findK(char *);
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    char *p, ch[100];
    puts("plase input a string : ");
    p=ch;
    scanf("%s", p); //此处不能直接使用 scanf("%s",p);因为p目前为空指针，为指向任何内存地址，要使用必须先进行初始化。比如将p = ch; 提前即可
//    p = ch;
    findK(p);
    
    return 0;
}

void findK(char *pStr)
{
    long len ;
    int flag = 0;
    len = strlen(pStr);
    for (int i = 0 ; i<len; i++) {
        if ('k'== *(pStr+i)) {
            puts("find the char K index of :");
            printf("%d \n", i);
            flag += 1;
        }
//        else
//            puts("sorry could not find char K! finished it！");
    }
    if(!flag)
    puts("sorry could not find char K! finished it！");
    else
        printf("total find %d K in the string !\n", flag);
}