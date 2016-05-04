//
//  TEConvertButton.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConvertButton.h"

@implementation TEConvertButton


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{ 
    CGRect frame = [super imageRectForContentRect:contentRect];
    CGFloat imageX  = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) -  self.imageEdgeInsets.right + self.imageEdgeInsets.left + 8;
    CGFloat imageY = 4;
    CGFloat imageWidth = 13;
    CGFloat imageHeight = 13;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super titleRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth([self imageRectForContentRect:contentRect]);
    return frame;
}

@end
