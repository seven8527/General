//
//  AppDelegate.m
//  Express
//
//  Created by owen on 15/11/3.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "AppDelegate.h"
#import "DBHelper.h"
#import "EXHttpHelper.h"
#import "NSString+MD5HexDigest.h"
#import "EXHttpHelper.h"
#import "DBMessageManager.h"
#import "DBDialogueListManager.h"
#import "DBDialogueMemberManager.h"
#import "DialogueMemberEntity.h"
#import "DBUserInfoManager.h"
#import "MsgPlaySound.h"

@interface AppDelegate ()
@property (nonatomic, strong) MsgPlaySound * msgPlaySound;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    APPDELEGATE.syncCode = @"000000";
    _loopTime = 1.0f;
    
    
    [self loadConfig]; //载入设置
    [DBHelper initDB]; //初始化db
    
    [self checkNetwork]; //检测网络自动登陆
    [self setupRootViewController]; //初始化根视图
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
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

// 设置rootViewController
- (void)setupRootViewController{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController <EXDialogueViewControllerProtocol> * dialogueCtl = [[JSObjection defaultInjector] getObject:@protocol(EXDialogueViewControllerProtocol)];
    UIViewController <EXSettingViewControllerProtocol> *settingCtl     = [[JSObjection defaultInjector] getObject:@protocol(EXSettingViewControllerProtocol)];
    UIViewController <EXFriendViewControllerProtocol> *friendCtl        = [[JSObjection defaultInjector] getObject:@protocol(EXFriendViewControllerProtocol)];
    
    //    EXDialogueViewController * dialogueCtl = [[EXDialogueViewController alloc]init];
    //    EXSettingViewController  *settingCtl   = [[EXSettingViewController alloc]init];
    //    EXFriendViewController  *friendCtl     = [[EXFriendViewController alloc]init];
    
    
    UINavigationController * dialogueNav = [[UINavigationController alloc]initWithRootViewController:dialogueCtl];
    UINavigationController * settingNav  = [[UINavigationController alloc]initWithRootViewController:settingCtl];
    UINavigationController * friendNav   = [[UINavigationController alloc]initWithRootViewController:friendCtl];
    
    
    dialogueCtl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"对话" image:ImageNamed(@"nav_button11") selectedImage:ImageNamed(@"nav_button1")];
    friendCtl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"好友" image:ImageNamed(@"nav_button12") selectedImage:ImageNamed(@"nav_button2")];
    settingCtl.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"设置" image:ImageNamed(@"nav_button13") selectedImage:ImageNamed(@"nav_button3")];
    
    // 设置tabbarController
    _tabBarController  = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = [[NSArray alloc]initWithObjects:dialogueNav, friendNav , settingNav, nil];
    _tabBarController.tabBar.tintColor = UIColorFromRGB(KFFFFFFColor);
    _tabBarController.tabBar.barTintColor =UIColorFromRGB(K00C3D5Color);
    _tabBarController.delegate = self;
//    [_tabBarController setSelectedIndex:1];
    
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
}


-(void)loadConfig
{
    
    NSUserDefaults *userInfo  = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict        = [userInfo objectForKey:@"EXUserInfo"];
    if (dict) {
        APPDELEGATE.userName      = [dict objectForKey:@"userName"];
        APPDELEGATE.userPass      = [dict objectForKey:@"userPass"];
        APPDELEGATE.userSessionID = [dict objectForKey:@"SessionID"];
        APPDELEGATE.UserID        = [dict objectForKey:@"UserID"];
        APPDELEGATE.gender        = [dict objectForKey:@"gender"];
        
        NSLog(@"userName:%@,  md5 password:%@", APPDELEGATE.userName ,  APPDELEGATE.userPass);
    }
    _msgPlaySound = [[MsgPlaySound alloc]initSystemShake];
    
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBUserInfoManager queryAll:db QueryUserInfoResult:^(UserInfoEntity *result) {
            _userInfo = result;
        }];
    }];
}


-(void)saveConfig
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"EXUserInfo"];
//    NSDictionary *dict = @{@"userName":  APPDELEGATE.userName, @"userPass":  APPDELEGATE.userPass, @"SessionID":  APPDELEGATE.userSessionID, @"UserID":  APPDELEGATE.UserID };
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:APPDELEGATE.userName forKey:@"userName"];
    [dict setValue:APPDELEGATE.userPass forKey:@"userPass"];
    [dict setValue:  APPDELEGATE.userSessionID forKey:@"userSessionID"];
    [dict setValue:APPDELEGATE.UserID forKey:@"UserID"];
    
    if (!APPDELEGATE.gender) {
        [dict setValue:APPDELEGATE.gender forKey:@"gender"];
    }
    
    [settings setObject:dict forKey:@"EXUserInfo"];
    [settings synchronize];
}
/**
 *  检查当前网络是否通畅
 *  如果网络通畅则自动登录
 */
- (void)checkNetwork
{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    reach.reachableBlock = ^(Reachability *reachability) //网络可用时，执行自动登陆
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
    if (APPDELEGATE.UserID==nil) {//第一次登陆的时候是空的
        //目前写死的 登陆信息
//        APPDELEGATE.UserID =@"13201903556";
//        APPDELEGATE.userName=@"13201903556";
//        NSString *password   = @"000000";
        
        APPDELEGATE.UserID =@"13000000233";
        APPDELEGATE.userName=@"13000000233";
        NSString *password   = @"1234567";

        //   MD5加密
        NSString *md5        = [password md5HexDigest];
        APPDELEGATE.userPass = md5;
        [self loginWithAccount:APPDELEGATE.UserID password:md5];
    }
    else
    {
        
//         [self getMessage];
        // 自动登陆启动
        if (![APPDELEGATE.userName isEqualToString:@""] && ![APPDELEGATE.userPass isEqualToString:@""]) {
            [self loginWithAccount:APPDELEGATE.userName password:APPDELEGATE.userPass];
        }
    }
    
}

/**
 *  调用后台登录接口
 *
 *  @param userName  登录账号
 *  @param userPass 登录密码
 */
- (void)loginWithAccount:(NSString *)userName password:(NSString *)userPass
{
    
    NSDictionary *parameters = @{@"userName": userName, @"userPass":userPass};
    [EXHttpHelper POST:KACTION_LOGIIN deviceType:KDEVICE_TYPE_MP  parameters:parameters success:^(int resultCode, id responseObject) {
        
        switch (resultCode) {
            case 0: //成功
            {
//              NSDictionary *data = (NSDictionary* )responseObject;
                APPDELEGATE.userSessionID = [responseObject objectForKey:@"userSessionID"];
                NSLog(@"登陆成功 userSessionID = %@", APPDELEGATE.userSessionID);
                [self saveConfig];
                [self getUserInfo];
                [self getMessage];
                [self getAllGroup];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            }
                break;
            case 1003: //用户不存在
            {
                NSLog(@"用户不存在");
            }
                break;
            case 1004: //用户密码错误
            {
                 NSLog(@"用户密码错误");
            }
                break;
            default:
                NSLog(@"未知错误, 服务器返回异常");
                break;
        }

    } failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
    }];
    
   }


-(void) startLooper
{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:_loopTime //循环时间
                                                       target:self
                                                     selector:@selector(getMessage)
                                                     userInfo:nil
                                                      repeats:NO];
    [timer fire];
}

-(void)getUserInfo
{
    NSDictionary * parameter  = @{@"userName":APPDELEGATE.userName };
    [EXHttpHelper POST:KACTION_GETUSERINFO deviceType:KDEVICE_TYPE_WT parameters:parameter success:^(int resultCode, id responseObject) {
        switch (resultCode) {
            case 0: //成功
            {
                NSLog(@"%@",responseObject);
                _userInfo = [[UserInfoEntity alloc]initWithDictionary:responseObject error:nil];
                [DBHelper inTransaction:^(FMDatabase *db) {
                    [DBUserInfoManager insert:_userInfo FMDatabase:db InsertResult:^(Boolean result) {
                        if (!result) {
                            WDLog(@"用户数据获取异常");
                        }
                    }];
                }];
                
            }
                break;
            default:
            {
                NSLog(@"未知错误, 服务器返回异常");
            }
                break;
        }
    } failure:^(NSError *error) {
        NSLog(@"Error: %ld", (long)error.code);
    }];
    
}

-(void)getMessage
{
    
    NSDictionary * parameter  = @{@"ios_token":@"ios", @"syncCode":APPDELEGATE.syncCode , @"userName":APPDELEGATE.userName };
    [EXHttpHelper POST:KACTION_GETMESSAGE deviceType:KDEVICE_TYPE_WT parameters:parameter success:^(int resultCode, id responseObject) {
        switch (resultCode) {
            case 0: //成功
            {
                if ([[responseObject allKeys] containsObject:@"ok"]) {
                    NSLog(@"=======没有新消息==== ");
                     [self startLooper]; //没有新消息，等待数秒拉取新消息
                }
                else
                {
                    [_msgPlaySound play];
                    APPDELEGATE.syncCode = [responseObject objectForKey:@"syncCode"];
                    NSLog(@"======= getMessage ====  %@", responseObject);
                    NSMutableArray * array = [MessageEntity arrayOfModelsFromDictionaries:[responseObject objectForKey:@"messages"]];
                    [DBHelper inTransaction:^(FMDatabase *db) {
                        [DBMessageManager insertArray:array FMDatabase:db ResultStat:^(Boolean result) {
                            NSLog(@"数据插入结果 = %@", result?@"YES":@"NO");
                            if (result) {
                                
                                [self notifi_updateDialogueList:db];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"getNewMassage" object:db];
//                                [self updateDialogueTabels:array];
                            }
                        }];
                    }];
                    
                    [self getMessage]; //有新消息，立即拉取新消息
                }
            }
                break;
            default:
            {
                NSLog(@"未知错误, 服务器返回异常");
                [self  getMessage];
            }
                break;
        }
    } failure:^(NSError *error) {
        NSLog(@"Error: %ld", (long)error.code);
        [self  getMessage];
    }];
}

-(void)getAllGroup
{
    NSDictionary *dict = @{@"userName":APPDELEGATE.userName, @"obtainType":@"all"};
    [EXHttpHelper POST:KACTION_GROUP_LIST deviceType:KDEVICE_TYPE_WT parameters:dict success:^(int resultCode, id responseObject) {
        switch (resultCode) {
            case 0: //成功
            {
                NSMutableArray  *groupList = [DialogueListEntity arrayOfModelsFromDictionaries:[responseObject objectForKey:@"groupList"]];
                [DBHelper inTransaction:^(FMDatabase *db) {
                    [DBDialogueListManager insertArray:groupList FMDatabase:db GroupType:Group InsertArrayResult:^(Boolean result) {
                        NSLog(@"%@", result?@"YES":@"NO");
                        
                    }];
                }];
                
            }
                break;
                
            default:
            {
                NSLog(@"未知错误, 服务器返回异常");
            }
                break;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


-(void) notifi_updateDialogueList:(FMDatabase *)db
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFI_MESSAGE_UPDATE_DIALOGUE_LIST object:db];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFI_MESSAGE_UPDATE_DIALOGUE_DETAIL object:db];
}
@end