//
//  main.c
//  _6.1.1_ActualParameter
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>


//形参和实参的例子： 形参，在函数掉用得时候进行分配内存，该内存分配在栈上，调用结束后，内存释放。
//所以，试图用形参改变实参的值是不可能的。
int sum(int n)
{
    for (int i = n ; i>0; i--) {
        n +=i;
    }
    printf("形参n的值为：%d\n", n);
    return  n;
    
}

int main(int argc, const char * argv[])
{

    int n, total;
    puts("plase input a number : ");
    
    scanf("%d", &n);
    
    
    total = sum(n);
    printf("实参n的值为: %d\n", n); 
    printf("total is : %d\n", total);
    
    return 0;
}


