//
//  UIImage+Corner.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-7.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Corner)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
