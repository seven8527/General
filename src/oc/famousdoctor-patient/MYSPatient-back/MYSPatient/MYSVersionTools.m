//
//  MYSVersionTools.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSVersionTools.h"

#define VERSION_IOS_REVIEWS_URL_FORMAT  @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=935534865"
#define VERSION_IOS7_REVIEWS_URL_FORMAT @"itms-apps://itunes.apple.com/app/id935534865"

@interface MYSVersionTools()

@end

@implementation MYSVersionTools

// 单例
+ (MYSVersionTools *)sharedInstance
{
    static MYSVersionTools *versionHelper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        versionHelper = [[MYSVersionTools alloc] init];
    });
    
    return versionHelper;
}


/**
 *  给我评价
 */
- (void)openAppReviews
{
    NSURL *URL = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        URL = [NSURL URLWithString:VERSION_IOS7_REVIEWS_URL_FORMAT];
    }
    else
    {
        URL = [NSURL URLWithString:VERSION_IOS_REVIEWS_URL_FORMAT];
    }
    [[UIApplication sharedApplication] openURL:URL];
}

@end
