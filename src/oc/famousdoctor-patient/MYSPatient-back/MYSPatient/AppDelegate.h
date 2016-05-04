//
//  AppDelegate.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-1-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) NSString *userId; // 用户id
@property (nonatomic, strong) NSString *cookie; // cookie
@property (nonatomic, strong) NSString *account; // 账号，可能是用户名、邮箱、手机
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) int payEntrance; // 支付入口  1、代表从咨询进入 2、代表从个人中心进入

//// 设置界面开关状态
//@property (nonatomic, copy) NSString *replayIsOpen;
//@property (nonatomic, copy) NSString *orderIsOpen;
//@property (nonatomic, copy) NSString *dynamicIsOpen;

@end

