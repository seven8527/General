//
//  main.cpp
//  2019
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
//    std::cout << "Hello, World!\n";
    int n ,x, y;
    while (std::cin>>n>>x) {
        if(n==0&&x==0)break;
        int flag = 0;
        for (int i =0; i<n; i++) {
            std::cin>>y;
            if (i !=0) {
                
                if (y>x&& flag ==0) {
                    std::cout<<" "<<x;
                    flag =1;
                }
                
                std::cout<<" "<<y;
                
                if (i == n-1&&y<x) {
                    std::cout<<" "<<x;
                }
            }
            else
            {
                if (y>x&& flag ==0) {
                    std::cout<<x;
                    flag =1;
                }
                if (flag) {
                    std::cout<<" ";
                }
                std::cout<<y;
            }
            
        }
        std::cout<<std::endl;
    }
    return 0;
}

