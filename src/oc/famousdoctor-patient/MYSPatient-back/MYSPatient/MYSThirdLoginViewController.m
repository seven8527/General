//
//  MYSThirdLoginViewController.m
//  MYSPatient
//
//  Created by lyc on 15/5/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSThirdLoginViewController.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "UtilsMacro.h"
#import "AppDelegate.h"
#import "AESCrypt.h"

@interface MYSThirdLoginViewController ()

@end

@implementation MYSThirdLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"第三方账号绑定手机号";
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)initView
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    phoneView.layer.borderColor = [[UIColor colorFromHexRGB:KC6C6C6Color] CGColor];
    phoneView.layer.borderWidth = 1;
    
    codeView.layer.borderColor = [[UIColor colorFromHexRGB:KC6C6C6Color] CGColor];
    codeView.layer.borderWidth = 1;
    
    codeBtn.layer.cornerRadius = 4;
    okBtn.layer.cornerRadius = 4;
}

- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  传递参数
 *
 *  @param openId 第三方平台用户id
 *  @param type   0=qq 1=微博
 */
- (void)sendValue:(NSString *)openId type:(NSString *)type source:(Class)source;
{
    mOpenID = openId;
    mType = type;
    mSource = source;
}

#pragma mark 
#pragma mark 按钮点击事件
/**
 *  获取验证码按钮点击事件
 */
- (IBAction)getCodeBtnClick:(id)sender
{
    [self hiddenKeyboard];
    if ([Utils checkCellPhoneNum:phoneTextField.text])
    {
        phoneTextField.enabled = NO;
        [self sendGetCodeRequest];
    } else {
        [Utils showMessage:@"请输入正确的手机号"];
    }
}

/**
 *  确定按钮点击事件
 */
- (IBAction)okBtnClick:(id)sender
{
    [self hiddenKeyboard];
    if ([@"" isEqualToString:codeTextField.text])
    {
        [Utils showMessage:@"请输入验证码"];
    } else {
        [self sendBindRequest];
    }
}

#pragma 发送获取验证码请求
- (void)sendGetCodeRequest
{
    [self startTimer];
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"login/get_code"];
    NSDictionary *parameters = @{@"user_mobile": phoneTextField.text};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
//        if (-99 == [[responseObject objectForKey:@"state"] integerValue])
//        {
//            [Utils showMessage:@"验证码发送失败,请重新尝试"];
//        }
    } failure:^(NSError *error) {
        LOG(@"%@",error);
    }];
}

// 启动定时器
- (void)startTimer
{
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [codeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
                [codeBtn setEnabled:YES];
                codeBtn.userInteractionEnabled = YES;
                [phoneTextField setEnabled:YES];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%d秒", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [codeBtn setTitle:strTime forState:UIControlStateDisabled];
                [codeBtn setEnabled:NO];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma 发送绑定请求
- (void)sendBindRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"login/bind"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:mType forKey:@"user_type"];
    [parameters setObject:mOpenID forKey:@"t_uid"];
    [parameters setObject:phoneTextField.text forKey:@"user_mobile"];
    [parameters setObject:@"" forKey:@"qq"];
    [parameters setObject:@"" forKey:@"weibo"];
    [parameters setObject:codeTextField.text forKey:@"code"];
    [parameters setObject:@"" forKey:@"nick_name"];
    
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);

        NSInteger state = [[responseObject objectForKey:@"state"] integerValue];
        if (-2 == state)
        {
            [Utils showMessage:@"第三方ID或第三方类型为空"];
        }
        if (-7 == state)
        {
            [Utils showMessage:@"验证码输入错误"];
        }
        if (1 == state || 2 == state)
        {   // 1 绑定成功 （手机号已经存在，直接绑定成功）
            // 2 绑定成功（手机号注册绑定成功）
            ApplicationDelegate.userId = [responseObject objectForKey:@"uid"];
            ApplicationDelegate.isLogin = YES;
            ApplicationDelegate.account = [responseObject objectForKey:@"mobile"];
            ApplicationDelegate.cookie = [responseObject objectForKey:@"cookie"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exchangeUser" object:nil];
            
            [self saveAccount:[responseObject objectForKey:@"mobile"] password:@""];
            
            NSArray *ctrlArr = self.navigationController.viewControllers;
            
            if ([ctrlArr count] > 2)
            {
                NSLog(@"%@", [ctrlArr objectAtIndex:[ctrlArr count] - 3]);
                
                if ([NSStringFromClass(mSource) isEqualToString:@"AppDelegate"]) {
                    ApplicationDelegate.tabBarController.selectedIndex = 1;
                }
                
                [self.navigationController popToViewController:[ctrlArr objectAtIndex:[ctrlArr count] - 3] animated:YES];
            }
            
            if ([self.delegate respondsToSelector:@selector(thirdLoginSuccess)])
            {
                [self.delegate thirdLoginSuccess];
            }
        }
        if (0 == state)
        {
            [Utils showMessage:@"绑定失败"];
        }
        if (504 == state)
        {
            [Utils showMessage:@"该手机号已绑定"];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
}

/**
 *  保存登录的账号和密码
 *
 *  @param account  登录的账号
 *  @param password 登录的密码
 */
- (void)saveAccount:(NSString *)account password:(NSString *)password
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"MYSUserLogin"];
    password = [AESCrypt encrypt:password password:@"mingyisheng"];
    NSDictionary *dict = @{@"Account": account, @"Password": password};
    [settings setObject:dict forKey:@"MYSUserLogin"];
    [settings synchronize];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboard];
}

- (void)hiddenKeyboard
{
    if ([phoneTextField isFirstResponder])
    {
        [phoneTextField resignFirstResponder];
    }
    
    if ([codeTextField isFirstResponder])
    {
        [codeTextField resignFirstResponder];
    }
}

@end
