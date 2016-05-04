//
//  main.cpp
//  2007
//
//  Created by Owen on 15-1-3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
//    std::cout << "Hello, World!\n";
    long long a, b, sum2, sum3;
    while (std::cin>>a>>b) {
        if(a>b)
        {
            a = a^b;
            b = a^b;
            a = b^a;
        }
        sum2 =sum3 =0;
        for (long i = a; i<=b; i++) {
            if(i%2==0)
            {
                sum2+=i*i;
            }
            else{
                sum3+=i*i*i;
            }
        }
        std::cout<<sum2<<" "<<sum3<<std::endl;
    }
    return 0;
}

