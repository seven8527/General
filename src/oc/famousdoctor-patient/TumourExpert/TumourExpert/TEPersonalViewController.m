//
//  TEPersonalViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPersonalViewController.h"
#import "UIColor+Hex.h"
#import "TEAppDelegate.h"
#import "NSString+CalculateTextSize.h"
#import "TEResultModel.h"
#import "TEStoreManager.h"
#import "TEPersonalLoginView.h"
#import "TEPersonalLogoutView.h"
#import "UIView+TEBadgeVifew.h"
#import "TERemindModel.h"
#import "TEHttpTools.h"

@interface TEPersonalViewController ()
@property (nonatomic, strong) TEPersonalLoginView *loginView;
@property (nonatomic, strong) TEPersonalLogoutView *logoutView;
@property (nonatomic, strong) NSString *consultRemind;
@end

@implementation TEPersonalViewController

#pragma mark - Propertys

//- (TEPersonalLoginView *)loginView {
//    if (!_loginView) {
//        _loginView = [[TEPersonalLoginView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 102)];
//        [_loginView.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_loginView.registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _loginView;
//}
//
//- (TEPersonalLogoutView *)logoutView {
//    if (!_logoutView) {
//        _logoutView = [[TEPersonalLogoutView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 84)];
//        [_logoutView.logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _logoutView;
//}

#pragma mark - DataSource

- (void)loadDataSource
{
    self.dataSource = [[TEStoreManager sharedStoreManager] getPersonalCenterConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (ApplicationDelegate.isLogin) {

        [self.tableView reloadData];
    } 
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClicked:)];
    if (ApplicationDelegate.isLogin) {
        rightBarButton.title = @"退出";
    } else {
        rightBarButton.title = @"登录";
    }
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self loadDataSource];
    
    // 从个人中心页面进入注册页面
    ApplicationDelegate.registerProtal = TERegisterPortalPersonal;
}


#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
    }
    
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            self.hidesBottomBarWhenPushed = YES;
            // 判断是否已登录
            if (ApplicationDelegate.isLogin) {
                UIViewController <TEPersonalDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPersonalDataViewControllerProtocol)];
                [self pushNewViewController:viewController];
            } else {
                UIViewController <TELoginViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TELoginViewControllerProtocol)];
                [self pushNewViewController:viewController];
            }
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        case 1:
        {
            self.hidesBottomBarWhenPushed = YES;
            // 判断是否已登录
            if (ApplicationDelegate.isLogin) {
                UIViewController <TEPatientViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientViewControllerProtocol)];
                [self pushNewViewController:viewController];
            } else {
                UIViewController <TELoginViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TELoginViewControllerProtocol)];
                [self pushNewViewController:viewController];
            }
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        case 2:
        {
            self.hidesBottomBarWhenPushed = YES;
            // 判断是否已登录
            if (ApplicationDelegate.isLogin) {
                UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
                viewController.title = @"网络咨询";
                viewController.consultType = @"0";
                [self pushNewViewController:viewController];
            } else {
                UIViewController <TELoginViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TELoginViewControllerProtocol)];
                [self pushNewViewController:viewController];
            }
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        case 3:
        {
            self.hidesBottomBarWhenPushed = YES;
            // 判断是否已登录
            if (ApplicationDelegate.isLogin) {
                UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
                viewController.title = @"电话咨询";
                viewController.consultType = @"1";
                [self pushNewViewController:viewController];
            } else {
                UIViewController <TELoginViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TELoginViewControllerProtocol)];
                [self pushNewViewController:viewController];
            }
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        case 4:
        {
            self.hidesBottomBarWhenPushed = YES;
            // 判断是否已登录
            if (ApplicationDelegate.isLogin) {
                UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
                viewController.title = @"面对面咨询";
                viewController.consultType = @"2";
                [self pushNewViewController:viewController];
            } else {
                UIViewController <TELoginViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TELoginViewControllerProtocol)];
                [self pushNewViewController:viewController];
            }
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        case 5:
        {
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <TESettingViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TESettingViewControllerProtocol)];
            [self pushNewViewController:viewController];
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        case 6:
        {
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <TEAboutUsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEAboutUsViewControllerProtocol)];
            [self pushNewViewController:viewController];
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
            
        default:
            break;
    }
}

- (void)rightButtonClicked:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"登录"]) {
        [self loginButtonClicked:item];
    } else {
        [self logoutButtonClicked:item];
    }
}

#pragma mark - Bussiness methods

- (void)logoutButtonClicked:(id)sender
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"logout"];
    [TEHttpTools post:URLString params:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"104"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注销成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
            ApplicationDelegate.isLogin = NO;
            ApplicationDelegate.userId = @"";
            ApplicationDelegate.account = @"";
            ApplicationDelegate.cookie = @"";
            
            self.navigationItem.rightBarButtonItem.title = @"登录";
            
            [self deleteAccountAndPassword];
            
            UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:3];
            navController.tabBarItem.badgeValue = nil;
            self.consultRemind = @"";
            [self.tableView reloadData];
        }

    } failure:^(NSError *error) {
        ;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"104"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注销成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//
//            ApplicationDelegate.isLogin = NO;
//            ApplicationDelegate.userId = @"";
//            ApplicationDelegate.account = @"";
//            ApplicationDelegate.cookie = @"";
//            
//            self.navigationItem.rightBarButtonItem.title = @"登录";
//            
//            [self deleteAccountAndPassword];
//            
//            UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:3];
//            navController.tabBarItem.badgeValue = nil;
//            self.consultRemind = @"";
//            [self.tableView reloadData];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

// 调用后台提醒接口
- (void)remind
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"remind"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TERemindModel *remind = [[TERemindModel alloc] initWithDictionary:responseObject error:nil];
        if (remind.text > 0 || remind.phone > 0 || remind.refer > 0) {
            UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:3];
            navController.tabBarItem.badgeValue = @"new";
            self.consultRemind = @"new";
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TERemindModel *remind = [[TERemindModel alloc] initWithDictionary:responseObject error:nil];
//        if (remind.text > 0 || remind.phone > 0 || remind.refer > 0) {
//            UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:3];
//            navController.tabBarItem.badgeValue = @"new";
//            self.consultRemind = @"new";
//            [self.tableView reloadData];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

- (void)loginButtonClicked:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TELoginViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TELoginViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)registerButtonClicked:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TERegisterViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TERegisterViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/**
 *  删除账号和密码
 */
- (void)deleteAccountAndPassword
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"TEUserLogin"];
    [settings synchronize];
}

@end
