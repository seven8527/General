#include <stdio.h>

int main()
{
	float f ;
	double d;
	long double ld;

	printf("float size is %d\n", sizeof f); //4	
	printf("double size is %d\n", sizeof d); //8
	printf("long double  size is %d\n", sizeof ld);//8


	printf("result 1/3*3 = %f\n", (1.0/3.0)*3); // ��֤


    float a;
    double b;
    a=33333.33333;
    b=33333.33333333333333;
    printf("a=%f\nb=%f\n",a,b); // ��ȷ�ȵ����� 7 λ�� ��С�������ౣ����λ��
    return 0;
}