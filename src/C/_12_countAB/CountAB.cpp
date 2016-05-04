#include <stdio.h>
int main()
{
	float a ,b , sum;
	char flag;
	
	printf("plase input a+(-*/)b :");
	scanf("%f%c%f", &a, &flag,&b);
	
	switch(flag)
	{
		case '+':
			printf("%f + %f = %f\n", a , b , a+b);

			break;
		case '-':
			printf("%f - %f = %f\n", a , b , a-b);

			break;

		case '*':
				printf("%f * %f = %f\n", a , b , a*b);

			break;
		case '/':
				printf("%f / %f = %f\n", a , b , a/b);
			break;

		default :
		   break;

	};

}