#include<stdio.h>
#include<math.h>

int main()
{

	int a, i, p;

	printf("plase input a number : ");
	scanf("%d", &a);
	p = sqrt(a);  // �����Ŀ�ƽ�� �����ڿ��������Լ����� ����Ҳ������

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