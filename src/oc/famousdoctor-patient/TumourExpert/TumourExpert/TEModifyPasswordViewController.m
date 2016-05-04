//
//  TEModifyPasswordViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEModifyPasswordViewController.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "TEAppDelegate.h"
#import "TEResultModel.h"
#import "AESCrypt.h"
#import "TEHttpTools.h"

@interface TEModifyPasswordViewController ()
@property (nonatomic, strong) UITextField *oldPasswordTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@end

@implementation TEModifyPasswordViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    // 设置标题
    self.title = @"修改密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(modifyPassword:)];
    

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:scrollView];
    
    // 原密码标签
    UILabel *oldPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 70, 21)];
    oldPasswordLabel.text = @"原密码：";
    oldPasswordLabel.font = [UIFont boldSystemFontOfSize:17];
    oldPasswordLabel.textColor = [UIColor colorWithHex:0x383838];
    [scrollView addSubview:oldPasswordLabel];
    
    // 输入原密码
    _oldPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 280, 30)];
    _oldPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _oldPasswordTextField.delegate = self;
    _oldPasswordTextField.font = [UIFont systemFontOfSize:13];
    _oldPasswordTextField.textColor = [UIColor colorWithHex:0x9e9e9e];
    _oldPasswordTextField.secureTextEntry = YES;
    _oldPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0x9e9e9e], NSFontAttributeName : [UIFont systemFontOfSize:13]};
    _oldPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入原密码" attributes:placeholderAttributes];
    [scrollView addSubview:_oldPasswordTextField];
    
    // 新密码标签
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 70, 21)];
    passwordLabel.text = @"新密码：";
    passwordLabel.font = [UIFont boldSystemFontOfSize:17];
    passwordLabel.textColor = [UIColor colorWithHex:0x383838];
    [scrollView addSubview:passwordLabel];
    
    // 输入新密码
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 280, 30)];
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.delegate = self;
    _passwordTextField.font = [UIFont systemFontOfSize:13];
    _passwordTextField.textColor = [UIColor colorWithHex:0x9e9e9e];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入新密码" attributes:placeholderAttributes];
    [scrollView addSubview:_passwordTextField];
    
    // 重复输入密码标签
    UILabel *confirmPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 70, 21)];
    confirmPasswordLabel.text = @"确    认：";
    confirmPasswordLabel.font = [UIFont boldSystemFontOfSize:17];
    confirmPasswordLabel.textColor = [UIColor colorWithHex:0x383838];
    [scrollView addSubview:confirmPasswordLabel];
    
    // 重复输入新密码
    _confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 190, 280, 30)];
    _confirmPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _confirmPasswordTextField.delegate = self;
    _confirmPasswordTextField.font = [UIFont systemFontOfSize:13];
    _confirmPasswordTextField.textColor = [UIColor colorWithHex:0x9e9e9e];
    _confirmPasswordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请重复输入新密码" attributes:placeholderAttributes];
    [scrollView addSubview:_confirmPasswordTextField];
    
    // 添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Bussiness methods

// 密码修改
- (void)modifyPassword:(id)sender
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *oldPassword = [_oldPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmPassword = [_confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([self validateOldPassword:oldPassword password:password confirmPassword:confirmPassword]) {
        [self modifyPasswordWithUserId:ApplicationDelegate.userId oldPassword:oldPassword password:password confirmPassword:confirmPassword];
    }
}


#pragma mark - API methods

// 调用后台修改密码接口
- (void)modifyPasswordWithUserId:(NSString *)userId oldPassword:(NSString *)oldPassword password:(NSString *)password confirmPassword:(NSString *)confirmPassword
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"updatepass"];
    NSDictionary *parameters = @{@"userid": userId, @"oldpawd":oldPassword, @"password1":password, @"password2":confirmPassword, @"cookie":ApplicationDelegate.cookie};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"88"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            NSLog(@"------%@", userId);
            [self saveAccount:ApplicationDelegate.account password:password];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([state isEqualToString:@"-17"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"原始密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"88"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//            NSLog(@"------%@", userId);
//            [self saveAccount:ApplicationDelegate.account password:password];
//            [self.navigationController popViewControllerAnimated:YES];
//        } else if ([state isEqualToString:@"-17"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"原始密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - Keyboard

// 隐藏键盘
- (void)hideKeyboard
{
    [self.oldPasswordTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

#pragma mark - Validate

// 验证原密码，新密码和确认密码
- (BOOL)validateOldPassword:(NSString *)oldPassword password:(NSString *)password confirmPassword:(NSString *)confirmPassword
{
    if ([oldPassword length] < 6 || [oldPassword length] > 20) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([password length] < 6 || [password length] > 20) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([confirmPassword length] < 6 || [confirmPassword length] > 20) {
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

@end
