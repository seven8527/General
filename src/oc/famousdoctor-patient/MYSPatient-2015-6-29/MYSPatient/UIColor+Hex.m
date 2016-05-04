//
//  UIColor+Hex.m
//  Mingyisheng
//
//  Created by 闫文波 on 14-8-5.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

// RRGGBB eg. 3F4F5F
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    NSString *inColorStringWithAlpha = [NSString stringWithFormat:
                                        @"%@%@", @"FF", inColorString];
    
    return [self colorFromHexARGB:inColorStringWithAlpha];
}

// AARRGGBB eg. "803F4F5F" -> 0x803F4F5F
// 如果inColorString不符合定义规则, 返回UIColor的色值是#00000000
+ (UIColor *)colorFromHexARGB:(NSString *)inColorString
{
    unsigned int colorCode = 0;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    
    // masks off high bits
    unsigned char alphaByte = (unsigned char) (colorCode >> 24);
    unsigned char redByte = (unsigned char) (colorCode >> 16);
    unsigned char greenByte = (unsigned char) (colorCode >> 8);
    unsigned char blueByte = (unsigned char) (colorCode);
    
    return [UIColor colorWithRed: (float)redByte / 0xff
                           green: (float)greenByte/ 0xff
                            blue: (float)blueByte / 0xff
                           alpha:(float)alphaByte / 0xff];
}

@end
