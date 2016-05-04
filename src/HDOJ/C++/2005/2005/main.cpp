//
//  main.cpp
//  2005
//
//  Created by Owen on 15-1-3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    // insert code here...
//    std::cout << "Hello, World!\n";

    int y,m,d,sum;
    while (scanf("%d/%d/%d",&y,&m,&d)!=EOF) {
        sum = 0;
       
        for (int i =1; i<m; i++) {
            switch (i) {
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    sum +=31;
                    break;
                case 2:
                    if ((y%4==0&&y%100!=0)||(y%400==0)) {
                        sum+=29;
                    }else{
                        sum+=28;
                    }
                    break;
                case 4 :
                case 6:
                case 9:
                case 11:
                    sum +=30;
                    break;
                default:
                    break;
            }
        }
        sum+=d;
        std::cout<<sum<<std::endl;
    }
    return 0;
}

