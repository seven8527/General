//
//  main.c
//  _9.7.2_changeArray
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>


int * changeArray(int *p)
{
    //    int a[20];
    for (int i = 0 ; i < 10/2; i++) {
        int a;
        a= *(p+i);
        *(p+i) = *(p+9-i);
        *(p+9-i) = a;
    }
    return p;
}
int main(int argc, const char * argv[])
{
    
    // insert code here...
    //    printf("Hello, World!\n");
    int a[10], *p;
    
    puts("plase input 10 integer value : ");
    for(int i = 0; i <10 ; i++)
    {
        scanf("%d",a+i);
    }
    p = changeArray(a);
    for (int j = 0 ; j < 10; j++) {
        printf("a[%d] = %d \n", j , *(a+j));
    }
    return 0;
}


