#include<stdio.h>
int main()
{
	 int i  = 10 ; 
	 printf(" ++i = %d\n ++i = %d\n --i = %d\n --i = %d\n", ++i,++i,--i, --i);  //这个问题其实是考 printf 

	 printf("++++++++++++++other mathed++++++++++++++++++\n");
	 printf("++i = %d\n", ++i);
	 printf("++i = %d\n", ++i);
	 printf("--i = %d\n", --i);
	 printf("--i = %d\n", --i);
	


	printf("-----------这两个程序的区别是用一个printf语句和多个printf 语句输出。但从结果可以看出是不同的。为什么结果会不同呢？就是因为printf函数对输出表中各量求值的顺序是自右至左进行的-------\n");
}