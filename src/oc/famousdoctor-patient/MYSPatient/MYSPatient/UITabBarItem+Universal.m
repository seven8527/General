//
//  UITabBarItem+Universal.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "UITabBarItem+Universal.h"

@implementation UITabBarItem (Universal)

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{    
    return [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
}

@end
