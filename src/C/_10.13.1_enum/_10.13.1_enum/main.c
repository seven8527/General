//
//  main.c
//  _10.13.1_enum
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

/*
 枚举类型：与结构体之类的类似，但是它里面存放的内容是整形的别名。默认从0 开始，可以自定义所代表的值。
 */
enum enu //与结构体，联合体相同，可以省略别名enu
{
    MON=1, TUE, WED, THU, FRI, SAT, SUN //其值从1 开始子增加到7
} enus ; //此处是变量列表enus 可以省略


typedef  enum menu
{
    MON1, TUE1=0, WED1, THU1, FRI1, SAT1, SUN1 //其值是默认从0 开始的，吧tue赋值为0 就出现了两个都是0的值了，不过没关系。都可以用的
//    MON1=1, TUE1, WED1, THU1, FRI1, SAT1, SUN1 //其值从1 开始子增加到7
} menus;
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    enum enu  myEnum;//重新定义了一个枚举变量, 枚举变量的值，必须包括在枚举内容之中
    
//    1.赋值
    myEnum = MON; //给myEnum赋值
//    puts(myEnum); 抱歉，他不是个字符串，不能这么搞的，用格式化打印吧
    printf("myEnum value is %d \n", myEnum);
    
//    2.枚举变量进行计算，为什么可以计算，因为他是整型么。那么 myEnum 可以这样赋值吗？？
    myEnum = 10;//我擦竟然可以的哦。
    printf("myEnum value is %d \n", myEnum);
    myEnum = MON+1;
    printf("myEnum value is %d \n", myEnum);
    
    
//    3.枚举类型所占的字节数
    printf("enum bite is %d\n", sizeof(myEnum));
    printf("enum bite is %d\n", sizeof(enus));
    printf("enum bite is %d\n", sizeof(enum enu));
    
    
//    4.打印
    menus myenu = MON1;//用了typedef 之后。我们得到的其实不是 变量，而是个别名。要重新定义一个变量
    printf("enum value is %d\n", myenu);
    return 0;
}

