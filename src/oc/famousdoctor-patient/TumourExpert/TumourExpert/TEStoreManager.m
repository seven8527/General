//
//  TEStoreManager.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEStoreManager.h"

@implementation TEStoreManager

+ (instancetype)sharedStoreManager
{
    static TEStoreManager *storeManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeManager = [[self alloc] init];
    });
    
    return storeManager;
}

- (NSMutableArray *)getConsultConfigureArray
{
    NSMutableArray *consults = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSString *typeKey = @"type";
    NSString *valueKey = @"value";
    
    NSDictionary *textConsultDictionary = @{typeKey: @"网络咨询", valueKey: @"0"};
    NSDictionary *phoneConsultDictionary = @{typeKey: @"电话咨询", valueKey: @"1"};
    NSDictionary *referralDictionary = @{typeKey: @"线下咨询", valueKey: @"2"};
    
    consults = (NSMutableArray *)@[textConsultDictionary, phoneConsultDictionary, referralDictionary];
    
    return consults;
}

- (NSMutableArray *)getPersonalDataConfigureArray
{
    NSMutableArray *personalDatas = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSString *titleKey = @"title";
    
    [personalDatas addObject:@[@{titleKey: @"用户名"}, @{titleKey : @"手机号"}, @{titleKey : @"电子邮箱"}]];
    
    [personalDatas addObject:@[@{titleKey: @"真实姓名"},@{titleKey: @"性别"},@{titleKey: @"出生日期"},@{titleKey: @"联系电话"},@{titleKey: @"省市区"},@{titleKey: @"详细地址"}]];
    
    return personalDatas;
}

- (NSMutableArray *)getSearchDoctorConfigureArray
{
    NSMutableArray *searchDoctorDatas = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSString *titleKey = @"title";
    
    [searchDoctorDatas addObject:@[@{titleKey: @"地区"}, @{titleKey : @"疾病"}, @{titleKey : @"医院"}]];
    
    return searchDoctorDatas;
    
//    NSMutableArray *searchDoctorDatas = [[NSMutableArray alloc] initWithCapacity:3];
//    
//    NSString *titleKey = @"title";
//    
//    searchDoctorDatas = (NSMutableArray *)@[@{titleKey: @"地区"}, @{titleKey: @"疾病"}, @{titleKey: @"医院"}];
//    
//    return searchDoctorDatas;

}


- (NSMutableArray *)getAboutConfigureArray
{
    NSMutableArray *abouts = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSString *titleKey = @"title";
    NSString *valueKey = @"value";
    
    NSDictionary *phoneDictionary = @{titleKey: @"客服电话", valueKey: @"4006-118-221"};
    NSDictionary *feedbackDictionary = @{titleKey: @"意见反馈", valueKey: @""};
    
    abouts = (NSMutableArray *)@[phoneDictionary, feedbackDictionary];
    
    return abouts;
}

- (NSMutableArray *)getPersonalCenterConfigureArray
{
    NSMutableArray *personals = [[NSMutableArray alloc] initWithCapacity:6];
    
    NSString *titleKey = @"title";

    personals = (NSMutableArray *)@[@{titleKey: @"基本资料"}, @{titleKey: @"健康档案"}, @{titleKey: @"网络咨询"}, @{titleKey: @"电话咨询"}, @{titleKey: @"面对面咨询"}, @{titleKey: @"设置"}, @{titleKey: @"关于我们"}];
    
    return personals;
}


- (NSMutableArray *)getSettingConfigureArray
{
    NSMutableArray *settings = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSString *titleKey = @"title";
    
    settings = (NSMutableArray *)@[@{titleKey: @"2G/3G/4G查看图片"}, @{titleKey: @"检查更新"}, @{titleKey: @"修改密码"}, @{titleKey: @"评价我们"}];
    
    return settings;
}

- (NSMutableArray *)getHealthUserConfigureArray
{
    NSMutableArray *personals = [[NSMutableArray alloc] initWithCapacity:6];
    
    NSString *titleKey = @"title";
    
    personals = (NSMutableArray *)@[@{titleKey: @"姓名"}, @{titleKey: @"身份证号"}, @{titleKey: @"性别"}, @{titleKey: @"出生日期"}, @{titleKey: @"身高"}, @{titleKey: @"体重"}];
    
    return personals;
}

- (NSMutableArray *)getHealthDiseaseConfigureArray
{
    NSMutableArray *personals = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSString *titleKey = @"title";
    
    personals = (NSMutableArray *)@[@{titleKey: @"就诊记录名称"}, @{titleKey: @"就诊医院"}, @{titleKey: @"就诊日期"}, @{titleKey: @"就诊科室"}, @{titleKey: @"初步诊断"}];
    
    return personals;
}

- (NSMutableArray *)getPayInfoConfigureArray
{
    NSMutableArray *payInfos = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSString *titleKey = @"title";
    
    [payInfos addObject:@[@{titleKey: @"户名"}, @{titleKey : @"账号"}, @{titleKey : @"开户行"}]];
    
    [payInfos addObject:@[@{titleKey: @"付款状态"}, @{titleKey: @"付款时间"},@{titleKey: @"付款金额"}]];
    
    return payInfos;
}

@end
