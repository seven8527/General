//
//  main.c
//  _10.7.1_pointertostruct
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
typedef  struct student stu;
struct student{
    int num;
    int age;
    char *name;
    float score;
    
}boy = {
    1, 15, "tom", 60.05
}, *pBoy; //定义指针变量

int main(int argc, const char * argv[])
{

    
    // insert code here...
//    printf("Hello, World!\n");
    //定义指针变量的另一种形式
    
    stu *pBoys = &boy; //改变了未使用所以报黄色感叹号。但是定义的方式是完全正确的。    
    
//    初始化结构体变量*pBoy
    
    pBoy =&boy; //与指针的初始化完全相同。无需过多解释
    printf("num is %d, age is %d, name is %s, score is %f\n", boy.num, boy.age, boy.name, boy.score);
    printf("num is %d, age is %d, name is %s, score is %f\n", (*pBoy).num, (*pBoy).age, (*pBoy).name, (*pBoy).score);//需要说明的是 .的优先级比*高，所以必须用括弧。
    
    printf("num is %d, age is %d, name is %s, score is %f\n", pBoy->num, pBoy->age, pBoy->name, pBoy->score );//对一个指针来讲当天可以用->来引用其成员
    
    return 0;
}

