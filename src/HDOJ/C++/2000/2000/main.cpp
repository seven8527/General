//
//  main.cpp
//  2000
//
//  Created by Owen on 14-12-31.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    
    char a[3];
    while (std::cin>>a[0]>>a[1]>>a[2]) {
        if (a[0]>a[1]) {
            a[0] = a[0]^a[1];
            a[1] = a[0]^a[1];
            a[0] = a[1]^a[0];
            
        }
        
        if (a[0]>a[2]) {
            a[0] = a[0]^a[2];
            a[2] = a[0]^a[2];
            a[0] = a[2]^a[0];
            
        }
        if(a[1]>a[2])
        {
            a[1] = a[1]^a[2];
            a[2] = a[1]^a[2];
            a[1] = a[2]^a[1];
            
        }
        std::cout<<a[0]<<" "<<a[1]<<" "<<a[2]<<std::endl;
    }
    return 0;
}

