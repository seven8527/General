//
//  main.c
//  _6.3.1_CharArray
//
//  Created by Owen on 14-12-23.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    char a[][5]={{'A','B','C','D','E'},{'I','V','Y','O','U'}};
    for(int i =0; i<2; i++)
    {
        for (int j =0 ; j<5; j++) {
            printf("%c",a[i][j]);
        }
        putchar('\n');
    }
    
    return 0;
}

