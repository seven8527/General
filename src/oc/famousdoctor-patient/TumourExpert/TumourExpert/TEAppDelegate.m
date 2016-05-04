//
//  TEAppDelegate.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAppDelegate.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "UITabBarItem+Universal.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEHomeViewController.h"
#import "TEExpertViewController.h"
#import "TEPersonalViewController.h"
#import "TEOrderViewController.h"
#import <IQKeyboardManager.h>
#import "TEUserModel.h"
#import "TEVersionTools.h"
#import "UIDevice+SupportedDevices.h"
#import "AESCrypt.h"
#import <SSKeychain.h>
#import "BaiduMobStat.h"
#import "TEResultModel.h"

#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "PartnerConfig.h"

#import "TEHttpTools.h"

@implementation TEAppDelegate

#pragma mark -
#pragma mark Application lifecycle

#pragma mark - UIApplication Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 网络指示器
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 检查版本
    [TEVersionTools sharedInstance].appID = @"917924758";
    [[TEVersionTools sharedInstance] checkVersion];
    
    // 自定义状态栏
    [TEUITools customStatusBar];
    
    // 自定义导航条
    [TEUITools customNavigationBar];
    
    // 设置rootViewController
    [self setupRootViewController];
    
    // 设置键盘
    [self setupKeyboard];
    
    //[self setupBaiduMob];
    
    [self deleteKeychainInfo];
    
    [self checkNetwork];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parse:url application:application];
	return YES;
}

#pragma mark - Pay

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                //[self finishedPay];
                
                UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                UIViewController <TEPaySuccessViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPaySuccessViewControllerProtocol)];
                viewController.TEConfirmConsultType = self.TEConfirmConsultType;
                viewController.hidesBottomBarWhenPushed = YES;
                [navController pushViewController:viewController animated:NO];
                
                for (UIViewController *ctrl in navController.viewControllers) {
                    if ([ctrl isMemberOfClass:[TEHomeViewController class]]) {
                        [self.tabBarController.navigationController popToViewController:ctrl animated:YES];
                    } else if ([ctrl isMemberOfClass:[TEExpertViewController class]]) {
                        [self.tabBarController.navigationController popToViewController:ctrl animated:YES];
                    } 
                }
			}
        }
        else
        {
            //交易失败
            UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
            UIViewController <TEPayFailureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayFailureViewControllerProtocol)];
            viewController.hidesBottomBarWhenPushed = YES;
            [navController pushViewController:viewController animated:NO];
        }
    }
    else
    {
        //失败
        UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
        UIViewController <TEPayFailureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayFailureViewControllerProtocol)];
        viewController.hidesBottomBarWhenPushed = YES;
        [navController pushViewController:viewController animated:NO];
    }
    
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}



#pragma mark - Bussiness methods

// 设置rootViewController
- (void)setupRootViewController
{
    UIViewController <TEHomeViewControllerProtocol> *homeViewController = [[JSObjection defaultInjector] getObject:@protocol(TEHomeViewControllerProtocol)];
    homeViewController.title = @"首页";
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    homeViewController.tabBarItem = [UITabBarItem itemWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home0.png"] selectedImage:[UIImage imageNamed:@"tab_home1.png"]];
    
    UIViewController <TEExpertViewControllerProtocol> *expertViewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertViewControllerProtocol)];
    expertViewController.title = @"找专家";
    UINavigationController *expertNavigationController = [[UINavigationController alloc] initWithRootViewController:expertViewController];
    expertViewController.tabBarItem = [UITabBarItem itemWithTitle:@"找专家" image:[UIImage imageNamed:@"tab_search0.png"] selectedImage:[UIImage imageNamed:@"tab_search1.png"]];
    
    UIViewController <TETriageViewControllerProtocol> *triageViewController = [[JSObjection defaultInjector] getObject:@protocol(TETriageViewControllerProtocol)];
    triageViewController.title = @"健康顾问";
    UINavigationController *triageNavigationController = [[UINavigationController alloc] initWithRootViewController:triageViewController];
    triageViewController.tabBarItem = [UITabBarItem itemWithTitle:@"健康顾问" image:[UIImage imageNamed:@"tab_chat0.png"] selectedImage:[UIImage imageNamed:@"tab_chat1.png"]];
    
    UIViewController <TEPersonalViewControllerProtocol> *personalViewController = [[JSObjection defaultInjector] getObject:@protocol(TEPersonalViewControllerProtocol)];
    personalViewController.title = @"个人中心";
    UINavigationController *personalNavigationController = [[UINavigationController alloc] initWithRootViewController:personalViewController];
    personalViewController.tabBarItem = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"tab_user0.png"] selectedImage:[UIImage imageNamed:@"tab_user1.png"]];
    
    _tabBarController  = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[homeNavigationController, expertNavigationController, triageNavigationController, personalNavigationController];
    _tabBarController.tabBar.tintColor = [UIColor colorWithHex:0x00947d];
    self.window.rootViewController = _tabBarController;
}

// 设置键盘
- (void)setupKeyboard
{
    //[IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}

// 设置百度统计
- (void)setupBaiduMob
{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.enableDebugOn = YES; //打开调试模式，发布时请去除此行代码或者设置为False即可。
    //    statTracker.logSendInterval = 1; //为1时表示发送日志的时间间隔为1小时,只有 statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch这时才生效。
    statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 60;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    statTracker.shortAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [statTracker startWithAppId:@"6e294ff81b"];//设置您在mtj网站上添加的app的appkey
}

// 完成支付
- (void)finishedPay
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"paysuccess"];
    NSDictionary *parameters = @{@"billno": self.orderId, @"cookie": ApplicationDelegate.cookie, @"pay_type": self.payType};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        if ([result.state isEqualToString:@"201"]) {
            
        }
    } failure:^(NSError *error) {
        ;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        if ([result.state isEqualToString:@"201"]) {
//            
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@, operation: %@", error, operation.responseString);
//    }];
}

/**
 *  自动登录
 */
- (void)autoLogin
{
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [settings objectForKey:@"TEUserLogin"];
    if (dict) {
        NSString *account = [dict objectForKey:@"Account"];
        NSLog(@"account:%@, jiami password:%@", account, [dict objectForKey:@"Password"]);
        NSString *password = @"";
        if ([dict objectForKey:@"Password"]) {
            password = [AESCrypt decrypt:[dict objectForKey:@"Password"] password:@"mingyisheng"];
        }
        NSLog(@"account:%@, password:%@", account, password);
        if (![account isEqualToString:@""] && ![password isEqualToString:@""]) {
            [self loginWithAccount:account password:password];
        }
    } else {
        [self userOperationLogWithUserId:@"0" actionType:@"mobile_open" os:@"ios" deviceType:@"mobile" deviceModel:[UIDevice supportedDeviceName] deviceUid:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    }
}

/**
 *  删除钥匙链信息
 */
- (void)deleteKeychainInfo
{
    NSArray *accounts = [SSKeychain accountsForService:kTEKeychainServiceName];
    for (NSDictionary *dictionary in accounts) {
        NSString *account = [dictionary objectForKey:@"acct"];
        NSError *error = nil;
        NSString *password =  [SSKeychain passwordForService:kTEKeychainServiceName account:account error:&error];
        NSLog(@"password:%@, account:%@", password, account);
        
        [SSKeychain deletePasswordForService:kTEKeychainServiceName account:account];
    }
}


#pragma mark - API

/**
 *  调用后台登录接口
 *
 *  @param account  登录账号
 *  @param password 登录密码
 */
- (void)loginWithAccount:(NSString *)account password:(NSString *)password
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"login"];
    NSDictionary *parameters = @{@"email": account, @"password":password};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEUserModel *user = [[TEUserModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = user.state;
        if ([state isEqualToString:@"1"]) {
            ApplicationDelegate.userId = user.userId;
            ApplicationDelegate.isLogin = YES;
            ApplicationDelegate.account = account;
            ApplicationDelegate.cookie = user.cookie;
            
            [self userOperationLogWithUserId:ApplicationDelegate.userId actionType:@"login" os:@"ios" deviceType:@"mobile" deviceModel:[UIDevice supportedDeviceName] deviceUid:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
        } else if ([state isEqualToString:@"-100"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEUserModel *user = [[TEUserModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = user.state;
//        if ([state isEqualToString:@"1"]) {
//            ApplicationDelegate.userId = user.userId;
//            ApplicationDelegate.isLogin = YES;
//            ApplicationDelegate.account = account;
//            ApplicationDelegate.cookie = user.cookie;
//            
//            [self userOperationLogWithUserId:ApplicationDelegate.userId actionType:@"login" os:@"ios" deviceType:@"mobile" deviceModel:[UIDevice supportedDeviceName] deviceUid:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
//            
//        } else if ([state isEqualToString:@"-100"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}


/**
 *  记录用户操作日志
 *
 *  @param userId      用户Id，没有用户Id默认为0
 *  @param actionType  操作的类型,登录为login, 注册为register, 打开为mobile_open, 支付为pay
 *  @param os          操作系统类型，苹果操作系统为ios
 *  @param deviceType  设备类型，手机为mobile, 平板为pad
 *  @param deviceModel 设备型号
 *  @param devideUid   设备唯一号
 */
- (void)userOperationLogWithUserId:(NSString *)userId actionType:(NSString *)actionType  os:(NSString *)os deviceType:(NSString *)deviceType deviceModel:(NSString *)deviceModel deviceUid:(NSString *)devideUid
{
    NSLog(@"userId:%@, actionType:%@, os:%@, deviceType:%@, deviceModel:%@, devideUid:%@", userId, actionType, os, deviceType, deviceModel, devideUid);
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"user_log"];
    NSDictionary *parameters = @{@"uid": userId, @"action":actionType, @"terminal_os": os, @"terminal": deviceType, @"terminal_type": deviceModel, @"moblie_sn": devideUid};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        ;
    } failure:^(NSError *error) {
        ;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

/**
 *  检查当前网络是否通畅
 *  如果网络通畅则自动登录
 */
- (void)checkNetwork
{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self autoLogin];
        });
    };
    
    [reach startNotifier];
}

@end
