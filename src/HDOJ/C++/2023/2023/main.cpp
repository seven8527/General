//
//  main.cpp
//  2023
//
//  Created by Owen on 15-1-4.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#include <iostream>

int main(int argc, const char * argv[])
{

    int stu[50][5], stuNum, sectionNum,count;
    double avgStu[50], avgSec[5];
    while (std::cin>>stuNum>>sectionNum) {
        double sumstu = 0;
        for (int i = 0; i< stuNum; i++) {
            for (int j = 0; j<sectionNum; j++) {
                std::cin>>stu[i][j];
                sumstu += stu[i][j];
            }
            avgStu[i] = sumstu/sectionNum;
            sumstu = 0;
        }
        double sumsec=0;
        
        for (int i = 0;  i< sectionNum; i++) {
            for (int j = 0 ; j < stuNum; j++ ) {
                sumsec +=stu[j][i];
            }
            avgSec[i] = sumsec/stuNum;
            sumsec = 0;
        }
        
        for (int i = 0 ; i< stuNum; i++) {
            if(i != 0 )std::cout<<" ";
            printf("%.2lf",  avgStu[i]);
        }
        std::cout<<std::endl;
        
        for (int i = 0 ; i< sectionNum; i++) {
            if(i != 0 )std::cout<<" ";
            printf("%.2lf",  avgSec[i]);
        }
        std::cout<<std::endl;
        int count=0 , flag = 0;
        for (int t = 0; t<stuNum; t++) {
            flag =0;
            for (int j = 0 ; j<sectionNum; j++) {
                if (avgSec[j] >stu[t][j]) {
                    flag  =1;
                }
            }
            if (!flag) {
                count++;
            }
            
        }
        std::cout<<count<<std::endl<<std::endl;
        
    }
    return 0;
}

