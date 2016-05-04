#include <stdio.h>

int main()
{

	int a , b ;  //定义两个用来比较的变量 .a和b 都保存在栈中

	printf("please input two integer Vaule "); // 提示输入

	scanf("%d %d", &a, &b); //接受输入值


	printf("%d and %d max is %d \n",a ,b , a>b?a:b); //打印比较结果


}



