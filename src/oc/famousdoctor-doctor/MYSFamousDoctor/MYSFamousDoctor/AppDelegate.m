//
//  AppDelegate.m
//  MYSFamousDoctor
//
//  Created by yanwb on 15/4/8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "AppDelegate.h"
#import "MYSLoginViewController.h"
#import "MYSHomeFamousViewController.h"
#import "MYSHomeDirectorViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *navgCtrl;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDictionary *userInfoDic = nil;
    if ([fileManager fileExistsAtPath:USER_INFO_PLIST])
    {
        userInfoDic = [NSDictionary dictionaryWithContentsOfFile:USER_INFO_PLIST];
    }
    
    if (nil != userInfoDic && ![@"" isEqualToString:[userInfoDic objectForKey:@"uid"]])
    {
        // 设定缓存
        MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
        userInfo.userId = [userInfoDic objectForKey:@"uid"];
        userInfo.cookie = [userInfoDic objectForKey:@"cookie"];
        userInfo.phone = [userInfoDic objectForKey:@"mobile"];
        userInfo.doctor_type = [userInfoDic objectForKey:@"doctor_type"];
        
        if ([@"0" isEqualToString:userInfo.doctor_type])
        {   // 名医汇
            MYSHomeFamousViewController *famousCtrl = [[MYSHomeFamousViewController alloc] init];
            navgCtrl = [[UINavigationController alloc] initWithRootViewController:famousCtrl];
        } else {
            // 主任医师团
            MYSHomeDirectorViewController *directorCtrl = [[MYSHomeDirectorViewController alloc] init];
            navgCtrl = [[UINavigationController alloc] initWithRootViewController:directorCtrl];
        }
    } else {
        MYSLoginViewController *loginCtrl = [[MYSLoginViewController alloc] init];
        navgCtrl = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    }

    self.window.rootViewController = navgCtrl;
    
    return YES;
}

- (void)umengTrack
{
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    [MobClick setLogEnabled:YES];
}

- (void)onlineConfigCallBack:(NSNotification *)notification
{
    NSLog(@"online config has fininshed and params = %@", notification.userInfo);
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
}

@end
