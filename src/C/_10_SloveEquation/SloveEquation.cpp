
//求ax2+bx+c=0方程的根，a、b、c由键盘输入，设b2-4ac>0。

#include <stdio.h>
#include <math.h>
int main()
{

	float a,b,c,disc,x1,x2,p,q;
	printf("请输入a, b, c :");
    scanf("a=%f,b=%f,c=%f",&a,&b,&c);
    disc=b*b-4*a*c;
	if(disc>0)
	{
		p=-b/(2*a);
		q=sqrt(disc)/(2*a);
		x1=p+q;
		x2=p-q;
		printf("x1 = %5.2f, x2 =%5.2f \n", x1, x2); //求解
	}
	else
	{
		printf("no Slove "); // 无解
	}
	return 0;
}
