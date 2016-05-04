//
//  MYSRegisterViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSRegisterViewController.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSLoginCell.h"
#import "UIImage+Corner.h"
#import "MYSFoundationCommon.h"
#import "MYSCaptchaCell.h"
#import "HttpTool.h"
#import "ValidateTools.h"
#import "MYSResultModel.h"
#import "MYSResultRegisterModel.h"
#import "AppDelegate.h"
#import "AESCrypt.h"

@interface MYSRegisterViewController () <UITextFieldDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, copy)  NSString *mobile;
@property (nonatomic, strong) UITextField *telTextField;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) UIButton *captchaButton; // 获取手机验证码
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *registerButton;
@property BOOL isAgreementSelected; // 是否勾选同意
@property (nonatomic, weak) UIButton *checkboxButton;
@property (nonatomic, weak) UILabel *agreementLabel; // 协议label
@property (nonatomic, weak) UIButton *agreementButton; // 点击查看协议
@end

@implementation MYSRegisterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    [self configUI];
    
    [self layoutUI];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tabBarController.tabBar.hidden = YES;

    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:self.registerButton];
    [self.registerButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:self.registerButton];
    [self.registerButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"注册";
    self.isAgreementSelected = YES;
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

    // 服务条款
    UIButton *checkboxButton = [UIButton newAutoLayoutView];
    checkboxButton.selected = YES;
    [checkboxButton addTarget:self action:@selector(isCheckboxSelected) forControlEvents:UIControlEventTouchUpInside];
    [checkboxButton setBackgroundImage:[UIImage imageNamed:@"login_checkbox_default_"] forState:UIControlStateNormal];
    [checkboxButton setImage:[UIImage imageNamed:@"login_checkbox_default_"] forState:UIControlStateNormal];
    [checkboxButton setImage:[UIImage imageNamed:@"login_checkbox_selected_"] forState:UIControlStateSelected];
    self.checkboxButton = checkboxButton;
    [footerView addSubview:checkboxButton];
    
    UILabel *agreementLabel = [UILabel newAutoLayoutView];
    agreementLabel.text = @"阅读并同意";
    agreementLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
    agreementLabel.backgroundColor = [UIColor clearColor];
    agreementLabel.font = [UIFont systemFontOfSize:14];
    self.agreementLabel = agreementLabel;
    [footerView addSubview:agreementLabel];
    
    UIButton *agreementButton = [UIButton newAutoLayoutView];
    [agreementButton setTitle:@"《名医生用户协议》" forState:UIControlStateNormal];
    agreementButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [agreementButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    [agreementButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [agreementButton addTarget:self action:@selector(checkAgreement) forControlEvents:UIControlEventTouchUpInside];
    self.agreementButton = agreementButton;
    [footerView addSubview:agreementButton];

    // 注册
    UIButton *registerButton = [UIButton newAutoLayoutView];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.layer.cornerRadius = 5.0;
    [registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    self.registerButton = registerButton;
    [footerView addSubview:registerButton];
    
    self.tableView.tableFooterView = footerView;
    
    [self updateViewConstraints];
}


- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        self.didSetupConstraints = YES;
        
        [self.checkboxButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17.5];
        [self.checkboxButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [self.checkboxButton autoSetDimension:ALDimensionHeight toSize:16];
        [self.checkboxButton autoSetDimension:ALDimensionWidth toSize:16];
        
        [self.agreementLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.checkboxButton withOffset:16];
        [self.agreementLabel autoSetDimension:ALDimensionWidth toSize:70];
        [self.agreementLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [self.agreementLabel autoSetDimension:ALDimensionHeight toSize:16];
        
        [self.agreementButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [self.agreementButton autoSetDimension:ALDimensionHeight toSize:16];
        [self.agreementButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.agreementLabel withOffset:-10];
        [self.agreementButton autoSetDimension:ALDimensionWidth toSize:140];
        
       
        [self.registerButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.registerButton autoSetDimension:ALDimensionWidth toSize:kScreen_Width-30];
        [self.registerButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.checkboxButton withOffset:30];
        [self.registerButton autoSetDimension:ALDimensionHeight toSize:44];

        }
    [super updateViewConstraints];
    
}

// 勾选服务条款
- (void)isCheckboxSelected
{
    self.checkboxButton.selected = !self.checkboxButton.selected;
    self.isAgreementSelected = !self.isAgreementSelected;
}

// 查看服务协议
- (void)checkAgreement
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <MYSAgreementViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSAgreementViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
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
    
    MYSCaptchaCell *captachaCell = [[MYSCaptchaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    captachaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"login_icon1_"];
        cell.valueTextField.delegate = self;
        cell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.valueTextField.placeholder = @"手机号";
        _telTextField = cell.valueTextField;
    } else if (indexPath.row == 1) {
        captachaCell.iconImageView.image = [UIImage imageNamed:@"login_icon3_"];
        captachaCell.valueTextField.delegate = self;
        captachaCell.valueTextField.placeholder = @"短信验证码";
        captachaCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
        captachaCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
        captachaCell.valueTextField.secureTextEntry = YES;
        _captchaTextField = captachaCell.valueTextField;
        _captchaButton = captachaCell.captchaButton;
        [_captchaButton addTarget:self action:@selector(clickCaptcha) forControlEvents:UIControlEventTouchUpInside];
        captachaCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        return captachaCell;
    } else if (indexPath.row == 2) {
        cell.iconImageView.image = [UIImage imageNamed:@"login_icon2_"];
        cell.valueTextField.delegate = self;
        cell.valueTextField.placeholder = @"6-16位密码";
        cell.valueTextField.secureTextEntry = YES;
        _passwordTextField = cell.valueTextField;
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

#pragma mark - Bussiness methods

// 点击获取手机验证码
- (void)clickCaptcha
{
    [_telTextField resignFirstResponder];
    [_telTextField setEnabled:NO];
    _captchaButton.userInteractionEnabled = NO;
    // 去除空格
    NSString *mobile = [_telTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.mobile = mobile;
    if ([self validateMobilePhone:mobile]) {
        [self fetchCaptchaWithUserMobilePhone:self.mobile];
    }
}

// 隐藏键盘
- (void)hideKeyboard
{
    [self.telTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.captchaTextField resignFirstResponder];
}


// 注册
- (void)clickRegisterButton
{
    self.mobile = [_telTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *captcha = [_captchaTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validatePassword:password captacha:captcha mobliePhone:self.mobile]) {
        
        //[self verifyMobilephone:self.mobile password:password];
        if (self.isAgreementSelected) {
            [self registerWithMobilePhone:self.mobile password:password captcha:captcha userType:@"0"];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认您已同意用户注册协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}

#pragma validate

- (BOOL)validateMobilePhone:(NSString *)mobilePhone
{
    if (![ValidateTools  validateMobile:mobilePhone]) {
        [_telTextField setEnabled:YES];
         _captchaButton.userInteractionEnabled = YES;
        [self.telTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
        return NO;
    }
    return YES;
}

// 验证手机和密码
- (BOOL)validatePassword:(NSString *)password captacha:(NSString *)captacha mobliePhone:(NSString *)mobilePhone
{
    if ([mobilePhone length] <= 0) {
        [self.telTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([mobilePhone length] != 11) {
        [self.telTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (captacha == nil || [captacha isEqualToString:@""]) {
        [self.captchaTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
        return NO;
    }
    if ([password length] < 6 || [password length] > 16) {
        [self.passwordTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入长度为6至16位密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }

    return  YES;
}



#pragma mark - API

// 调用后台获取验证码接口
- (void)fetchCaptchaWithUserMobilePhone:(NSString *)mobile
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"captcha"];
    NSDictionary *parameters = @{@"mobile": mobile};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSResultModel *result = [[MYSResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"99"]) {
            [self startTimer];
        } else if ([state isEqualToString:@"-2"]) {
            [_telTextField setEnabled:YES];
            _captchaButton.userInteractionEnabled = YES;
            [self.telTextField becomeFirstResponder];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已被注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-4"]) {
            [_telTextField setEnabled:YES];
            _captchaButton.userInteractionEnabled = YES;
            [self.telTextField becomeFirstResponder];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        _captchaButton.userInteractionEnabled = YES;
    }];
}


// 调用后台注册接口
- (void)registerWithMobilePhone:(NSString *)mobile password:(NSString *)password captcha:(NSString *)captcha userType:(NSString *)type
{
    [self hideKeyboard];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"register"];
    NSDictionary *parameters = @{@"mobile": mobile, @"passwd": password, @"code": captcha, @"user_type": type, @"register_from": @"1"};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSResultRegisterModel *result = [[MYSResultRegisterModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"111"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
            ApplicationDelegate.isLogin = YES;
            ApplicationDelegate.userId = result.uid;
            ApplicationDelegate.account = mobile;
            ApplicationDelegate.cookie = result.cookie;
            
            [self saveAccount:mobile password:password];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"exchangeUser" object:nil];

            
            if (self.isGuidePortal) {
                [self.delegate willDismissRegister];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        } else if ([state isEqualToString:@"-2"]) {
            [self.captchaTextField becomeFirstResponder];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已被注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-4"]) {
            [self.telTextField becomeFirstResponder];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-7"]) {
            [self.captchaTextField becomeFirstResponder];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
    
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
                [_telTextField setEnabled:YES];
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



// 返回
- (void)clickLeftBarButton
{
    if (self.isGuidePortal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
