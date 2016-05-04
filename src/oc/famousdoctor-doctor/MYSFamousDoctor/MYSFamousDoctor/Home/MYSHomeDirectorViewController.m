//
//  MYSHomeDirectorViewController.m
//  MYSFamousDoctor
//
//  主任医师团-Home页面
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHomeDirectorViewController.h"
#import "MYSUserInfoViewController.h"
#import "MYSPatientQuestionsViewController.h"
#import "MYSMyReplyViewController.h"
#import "MYSHomeDirectorModel.h"

@interface MYSHomeDirectorViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation MYSHomeDirectorViewController

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
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    [self sendRquest];
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
            
            patientQuestions.text = [MYSUtils checkIsNullReturnZero:[msg objectForKey:@"question"]];
            myReply.text = [MYSUtils checkIsNullReturnZero:[msg objectForKey:@"myanswer"]];
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
 *  患者提问按钮点击事件
 */
- (IBAction)patientQuestionsBtnClick:(id)sender
{
    NSLog(@"患者提问按钮点击");
    MYSPatientQuestionsViewController *questionCtrl = [[MYSPatientQuestionsViewController alloc] init];
    [self.navigationController pushViewController:questionCtrl animated:YES];
}

/**
 *  我的回复按钮点击事件
 */
- (IBAction)myReplyBtnClick:(id)sender
{
    NSLog(@"我的回复按钮点击");
    MYSMyReplyViewController *replyCtrl = [[MYSMyReplyViewController alloc] init];
    [self.navigationController pushViewController:replyCtrl animated:YES];
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
