//
//  main.cpp
//  2012
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>
#include <math.h>

int main(int argc, const char * argv[])
{

    int  x,y,flag;
    while (std::cin>>x>>y) {
        
        flag = 0;
        if(x==0&&y==0)break;
        for (int  i= x; i<=y; i++) {
            int sum = i*i+i+41;
            for(int j = 2;j <=sqrt(sum); j++) {
                if (sum%j==0) {
                    flag =1;
                }
            }
        }
        
        if(!flag)
        {
            std::cout<<"OK"<<std::endl;

        }
        else{
            std::cout<<"Sorry"<<std::endl;
           
        }
        
    }
    return 0;
}

