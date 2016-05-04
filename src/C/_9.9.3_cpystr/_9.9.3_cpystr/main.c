//
//  main.c
//  _9.9.3_cpystr
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>



char * cpystr(char * des, char *src)
{
    char *p = des;
    while ((*des = *src)!='\0') {
        des++;
        src++;
    }
//    puts(p);
    return p;
}

char * cpystr1(char * des, char *src)
{
    char *p =des;
    while (*des++==*src++) {
        
    }
    return p;
}

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    char desch[20], srcch[20] , *pdes = desch, *psrc = srcch;
    puts("plase input two string : ");
    scanf("%s", pdes);
    scanf("%s", psrc);
//    puts(pdes);
//    puts(psrc);
    
//    pdes = cpystr(pdes, psrc);
    puts("the des str is :");
    puts( cpystr(pdes, psrc));
//    pdes = cpystr(char *des, char *src)
    puts( cpystr1(pdes, psrc));
    
    return 0;
}

