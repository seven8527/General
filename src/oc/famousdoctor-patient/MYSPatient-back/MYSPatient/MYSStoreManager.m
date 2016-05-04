//
//  MYSStoreManager.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSStoreManager.h"
#import "UtilsMacro.h"
#import "AppDelegate.h"

@implementation MYSStoreManager

+ (instancetype)sharedStoreManager
{
    static MYSStoreManager *storeManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeManager = [[self alloc] init];
    });
    
    return storeManager;
}

// 首页
- (NSMutableArray *)getHomeConfigureAray
{
    NSMutableArray *homeArray = [NSMutableArray array];
    
    NSString *titleKey = @"title";
    
    NSString *iconKey = @"icon";
    
    NSString *detailKey = @"detail";
    
    NSDictionary *mingyihui = @{titleKey: @"名医汇", iconKey: @"home_icon1", detailKey: @"给您最权威的咨询服务"};
    
    NSDictionary *disease = @{titleKey: @"疾病大全", iconKey: @"home_icon2", detailKey: @"根据疾病找专家"};
 
    [homeArray addObject:@[mingyihui, disease]];
    
    return homeArray;
}


// 更多
- (NSMutableArray *)getMoreConfigureAray
{
    NSMutableArray *moreArray = [NSMutableArray array];
    
    NSString *titleKey = @"title";
    
    NSString *iconKey = @"icon";
    
    NSString *detailKey = @"detail";
    
//    NSDictionary *share = @{titleKey: @"分享给好友", iconKey: @"more_icon1", detailKey: @""};
    
    NSDictionary *score = @{titleKey: @"给我们打分", iconKey: @"more_icon2", detailKey: @""};
    
    NSDictionary *suggestion = @{titleKey: @"意见反馈", iconKey: @"more_icon3", detailKey: @""};
    
    NSDictionary *hotLine = @{titleKey: @"客服专线", iconKey: @"more_icon4", detailKey: @"4006-118-221"};
    
    NSDictionary *team = @{titleKey: @"关于我们", iconKey: @"more_icon5", detailKey: @""};
    
//    NSDictionary *setting = @{titleKey: @"设置", iconKey: @"more_icon6", detailKey: @""};
    
//    NSDictionary *version = @{titleKey: @"当前版本", iconKey: @"more_icon7", detailKey: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]};
    
    
    [moreArray addObject:@[score, suggestion]];
    
    [moreArray addObject:@[hotLine, team]];
    
    return moreArray;
}


// 设置
- (NSMutableArray *)getSettingConfigureAray
{
    
    NSMutableArray *settingArray = [NSMutableArray array];
    
    NSString *titleKey = @"title";
    
    NSString *iconKey = @"icon";
    
    NSString *isOpen = @"isOpen";
    
    NSString *replayIsOpen = @"";
    NSString *orderIsOpen = @"";
    NSString *dynamicIsOpen = @"";
    
    NSUserDefaults *settingDefaults = [NSUserDefaults standardUserDefaults];
    if ([settingDefaults objectForKey:@"replay"]) {
        replayIsOpen = [settingDefaults objectForKey:@"replay"];
    }
    if ([settingDefaults objectForKey:@"order"]) {
        orderIsOpen = [settingDefaults objectForKey:@"order"];
    }
    if ([settingDefaults objectForKey:@"dynamic"]) {
        dynamicIsOpen = [settingDefaults objectForKey:@"dynamic"];
    }
    
    NSMutableDictionary *replay = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"医生回复提醒",@"set_icon1_",  replayIsOpen,nil] forKeys:[NSArray arrayWithObjects:titleKey, iconKey, isOpen, nil]];
    
    NSMutableDictionary *order = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"订单状态变更提醒",@"set_icon2_",  orderIsOpen,nil] forKeys:[NSArray arrayWithObjects:titleKey, iconKey, isOpen, nil]];
    
    NSMutableDictionary *dynamic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"医生动态消息提醒",@"set_icon3_", dynamicIsOpen,nil] forKeys:[NSArray arrayWithObjects:titleKey, iconKey, isOpen, nil]];

    [settingArray addObjectsFromArray:@[replay, order, dynamic]];
    
    return settingArray;

}

// 新增就诊记录
- (NSMutableArray *)getAddNewRecordConfigureAray
{
    NSMutableArray *moreArray = [NSMutableArray array];
    
    NSString *titleKey = @"title";
    
    NSDictionary *time = @{titleKey: @"就诊时间"};
    
    NSDictionary *hospitol = @{titleKey: @"就诊医院"};
    
    NSDictionary *department = @{titleKey: @"就诊科室"};
    
    NSDictionary *Diagnosis = @{titleKey: @"诊断"};
    
    
    [moreArray addObject:@[time, hospitol, department,Diagnosis]];

    return moreArray;
}

@end
