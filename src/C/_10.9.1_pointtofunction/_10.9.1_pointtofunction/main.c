//
//  main.c
//  _10.9.1_pointtofunction
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
struct stu{
    int num;
    char *name;
    char sex;
    float score;
}boy[5]={
    {101,"Li ping",'M',45},
    {102,"Zhang ping",'M',62.5},
    {103,"He fang",'F',92.5},
    {104,"Cheng ling",'F',87},
    {105,"Wang ming",'M',58}
};

void ave(struct stu *stud)
{
    float sum;
    for (int i = 0;  i < 5; i++) {
        sum +=stud->score;
        stud++;
    }
    printf("age is %f\n", sum/5);
}
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    ave(boy);
    return 0;
}

