//
//  main.cpp
//  2034
//
//  Created by Owen on 15-1-6.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    int n, m, nArr[1000], mArr[1000];
    while (std::cin>>n >>m) {
        if (n==0&&m==0) {
            break;
        }
        for (int i =0; i<n; i++) {
            std::cin>>nArr[i];
        }
        for (int j=0; j<m; j++) {
            std::cin>>mArr[j];
            
        }
        int x =0,s[1000];
        for (int i =0; i <n; i++) {
            bool flag = true;
            for (int j =0; j<m; j++) {
                if (nArr[i]==mArr[j]) {
                    flag = false;
                }
            }
            if (flag) {
                
                s[x]=nArr[i];
                if (x >0) {
                    for (int ii = 0; ii<x; ii++) {
                        if (s[ii]>s[x]) {
                            int p = s[x];
                            for (int xx = x; xx>ii; xx--) {
                                s[xx] =s[xx-1];
                            }
                            s[ii]=p;
                        }
                    }
                }
               
                x++;
            }
        }
        if (x ==0) {
            std::cout<<"NULL"<<std::endl;
        }
        else
        {
            for (int i =0; i<x; i++) {
                std::cout<<s[i]<<" ";
                
            }
            std::cout<<std::endl;
        }
    }
    return 0;
}

