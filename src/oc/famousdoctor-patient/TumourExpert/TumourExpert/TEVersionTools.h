//
//  TEVersionTools.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-8-1.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEVersionTools : NSObject

/**
 *  应用在苹果商店的id
 */
@property (strong, nonatomic) NSString *appID;

/**
 *  TEVersionTools的单例方法
 *
 *  @return TEVersionTools的实例
 */
+ (TEVersionTools *)sharedInstance;

/**
 *  检查你的应用已安装的版本和它在苹果商店的版本是否有冲突
 *  如果有新版本存在，提示用户进行更新
 */
- (void)checkVersion;

/**
 *  同步检查版本更新
 */
- (void)checkVersionForSynchronous;

/**
 *  给我评价
 */
- (void)openAppReviews;

@end
