//
//  main.cpp
//  2010
//
//  Created by Owen on 15-1-3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>
#define T 10

int main(int argc, const char * argv[])
{

    int m , n , count ;
    while (std::cin>>m>>n) {
        count =0;
        for (int i = m ; i<=n; i++) {
            int x = i , tmp =0;
            while (1) {
                tmp +=(x%10)*(x%10)*(x%10);
                x = x/T;
                if (x == 0) break;
            }
            if(i == tmp)
            {
                if (count>0) {
                    std::cout<<" ";
                }
                std::cout<<i;
                count++;
            }
        }
        if(count>0)
            std::cout<<std::endl;
        else
            std::cout<<"no"<<std::endl;
    }
    
    return 0;
}

