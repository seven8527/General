//
//  main.c
//  _9.3.1_SwapAB
//
//  Created by Owen on 14-12-24.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
void swap(int *a , int *b)
{
    /**
    int x; //局部变量 ,该值可以是指针变量也可以不是指针变量。
    //但是此变量为指针时，应该对指针进行初始化。不然，指针没有地址，怎么指向一个变量
    x = *a; //将指针a指向的值赋值给x
    *a = *b;//将指针b指向的内容 赋值给指针a
    *b = x; //将局部变量x的值赋值给指针b所指向的变量。
    //事实上是将a 和b 的值进行交换
    */
    
    /*
    //使用纯指针进行实现
    int *p;
    p = a; // 将a的地址赋值给p，那么p和a都指向一个变量
    *a=*b; //将b的值赋值给a， 那么p和a都指向b的值
    *b = *p; //将p的值赋值给b， 那么b和a，p的值都是一样的。
    //故，此方法是将a和b的值赋值了一份。将a的值丢了。

     */
//    那么如何实现呢？， 可以这么做。看操作。
    int *p , x;
    p=&x;  //好了，对其进行解释，为什么要定义一个变量x呢？因为要初始化*p，先给p分配一个地址。
    *p = *a; // 然后将a指针的值，赋值给*p，其实是x得值发生了变化
    *a =*b;  // 然后把b指针的值赋值个a，其实就是实参a的值变成了b得值
    *b = *p; // 然后把*p的值赋值给*b, 实际上就是把x的值赋值给了实参b
    
    
    
}

void swap1(int a , int b)
{
    int x;
    x = a; //将形参a的值赋值给x
    a = b; //将形参b的值赋值个形参a
    b = x; //将局部变量x的值赋值给形参b
    //该方法交换了两个形参的值，并未交换传入的实参值。必须明确
    
    
}

void swap2(int *a, int *b)
{
    int *x;  //定义一个指针变量
    x = a;  //将a的地址放入x指针中，
    a = b;  //将b的地址放入a中
    b = x;  //将x的地址放入b中
    //看样子都是地址交换。问题是，完全没有引用到实参。
    //这里只是对两个地址进行了交换，实际上你可以认为是（int a, int b） 的另一种变种
}
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    int  a , b;
    puts("plase input two integer :");
    scanf("%d %d", &a, &b);
    
    swap(&a, &b);
    printf("use pointer swap input is : %d %d\n", a, b );
    
    
    swap1(a, b);
    printf("unuse pointer swap input is : %d %d\n", a, b );

    swap2(&a,&b);
    printf("use pointer swap input is : %d %d\n", a, b );
    

    return 0;
}

