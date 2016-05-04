//
//  main.cpp
//  2017
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    
    char ch[1024];
    int n, count;
    while (std::cin>>n) {
        for(int j = 0 ; j< n ; j++)
        {
            std::cin>>ch;
            count=0;
            for (int i = 0 ; ch[i]!='\0'; i++) {
                
                count = (ch[i]<='9' &&ch[i]>='0') ?(++count):count;
            }
            std::cout<<count<<std::endl;
        }
        
        
    }
    return 0;
}

