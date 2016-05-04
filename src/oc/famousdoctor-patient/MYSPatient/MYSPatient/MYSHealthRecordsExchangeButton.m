//
//  MYSHealthRecordsExchangeButton.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-27.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsExchangeButton.h"

@implementation MYSHealthRecordsExchangeButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 12)/2, 0, 8, 8);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 8 + 9, contentRect.size.width, contentRect.size.height - 17);
}

@end
