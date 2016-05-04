#include <stdio.h>
int main()
{	
	char a ,b;
	unsigned char ua;

	a = 'F';
	b= 'd';

	printf("a is %d b is %d \n", a , b);

	printf("a is %c b is %c \n", a , b);
	printf("char type size is %d \n", sizeof a ); //1
	printf("unsigned char type size is %d \n", sizeof ua); //1
}