#include<stdio.h>
#include<math.h> // sqrt ��ƽ����Ҫ��ͷ�ļ�
int main()
{	
	float a,b,c , s,area;
	printf("plase input a,b,c :");

	scanf("%f,%f,%f", &a,&b,&c);

	s = (a+b+c)/2.0;
	area  = sqrt(s*(s-a)*(s-b)*(s-c)); //�������ʽ
	
	printf("a = %7.2f, b= %7.2f, c = %7.2f, s = %7.2f \n", a, b, c, s); //��ʽ��7λ�� С������λ
	printf("area = %7.2f\n", area);

}