#include<stdio.h>

int main()
{	
	float PI = 3.1415926535;
	int a , p ; 
	printf("plase input a integer value : ");
	scanf("%d", &a);
	p = a*a*PI;

	printf("a*a*PI is %d\n", p);
	return 0;

}