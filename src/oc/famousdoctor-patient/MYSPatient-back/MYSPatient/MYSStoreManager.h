//
//  MYSStoreManager.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSStoreManager : NSObject

+ (instancetype)sharedStoreManager;

// 首页
- (NSMutableArray *)getHomeConfigureAray;

// 更多
- (NSMutableArray *)getMoreConfigureAray;

// 设置
- (NSMutableArray *)getSettingConfigureAray;

// 新增就诊记录
- (NSMutableArray *)getAddNewRecordConfigureAray;
@end
