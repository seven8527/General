#include <stdio.h>

void compare(int, int ,int); // ��������

int main()
{
	 int a ,b,c;
	 printf("plase input a, b ,c :");
	 scanf("%d %d %d", &a,&b,&c);
	 compare(a, b, c );
}

void compare(int a, int b, int c)
{
	int d = a>b? a:b; //ȡ�� a��b�нϴ��
	d = c>d? c:d; //ȡ��c ��d �д��
	printf("max in %d,%d,%d is %d\n", a, b,c, d );

	int e = a<b? a:b;//ȡ�� a��b��С��
	e = e<c? e :c;//ȡ��c ��e ��С��
	printf("min in %d,%d,%d is %d\n", a, b,c,e  );
}