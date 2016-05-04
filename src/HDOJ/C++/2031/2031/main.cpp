//
//  main.cpp
//  2031
//
//  Created by Owen on 15-1-6.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>
#include <cstring>
char intToChar(int n)
{
    switch (n) {
        case 15:
            return 'F';
            
        case 14:
            return 'E';
           
            
        case 13:
            return 'D';
            
            
        case 12:
            return 'C';
            
        case 11:
            return 'B';
            
        case 10:
            return 'A';
        case 9:
            return '9';
            
        case 8:
            return '8';
            
        case 7:
            return '7';
            
        case 6:
            return '6';
            
        case 5:
            return '5';
            
        case 4:
            return '4';
            
        case 3:
            return '3';
            
        case 2:
            return '2';
            
        case 1:
            return '1';
            
        case 0:
            return '0';
            
        default:
            break;
    }
    return (char)n;
}
int main(int argc, const char * argv[])
{

    bool flag;
    int n,x;
    char des[1000];
    while (std::cin>>n>>x) {
        if (n<0) {
            flag = true;
        }
        else{
            flag = false;
        }
        int index = 0, tmp;
        while (n!=0) {
            
            tmp = n%x;
            n = n/x;
            des[index]=intToChar(abs(tmp));
            index++;
            
        }
         des[index]='\0';
        if (flag) {
            std::cout<<"-";
        }
        
        while (index) {
            std::cout<<des[index-1];
            index--;
        }
        std::cout<<std::endl;
    }
    return 0;
}

