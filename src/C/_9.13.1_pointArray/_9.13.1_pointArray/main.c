//
//  main.c
//  _9.13.1_pointArray
//
//  Created by Owen on 14-12-26.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{
    int a[2][3]={{1,3,4},{6,9,10}}; //二维数组
    int *pa[2] ={a[0],a[1]}; //指针类型的数组， 该数组中得内容为指针：每一个数组的首地址
    int *p = a[0], i;
    
    
    for ( i = 0 ; i<2; i++) {
        printf("%d,%d,%d\n", a[i][0],*(a[i]+1), *(*(a+i)+2) );
        //1,通过下标取值， 2，通过第一个元素去首地址，在计算地址取元素 3. 纯粹的去地址，先计算列地址。在计算行地址
        
    }
    
    for (i = 0; i< 2; i++) {
        printf("%d,%d,%d\n", *pa[i], (&p+i)[1][1],*(pa[i]+2));
        //1，通过去首地址再获得元素。2，这个把我自己也高糊涂了。
        //3，先通过下标取列地址，再通过计算行地址。最后去元素。
        
        printf("%d,%d,%d\n",*pa[i],p[i],*(p+i));//例子就是一堆狗屎
    }

    // insert code here...
//    printf("Hello, World!\n");
    return 0;
}

