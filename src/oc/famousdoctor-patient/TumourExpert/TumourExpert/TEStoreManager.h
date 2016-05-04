//
//  TEStoreManager.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEStoreManager : NSObject

+ (instancetype)sharedStoreManager;

// 获取咨询配置数组
- (NSMutableArray *)getConsultConfigureArray;

// 获取个人资料配置数组
- (NSMutableArray *)getPersonalDataConfigureArray;

// 获取关于配置数组
- (NSMutableArray *)getAboutConfigureArray;

// 获取个人中心配置数组
- (NSMutableArray *)getPersonalCenterConfigureArray;

// 获取设置配置数组
- (NSMutableArray *)getSettingConfigureArray;

// 获取健康档案用户配置数组
- (NSMutableArray *)getHealthUserConfigureArray;

// 获得健康档案病情配置数组
- (NSMutableArray *)getHealthDiseaseConfigureArray;

// 获得找名医配置数组
- (NSMutableArray *)getSearchDoctorConfigureArray;

// 获取付款信息配置数组
- (NSMutableArray *)getPayInfoConfigureArray;

@end
