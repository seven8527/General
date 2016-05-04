//
//  MYSPersonalChangePasswordViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalChangePasswordViewController.h"
#import "MYSLoginCell.h"
#import "UIImage+Corner.h"
#import "MYSFoundationCommon.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "HttpTool.h"
#import "MYSResultModel.h"
#import "AESCrypt.h"

@interface MYSPersonalChangePasswordViewController () <UITextFieldDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UITextField *currentPasswordTextField;
@property (nonatomic, strong) UITextField *renewPasswordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, weak) UIButton *loginButton;

@end

@implementation MYSPersonalChangePasswordViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tabBarController.tabBar.hidden = YES;
    
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:self.loginButton];
    [self.loginButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:self.loginButton];
    [self.loginButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
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
    self.title = @"修改密码";
}

// UI布局
- (void)layoutUI
{
    
    self.tableView.rowHeight = 48;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.tableView.separatorColor = [UIColor colorFromHexRGB:KD1D1D1Color];
    
    // 添加手势退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tap];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreen_Height - 180)];
    // 确认修改
    UIButton *loginButton = [UIButton newAutoLayoutView];
    [loginButton setTitle:@"确认修改" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 5.0;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton addTarget:self action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    self.loginButton = loginButton;
    [footerView addSubview:loginButton];
    
    
    self.tableView.tableFooterView = footerView;
    [self updateViewConstraints];
}


- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        self.didSetupConstraints = YES;
        
        // 反馈内容提示
        [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [self.loginButton autoSetDimension:ALDimensionHeight toSize:44];
        
    }
    [super updateViewConstraints];
    
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    MYSLoginCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MYSLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.valueTextField.delegate = self;
    cell.valueTextField.secureTextEntry = YES;
    
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"login_icon2_"];
        cell.valueTextField.placeholder = @"当前密码";
        _currentPasswordTextField = cell.valueTextField;
    } else if (indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"login_icon4_"];
        cell.valueTextField.placeholder = @"新密码";
        _renewPasswordTextField = cell.valueTextField;
    } else {
        cell.iconImageView.image = [UIImage imageNamed:@"login_icon4_"];
        cell.valueTextField.placeholder = @"确认密码";
        _confirmPasswordTextField = cell.valueTextField;
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
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


// 隐藏键盘
- (void)hideKeyboard
{
    [self.currentPasswordTextField resignFirstResponder];
    [self.renewPasswordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 确认修改
- (void)modifyPassword
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *oldPassword = [self.currentPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.renewPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmPassword = [self.confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([self validateOldPassword:oldPassword password:password confirmPassword:confirmPassword]) {
        [self modifyPasswordWithUserId:ApplicationDelegate.userId oldPassword:oldPassword password:password confirmPassword:confirmPassword];
    }
}

// 调用后台修改密码接口
- (void)modifyPasswordWithUserId:(NSString *)userId oldPassword:(NSString *)oldPassword password:(NSString *)password confirmPassword:(NSString *)confirmPassword
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"updatepass"];
    NSDictionary *parameters = @{@"userid": userId, @"oldpawd":oldPassword, @"password1":password, @"password2":confirmPassword, @"cookie":ApplicationDelegate.cookie};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        
        MYSResultModel *result = [[MYSResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"88"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            LOG(@"------%@", userId);
            [self saveAccount:ApplicationDelegate.account password:password];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([state isEqualToString:@"-17"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"原始密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
    }];
}

// 验证原密码，新密码和确认密码
- (BOOL)validateOldPassword:(NSString *)oldPassword password:(NSString *)password confirmPassword:(NSString *)confirmPassword
{
    if ([oldPassword length] < 6 || [oldPassword length] > 16) {
        [self.currentPasswordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入长度为6至16位原密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([password length] < 6 || [password length] > 16) {
        [self.renewPasswordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入长度为6至16位新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([confirmPassword length] < 6 || [confirmPassword length] > 16) {
        [self.confirmPasswordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入长度为6至16位新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![password isEqualToString:confirmPassword]) {
        [self.renewPasswordTextField becomeFirstResponder];
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
    [settings removeObjectForKey:@"MYSUserLogin"];
    password = [AESCrypt encrypt:password password:@"mingyisheng"];
    NSDictionary *dict = @{@"Account": account, @"Password": password};
    [settings setObject:dict forKey:@"MYSUserLogin"];
    [settings synchronize];
}


@end
