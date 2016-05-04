//
//  main.c
//  _6.5.3_ContryNameSort
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

// 输入五个国家的名字。按字母排序进行输出

#include <stdio.h>
void sortContryName(char name[5][20]);
int main(int argc, const char * argv[])
{

    char name[5][20];
    puts("plase input five contry`s name : ");
    for (int i ; i<5; i++) {
        gets(name[i]);
    }
    putchar('\n');
    
    sortContryName(name);
    return 0;
}

void sortContryName(char name[][20])
{
    char tmp[20];
    for (int i = 0 ; i<4; i++) {
        for (int j = i ; j<5; j++) {
            if(strcmp(name[i], name[j])>0)
            {
                strcpy(tmp, name[i] );
                strcpy(name[i], name[j]);
                strcpy(name[j], tmp);
                
            }
        
        }
        puts(name[i]);
        putchar('\n');
    }
    puts(name[4]);
    putchar('\n');
}