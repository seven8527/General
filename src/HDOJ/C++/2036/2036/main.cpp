////
////  main.cpp
////  2036
////
////  Created by Owen on 15-1-6.
////  Copyright (c) 2015年 Owen. All rights reserved.
////
//
//#include <iostream>
//#include <math.h>
//struct point
//{
//    int x,y;
//} ;
//double area(point p1, point p2, point p3)
//{
//    double s1 ,s2 ,s3, s;
//    s1 = sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
//    s2 = sqrt((p3.x-p2.x)*(p3.x-p2.x)+(p3.y-p2.y)*(p3.y-p2.y));
//    s3 = sqrt((p1.x-p3.x)*(p1.x-p3.x)+(p1.y-p3.y)*(p1.y-p3.y));
//    s = (s1+s2+s3)/2;
//    return  sqrt(s*(s-s1)*(s-s2)*(s-s3));
//}
//
//int main(int argc, const char * argv[])
//{
//
//    // insert code here...
////    std::cout << "Hello, World!\n";
//    int n;
//    struct point p0,p1,p2,p3;
//    while (std::cin>>n) {
//        if (n ==0) {
//            return 0;
//        }
//        double sum=0;
//        
//        for (int i =1; i<=n; i++) {
//            
//            
//            if (i == 1) {
//                std::cin>>p1.x>>p1.y;
//                p0.x = p1.x;
//                p0.y = p1.y;
//                
//            }
//            else if (i==2)
//            {
//                std::cin>>p2.x >>p2.y;
//                
//            }
//            else if(i ==3)
//            {
//                std::cin>>p3.x >>p3.y;
//                sum += area(p1,p2, p3);
//            }
//            else
//            {
//                p1 = p2;
//                p2 = p3;
//                std::cin>>p3.x >>p3.y;
//                if ((p2.y!=p0.y)&&(p2.x!=p0.x)) {
//                    if (((p3.y-p0.y)/(p2.y-p0.y)-(p3.x-p0.x)/(p2.x-p0.x))>0) {
//                        sum += area(p0,p2, p3);
//                    }
//                    else
//                    {
//                        sum -= area(p0,p2, p3);
//                    }
//                    
//                }
//                else{
//                    
//                }
//            }
//        }
//        printf("%.1lf\n", sum);
//    }
//    return 0;

//}
//
#include<stdio.h>
int main()
{
    int n,x[3],y[3];
    double s;
    while(scanf("%d",&n)!=EOF)
    {
        if(n==0) break;
        if(n>=3&&n<=100)
        {
            s=0;
            scanf("%d%d",x,y);
            x[2]=x[0];
            y[2]=y[0];
            while(--n)
            {
                scanf("%d%d",&x[1],&y[1]);
                s+=x[0]*y[1]-x[1]*y[0];
                x[0]=x[1];
                y[0]=y[1];
            }
            s+=x[0]*y[2]-x[2]*y[0];
            printf("%.1lf\n",s/2);
        }
    }
    return  0;
}