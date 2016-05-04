#include<stdio.h>
#include<math.h>


//t/4 = 1-1/3+1/5.....
int main()
{
	double  sum=0  ; 
	int n;

	printf("plase input a Integer N: ");
	scanf("%d", &n);

	for(int i=1; i<=n; i++)
	{
		sum += pow(-1.0, i+1)/(2*i-1);// ¹«Ê½

	}

	printf("sum is %lf\n", sum);
	return 0;

}