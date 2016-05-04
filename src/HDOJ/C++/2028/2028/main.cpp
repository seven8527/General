//
//  main.cpp
//  2028
//
//  Created by Owen on 15-1-5.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>
unsigned long GCD(unsigned long num1,unsigned long num2)
{
    if(num1%num2==0)
        return num2;
    else return  GCD(num2,num1%num2);
}
unsigned long LCM(unsigned long a,unsigned long b)
{
    unsigned long temp_lcm;
    temp_lcm=a*b/GCD(a,b);//最小公倍数等于两数之积除以最大公约数
    return temp_lcm;
}
int main(int argc, const char * argv[])
{
    unsigned long n,  lcm, x;
    while (std::cin>>n) {
        lcm = 0;
        for (int i = 0;  i<n; i++) {
            if (i == 0) {
                std::cin>>lcm;
            }
            else
            {
                std::cin>>x;
                if(lcm>x)
                    lcm = LCM(lcm, x);
                else
                    lcm = LCM(x, lcm);
            }
        }
//        std::cout<<sizeof(int)<<std::endl;
        std::cout<<lcm<<std::endl;
    }
    
    return 0;
}

