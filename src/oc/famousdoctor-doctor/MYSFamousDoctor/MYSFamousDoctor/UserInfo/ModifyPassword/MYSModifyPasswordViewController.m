//
//  MYSModifyPasswordViewController.m
//  MYSFamousDoctor
//
//  修改密码
//
//  Created by lyc on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSModifyPasswordViewController.h"

#define BORDER_COLOR [UIColor colorWithRed:181/255.0f green:181/255.0f blue:181/255.0f alpha:1]
#define BORDER_WIDTH 1.0f
#define CORNER_RADIUS_SIZE 5.0f

@interface MYSModifyPasswordViewController ()

@end

@implementation MYSModifyPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    [self initView];
}

- (void)initView
{
    oldPassView.layer.borderColor = [BORDER_COLOR CGColor];
    oldPassView.layer.borderWidth = BORDER_WIDTH;
    oldPassView.layer.cornerRadius = CORNER_RADIUS_SIZE;
    
    newPassView1.layer.borderColor = [BORDER_COLOR CGColor];
    newPassView1.layer.borderWidth = BORDER_WIDTH;
    newPassView1.layer.cornerRadius = CORNER_RADIUS_SIZE;
    
    newPassView2.layer.borderColor = [BORDER_COLOR CGColor];
    newPassView2.layer.borderWidth = BORDER_WIDTH;
    newPassView2.layer.cornerRadius = CORNER_RADIUS_SIZE;
    
    saveBtn.layer.cornerRadius = CORNER_RADIUS_SIZE;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboard];
}

- (void)hiddenKeyboard
{
    if ([oldPassView isFirstResponder])
    {
        [oldPassView resignFirstResponder];
    }
    
    if ([newPassView1 isFirstResponder])
    {
        [newPassView1 resignFirstResponder];
    }
    
    if ([newPassView2 isFirstResponder])
    {
        [newPassView2 resignFirstResponder];
    }
}

- (IBAction)modifyBtnClick:(id)sender
{
    [self hiddenKeyboard];
    
    if ([self checkInput])
    {
        [self sendModifyRequest];
    }
}

/**
 *  检测输入项
 */
- (BOOL)checkInput
{
    if ([@"" isEqualToString:oldPassTextFeild.text])
    {
        [oldPassTextFeild becomeFirstResponder];
        [self showAlert:@"请输入当前密码"];
        return NO;
    }
    if ([@"" isEqualToString:newPass1View1TextFeild.text])
    {
        [newPass1View1TextFeild becomeFirstResponder];
        [self showAlert:@"请输入新密码"];
        return NO;
    }
    if (newPass1View1TextFeild.text.length < 6 || newPass1View1TextFeild.text.length > 16)
    {
        [newPass1View1TextFeild becomeFirstResponder];
        [self showAlert:@"请输入长度为6至16位密码"];
        return NO;
    }
    if ([@"" isEqualToString:newPass2View1TextFeild.text])
    {
        [newPass2View1TextFeild becomeFirstResponder];
        [self showAlert:@"请输入确认密码"];
        return NO;
    }
//    if (newPass2View1TextFeild.text.length < 6)
//    {
//        [newPass1View1TextFeild becomeFirstResponder];
//        [self showAlert:@"确认密码长度必须大于6位"];
//        return NO;
//    }
//    if (newPass2View1TextFeild.text.length > 16)
//    {
//        [newPass1View1TextFeild becomeFirstResponder];
//        [self showAlert:@"确认密码长度必须小于等于16位"];
//        return NO;
//    }
    if (![newPass1View1TextFeild.text isEqualToString:newPass2View1TextFeild.text])
    {
        [self showAlert:@"两次输入新密码不一致"];
        return NO;
    }
    return YES;
}

- (void)sendModifyRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"updatepass"];
    
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
//    NSDictionary *parameters = @{@"uid": };
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:userInfo.userId forKey:@"userid"];
    [parameters setValue:oldPassTextFeild.text forKey:@"oldpawd"];
    [parameters setValue:newPass1View1TextFeild.text forKey:@"password1"];
    [parameters setValue:newPass2View1TextFeild.text forKey:@"password2"];
    [parameters setValue:userInfo.cookie forKey:@"cookie"];
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        if ([@"88" isEqualToString:state])
        {
            [self showAlert:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([@"-17" isEqualToString:state]) {
            [self showAlert:@"原密码不正确"];
        } else {
            [self showAlert:@"非法操作"];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        [self showAlert:@"请求失败"];
    }];
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
