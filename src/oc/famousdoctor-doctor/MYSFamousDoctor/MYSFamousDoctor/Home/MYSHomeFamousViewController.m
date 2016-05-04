//
//  MYSHomeFamousViewController.m
//  MYSFamousDoctor
//
//  名医汇-Home页面
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHomeFamousViewController.h"
#import "MYSUserInfoViewController.h"
#import "MYSNetConsultationViewController.h"
#import "MYSPhoneConsultationViewController.h"
#import "MYSFaceToFaceViewController.h"
#import "MYSLoginViewController.h"

@interface MYSHomeFamousViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation MYSHomeFamousViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirst = YES;
    doctorImageView.layer.masksToBounds = YES;
    doctorImageView.layer.cornerRadius = 45;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sendRquest];
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

/**
 *  发送请求
 */
- (void)sendRquest
{
    if (isFirst)
    {
        hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
        hud.labelText = @"正在加载";
    }
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"doctor_home"];
    
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    NSDictionary *parameters = @{@"uid": userInfo.userId};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
                
        NSString *state = [responseObject objectForKey:@"state"];
        
        if ([@"1" isEqualToString:state])
        {    // 访问成功的场合
            
            id msg = [responseObject objectForKey:@"msg"];
            
            userInfo.doctor_name = [MYSUtils checkIsNull:[msg objectForKey:@"doctor_name"]];
            userInfo.doctor_pic = [MYSUtils checkIsNull:[msg objectForKey:@"pic"]];
            
            NSString *imageUrl = [MYSUtils checkIsNull:[msg objectForKey:@"pic"]];
            NSURL *url = [NSURL URLWithString:imageUrl];
            [doctorImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
            
            doctorName.text = [MYSUtils checkIsNull:[msg objectForKey:@"doctor_name"]];
            doctorUnit.text = [MYSUtils checkIsNull:[msg objectForKey:@"title"]];
            
            net.text = [MYSUtils checkIsNullReturnZero:[msg objectForKey:@"net"]];
            call.text = [MYSUtils checkIsNullReturnZero:[msg objectForKey:@"tel"]];
            faceToFace.text = [MYSUtils checkIsNullReturnZero:[msg objectForKey:@"referral"]];
        } else if ([@"-2" isEqualToString:state]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"该医生不存在"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.tag = 99999;
            [alert show];
        } else {
            [self showAlert:@"账户信息异常"];
        }
        if (isFirst)
        {
            [hud hide:YES];
        }
        isFirst = NO;
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        if (isFirst)
        {
            [hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败，是否重新加载?" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"确定", nil];
            alert.tag = 20001;
            [alert show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (20001 == alertView.tag)
    {
        if (0 == buttonIndex)
        {
            MYSLoginViewController *loginCtrl = [[MYSLoginViewController alloc] init];
            [self.navigationController pushViewController:loginCtrl animated:YES];
        } else {
            [self sendRquest];
        }
    }
    
    if (99999 == alertView.tag)
    {
        MYSLoginViewController *loginCtrl = [[MYSLoginViewController alloc] init];
        [self.navigationController pushViewController:loginCtrl animated:YES];
    }
}

#pragma mark 
#pragma mark 按钮点击事件
/**
 *  网络咨询按钮点击事件
 */
- (IBAction)netBtnClick:(id)sender
{
    NSLog(@"网络咨询按钮点击");
    MYSNetConsultationViewController *netCtrl = [[MYSNetConsultationViewController alloc] init];
    [self.navigationController pushViewController:netCtrl animated:YES];
}

/**
 *  电话咨询按钮点击事件
 */
- (IBAction)callBtnClick:(id)sender
{
    NSLog(@"电话咨询按钮点击");
    MYSPhoneConsultationViewController *netCtrl = [[MYSPhoneConsultationViewController alloc] init];
    [self.navigationController pushViewController:netCtrl animated:YES];
}

/**
 *  面对面咨询按钮点击事件
 */
- (IBAction)faceToFaceBtnClick:(id)sender
{
    NSLog(@"面对面咨询按钮点击");
    MYSFaceToFaceViewController *faceCtrl = [[MYSFaceToFaceViewController alloc] init];
    [self.navigationController pushViewController:faceCtrl animated:YES];
}

/**
 *  联系医助按钮点击事件
 */
- (IBAction)contactBtnClick:(id)sender
{
    NSLog(@"联系医助按钮点击");
    NSString *urlString = [NSString stringWithFormat:@"telprompt://%@", @"4006118221"];
    NSURL *URL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:URL];
}

/**
 *  个人信息按钮点击事件
 */
- (IBAction)userinfoBtnClick:(id)sender
{
    NSLog(@"个人信息按钮点击");
    MYSUserInfoViewController *userInfoCtrl = [[MYSUserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfoCtrl animated:YES];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
