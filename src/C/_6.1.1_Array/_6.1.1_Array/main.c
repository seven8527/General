//
//  main.c
//  _6.1.1_Array
//
//  Created by Owen on 14-12-23.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    
    int a[10];
    for (int i =0; i<10; i++) {
        a[i] = i;
        
    }
    
    for (int j = 9; j>=0; j--) {
        printf("a[%d] = %d \n", j, a[j]);
        
    }
    return 0;
}

