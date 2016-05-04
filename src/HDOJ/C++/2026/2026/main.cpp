//
//  main.cpp
//  2026
//
//  Created by Owen on 15-1-5.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{
    char ch[100];
    while (gets(ch)!=NULL) {
        for (int i = 0; ch[i]!='\0'; i++) {
            if ( i ==0 ) {
                std::cout<<(char)toupper(ch[i]);
            }
            else{
                if (ch[i-1]==' ') {
                    std::cout<<(char)toupper(ch[i]);
                }
                else{
                    std::cout<<ch[i];
                }
                
            }
        }
        std::cout<<std::endl;
    }

    return 0;
}

