//
//  AppDelegate.h
//  Express
//
//  Created by owen on 15/11/3.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoEntity.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) NSString *UserID; // 用户id
@property (nonatomic, strong) NSString *userSessionID; // SessionID
@property (nonatomic, strong) NSString *userName; // 账号，可能是用户名、邮箱、手机
@property (nonatomic, strong) NSString *userPass; // md5加密
@property (nonatomic, strong) NSString *gender;

@property (nonatomic, assign) BOOL isLogin;         //是否已经登录
@property (nonatomic, strong) NSString *syncCode;   //同步吗
@property (nonatomic, assign) float loopTime;       //循环回调时间

@property (nonatomic, strong) UserInfoEntity * userInfo;

-(void)saveConfig;
-(void)getMessage;

-(void) notifi_updateDialogueList:(FMDatabase *)db;
@end

