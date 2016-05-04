//
//  main.cpp
//  2022
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

   
    int MM[100][100], x, y , value, indexX = 0, indexY=0;
    while (std::cin>>x >> y) {
        value = 0;
        
        for (int i = 0 ; i<x; i++) {
            for (int j = 0 ; j<y; j++) {
                
                std::cin>>MM[i][j];
                if (i == 0 && j ==0) {
                    value =MM[i][j];
                    indexX = 0;
                    indexY = 0;
                }
                else
                {
                    if (abs(value)<abs(MM[i][j])) {
                        value =MM[i][j];
                        indexX = i;
                        indexY = j;
                    }
                    
                }
            }
        }
        std::cout<<indexX+1 <<" "<<indexY+1<<" "<<value<<std::endl;
    }
    return 0;
}

