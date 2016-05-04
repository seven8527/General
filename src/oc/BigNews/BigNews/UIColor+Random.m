//
//  UIColor+Random.m
//  BigNews
//
//  Created by owen on 15/8/14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//


#import "UIColor+Random.h"
@implementation UIColor (Random)
+(UIColor *)randomColor{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom((unsigned)time(nil));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}
@end