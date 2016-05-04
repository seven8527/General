//
//  main.c
//  _6.5.2_ArrayToNewArray
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

void creatNewArray(int array[][5], int newArray[3]);
int main(int argc, const char * argv[])
{

    //初始化一个二维数组 ，将数组每一行最大的组成一个新的数组
    //首先定义一个二维数组并初始化，在定义一个一唯数组用来存储新的数组
    //对比算法如下：循环对比二维数组中的各项找出最大的，放入新数组中。
    int  newArray[3];
    int array[][5] ={1,2,3,4,5, 55,4,43,23,4, 67,45,23,76,79};
    creatNewArray(array, newArray)  ;
    
    return 0;
}

void creatNewArray(int array[][5], int newArray[])
{
    for (int i =0;  i<3; i++) {
        for (int j = 0 ; j<5; j++) {
            if (j==0) {
                newArray[i] = array[i][j]; //不管如何第一次先赋值
                
            }
            else
            {
                if (newArray[i]<array[i][j]) { //进行比较将比较大的数放入数组中
                    newArray[i] = array[i][j];
                }
            }
        }
    }
    
    for (int i = 0 ; i< 3 ; i++) {
        printf("new array is :newArray[%d] = %d \n", i , newArray[i]);
    }
}

