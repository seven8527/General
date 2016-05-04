//
//  MYSRightImageButton.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSRightImageButton.h"

@implementation MYSRightImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setRightImageWidth:(CGFloat)rightImageWidth
{
    _rightImageWidth = rightImageWidth;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width - self.rightImageWidth, 0, self.rightImageWidth, contentRect.size.height);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width - self.rightImageWidth, contentRect.size.height);
}
@end
