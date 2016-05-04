//
//  main.c
//  _10.12.1_union
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
/*
c语言中既有结构体，又有联合体，大家知道他们的区别吗？下面来研究一下：
 1.结构体在内存中所占用的字节数是各个元素所占字节数的综合，联合体在内存中占用的空间是元素中占用空间最大的元素的大小，也就是说联合体在内存中是公用内存空间的。
 2.在C/C++程序的编写中，当多个基本数据类型或复合数据结构要占用同一片内存时，我们要使用联合体；当多种类型，多个对象，多个事物只取其一时（我们姑且通俗地称其为“n 选1”），我们也
 可以使用联合体来发挥其长处。
 */
union uns{
    
    struct stru{
        int a; //int 占用4个字节
        int b; //4 个字节
        int c; //4个字节
    }stru; //一共占用4个字节
    int x; //共享stru 所占用的12 个字节， x的地址其实就是 结构体中a的地址哦
    
} uns;
int main(int argc, const char * argv[])
{
    uns.stru.a = 10;
    uns.stru.b = 20;
    uns.stru.c = 30;
    uns.x = 0;
    printf("union size is %d\n", sizeof(uns));
    printf("struct size is %d\n", sizeof(uns.stru));
    printf("address of x is %x\n", &uns.x);
    printf("address of a is %x\n", &uns.stru.a);

    
    printf("stru.a is %d\nstru.b is %d\nstru.c is %d \n", uns.stru.a, uns.stru.b, uns.stru.c);
    printf("x is %d\n", uns.x);
    
    /*
     union类型是共享内存的，以size最大的结构作为自己的大小，这样的话，uns这个结构就包含stru这个结构体，而大小也等于u这个结构体的大小，在内存中的排列为声明的顺序a,b,c从低到高，然后赋值的时候，在内存中，就是a的位置放置10，b的位置放置20，c的位置放置30，现在对x赋值，对x的赋值因为是union，要共享内存，所以从union的首地址开始放置，首地址开始的位置其实是a的位置，这样原来内存中a的位置就被x所赋的值代替了，就变为0了，这个时候要进行打印，就直接看内存里就行了，a的位置也就是x的位置是0，而b，c的位置的值没有改变，所以应该是0,20,30
     */
    // insert code here...
//    printf("Hello, World!\n");
    return 0;
}

