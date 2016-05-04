//
//  main.cpp
//  2004
//
//  Created by Owen on 14-12-31.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    float score;
    while (std::cin>> score) {
        if(score>=90&& score<=100)
        {
            std::cout<<"A"<<std::endl;
        }else if (score>=80 && score <=89)
        {
            std::cout<<"B"<<std::endl;
        }else if (score>=70 && score <=79)
        {
            std::cout<<"C"<<std::endl;
        }else if (score>=60 && score <=69)
        {
            std::cout<<"D"<<std::endl;
        }
        else if (score>=0 && score <=59)
        {
            std::cout<<"E"<<std::endl;
        }else
        {
            std::cout<<"Score is error!"<<std::endl;
        }
        
    }
    return 0;
}

