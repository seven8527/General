//
//  MYSLoginViewController.m
//  MYSFamousDoctor
//
//  登录
//
//  Created by Mr.L on 15/4/8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSLoginViewController.h"
#import "MYSHomeFamousViewController.h"
#import "MYSHomeDirectorViewController.h"
#import "MYSRegisterFirstTableViewController.h"
#import "MYSLoginModel.h"
#import "MYSRegisterSecondTableViewController.h"
#import "MYSExaminingViewController.h"
#import "MYSExamineFailViewController.h"
#import "MYSModifyPassTableViewController.h"

@interface MYSLoginViewController ()

@end

@implementation MYSLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    inputView.layer.cornerRadius = 8;
    inputView.layer.borderColor = [[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1] CGColor];
    inputView.layer.borderWidth = 0.5;
    
    loginBtn.layer.cornerRadius = 5;
    registerBtn.layer.cornerRadius = 5;
    registerBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0f green:164/255.0f blue:143/255.0f alpha:1] CGColor];
    registerBtn.layer.borderWidth = 0.5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    CGFloat logoWidth = 118;
    CGFloat logoHeight = 168;
    if (kScreen_Height == 480)
    {
        logoImageView.hidden = YES;
        CGFloat rate = 0.75;
        logo.frame = CGRectMake((kScreen_Width - logoWidth * rate) / 2, 52, logoWidth * rate, logoHeight * rate);
        [self.view addSubview:logo];
    } else {
        logoImageView.hidden = NO;
    }
}

/**
 *  登录按钮点击事件
 */
- (IBAction)loginBtnClick:(id)sender
{
    [self hiddenKeyboard];
    if ([self checkLoginInput])
    {
        [self sendLoginRequest];
    }
}

#pragma mark 发送登录请求
/**
 *  发送登录请求
 */
- (void)sendLoginRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    hud.labelText = @"正在加载";
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"login/dlogin"];
    NSDictionary *parameters = @{@"mobile": usernameTextField.text, @"password":passwordTextField.text};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        MYSLoginModel *result = [[MYSLoginModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = [responseObject objectForKey:@"state"];
        
        // 设定缓存
        MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
        userInfo.userId = [MYSUtils checkIsNull:[responseObject objectForKey:@"uid"]];
        userInfo.cookie = [MYSUtils checkIsNull:[responseObject objectForKey:@"cookie"]];
        userInfo.phone = [MYSUtils checkIsNull:[responseObject objectForKey:@"mobile"]];
        userInfo.doctor_type = [MYSUtils checkIsNull:[responseObject objectForKey:@"doctor_type"]];
        
        if ([state isEqualToString:@"1"])
        {   // 成功
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            if (![fileManager fileExistsAtPath:USER_INFO_PLIST])
            {
                [fileManager createFileAtPath:USER_INFO_PLIST contents:nil attributes:nil];
            }
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"close"]] forKey:@"close"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"cookie"]] forKey:@"cookie"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"doctor_type"]] forKey:@"doctor_type"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"email_confirm"]] forKey:@"email_confirm"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"mobile"]] forKey:@"mobile"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"mobile_confirm"]] forKey:@"mobile_confirm"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"nick_name"]] forKey:@"nick_name"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"state"]] forKey:@"state"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"uid"]] forKey:@"uid"];
            [dic setObject:[MYSUtils checkIsNull:[responseObject objectForKey:@"user_type"]] forKey:@"user_type"];
            [dic writeToFile:USER_INFO_PLIST atomically:YES];
            
            if ([@"0" isEqualToString:result.doctor_type])
            {   // 名医汇
                MYSHomeFamousViewController *famousCtrl = [[MYSHomeFamousViewController alloc] init];
                [self.navigationController pushViewController:famousCtrl animated:YES];
            } else {
                // 主任医师团
                MYSHomeDirectorViewController *directorCtrl = [[MYSHomeDirectorViewController alloc] init];
                [self.navigationController pushViewController:directorCtrl animated:YES];
            }
        } else if ([state isEqualToString:@"-403"]) {
            [self showAlert:@"用户为黑名单"];
        } else if ([state isEqualToString:@"-405"]) {
            [self showAlert:@"账户为普通用户不允许登录"];
        } else if ([state isEqualToString:@"-406"]) {
            // 未填资料
            MYSRegisterSecondTableViewController *addInfo = [[MYSRegisterSecondTableViewController alloc] init];
            [self.navigationController pushViewController:addInfo animated:YES];
        } else if ([state isEqualToString:@"-407"]) {
            // 资料待审核
            MYSExaminingViewController  *addInfo = [[MYSExaminingViewController alloc] init];
            [self.navigationController pushViewController:addInfo animated:YES];
        } else if ([state isEqualToString:@"-408"]) {
            // 审核不通过
            MYSExamineFailViewController *addInfo = [[MYSExamineFailViewController alloc] init];
            [self.navigationController pushViewController:addInfo animated:YES];
        } else if ([state isEqualToString:@"-100"]) {
            [self showAlert:@"登录失败"];
        }
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        [self showAlert:@"请求失败"];
    }];
}

/**
 *  check登录输入信息
 */
- (BOOL)checkLoginInput
{
    if ([@"" isEqualToString:usernameTextField.text])
    {
        [self showAlert:@"请输入用户名"];
        return NO;
    }
    if ([@"" isEqualToString:passwordTextField.text])
    {
        [self showAlert:@"请输入密码"];
        return NO;
    }
    return YES;
}

- (IBAction)forgetPassBtnClick:(id)sender
{
    MYSModifyPassTableViewController *ctrl = [[MYSModifyPassTableViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

/**
 *  注册按钮点击事件
 */
- (IBAction)registerBtnClick
{
    [self hiddenKeyboard];
    MYSRegisterFirstTableViewController  *registerFirstCtrl = [[MYSRegisterFirstTableViewController alloc] init];
    [self.navigationController pushViewController:registerFirstCtrl animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboard];
}

/**
 *  隐藏键盘
 */
- (void)hiddenKeyboard
{
    if ([usernameTextField isFirstResponder])
    {
        [usernameTextField resignFirstResponder];
    }
    
    if ([passwordTextField isFirstResponder])
    {
        [passwordTextField resignFirstResponder];
    }
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
