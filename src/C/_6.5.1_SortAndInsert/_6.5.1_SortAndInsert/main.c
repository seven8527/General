//
//  main.c
//  _6.5.1_SortAndInsert
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

void sort(int a[] );
void insert (int a[], int input);

int main(int argc, const char * argv[])
{

    int  a[13] = {1,2,4,6,8,12,43,45,86,33,5,3}, input;
    
    sort(a);
    printf("plase input a vaule to insert the array ： ");
    scanf("%d",&input);
    
    insert(a, input);
    
    return 0;
}

// 先对数组进行排序，升序排列并打印。
void sort(int a[])
{
    for (int i =0;  i< 11; i++) {
        for (int j=i ; j<12; j++) {
//            int tmp = a[i] >a[j]?a[i]:a[j];
            int tmp;
            if( a[i]> a[j])
            {
                tmp = a[i];
                a[i] =  a[j];
                a[j] = tmp;
            }
        }
        printf("a[%d] = %d \n", i, a[i]);
        
    }

     printf("a[11] = %d \n", a[11]);
    
    
}

//进行插入操作，先判断插入位置，输入数字以此跟数组中的数进行对比，对比后找到插入索引
//然后进行插入
void insert (int a[], int input )
{
    int index1=0;
    
    for ( int i = 0 ; i<12; i++) {
        if (a[i]>input) {
            index1 = i;
            break;
            
        }
        else
        {
            index1 = 12;
        }
    }
    printf("index1 = %d\n", index1);

    if (index1 == 12) {
        a[12] = input;
    }
    else
    {
        for (int  i = 13; i>index1  ; i--) {
            if(i-1>=0)
            a[i] =a[i-1];
        }
        a[index1] = input;
    }
    
    for (int i = 0 ; i <13; i++) {
        printf("out put a[%d] = %d\n", i, a[i]);
    }
}