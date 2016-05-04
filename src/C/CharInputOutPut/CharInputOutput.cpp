#include <stdio.h>

/**
* 输入一个字符 ， 当输入回车时结束
*/
int main()
{
	char a, b;
	printf("plase input a char : ");
	a = getchar();
	while(a!='\n')
	{
		//printf("plase input a char : ");
		//a = getchar();
		putchar(a);
		putchar('\n');

		printf("you input : %c\n", a);
		printf("plase input a char : ");
		a = getchar();
	}

	return 0;
	// putchar 可以打印一个字符 到屏幕
	// getchar 可以获取键盘输入的一个字符

}