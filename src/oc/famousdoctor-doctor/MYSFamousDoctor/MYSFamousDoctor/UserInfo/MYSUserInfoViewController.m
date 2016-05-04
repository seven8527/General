//
//  MYSUserInfoViewController.m
//  MYSFamousDoctor
//
//  个人信息
//
//  Created by lyc on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSUserInfoViewController.h"
#import "MYSLoginViewController.h"
#import "MYSModifyPasswordViewController.h"
#import "MYSAboutUsViewController.h"
#import "MYSMyColumnViewController.h"
#import "MYSAuthenticationInfoViewController.h"

@interface MYSUserInfoViewController ()
{
    MYSUserInfoManager *userInfo;
}

@end

@implementation MYSUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    mData = [[NSMutableArray alloc] init];
    
    userInfo = [MYSUserInfoManager shareInstance];
    if ([@"0" isEqualToString:userInfo.doctor_type])
    {   // 名医汇
        [mData addObject:famousTopCell];
    } else {
        // 主任医师
        [mData addObject:zhurenTopCell];
    }
    [mData addObject:updateCell];
    [mData addObject:aboutUsCell];
    [mData addObject:bottomCell];
    
    mTableView.delegate = self;
    mTableView.dataSource =self;
}

#pragma mark
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mData count];
}

/**
 *  设定cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowHeight = 0;
    switch (indexPath.row)
    {
        case 0:
            if ([@"0" isEqualToString:userInfo.doctor_type])
            {   // 名医汇
                rowHeight = 183;
            } else {
                // 主任医师
                rowHeight = 143;
            }
            break;
        case 1:
            rowHeight = 10;
            break;
        case 3:
            rowHeight = 54;
            break;
        case 2:
            rowHeight = 44;
            break;
        default:
            break;
    }
    return rowHeight;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [mData objectAtIndex:indexPath.row];
}

#pragma mark
#pragma mark 按钮点击事件
/**
 *  认证信息点击事件
 */
- (IBAction)authenticationInfoBtnClick:(id)sender
{
    NSLog(@"认证信息点击");
    MYSAuthenticationInfoViewController *modifyPasswordCtrl = [[MYSAuthenticationInfoViewController alloc] init];
    [self.navigationController pushViewController:modifyPasswordCtrl animated:YES];
}

/**
 *  修改密码点击事件
 */
- (IBAction)modifyPasswordBtnClick:(id)sender
{
    NSLog(@"修改密码点击");
    MYSModifyPasswordViewController *modifyPasswordCtrl = [[MYSModifyPasswordViewController alloc] init];
    [self.navigationController pushViewController:modifyPasswordCtrl animated:YES];
}

/**
 *  拨打客服电话点击事件
 */
- (IBAction)callCustomServiceBtnClick:(id)sender
{
    NSLog(@"拨打客服电话点击");

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4006-118-221"]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
}

/**
 *  我的专栏点击事件
 */
- (IBAction)myColumnBtnClick:(id)sender
{
    NSLog(@"我的专栏点击");
    MYSMyColumnViewController *myColumnCtrl = [[MYSMyColumnViewController alloc] init];
    [self.navigationController pushViewController:myColumnCtrl animated:YES];
}

/**
 *  关于我们点击事件
 */
- (IBAction)aboutUsBtnClick:(id)sender
{
    NSLog(@"关于我们点击");
    
    MYSAboutUsViewController *aboutUsCtrl = [[MYSAboutUsViewController alloc] init];
    [self.navigationController pushViewController:aboutUsCtrl animated:YES];
}

/**
 *  退出登录点击事件
 */
- (IBAction)logoutBtnClick:(id)sender
{
    NSLog(@"退出登录点击");
    [[MYSUserInfoManager shareInstance] clearnData];
    MYSLoginViewController *loginCtrl = [[MYSLoginViewController alloc] init];
    [self.navigationController pushViewController:loginCtrl animated:YES];
}

@end
