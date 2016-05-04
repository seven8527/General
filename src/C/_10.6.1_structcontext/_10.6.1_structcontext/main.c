//
//  main.c
//  _10.6.1_structcontext
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
#define  NUM 3
typedef struct content contents;
struct content{
    char name[20];
    char phone[20];
};

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    
    contents content[NUM]; //定义结构体数组
    for (int i  = 0 ; i < NUM ; i++) {
        printf("plase input name : ");
        gets(content[i].name); //输入名字
        printf("plase input phone num : ");
        gets(content[i].phone); //输入手机号码
    }
    
    for (int i = 0 ; i < NUM; i++) {
        printf("name is %s, phone is %s \n", content[i].name , content[i].phone);
    }
    return 0;
}

