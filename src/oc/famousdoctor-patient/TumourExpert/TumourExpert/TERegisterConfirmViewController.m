//
//  TERegisterConfirmViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-25.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TERegisterConfirmViewController.h"
#import "TECaptchaCell.h"
#import "TEResetPasswordViewController.h"
#import "TEValidateTools.h"
#import "TEResultModel.h"
#import "TEAppDelegate.h"
#import "TEResultRegisterModel.h"
#import "TEExpertDetailViewController.h"
#import "TEPersonalViewController.h"
#import "UIDevice+SupportedDevices.h"
#import "AESCrypt.h"
#import "TEHttpTools.h"

@interface TERegisterConfirmViewController ()
@property (nonatomic, strong) UIButton *captchaButton; // 获取手机验证码
@property (nonatomic, strong) UITextField *captchaTextField;
@end

@implementation TERegisterConfirmViewController

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
    
    [self configUI];
    
    [self layoutUI];
    
    [self clickCaptcha];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"注册";
}

// UI布局
- (void)layoutUI
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 127)];
    self.tableView.tableFooterView = footerView;

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(21, 20, 277, 51);
    [confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(clickFinishRegister) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
}

- (void)setMobile:(NSString *)mobile
{
    _mobile = mobile;
}

- (void)setPassword:(NSString *)password
{
    _password = password;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TECaptchaCell *captchaCell = [[TECaptchaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    captchaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    captchaCell.infoLabel.text = @"验证码：";
    captchaCell.valueTextField.delegate = self;
    captchaCell.valueTextField.placeholder = @"请输入验证码";
    captchaCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    _captchaTextField = captchaCell.valueTextField;
    [captchaCell.captchaButton addTarget:self action:@selector(clickCaptcha) forControlEvents:UIControlEventTouchUpInside];
    captchaCell.captchaButton.enabled = YES;
    _captchaButton = captchaCell.captchaButton;

    return captchaCell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Bussiness methods

// 点击获取手机验证码
- (void)clickCaptcha
{
    _captchaButton.userInteractionEnabled = NO;
    [self fetchCaptchaWithUserMobilePhone:self.mobile];
}


// 点击注册
- (void)clickFinishRegister
{
    // 去除空格
     NSString *captcha = [_captchaTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self validateCaptcha:captcha]) {
        [self registerWithMobilePhone:self.mobile password:self.password captcha:captcha userType:@"0"];
    }
}

#pragma mark - Validate

// 验证验证码
- (BOOL)validateCaptcha:(NSString *)captcha 
{
    if (captcha == nil || [captcha isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - API

// 调用后台获取验证码接口
- (void)fetchCaptchaWithUserMobilePhone:(NSString *)mobile
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"captcha"];
    NSDictionary *parameters = @{@"mobile": mobile};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"99"]) {
            [self startTimer];
        }
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        _captchaButton.userInteractionEnabled = YES;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"99"]) {
//            [self startTimer];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        _captchaButton.userInteractionEnabled = YES;
//    }];
}

// 调用后台注册接口
- (void)registerWithMobilePhone:(NSString *)mobile password:(NSString *)password captcha:(NSString *)captcha userType:(NSString *)type
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"register"];
    NSDictionary *parameters = @{@"mobile": mobile, @"passwd": password, @"code": captcha, @"user_type": type, @"register_from": @"1"};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        TEResultRegisterModel *result = [[TEResultRegisterModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"111"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
            ApplicationDelegate.isLogin = YES;
            ApplicationDelegate.userId = result.uid;
            ApplicationDelegate.account = mobile;
            ApplicationDelegate.cookie = result.cookie;
            
            [self saveAccount:mobile password:password];
            
            [self userOperationLogWithUserId:ApplicationDelegate.userId actionType:@"register" os:@"ios" deviceType:@"mobile" deviceModel:[UIDevice supportedDeviceName] deviceUid:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            for (UIViewController *ctrl in self.navigationController.viewControllers) {
                if (ApplicationDelegate.registerProtal == TERegisterPortalConsult  && [ctrl isMemberOfClass:[TEExpertDetailViewController class]]) {
                    [self.navigationController popToViewController:ctrl animated:YES];
                } else if (ApplicationDelegate.registerProtal == TERegisterPortalPersonal  && [ctrl isMemberOfClass:[TEPersonalViewController class]]) {
                    [self.navigationController popToViewController:ctrl animated:YES];
                }
            }
        } else if ([state isEqualToString:@"-4"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-7"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机验证码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//        TEResultRegisterModel *result = [[TEResultRegisterModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"111"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//            
//            ApplicationDelegate.isLogin = YES;
//            ApplicationDelegate.userId = result.uid;
//            ApplicationDelegate.account = mobile;
//            ApplicationDelegate.cookie = result.cookie;
//            
//            [self saveAccount:mobile password:password];
//            
//            [self userOperationLogWithUserId:ApplicationDelegate.userId actionType:@"register" os:@"ios" deviceType:@"mobile" deviceModel:[UIDevice supportedDeviceName] deviceUid:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
//            
//            for (UIViewController *ctrl in self.navigationController.viewControllers) {
//                if (ApplicationDelegate.registerProtal == TERegisterPortalConsult  && [ctrl isMemberOfClass:[TEExpertDetailViewController class]]) {
//                    [self.navigationController popToViewController:ctrl animated:YES];
//                } else if (ApplicationDelegate.registerProtal == TERegisterPortalPersonal  && [ctrl isMemberOfClass:[TEPersonalViewController class]]) {
//                    [self.navigationController popToViewController:ctrl animated:YES];
//                }
//            }
//        } else if ([state isEqualToString:@"-4"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else if ([state isEqualToString:@"-7"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机验证码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - Timer

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
                [_captchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_captchaButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
                [_captchaButton setEnabled:YES];
                _captchaButton.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%d秒", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_captchaButton setTitle:strTime forState:UIControlStateDisabled];
                [_captchaButton setEnabled:NO];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
    [settings removeObjectForKey:@"TEUserLogin"];
    password = [AESCrypt encrypt:password password:@"mingyisheng"];
    NSDictionary *dict = @{@"Account": account, @"Password": password};
    [settings setObject:dict forKey:@"TEUserLogin"];
    [settings synchronize];
}


/**
 *  记录用户操作日志
 *
 *  @param userId      用户Id，没有用户Id默认为0
 *  @param actionType  操作的类型,登录为login, 注册为register, 打开为mobile_open, 支付为pay
 *  @param os          操作系统类型，苹果操作系统为ios
 *  @param deviceType  设备类型，手机为mobile, 平板为pad
 *  @param deviceModel 设备型号
 *  @param devideUid   设备唯一号
 */
- (void)userOperationLogWithUserId:(NSString *)userId actionType:(NSString *)actionType  os:(NSString *)os deviceType:(NSString *)deviceType deviceModel:(NSString *)deviceModel deviceUid:(NSString *)devideUid
{
    NSLog(@"userId:%@, actionType:%@, os:%@, deviceType:%@, deviceModel:%@, devideUid:%@", userId, actionType, os, deviceType, deviceModel, devideUid);
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"user_log"];
    NSDictionary *parameters = @{@"uid": userId, @"action":actionType, @"terminal_os": os, @"terminal": deviceType, @"terminal_type": deviceModel, @"moblie_sn": devideUid};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

@end
