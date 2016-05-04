#include <stdio.h>


int main()
{
	int sum = 0 ; //定义一个变量，该变量用于统计累加总和。


	for(int i = 0 ; i<=100; i++)
	{
		sum += i ;

	}

	printf("1+2+3+...+99+100 = %d \n", sum);

	return 0;

}

