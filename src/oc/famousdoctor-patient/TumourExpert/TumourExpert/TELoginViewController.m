//
//  TELoginViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-15.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TELoginViewController.h"
#import "UIColor+Hex.h"
#import "TEAppDelegate.h"
#import "TEUserModel.h"
#import "TEUITools.h"
#import "TELoginCell.h"
#import "NSString+CalculateTextSize.h"
#import "UIDevice+SupportedDevices.h"
#import "AESCrypt.h"
#import "TEHttpTools.h"

@interface TELoginViewController ()
@property (retain, nonatomic) UITextField *accountTextField;
@property (retain, nonatomic) UITextField *passwordTextField;
@end

@implementation TELoginViewController

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _accountTextField.text = @"";
    _passwordTextField.text = @"";
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
    self.title = @"登录";
}

// UI布局
- (void)layoutUI
{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(registerAccount)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(21, 20, 277, 51);
    [loginButton setTitle:@"登    录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loginButton];
    self.tableView.tableFooterView = footerView;
    
    CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
    
    // 找回密码
    UIButton *resetButton = [[UIButton alloc] init];
    [resetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [resetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [resetButton setTitleColor:[UIColor colorWithHex:0x9e9e9e] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    CGSize resetSize = [resetButton.titleLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    resetButton.frame = CGRectMake(kScreen_Width / 2 + (kScreen_Width / 2 - resetSize.width) / 2, CGRectGetMaxY(footerView.frame), resetSize.width, 21);
    [self.tableView addSubview:resetButton];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    TELoginCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TELoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_user.png"];
        cell.valueTextField.delegate = self;
        cell.valueTextField.placeholder = @"请输入用户名/邮箱/手机";
        _accountTextField = cell.valueTextField;
    } else if (indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_lock.png"];
        cell.valueTextField.delegate = self;
        cell.valueTextField.placeholder = @"请输入密码";
        cell.valueTextField.secureTextEntry = YES;
        _passwordTextField = cell.valueTextField;
    }
    
    return cell;
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

// 登录
- (void)login
{
    // 去除空格
    NSString *account = [_accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateAccount:account password:password]) {
        [self loginWithAccount:account password:password];
    }
}

// 找回密码
- (void)resetPassword
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEResetPasswordViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEResetPasswordViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}


// 注册
- (void)registerAccount
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TERegisterViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TERegisterViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - API

// 调用后台登录接口
- (void)loginWithAccount:(NSString *)account password:(NSString *)password
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"login"];
    NSDictionary *parameters = @{@"email": account, @"password":password};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEUserModel *user = [[TEUserModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = user.state;
        if ([state isEqualToString:@"1"]) {
            ApplicationDelegate.userId = user.userId;
            ApplicationDelegate.isLogin = YES;
            ApplicationDelegate.account = account;
            ApplicationDelegate.cookie = user.cookie;
            
            [self saveAccount:account password:password];
            
            [self userOperationLogWithUserId:ApplicationDelegate.userId actionType:@"login" os:@"ios" deviceType:@"mobile" deviceModel:[UIDevice supportedDeviceName] deviceUid:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([state isEqualToString:@"-100"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
        
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEUserModel *user = [[TEUserModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = user.state;
//        if ([state isEqualToString:@"1"]) {
//            ApplicationDelegate.userId = user.userId;
//            ApplicationDelegate.isLogin = YES;
//            ApplicationDelegate.account = account;
//            ApplicationDelegate.cookie = user.cookie;
//            
//            [self saveAccount:account password:password];
//            
//            [self userOperationLogWithUserId:ApplicationDelegate.userId actionType:@"login" os:@"ios" deviceType:@"mobile" deviceModel:[UIDevice supportedDeviceName] deviceUid:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
//
//            [self.navigationController popViewControllerAnimated:YES];
//        } else if ([state isEqualToString:@"-100"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - Validate

// 验证账号和手机
- (BOOL)validateAccount:(NSString *)account password:(NSString *)password
{
    if (![account length] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![password length] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
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
