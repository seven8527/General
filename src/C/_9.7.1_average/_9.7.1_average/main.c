//
//  main.c
//  _9.7.1_average
//
//  Created by Owen on 14-12-25.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
float aver(float *pA)
{
    float aver, sum;
    for (int i = 0 ; i < 5; i++) {
//        sum +=*pA++; //注意*pA++ 的运算方式是自右向左的，即就是先pA++再*， 但是pA++的意思是先使用后增加值，这样一来实际上还是*pA 运算完成后立马pA自增加1
        
//        sum+=pA[i]; //第二种方式，引用数组的元素，即：通过下标引用元素
        sum += *(pA+i);//第三种方式: 先计算指针地址，再去值。该方法可行。
    }
    aver = sum/5;
    printf("average is %f\n ", aver);
    
    return  aver;
}


int main(int argc, const char * argv[])
{

    // insert code here...
    //    printf("Hello, World!\n");
    float a[5],*p=a;
    puts("plase input five float value : ");
    for ( int i=0; i < 5; i++) {
//        scanf("%f",&a[i]); //最原始的数组元素引用方法。
//        scanf("%f",a+i);//高级的方法。a为数组首地址，加上相应的下标既可以找到对应的数组元素地址
        scanf("%f", p++); //方式三：通过指针，自增引用数组下标 要注意此处使用 a++是无法实现自增的目的
        //因为a是const值，数组的首地址不能被修改
        
    }
    aver(a);
    
    return 0;
}

