//
//  main.c
//  _6.3.2_charString
//
//  Created by Owen on 14-12-23.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[])
{

    char a[] = {"this is a book"};
    // char a[] = "this is a book" 等于
    //或者 char a[] ={'t','h','i','s',' ', 'i','s',' ', 'a', ' ', 'b', 'o', 'o', 'k'}
    //前两种方式比第三中方式 多了\0 结束符。
    
    //字符串输出 可以直接用数组地址
    
    printf("char a[] is %s\n ", a);
    
    return 0;
}

