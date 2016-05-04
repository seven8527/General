//
//  main.cpp
//  1004
//
//  Created by Owen on 14-12-30.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
//    std::cout << "Hello, World!\n";
    int n, count, lastcount  ;
    char pColor[1000][15], *str = NULL;
    while(std::cin>>n)
    {
        if (n!=0) {
            lastcount = 0;
            for (int i = 0; i <n; i++) {
                std::cin>>pColor[i];
                count =0;
                if(i==0) str = pColor[i];
                for (int j =0; j< i; j++) {
                   if(strcmp(pColor[i], pColor[j])==0)
                   {
                       count ++;
                   }
                }
                if(lastcount < count)
                {
                    lastcount = count;
                    str = pColor[i];
                }
            }
            puts(str);
        }
        else{
//            puts("0");
            break;
        }
    }
    return 0;
}

