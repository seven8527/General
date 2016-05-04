//
//  main.cpp
//  2025
//
//  Created by Owen on 15-1-5.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    char maxChar = '\0' , ch[100];
    while (std::cin>>ch) {
//        getchar();
        maxChar = '\0';
        for (int i = 0; ch[i]!='\0'; i++) {
            if (i ==0) {
                maxChar = ch[i];
            }
            else{
                maxChar = maxChar<ch[i]?ch[i]:maxChar;
            }
        }
        for (int i = 0; ch[i] !='\0'; i++) {
            std::cout<<ch[i];
            if (maxChar==ch[i]) {
                std::cout<<"(max)";
            }
        }
        std::cout<<std::endl;
    }
    return 0;
}

