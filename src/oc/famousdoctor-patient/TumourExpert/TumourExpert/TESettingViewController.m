//
//  TESettingViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-24.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESettingViewController.h"
#import "TEStoreManager.h"
#import "TEVersionTools.h"
#import "TEAppDelegate.h"

typedef NS_ENUM(NSInteger, TESettingSwitchStatus) {
    TESettingSwitchStatusOpen = 1,
     TESettingSwitchStatusClose = 2
};

@interface TESettingViewController ()

@end

@implementation TESettingViewController

#pragma mark - DataSource

- (void)loadDataSource
{
    self.dataSource = [[TEStoreManager sharedStoreManager] getSettingConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
    }
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 自定义accessoryView
        UISwitch *autoLoginSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"settingSwitch"] isEqualToString:@"1"])
        {
            autoLoginSwitch.on = YES;
        } else {
            autoLoginSwitch.on = NO;
        }

        [autoLoginSwitch addTarget:self action:@selector(switchAutoLogin:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = autoLoginSwitch;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [[TEVersionTools sharedInstance] checkVersionForSynchronous];
    } else if (indexPath.row == 2) {
        self.hidesBottomBarWhenPushed = YES;
        // 判断是否已登录
        if (ApplicationDelegate.isLogin) {
            UIViewController <TEModifyPasswordViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEModifyPasswordViewControllerProtocol)];
            [self pushNewViewController:viewController];
        } else {
            UIViewController <TELoginViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TELoginViewControllerProtocol)];
            [self pushNewViewController:viewController];
        }
    } else if (indexPath.row == 3) {
        [[TEVersionTools sharedInstance] openAppReviews] ;
    }
}

// 设置自动登录的开关
- (void)switchAutoLogin:(UISwitch *)aSwitch
{
    if (aSwitch.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"settingSwitch"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"settingSwitch"];
    }
    
}

@end
