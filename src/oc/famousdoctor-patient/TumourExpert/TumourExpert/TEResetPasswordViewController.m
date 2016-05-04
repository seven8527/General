//
//  TEResetPasswordViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEResetPasswordViewController.h"
#import "UIColor+Hex.h"
#import "TEValidateTools.h"
#import "TEResultModel.h"
#import "TEUITools.h"
#import "TERegisterCell.h"
#import "TECaptchaCell.h"
#import "TEHttpTools.h"

@interface TEResetPasswordViewController ()
@property (nonatomic, strong) UITextField *mobilephoneTextField;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) UITextField *passwordTextField; // 新密码
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UIButton *captchaButton; // 获取手机验证码
@end

@implementation TEResetPasswordViewController

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
    self.title = @"找回密码";
}

// UI布局
- (void)layoutUI
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(21, 20, 277, 51);
    [confirmButton setTitle:@"确    定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    self.tableView.tableFooterView = footerView;
    
    // 添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // 监测textField的动态变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        TECaptchaCell *captchaCell = [[TECaptchaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        captchaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        captchaCell.infoLabel.text = @"验证码：";
        captchaCell.valueTextField.delegate = self;
        captchaCell.valueTextField.placeholder = @"请输入验证码";
        captchaCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
        _captchaTextField = captchaCell.valueTextField;
        [captchaCell.captchaButton addTarget:self action:@selector(clickCaptcha) forControlEvents:UIControlEventTouchUpInside];
        _captchaButton = captchaCell.captchaButton;
        
        return captchaCell;
    } else {
        static NSString *CellIdentifier = @"CellIdentifier";
        
        TERegisterCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[TERegisterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell.infoLabel.text = @"手机号：";
            cell.valueTextField.delegate = self;
            cell.valueTextField.placeholder = @"请输入注册的手机号";
            cell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
            _mobilephoneTextField = cell.valueTextField;
        } else if (indexPath.row == 2) {
            cell.infoLabel.text = @"新密码：";
            cell.valueTextField.delegate = self;
            cell.valueTextField.placeholder = @"请输入6-20位密码";
            cell.valueTextField.secureTextEntry = YES;
            _passwordTextField = cell.valueTextField;
        } else if (indexPath.row == 3) {
            cell.infoLabel.text = @"确认密码：";
            cell.valueTextField.delegate = self;
            cell.valueTextField.placeholder = @"请重复输入密码";
            cell.valueTextField.secureTextEntry = YES;
            _confirmPasswordTextField = cell.valueTextField;
        }
        
        return cell;
    }
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

#pragma mark - UITextField notifications

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if ([textField isEqual:_mobilephoneTextField]) {
        if ([TEValidateTools validateMobile:_mobilephoneTextField.text]) {
            [_captchaButton setEnabled:YES];
        } else {
            [_captchaButton setEnabled:NO];
        }
    }
}

#pragma mark - Bussiness methods

// 点击获取手机验证码按钮
- (void)clickCaptcha
{
    [_mobilephoneTextField resignFirstResponder];
    [_mobilephoneTextField setEnabled:NO];
    _captchaButton.userInteractionEnabled = NO;
    
    // 去除空格
    NSString *mobile = [_mobilephoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self fetchCaptchaWithMobilePhone:mobile];
}

// 点击确认按钮
- (void)resetPassword
{
    // 去除空格
    NSString *mobile = [_mobilephoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *captcha = [_captchaTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmPassword = [_confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateMobilePhone:mobile password:password confirmPassword:confirmPassword]) {
        [self resetPasswordWithMobilePhone:mobile captcha:captcha password:password];
    }
}

#pragma mark - API

// 调用后台获取验证码接口
- (void)fetchCaptchaWithMobilePhone:(NSString *)mobile
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"findpassd/get"];
    NSDictionary *parameters = @{@"phone": mobile};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"99"]) {
            [self startTimer];
        } else if ([state isEqualToString:@"-4"]) {
            [_mobilephoneTextField setEnabled:YES];
            _captchaButton.userInteractionEnabled = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-9"]) {
            [_mobilephoneTextField setEnabled:YES];
            _captchaButton.userInteractionEnabled = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
        [_mobilephoneTextField setEnabled:YES];
        _captchaButton.userInteractionEnabled = YES;
        NSLog(@"Error: %@", error);
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
//        } else if ([state isEqualToString:@"-4"]) {
//            [_mobilephoneTextField setEnabled:YES];
//            _captchaButton.userInteractionEnabled = YES;
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else if ([state isEqualToString:@"-9"]) {
//            [_mobilephoneTextField setEnabled:YES];
//            _captchaButton.userInteractionEnabled = YES;
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_mobilephoneTextField setEnabled:YES];
//        _captchaButton.userInteractionEnabled = YES;
//        NSLog(@"Error: %@", error);
//    }];
}

// 调用后台找回密码接口
- (void)resetPasswordWithMobilePhone:(NSString *)mobile captcha:(NSString *)captcha password:(NSString *)password
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"findpassd/updatepass"];
    NSDictionary *parameters = @{@"mobile": mobile, @"findcode": captcha, @"newpass": password};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"88"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的密码已重置成功，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([state isEqualToString:@"-12"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-13"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已经过期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-88"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"找回密码失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"88"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的密码已重置成功，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//            [self.navigationController popViewControllerAnimated:YES];
//        } else if ([state isEqualToString:@"-12"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else if ([state isEqualToString:@"-13"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已经过期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else if ([state isEqualToString:@"-88"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"找回密码失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
                [_mobilephoneTextField setEnabled:YES];
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

#pragma mark - Keyboard

// 隐藏键盘
- (void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [self.mobilephoneTextField resignFirstResponder];
    [self.captchaTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

#pragma mark - Validate

// 验证手机, 密码
- (BOOL)validateMobilePhone:(NSString *)mobilePhone  password:(NSString *)password confirmPassword:(NSString *)confirmPassword
{
    if ([mobilePhone length] != 11) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    if ([password length] < 6 || [password length] > 20) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![password isEqualToString:confirmPassword]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

@end
