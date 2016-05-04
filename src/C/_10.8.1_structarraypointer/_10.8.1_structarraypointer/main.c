//
//  main.c
//  _10.8.1_structarraypointer
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
typedef  struct student  stu;
struct student{
    int num;
    int age;
    char * name;
    float score;
} stud[3]= {
    {1, 13, "tom", 45.30},
    {2, 45, "kitty", 75.23},
    {3, 76, "oktt", 32.0}
}, *pStu;

int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    pStu =stud;//指针指向 结构体数组的时候，由于数组名就是那个地址。所以还用取地址么笨蛋？
//    当天也可以如此进行赋值，但是有点多余哦
//    pStu = &stud[0]; 
    for(; pStu <stud+3; pStu++ )
    {
        printf("num is %d, age is %d, name is %s, score is %f\n", pStu->num, pStu->age, pStu->name, pStu->score);
    }
    return 0;
}

