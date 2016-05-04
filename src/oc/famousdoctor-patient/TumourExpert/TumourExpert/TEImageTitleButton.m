//
//  TEImageTitleButton.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-22.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEImageTitleButton.h"

@implementation TEImageTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 26;
    CGFloat titleY = 0;
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = 17;
    CGFloat imageHeight = 18;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

@end
