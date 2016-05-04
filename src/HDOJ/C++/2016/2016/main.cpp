//
//  main.cpp
//  2016
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    long arr[101], n , indexMin, min=0;
    while (std::cin>>n) {
        if(n==0)break;
        indexMin =0, min = 0;
        for (int i =0; i <n; i++) {
            std::cin>>arr[i];
            if(i ==0) min =arr[i];
            else
            {
                if (min>=arr[i]) {
                    min = arr[i];
                    indexMin = i;
                }
//                min = min>arr[i]? arr[i]:min;
//                indexMin = min>arr[i]? i:min;
            }
            
        }
        
        arr[indexMin] = arr[0];
        arr[0] = min;
        for (int j = 0; j < n; j++) {
            if (j!=0) {
                std::cout<<" ";
            }
            std::cout<<arr[j];
        }
        std::cout<<std::endl;
    }
    return 0;
}

