//
//  main.c
//  _10.1.1_struct
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

//如何定义一个结构体？
//1.用关键字 struct 后面紧跟结构体的名称， 然后是结构体的内容
//2.最后是大括号，后面可以跟着 成员变量的名称，也可以不跟。
//3.结构体如何定义一个结构体变量呢？ struct STU student;

typedef struct STU stu;
struct {
    int year;
    int month;
    int day;
} date1; //前面没有定义名称，后面一定要定义变量

struct DATE{
    int year;
    int month;
    int day;
    
};

struct STU{
    int age;
    char *name;
    float height;
    char sex;
    struct DATE birthday; //定义结构体变量
//    date1;
    
} student1, student2;

//此处定义一个结构体数组。
struct persion{
    char *name;
    int age;
    
}persions[2]={
    {"tom", 3},{"kitty", 5}
}; //初始化一个结构体数组


int main(int argc, const char * argv[])
{

    // insert code here...
    
//    date1
//    定义结构体
    student1.birthday.day = 10;// 此结构体已经在声明时定义好
    date1.year  =2014; //同上
    struct DATE date; //此处定义一个结构体变量
    date.year = 2015; // 对变量的参数进行声明
    stu student3;
    student3.name ="tom";
    
    
    printf("student1.brithday.day is %d\n", student1.birthday.day);
    printf("date1.year is %d\n", date1.year);
    printf("DATE struct date.year is %d\n", date.year);
    printf("name is %s\n", student3.name);
    
    printf("persion name is %s, age is %d\n", persions[1].name, persions[1].age);
    
    return 0;
}

