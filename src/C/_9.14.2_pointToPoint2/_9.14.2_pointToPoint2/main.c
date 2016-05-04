//
//  main.c
//  _9.14.2_pointToPoint2
//
//  Created by Owen on 14-12-26.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int a[] ={1,3,4,5,6};
    int *pa[] = {a, a+1,a+2,a+3,a+4 }; //数组内容只能存放地址哦。
    
    int **p, n = 5;
    p = pa;
    for (int i = 0 ; i < n; i++) {
        printf("%d\n", **(p+i)); //使用*p先取出的地址，然后*(*p)在取值
    }
    
    //这么说，其实二维数组就是个指向指针的指针
    
    return 0;
}

