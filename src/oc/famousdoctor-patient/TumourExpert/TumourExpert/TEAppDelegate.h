//
//  TEAppDelegate.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TERegisterPortal) {
    TERegisterPortalPersonal     = 1,  // 从个人中心页面进入注册页面
    TERegisterPortalConsult    = 2,  // 从专家咨询页面进入注册页面
};

typedef NS_ENUM(NSInteger, TEPatientDataPortal) {
    TEPatientDataPortalPersonal   = 1,  // 从个人中心页面进入患者资料页面
    TEPatientDataPortalConsult    = 2,  // 从专家咨询页面进入患者资料页面
};

typedef NS_ENUM(NSInteger, TEAddPatientPotal) {
    TEAddPatientPotalPersonal = 1, //从个人中心进入添加患者
    TEAddPatientPotalConsult = 2 //从创建咨询界面进入添加患者
};

@interface TEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) NSString *userId; // 用户id
@property (nonatomic, strong) NSString *account; // 账号，可能是用户名、邮箱、手机
@property (nonatomic, strong) NSString *orderId; // 订单id
@property (nonatomic, strong) NSString *payType; // 支付类型
@property (nonatomic, assign) int TEConfirmConsultType; // 咨询类型
@property (nonatomic, strong) NSString *cookie; // cookie
@property (nonatomic, assign) BOOL isLogin; // 是否已登录
@property (nonatomic, assign) int registerProtal; // 注册的入口
@property (nonatomic, assign) int patientDataProtal; // 患者资料的入口
@property (nonatomic, assign) int addPatientProtal; // 添加咨询者入口
@property (nonatomic, assign) int payProtal; // 去付款入口

@end
