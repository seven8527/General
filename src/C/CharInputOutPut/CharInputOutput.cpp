#include <stdio.h>

/**
* ����һ���ַ� �� ������س�ʱ����
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
	// putchar ���Դ�ӡһ���ַ� ����Ļ
	// getchar ���Ի�ȡ���������һ���ַ�

}