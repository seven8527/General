//
//  main.c
//  _10.10.1_malloc_calloc_realloc_free
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    //如何动态分配内存地址呢?好球，malloc（int size） calloc(int nsize, int size) realloc(int *p, int size);将p的内存进行重新分配，如果size=0 则释放之，
    //用完如何释放呢？ free(*p)
    int *p;
    if ((p=(int *)malloc(10*sizeof(int)))==NULL) {//分配内存大小为 整数的字宽的10倍 并将其首地址赋值给p 检查p是否是空，这样能检查是不是分配成功了。
            printf("内存分配失败");
            exit(-1);
            
    }
    for (int *i = p ; i < p+10 ; i++) { //对指针进行赋值。此处用的是指针的自增
        *i = i-p;
        
    }
    for (int i = 0 ; i <10; i++) { //打印每一个内存地址中得值
        printf("int value is : %d\n", *p);
        p++;
    }
    
    free(p=p-10);//为何要减10 ，切记指针不要随意给边其值，不然释放的时候就蛋疼了。
    
    puts("============calloc(int numsize, int size)========");
    if ((p=(int *)calloc(10, sizeof(int)))==NULL) {//分配内存大小为 整数的字宽,分配10个内存 并将其首地址赋值给p 检查p是否是空，这样能检查是不是分配成功了。
        printf("内存分配失败");
        exit(-1);
        
    }
    
    for (int *i = p ; i < p+10 ; i++) { //对指针进行赋值。此处用的是指针的自增
        *i = (i-p)*10;
        
        printf("int vaule = %d \n", *i );
    }
   
//    free(p);//如果这里释放p 那么realloc 就没法用了。你懂的。
//    或者也可以用realloc(p, 0); 来释放这个指针p;

    puts("============realloc(int numsize, int size)========");
    if ((p=(int *)realloc(p,10*sizeof(int)))==NULL) {//分配内存大小为 整数的字宽的十倍， 并将其首地址赋值给p， 检查p是否是空，这样能检查是不是分配成功了。
        printf("内存分配失败");
        exit(-1);
        
    }
    
    for (int *i = p ; i < p+10 ; i++) { //对指针进行赋值。此处用的是指针的自增
        *i = (i-p)*11;
        
        printf("int vaule = %d \n", *i );
    }
    
    free(p);
   return 0;
}

