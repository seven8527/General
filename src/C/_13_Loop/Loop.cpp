#include <stdio.h>

int main()
{
	int sum=0, i=0 ; 
Loop:if(i<=100)
	 {
		 sum +=i;
		 i++;
		 goto Loop;
	 }

	 printf("1+2+3+...+99+100 = %d\n", sum);
	 return ;
}