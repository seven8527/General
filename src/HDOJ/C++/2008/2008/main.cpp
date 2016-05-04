//
//  main.cpp
//  2008
//
//  Created by Owen on 15-1-3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
//    std::cout << "Hello, World!\n";
    int a, b, c, n;
    double x;
    while (std::cin>>n) {
        a = b = c = 0;
        if (n ==0) break;
        for (int i =0; i<n; i++) {
            std::cin>>x;
            if (x ==0) {
                b++;
            }else if(x<0)
            {
                a++;
            }else{
                c++;
            }
        }
        std::cout<<a<<" "<<b<<" "<<c <<std::endl;

    }
    return 0;
}

