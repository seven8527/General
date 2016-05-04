#include<stdio.h>
#include<math.h>

int main()
{

	int a, i, p;

	printf("plase input a number : ");
	scanf("%d", &a);
	p = sqrt(a);  // 素数的开平方 不存在可以整除自己的数 该数也是素数

	for(i =2; i<=p; i++)
	{
		if(a%i == 0) break;
	}

	if(i >=p+1)
		printf("%d is a Prime number\n", a);
	else
		printf("%d is not a Prime number\n", a);

	return 0;
}