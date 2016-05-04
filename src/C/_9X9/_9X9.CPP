#include<stdio.h>

int main()
{
	printf("---------------9X9------------------\n");

	for(int i = 1 ; i<=9; i++)
	{
		for(int j =1; j <=i; j++)
		{
			printf("%3d",i*j);
		}
		printf("\n");

	}
	printf("---------------9X9------------------\n");


}