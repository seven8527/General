//
//  RegisterViewController.m
//  Login
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "RegisterViewController.h"
#import "OJHttpUtil.h"
#import "MBProgressHUD.h"
#import "OJAlertUtil.h"
@implementation RegisterViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)HideKeyboard{
    [_name resignFirstResponder];
    [_pwd resignFirstResponder];
    [_pwd1 resignFirstResponder];
}

- (IBAction)RegisterBtnClicked:(id)sender {
    
    if([self checkEmpty:_name.text]||[self checkEmpty:_pwd.text ]||[self checkEmpty:_pwd1.text])
    {
      
        [OJAlertUtil showAlert:@"账号密码不能为空"];
        return ;
    }
    if(![_pwd.text isEqualToString:_pwd1.text])
    {
        [OJAlertUtil showAlert:@"两次输入的密码不一致"];
        return ;
    }
    NSString *url =@"http://www.owen.webatu.com/register.php";
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:_name.text,@"name", _pwd.text,@"pwd",nil];
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES ];
    mbp.labelText = @"正在提交...";
    [mbp show:YES];
    
    [OJHttpUtil GET:url parameters:para success:^(id responseObject) {
        NSString * stat = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"state"]];
        if([stat isEqualToString:@"1"])
        {
            NSLog(@"%@",[responseObject objectForKey:@"msg"]);
            
        }
        
        [OJAlertUtil showAlert:@"登录成功"];
        [mbp hide:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        [_delegate registed:self];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
        [mbp hide:YES];
        NSString *stat = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        [OJAlertUtil showAlert:[NSString stringWithFormat:@"网络请求异常 错误码:%i 错误状态:%@", error.code, stat]];
    }];
}

-(BOOL)checkEmpty:(NSString *)str
{
    return [str isEqualToString:@" "]||str.length==0;
}
@end
