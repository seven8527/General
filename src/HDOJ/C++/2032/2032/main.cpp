//
//  main.cpp
//  2032
//
//  Created by Owen on 15-1-6.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{
    int san[30][30], n[30], i=0;
    while (std::cin>>n[i]) {
        i++;
        if ( getchar()=='\n') break;
    }
    for (int a = 0; a<30; a++) {
        for (int b = 0; b<=a; b++) {
            if (b ==0||b ==a) {
                san[a][b]= 1;
                
            }
            else
            {
                san[a][b] = san[a-1][b-1]+san[a-1][b];
            }
//            std::cout<<san[a][b];
//            if (b ==a) {
//                std::cout<<std::endl;
//            }
//            else
//            {
//                std::cout<<" ";
//            }
        }
    }
    
    for (int a = 0 ; a<i; a++) {
        
        for (int p = 0; p< n[a]; p++) {
            for (int q = 0; q<p+1; q++) {
                std::cout<< san[p][q];
                if (q ==p) {
                    std::cout<<std::endl;
                }
                else
                {
                   std::cout<< " ";
                }
            }
        }
//        if (a !=i-1) {
            std::cout<<std::endl;
//        }
        
    }
    return 0;
}

