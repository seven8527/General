//
//  main.c
//  _9.13.2_pointerarrayaspmar
//
//  Created by Owen on 14-12-26.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

void sorts(char *a[], int n)
{
    for (int i = 0; i < n-1 ; i++) {
        char ch[20], *p = ch;
        for (int j = i +1; j < n; j++) {
            
            if(strcmp(*(a+i), *(a+j))>0 )
            {
                //头大了。作为指针数组，数组的每个元素都是指针值，当你要拷贝两个字符串的时候需要传入其指针那么，到这个地方的时候，我们就应该吧两个数组元素取出来，将他们的地址传入strcpy
                //直接传入值是错误的，不能用*取值哦。
//                strcpy(p, &(a[i]));
//                strcpy(&(a[i]) , &(a[j]));
//                strcpy(&(a[j]), p);
                strcpy(p, (a+i));
                strcpy((a+i), (a+j));
                strcpy((a+j), p);
                
//                p = a[i];
//                a[i] = a[j];
//                a[j] = p;
            }
        }
    }
    
}
void print(char *a[], int n ){
    for (int i = 0 ; i<n; i++) {
        puts(*(a+i)); //puts(a[i]);
    }
}

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    static char *name[]={ "CHINA","AMERICA","AUSTRALIA","FRANCE","GERMAN"};
    int n = 5;
    sorts(name, n);
    print(name, n);
    return 0;
}

