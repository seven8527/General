//
//  main.c
//  _10.14.1_link
//
//  Created by Owen on 14-12-29.
//  Copyright (c) 2014年 Owen. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>


//typedef  struct link mylink;
//struct link{
//    int index;
//    struct link *pNext;
//} *plink;
//int static number;
//
//void create()
//{
//  plink = (mylink *)malloc(sizeof(mylink) );
//    if (plink ==NULL) {
//        puts("内存分配失败");
//        exit(1);
//    }
//    plink->index =0;
//    plink->pNext = NULL;
//    number =1;
//}
//void insert(int n , mylink *lst)
//{
////    mylink * pTmplist = (mylink *)malloc(sizeof(mylink)),
//    mylink *psrcList = plink;
//    if (n ==0) {
//      
//        lst->pNext = plink;
//        plink = lst;
//    }
//    else
//    {
//        for (int i = 0;  i<n; i++) {
//        
//            lst->pNext = psrcList->pNext;
//    
//        }
//        psrcList->pNext = lst;
//    }
//    number++;
//}
//void del(int n)
//{
//    mylink *pTmp = plink;
//    for (int  i =0; i<n; i++) {
//        pTmp =pTmp->pNext;
//        //free(pTmp);
//    }
//    pTmp = pTmp->pNext->pNext;
//    pTmp++;
//    free(pTmp);
//    number--;
//}

//#define NULL 0 
#define TYPE struct student //宏定义， TYPE 代表 struct student
#define LEN sizeof(TYPE) //计算结构体长度的宏定义 也可以写成这样 LEN sizeof(TYPE) 或者  LEN sizeof(struct student)
#define NUM 3


struct student{ // 定义学生结构体
    int age;
    char name[20];
    TYPE *pNext; //结构体包含下一个结构体的指针
};



TYPE * create(int n) //生成一个大小为n的单向链表,并返回其首地址
{
    TYPE *head = NULL,*pf = NULL ,*pb; //head是 链表的首地址， pf是前一个 node pb是后一个node
    for (int i = 0 ; i < n ; i++) {
        pb = (TYPE*)malloc(LEN); //分配内存，大小是结构体的大小
        puts("plase input age and name");
        scanf("%d %s", &(pb->age), pb->name); //输入元素
        if (i ==0) { //如果是首元素的话，将头指针指向该元素，当然pf 也是该元素
            head = pf = pb;
        }
        else{
            pf->pNext = pb; //不是第一个元素的话，将前一个元素的pnext 指向该元素
            }
        pb->pNext = NULL;  //将链表尾端的指针赋值为空
        pf = pb; //循环前，将pf首元素移位到pb末端元素，下面重新创建元素的时候pf就是首元素

    }
    
    
    return(head); // 返回链表首地址
}
TYPE* insert(TYPE * pHead, int n)
{
    TYPE * pNode  = (TYPE *)malloc(LEN), *pf = NULL; //定义一个节点并分配内存， 定义一个前节点 pf
    puts("plase input age and name to insert : ");
    scanf("%d %s",&(pNode->age), pNode->name);//对该节点进行 赋值
    if(n ==1) // 如果要查入的位置是第一个元素的话
    {
        pNode->pNext = pHead; //将节点的指针指向链表头
        pHead = pNode; //并将该节点赋值给phead,表示链表从该节点开始
    }
    else{
        pf = pHead; //将pf指向 链表的头
        for(int i =1 ; i < n-1 ; i++) //对链表进行插入和删除的时候，必须找到要插入位置的前一个位置，不然，指针无法进行操作
        {
          
           pf = pf->pNext; //将pf 移动到要插入元素的前面
          
        }
        pNode->pNext = pf->pNext; //将pnode节点的指针指向要插入元素的下一个元素
        pf->pNext = pNode; //将pf指针指的pnext指向 节点
    }
    
    return pHead; //返回链表的头指针
}

TYPE* del(TYPE* pHead, int n)
{
    TYPE * pNode ,*pf ; //定义一个节点，该节点最后用来删除， pf代表该节点的前一个节点
    if (n==1) { //如果要删除的是第一个元素， 好，那就吧pf向后移动， 或者把链表头赋值成链表头的下一个元素
        pNode = pHead; //pnode 用来删除的
        pHead =   pHead->pNext; //重新设置头
        
    }
    else
    {
        pf = pHead; //将pf指向头
        for (int i  =1 ; i <n-1 ; i++) {
            pf =pf->pNext; //将pf指向要删除的元素的前节点
        }
        if (pf->pNext!=NULL) { //判断要删除的元素是不是最后一个元素
            pf->pNext = pf->pNext->pNext; //把该节点指向后一个节点所指向的节点。
            pNode = pf;//此处 标记要释放内存的地址
        }
        else
        {
            pNode = pf;//如果是最后一个元素，只进行 释放内存
        }
    }
    free(pNode); //释放内存
    return pHead; //返回链表的首地址
}
int main(int argc, const char * argv[])
{

    // insert code here...
//    printf("Hello, World!\n");
    
//    create();
//    printf("%d\n",plink->index);
//    printf("size of list is %lu\n",sizeof(plink));
//    
//    mylink *list1 = (mylink *)malloc(sizeof(mylink));
//    list1->index = 1;
//    insert(2, list1);
//    for (int i = 0 ; i<number; i++) {
//        printf("index is %d \n", plink->index);
//        plink++;
//    }
//    printf("size of list is %lu\n",sizeof(plink));
//    printf("index is %d \n", plink->index);
    
//    del(0);
//    for (int i = 0 ; i<number; i++) {
//        printf("index is %d\n", plink->index);
//    }
    
    TYPE * mStu;
    mStu = create(NUM);
//    mStu =insert(mStu, 5);
    mStu = del(mStu, 4);
    if (mStu != NULL) {
        for (int i = 0; i < NUM+1; i++) {
            if(mStu !=NULL){
                printf("index is %d, age is %d, name is %s\n", i , mStu->age, mStu->name);
            
                mStu=mStu->pNext;
            }
        }
    }
    return 0;
}

