//
//  main.cpp
//  1008
//
//  Created by Owen on 14-12-31.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
//    std::cout << "Hello, World!\n";
    int iArr[100],n,sum;
    while (std::cin>>n) {
        if(n ==0)return 0;
        int i = 0;
        sum = 0;
        for (;  i < n ; i ++) {
            std::cin>>iArr[i];
            if (i>0) {
                if(iArr[i]-iArr[i-1]>0)
                        sum +=(iArr[i]-iArr[i-1])*6;
                else
                        sum +=(iArr[i]-iArr[i-1])*-4;
            }
            else
               sum += iArr[i]*6;
            
        }
        sum += i*5;
        std::cout<<sum<<std::endl;
    }
    return 0;
}

