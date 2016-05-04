//
//  main.c
//  _7.9.1_autoRegisterStaticExten
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

long autoType(int n)
{
    puts("=======auto=========");
    auto long x=1;
    for (int i=1; i<=n; i++) {
        x*=i;
    }
    printf("%d! is %ld\n", n, x  );
    return x;
}

long registerType(int n)
{
    puts("=======register======");
    register long x  =1;
    for (int i =1 ; i<=n; i++) {
        x*=i;
    }
    printf("%d! is %ld\n", n, x  );
    return x;
}


long staticType(int n)
{
    puts("=======static======");
    static long x  =1;
    for (int i =1 ; i<=n; i++) {
        x*=i;
    }
    printf("%d! is %ld\n", n, x  );
    return x;
}
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    for (int i =1; i<5; i++) {
        autoType(i);
        
    }
    
    
    for (int i =1; i<5; i++) {
        registerType(i);
        
    }
    
    
    
    for (int i =1; i<5; i++) {
        staticType(i);
        
    }

    
    extern A, B;
    
    printf("A x B = %d\n",A*B);
    return 0;
}



int A = 19, B = 23;
