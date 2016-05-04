//
//  main.c
//  _8.5.1_ifdef
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
#define DEBUG  0

int main(int argc, const char * argv[])
{

    // insert code here...
    printf("Hello, World!\n");
#if DEBUG
    printf("debug is opened!\n");
#else
    printf("debug is closed!\n");
#endif
    
    
#ifdef DEBUG
    printf("opened debug\n");
#else 
    printf("closed debug\n");
#endif
    
    return 0;
}

