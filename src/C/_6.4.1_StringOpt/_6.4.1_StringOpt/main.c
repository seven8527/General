//
//  main.c
//  _6.4.1_StringOpt
//
//  Created by Owen on 14-12-23.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    //1. puts 2.gets 3.strcat 4.strcmp 5.strlen 6.strcpy
    
    char ch[20];
    printf("plase input a String : ");
    
    gets(ch);
    puts(ch);
    
    char ch1[] = "you input : ";
    strcat(ch1 ,ch );
    
    puts(ch1);
    
    printf("%d\n",strcmp(ch1, ch));
    
    printf("%d\n", strlen(ch));
    
    strcpy(ch1, ch);
    puts(ch1);
    
    printf("%s\n",  strstr(ch1,ch));
    return 0;
}

