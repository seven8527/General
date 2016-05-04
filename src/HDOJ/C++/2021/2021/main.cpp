//
//  main.cpp
//  2021
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    
    int n ,x ,count ;
    while (std::cin>> n) {
        if(n ==0) break;
        
        count = 0;
        for (int i = 0; i<n; i++) {
            std::cin>>x;
            int t100 = x/100;
            x = x%100;
            int t50 = x/50;
            x = x%50;
            int t10 = x/10;
            x = x%10;
            int t5 = x/5;
            x = x%5;
            int t2 = x/2;
            x = x%2;
            int t1 =x;
            count +=t100+t50+t10+t5+t2+t1;
//            std::cout<<count<<std::endl;
        }
        std::cout<<count<<std::endl;
    }
    return 0;
}

