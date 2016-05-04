//
//  main.cpp
//  2009
//
//  Created by Owen on 15-1-3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>
#include <math.h>


int main(int argc, const char * argv[])
{

    int n ,m ;
    double mnext, sum;
    while (std::cin>>n>>m) {
        sum =mnext= n;
        if(m>=1)
        {
            for (int i =1; i<m; i++) {
                mnext =sqrt(mnext);
                sum +=mnext;
            }
        }
//        std::cout<<sum<<std::endl;
        printf("%.2lf\n",sum);
    }
    
    return 0;
}

