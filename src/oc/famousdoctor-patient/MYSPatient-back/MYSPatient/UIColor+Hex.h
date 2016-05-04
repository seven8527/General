//
//  UIColor+Hex.h
//  Mingyisheng
//
//  Created by 闫文波 on 14-8-5.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

+ (UIColor *)colorFromHexARGB:(NSString *)inColorString;

@end
