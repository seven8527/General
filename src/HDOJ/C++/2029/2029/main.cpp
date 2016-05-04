//
//  main.cpp
//  2029
//
//  Created by Owen on 15-1-5.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

   
    int n;
    char ch[100];
    std::cin>>n;
    for (int i = 0; i<n; i++) {
        if(i==0)getchar();
        gets(ch);
        bool  flag = true;
        unsigned long len = strlen(ch);
        for (int j=0 ; j < len/2; j++) {
            if (ch[j]!=ch[len-j-1]) {
                flag = false;
            }
            
        }
        if (flag) {
            std::cout<<"yes"<<std::endl;
        }
        else
        {
            std::cout<<"no"<<std::endl;
        }
    }
    return 0;
}

