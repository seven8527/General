//
//  UIImage+Color.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-22.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 *  通过颜色生成一个纯色的图片
 *
 *  @param color 颜色值
 *  @param size  图片的尺寸
 *
 *  @return 纯色的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
