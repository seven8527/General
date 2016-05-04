//
//  TEFoundationCommon.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-3.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEFoundationCommon : NSObject

/**
 *  获得状态栏和导航条的适配高度
 *
 *  @return 状态栏和导航条的适配高度
 */
+ (CGFloat)getAdapterHeight;

/**
 *  获得Nav Bar的适配高度
 *
 *  @return Nav Bar的动态高度
 */
+ (CGFloat)getNavBarAdapterHeight;

/**
 *  获得Tab Bar的适配高度
 *
 *  @param rect Tab Bar的区域
 *
 *  @return Tab Bar的动态高度
 */
+ (CGFloat)getTabBarAdapterHeight:(CGRect)rect;

+ (NSString *)md5:(NSString *)str;

@end
