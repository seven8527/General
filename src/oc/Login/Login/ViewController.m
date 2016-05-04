//
//  ViewController.m
//  Login
//
//  Created by Owen on 15-6-3.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "ViewController.h"
#import "OJAlertUtil.h"
#import "OJHttpUtil.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "OJProgressBar.h"


@interface ViewController ()


@end

@implementation ViewController


/**
 *  视图加载完成
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBord)];
    [self.view addGestureRecognizer:tap];
}

-(void)hideKeyBord
{
    [_userName resignFirstResponder];
    [_passWord resignFirstResponder];
    
}
#pragma mark-
#pragma 点击按钮
- (IBAction)btnOpenClicked:(id)sender
{
    NSString *name = [_userName text];
    NSString *pwd = [_passWord text];
    
   // NSString * printStr = [NSString stringWithFormat:@"name is %@ and pwd is %@", name ,pwd];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:printStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
//    [alert show];
    NSString *str = [NSString stringWithFormat:@"http://www.owen.webatu.com/login0.php"];
    
    NSDictionary *parameters = @{@"name":name  , @"pwd":pwd};
    
   
    OJProgressBar *mbP = [OJProgressBar showHUDAddTo:self.view animated:YES message:@"提交中..."];

    
    [OJHttpUtil GET:str parameters:parameters success: ^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        NSString *state = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"state"]];
        if([state isEqualToString:@"1"])
        {
            [OJAlertUtil showAlert:@"登录成功"];
        }
        else if([state isEqualToString:@"0"])
        {
            [OJAlertUtil showAlert:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]]];
             NSLog(@"%@", [responseObject objectForKey:@"msg"]);
        }
        else{
            [OJAlertUtil showAlert:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]]];
            NSLog(@"%@", [responseObject objectForKey:@"msg"]);

        }
        [mbP hide:YES];
    
    } failure:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
        [mbP hide:YES];
        [OJAlertUtil showAlert:[NSString stringWithFormat:@"网络请求异常 error code:%i", error.code]];


    }];
    
    
//    [AlertUtil showAlert:printStr];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnRegisterClicked:(id)sender
{
    
    RegisterViewController *regist = [[RegisterViewController alloc]initWithNibName:@"RegisterView" bundle:nil];
    regist.delegate = self;
    [self presentViewController:regist animated:YES completion:nil];
    
}
-(void)registed:(RegisterViewController *)sender{
    [_userName setText:[sender.name text]];
    [_passWord setText:[sender.pwd text]];
}
@end