//
//  main.c
//  _6.1.2_outputMax
//
//  Created by Owen on 14-12-23.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

/**
 * 选取输入的十个数中最大的输出
 */

int main(int argc, const char * argv[])
{
    
    int a[10], max = -65535;
    printf("plase input 10 integer value : ");
    for (int i =0;  i<10; i++) {
        scanf("%d",&a[i]);
        max = max>a[i]? max: a[i];
        
    }
    
    printf("Max in input is %d \n", max);
    
    return 0;
}

