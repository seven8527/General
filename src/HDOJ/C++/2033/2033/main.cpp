//
//  main.cpp
//  2033
//
//  Created by Owen on 15-1-6.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    
    int ah,am,as, bh,bm,bs, n;
    std::cin>>n;
    for (int i =0; i<n; i++) {
        std::cin>>ah>>am>>as>>bh>>bm>>bs;
        as += bs;
        if (as>59) {
            as-=60;
            am+=1;
        }
        am+=bm;
        if (am>59) {
            am-=60;
            ah+=1;
        }
        ah +=bh;
        std::cout<<ah<<" "<<am<<" "<<as<<std::endl;
    }
    return 0;
}

