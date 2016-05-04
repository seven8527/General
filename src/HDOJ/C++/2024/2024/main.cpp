//
//  main.cpp
//  2024
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>
bool test(char *ch)
{
    for (int i = 0 ; ch[i]!='\0'; i++) {
        if (i ==0) {
            if (!(ch[i] =='_'||(ch[i]>='a'&&ch[i]<='z')||(ch[i]>='A'&&ch[i]<='Z'))) {
                return false;
            }
        }
        else{
            if (!(ch[i] =='_'||(ch[i]>='a'&&ch[i]<='z')||(ch[i]>='A'&&ch[i]<='Z')||(ch[i]>='0'&&ch[i]<='9'))) {
                return false;
            }
           
        }
    }
    return  true;
}
int main(int argc, const char * argv[])
{
    int n ;
    char ch[50];
    while (std::cin>>n){
        for (int i = 0 ; i<n; i++) {
            if(i ==0) getchar();
            gets(ch);
            if (test(ch)) {
                std::cout<<"yes"<<std::endl;
            }
            else{
                std::cout<<"no"<<std::endl;
            }
        }
    }
    
    return 0;
}

