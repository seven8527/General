#include<stdio.h>
#include<math.h> // sqrt 开平方需要的头文件
int main()
{	
	float a,b,c , s,area;
	printf("plase input a,b,c :");

	scanf("%f,%f,%f", &a,&b,&c);

	s = (a+b+c)/2.0;
	area  = sqrt(s*(s-a)*(s-b)*(s-c)); //求面积公式
	
	printf("a = %7.2f, b= %7.2f, c = %7.2f, s = %7.2f \n", a, b, c, s); //格式化7位， 小数点两位
	printf("area = %7.2f\n", area);

}