//
//  main.cpp
//  1003
//
//  Created by Owen on 14-12-30.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{
    int num ,count , mIntValue[100000], lastMax , Max, indexf=0, indexb=0, maxfu=-10000, indexfu, flag = 0;
    
    std::cin>>num;
    
    for (int t =1; t<=num; t++) {
        Max = lastMax = 0;
        std::cin>>count;
        for (int i = 0 ;  i<count; i++) {
            std::cin>>mIntValue[i];
            //            std::cout<<mIntValue[i]<<std::endl;
//            Max += mIntValue[i];
            if(count ==1)
            {
                lastMax = Max =mIntValue[0];
                indexf = 0;
                indexb = 0;
            }
            else{
                if (mIntValue[i]>=0) {
                    if (!flag) {
                        indexf = i;
                        indexb = i;
                        lastMax = Max =0;
                    }
                    flag = 1;
                    Max += mIntValue[i];
                    if(Max > lastMax)
                    {
                        lastMax = Max;
                        indexb = i;
                    }
                    
                }
                else
                {
                    indexfu = i;
                    if (maxfu<mIntValue[i]) {
                        maxfu = mIntValue[i];
                    }
                    
                }
            }
            
            
        }
        if(!flag)
        {
            lastMax = maxfu;
        }
        std::cout<<"Case "<<t<<":"<<std::endl;
        std::cout<<lastMax <<" "<<indexf+1<<" "<< indexb+1<<std::endl;
        if (t!=num) {
            std::cout<<std::endl;
        }
        
    }
    return 0;
}