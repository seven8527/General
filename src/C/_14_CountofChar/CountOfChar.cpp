#include<stdio.h>
int main()
{
	 int sum=0;

	 printf("<plase input char in line end with \\n > :");
	 while(getchar()!='\n')
	 {	
		 sum++;
	 }

	 printf("you are inputing %d char\n", sum);
	 return 0; 
}