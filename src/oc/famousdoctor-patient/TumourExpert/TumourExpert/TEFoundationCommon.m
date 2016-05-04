//
//  TEFoundationCommon.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-3.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEFoundationCommon.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TEFoundationCommon

/**
 *  获得状态栏和导航条的适配高度
 *
 *  @return 状态栏和导航条的适配高度
 */
+ (CGFloat)getAdapterHeight
{
    CGFloat adapterHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        adapterHeight = 64;
    }
    return adapterHeight;
}

/**
 *  获得Nav Bar的适配高度
 *
 *  @return Nav Bar的动态高度
 */
+ (CGFloat)getNavBarAdapterHeight {
    CGFloat adapterHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7.0) {
        adapterHeight = 44;
    }
    return adapterHeight;
}

/**
 *  获得Tab Bar的适配高度
 *
 *  @param rect Tab Bar的区域
 *
 *  @return Tab Bar的动态高度
 */
+ (CGFloat)getTabBarAdapterHeight:(CGRect)rect {
    CGFloat adapterHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7.0) {
        adapterHeight = CGRectGetHeight(rect);
    }
    return adapterHeight;
}

/**
 *  md5加密
 *
 *  @param str 加密前的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)md5:(NSString *)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

@end
