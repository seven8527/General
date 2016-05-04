//
//  AppDelegate.m
//  BigNews
//
//  Created by Owen on 15-8-12.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController/BNBaseViewController.h"
#import "BNHomeViewController.h"
#import "BNSettingViewController.h"
#import "BNHotsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    BNHomeViewController <BNHomeViewControllerProtocol> *homeCtl          = [[JSObjection defaultInjector] getObject:@protocol(BNHomeViewControllerProtocol)];
    BNSettingViewController <BNSettingViewControllerProtocol> *settingCtl = [[JSObjection defaultInjector] getObject:@protocol(BNSettingViewControllerProtocol)];

    BNHotsViewController <BNHotsViewControllerProtocol> *hotsCtl          = [[JSObjection defaultInjector] getObject:@protocol(BNHotsViewControllerProtocol)];
    
    UINavigationController * homeNav    = [[UINavigationController alloc]initWithRootViewController:homeCtl];
    UINavigationController * settingNav = [[UINavigationController alloc]initWithRootViewController:settingCtl];
    UINavigationController * hotsNav    = [[UINavigationController alloc]initWithRootViewController:hotsCtl];
    
//    - (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
    homeCtl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:ImageNamed(@"nav_button11") selectedImage:ImageNamed(@"nav_button1")];
    hotsCtl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"热门" image:ImageNamed(@"nav_button12") selectedImage:ImageNamed(@"nav_button2")];
    settingCtl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"设置" image:ImageNamed(@"nav_button13") selectedImage:ImageNamed(@"nav_button3")];
    
    // 设置tabbarController
    _tabBarController  = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[homeNav, hotsNav , settingNav];
    _tabBarController.tabBar.tintColor = UIColorFromRGB(KFFFFFFColor);
    _tabBarController.tabBar.barTintColor =UIColorFromRGB(K00C3D5Color);
    _tabBarController.delegate = self;
    
    self.window.rootViewController = _tabBarController;

    
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
}

@end
