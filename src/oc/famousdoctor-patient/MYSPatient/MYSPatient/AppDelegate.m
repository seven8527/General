//
//  AppDelegate.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-1-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "AppDelegate.h"
#import "UITabBarItem+Universal.h"
#import "UtilsMacro.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "MYSPersonalViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MYSUserGuideViewController.h"
#import "MobClick.h"
#import "AESCrypt.h"
#import "HttpTool.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"

#define UMENG_APPKEY @"550bc50ffd98c54cba000203"

@interface AppDelegate () <UITabBarControllerDelegate, MYSUserGuideViewControllerDelegate, WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 注册微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WB_APP_ID];
    
    //向微信注册
    [WXApi registerApp:@"wx84b2b09b83324c2b"];
    
    // window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 启动UMeng统计
    [MobClick startWithAppkey:UMENG_APPKEY];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [self launchApp];

    [self customNavigationBar];
   
    [self checkNetwork];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    ApplicationDelegate.userId = nil;
    ApplicationDelegate.isLogin = NO;
    ApplicationDelegate.cookie = nil;
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            LOG(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            LOG(@"result = %@",resultDic);
        }];
    }
    
    if ([url.host isEqualToString:QQ_HOST])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([url.scheme isEqualToString:WB_SCHEME])
    {   // 微博
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    if ([url.scheme isEqualToString:WX_APP_ID])
    {   // 微信
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if ([url.host isEqualToString:QQ_HOST])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([url.scheme isEqualToString:WB_SCHEME])
    {   // 微博
        return [WeiboSDK handleOpenURL:url delegate:self];;
    }
    
    if ([url.scheme isEqualToString:WX_APP_ID])
    {   // 微信
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {   // 微博第三方登陆回调
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weiBoLoginSuccess" object:[(WBAuthorizeResponse *)response userID]];
    }
}

-(void) onReq:(BaseReq*)req
{
}

-(void) onResp:(BaseResp*)resp
{
    SendAuthResp *temp = (SendAuthResp*)resp;
    // 微信第三方登陆回调
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"weiXinLoginSuccess" object:temp.code];
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_APP_ID, WX_SECRET, temp.code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                self.access_token.text = [dic objectForKey:@"access_token"];
//                self.openid.text = [dic objectForKey:@"openid"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weiXinLoginSuccess" object:[dic objectForKey:@"openid"]];
            }
        });
    });
}

/**
 *  自定义导航栏
 */
- (void)customNavigationBar
{
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexRGB:KF6F6F6Color]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorFromHexRGB:K747474Color]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    // 统一设置标题字体大小、颜色，并去掉文字阴影
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorFromHexRGB:K333333Color],
                                                            NSFontAttributeName: [UIFont systemFontOfSize:18],
                                                            NSShadowAttributeName: shadow}];
    //    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //    [[UINavigationBar appearance] setShadowImage:[MYSFoundationCommon imageFromColor:[UIColor colorFromHexRGB:KC2C2C2Color] withRect:CGRectMake(0, 63, kScreen_Width, 0.5)]];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [tabBarController.viewControllers objectAtIndex:1]) {
        if (!ApplicationDelegate.isLogin) { // 未登录
            UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
            loginViewController.title = @"登录";
            loginViewController.source = NSClassFromString(@"AppDelegate");
            //loginViewController.aSelector = @selector(reflect);
            //loginViewController.instance = self;
//            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//            [viewController presentViewController:navController animated:YES completion:nil];
            
//            UINavigationController *navg = (UINavigationController *)viewController;
//            [navg pushViewController:loginViewController animated:YES];
            
            UINavigationController *navg = (UINavigationController *)tabBarController.selectedViewController;
            [navg pushViewController:loginViewController animated:YES];

            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}


- (void)launchApp
{
    // 取出上次使用的的版本号
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"CFBundleShortVersionString";
    NSString *lastVersion = [userDefaults objectForKey:key];
    
    // 获得当前版本号
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
    
    if([lastVersion isEqualToString:currentVersion]) {
        // 版本相同，说明已经使用过该版本app,直接进入
        [self setupRootViewController];
    } else {
        // 版本不一样，说明是首次使用该版本app,展示新特性
        [userDefaults setObject:currentVersion forKey:key];
        [userDefaults synchronize];
        [self setupGuideViewController];
    }
}

// 设置rootViewController
- (void)setupRootViewController
{
    
    // 首页控制器
    UIViewController <MYSHomeViewControllerProtocol> *homeViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSHomeViewControllerProtocol)];
    homeViewController.title = @"掌上名医生";
    homeViewController.tabBarItem = [UITabBarItem itemWithTitle:@"首页" image:[UIImage imageNamed:@"nav_button11"] selectedImage:[UIImage imageNamed:@"nav_button1"]];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    // 个人中心控制器
    UIViewController <MYSPersonalViewControllerPrototol> *personalViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalViewControllerPrototol)];
    personalViewController.title = @"个人中心";
    personalViewController.tabBarItem = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"nav_button12"] selectedImage:[UIImage imageNamed:@"nav_button2"]];
    UINavigationController *personalNavigationController = [[UINavigationController alloc] initWithRootViewController:personalViewController];
    
    
    // 更多控制器
    UIViewController <MYSMoreViewControllerProtocol> *moreViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSMoreViewControllerProtocol)];
    moreViewController.title = @"更多";
    moreViewController.tabBarItem = [UITabBarItem itemWithTitle:@"更多" image:[UIImage imageNamed:@"nav_button13"] selectedImage:[UIImage imageNamed:@"nav_button3"]];
    UINavigationController *moreNavigationController = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    
    
    // 设置tabbarController
    _tabBarController  = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[homeNavigationController, personalNavigationController, moreNavigationController];
    _tabBarController.tabBar.tintColor = [UIColor colorFromHexRGB:k00947DColor];
    _tabBarController.delegate = self;
    self.window.rootViewController = _tabBarController;
}


// 设置引导页
- (void)setupGuideViewController
{
    UIViewController <MYSUserGuideViewControllerProtocol> *userGuideViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSUserGuideViewControllerProtocol)];
    userGuideViewController.delegate = self;
    UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:userGuideViewController];
    self.window.rootViewController = navg;
}

// 新手引导即将消失
- (void)willDismissUserGuide
{
    [self setupRootViewController];
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

/**
 *  自动登录
 */
- (void)autoLogin
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [settings objectForKey:@"MYSUserLogin"];
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
    }
}

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
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        MYSUserModel *user = [[MYSUserModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = user.state;
        if ([state isEqualToString:@"1"]) {
            ApplicationDelegate.userId = user.userId;
            ApplicationDelegate.isLogin = YES;
            ApplicationDelegate.account = account;
            ApplicationDelegate.cookie = user.cookie;
        } else if ([state isEqualToString:@"-100"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
