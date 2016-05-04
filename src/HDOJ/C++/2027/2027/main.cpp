//
//  main.cpp
//  2027
//
//  Created by Owen on 15-1-5.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

   
    int n ;
    char ch[100];
    while (std::cin>>n) {
        getchar();
        for (int x = 1; x<=n; x++) {
            gets(ch);
            int counta=0,counte=0,counti=0,counto=0,countu=0;
            
            for (int i = 0; ch[i]!='\0'; i++) {
                switch (ch[i]) {
                    case'a':
                        counta++;
                        break;
                    case'e':
                        counte++;
                        break;
                    case'i':
                        counti++;
                        break;
                    case'o':
                        counto++;
                        break;
                    case'u':
                        countu++;
                        break;
                        
                    default:
                        break;
                }
            }
            std::cout<<"a:"<<counta<<std::endl;
            std::cout<<"e:"<<counte<<std::endl;
            std::cout<<"i:"<<counti<<std::endl;
            std::cout<<"o:"<<counto<<std::endl;
            std::cout<<"u:"<<countu<<std::endl;
            if (x !=n) {
                std::cout<<std::endl;
            }

        }
    }
    return 0;
}

