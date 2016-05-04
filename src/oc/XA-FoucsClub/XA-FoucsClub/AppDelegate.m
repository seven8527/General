//
//  AppDelegate.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/12.
//  Copyright (c) 2015年 owen. All rights reserved.
//


#import "AppDelegate.h"
#import "NewsViewController.h"
#import  "PersionViewController.h"
#import "MoreViewController.h"
#import "User.h"
#import  "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds]; //设置主屏幕
    
    UITabBarController *tab = [[UITabBarController alloc]init]; // 创建 tabbar 控制器
    
    
    _window.rootViewController = tab; //设置主window 的控制器为 tab；
    
    //新建控制器的item
    UINavigationController *homeNav = [[UINavigationController alloc]init];
    
    UIViewController *homeController = [[NewsViewController alloc]init];
    homeController.view.backgroundColor = [UIColor redColor];
    homeController.tabBarItem.title = @"分类";
    homeController.tabBarItem.image = [UIImage imageNamed:@"nav_button11"];
    homeController.tabBarItem.badgeValue = @"12";
    
    [homeNav pushViewController:homeController animated:NO];
    
    
     UINavigationController *persionNav = [[UINavigationController alloc]init];
    UIViewController *persionController = [[PersionViewController alloc]init];
    persionController.view.backgroundColor = [UIColor greenColor];
    persionController.tabBarItem.title = @"热门";
    persionController.tabBarItem.image = [UIImage imageNamed:@"nav_button12"];
    [persionNav pushViewController:persionController animated:NO];

     UINavigationController *moreNav = [[UINavigationController alloc]init];
    UIViewController *moreController = [[MoreViewController alloc]init];
    moreController.view.backgroundColor = [UIColor darkGrayColor];
    moreController.tabBarItem.title = @"更多";
    moreController.tabBarItem.image = [UIImage imageNamed:@"nav_button13"];
    [moreNav pushViewController:moreController animated:NO];

    
    
    //将item 添加到 tabbar 控制器
    tab.viewControllers = @[homeNav , persionNav, moreNav];
    [_window makeKeyAndVisible];
    
    User *user = [self getUserData];
    if(user == NULL)
    {
        LoginViewController *login = [[LoginViewController alloc]init];
        
        
        [_window.rootViewController presentViewController:login animated:YES completion:nil];
//        ALERT(@"尚未登录,请先登录");
    }
    else
    {
        ALERT(@"已经登录");
    }
    return YES;
}


-(User *)getUserData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   
   NSData* data = [userDefaults objectForKey:LOGIN_USERDEFAULT_KEY];
   User * user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
   return user;
}

-(void) saveData:(User *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [userDefaults setObject:data forKey:LOGIN_USERDEFAULT_KEY];
}
- (void)clearData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:LOGIN_USERDEFAULT_KEY];
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
