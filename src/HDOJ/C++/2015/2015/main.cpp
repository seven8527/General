//
//  main.cpp
//  2015
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    int n ,m ,sum ;
    while (std::cin>>n >> m) {
        int tmp=0;
        sum = 0;
        for (int i = 1; i<=n; i++) {
            sum += i*2;
            tmp++;
            if(tmp == m)
            {
                sum = sum/m;
                if(i!=m) std::cout<<" ";
                std::cout<<sum;
                sum = 0;
                tmp =0;
            }
           
            
            if (i == n) {
                if (tmp!=m&& tmp!=0) {
                    sum = sum/tmp;
                    if(i!=m) std::cout<<" ";
                    std::cout<<sum;
                }
                std::cout<<std::endl;
            }
        }
    }
    return 0;
}

