//
//  MYSLoginViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "WXApi.h"

@protocol MYSLoginViewControllerDelegate <NSObject>
- (void)willDismissLogin;
@end

@interface MYSLoginViewController : MYSBaseTableViewController <TencentSessionDelegate, WXApiDelegate>
@property (nonatomic, strong) Class source; // 来源
@property (nonatomic, assign) SEL aSelector; // 方法
@property (nonatomic, strong) id instance; // 实例
@property (nonatomic, assign) BOOL isHiddenRegisterButton; // 是否隐藏注册按钮

@property (nonatomic, weak) id <MYSLoginViewControllerDelegate> delegate;


// QQ第三方登陆属性 Start
@property (retain, nonatomic) TencentOAuth *tencentOAuth;
@property (retain, nonatomic) NSArray *tencentPermissions;
@property (retain, nonatomic) NSString *tencentOpenID;
// QQ第三方登陆属性 End


@end
