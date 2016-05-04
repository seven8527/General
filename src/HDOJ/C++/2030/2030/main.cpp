//
//  main.cpp
//  2030
//
//  Created by Owen on 15-1-5.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

bool is_zh(char p)
{
    if (~(p>>8)==0) {
        return  true;
    }
    return  false;
}
int main(int argc, const char * argv[])
{

    int n ;
    char ch[10000];
    std::cin>>n;
    for (int i = 0 ; i<n; i++) {
        
        if (i ==0) {
            getchar();
        }
        
        int count = 0;
        gets(ch);
        
        for (int j = 0; j < strlen(ch); j++) {
            if (is_zh(ch[j])) {
                ++count;
                
            }
        }
            std::cout<<count/2<<std::endl;
     }
    
    return 0;
}

