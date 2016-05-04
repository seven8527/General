//
//  main.c
//  _12.4.1_FILE
//
//  Created by Owen on 14-12-30.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

static  char * PATH ="/Users/owen/Desktop/1.txt";
void fgetcs()
{
    FILE *file;
    char str[20] ;
    file = fopen("/Users/owen/Desktop/1.txt", "rb");
    if(file == NULL)
    {
        puts("文件读取失败");
    }
        char a = fgetc(file);
        while (a !=EOF) {
            putchar(a);
            a = fgetc(file);
        }
        fgets(str, 20, file );
        puts(str);
        puts("\nfile read EOF");
        fclose(file);
    
    
}
void fappend()
{
    FILE* file;
    file = fopen(PATH, "a");
    if(file == NULL)
    {
        puts("文件打开失败！");
    }
    fputc('\n', file);
    fputs(PATH, file);
    fclose(file);
}
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    fappend();
    fgetcs();
    
    return 0;
}

