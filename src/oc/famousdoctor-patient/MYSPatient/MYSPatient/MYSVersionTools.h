//
//  MYSVersionTools.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSVersionTools : NSObject

/**
 *  应用在苹果商店的id
 */
@property (strong, nonatomic) NSString *appID;

/**
 *  TEVersionTools的单例方法
 *
 *  @return TEVersionTools的实例
 */
+ (MYSVersionTools *)sharedInstance;

/**
 *  给我评价
 */
- (void)openAppReviews;


@end
