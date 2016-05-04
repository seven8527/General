//
//  main.c
//  _6.1.3_SortArray
//
//  Created by Owen on 14-12-23.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    int a[10];
    
    printf("plase input 10 value : ");
    
    for (int i =0; i< 10; i++) {
        scanf("%d", &a[i]);
    }
    
    for (int j = 0 ; j<10-1 ; j++) {
        for (int k=j+1; k<10 ; k++) {
            if (a[j]<a[k]) {
                int temp = a[j];
                a[j] = a[k];
                a[k] = temp;
            }
        }
    }
    
    for (int i =0; i<10; i++) {
        printf("a[%d] = %d \n", i, a[i]);
    }
    return 0;
}

