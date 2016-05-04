#include <stdio.h>

void compare(int, int ,int); // 声明方法

int main()
{
	 int a ,b,c;
	 printf("plase input a, b ,c :");
	 scanf("%d %d %d", &a,&b,&c);
	 compare(a, b, c );
}

void compare(int a, int b, int c)
{
	int d = a>b? a:b; //取出 a和b中较大的
	d = c>d? c:d; //取出c 和d 中大的
	printf("max in %d,%d,%d is %d\n", a, b,c, d );

	int e = a<b? a:b;//取出 a和b中小的
	e = e<c? e :c;//取出c 和e 中小的
	printf("min in %d,%d,%d is %d\n", a, b,c,e  );
}