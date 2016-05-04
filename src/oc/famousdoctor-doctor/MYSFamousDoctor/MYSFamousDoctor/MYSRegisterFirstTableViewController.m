//
//  MYSRegisterFirstTableViewController.m
//  MYSFamousDoctor
//
//  Created by yanwb on 15/4/8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSRegisterFirstTableViewController.h"
#import "MYSLoginCell.h"
#import "MYSCaptchaCell.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"
#import "ValidateTools.h"
#import "MYSResultModel.h"
#import "MYSRegisterSecondTableViewController.h"
#import "MYSUserAgreementViewController.h"

@interface MYSRegisterFirstTableViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, weak) UIButton *checkboxButton;
@property BOOL isAgreementSelected; // 是否勾选同意
@property (nonatomic, strong) UITextField *telTextField;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) UIButton *captchaButton; // 获取手机验证码
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, copy)  NSString *mobile;
@end

@implementation MYSRegisterFirstTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.isAgreementSelected = YES;
    
    [self layoutBottonView];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.tableView addGestureRecognizer:gesture];
}

- (void)tapClick
{
    [self hiddenKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)layoutBottonView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    // 服务条款
    UIButton *checkboxButton = [[UIButton alloc] initWithFrame:CGRectMake(17.5, 12.5, 16, 16)];
    checkboxButton.selected = YES;
    [checkboxButton addTarget:self action:@selector(isCheckboxSelected) forControlEvents:UIControlEventTouchUpInside];
    [checkboxButton setBackgroundImage:[UIImage imageNamed:@"login_checkbox_default_"] forState:UIControlStateNormal];
    [checkboxButton setImage:[UIImage imageNamed:@"login_checkbox_default_"] forState:UIControlStateNormal];
    [checkboxButton setImage:[UIImage imageNamed:@"login_checkbox_selected_"] forState:UIControlStateSelected];
    self.checkboxButton = checkboxButton;
    [footerView addSubview:checkboxButton];
    
    UILabel *agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkboxButton.frame) + 10, 12, 70, 16)];
    agreementLabel.text = @"阅读并同意";
    agreementLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
    agreementLabel.backgroundColor = [UIColor clearColor];
    agreementLabel.font = [UIFont systemFontOfSize:14];
//    self.agreementLabel = agreementLabel;
    [footerView addSubview:agreementLabel];
    
    UIButton *agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(agreementLabel.frame), 12, 140, 16)];
    [agreementButton setTitle:@"《名医生用户协议》" forState:UIControlStateNormal];
    agreementButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [agreementButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    [agreementButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [agreementButton addTarget:self action:@selector(checkAgreement) forControlEvents:UIControlEventTouchUpInside];
//    self.agreementButton = agreementButton;
    [footerView addSubview:agreementButton];
    
    // 注册
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(checkboxButton.frame) + 31, kScreen_Width - 30, 44)];;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.layer.cornerRadius = 5.0;
    [registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:registerButton];
    [registerButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:registerButton];
    [registerButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];

//    self.registerButton = registerButton;
    [footerView addSubview:registerButton];

    self.tableView.tableFooterView = footerView;
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *login = @"loginCell";
    MYSLoginCell *loginCell = [tableView dequeueReusableCellWithIdentifier:login];
    
    if (loginCell == nil) {
        loginCell = [[MYSLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:login];
    }
    
    MYSCaptchaCell *captachaCell = [[MYSCaptchaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0 ) {
        loginCell.iconImageView.image = [UIImage imageNamed:@"sign_in_phone"];
        CGRect frame = loginCell.iconImageView.frame;
        loginCell.iconImageView.frame = CGRectMake(frame.origin.x, frame.origin.y, 15, 20);
        loginCell.valueTextField.delegate = self;
        loginCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
        loginCell.valueTextField.placeholder = @"手机号";
        _telTextField = loginCell.valueTextField;
        return loginCell;
    } else if (indexPath.row == 1) {
        captachaCell.iconImageView.image = [UIImage imageNamed:@"sign-in_verify"];
        CGRect frame = captachaCell.iconImageView.frame;
        captachaCell.iconImageView.frame = CGRectMake(frame.origin.x, frame.origin.y, 16, 19);
        captachaCell.valueTextField.delegate = self;
        captachaCell.valueTextField.placeholder = @"短信验证码";
        captachaCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
        captachaCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
        _captchaTextField = captachaCell.valueTextField;
        _captchaButton = captachaCell.captchaButton;
        [_captchaButton addTarget:self action:@selector(clickCaptcha) forControlEvents:UIControlEventTouchUpInside];
        captachaCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        return captachaCell;
    } else {
        loginCell.iconImageView.image = [UIImage imageNamed:@"sign_in_password"];
        CGRect frame = loginCell.iconImageView.frame;
        loginCell.iconImageView.frame = CGRectMake(frame.origin.x, frame.origin.y, 17, 19);
        loginCell.valueTextField.delegate = self;
        loginCell.valueTextField.placeholder = @"6-16位字符";
        loginCell.valueTextField.secureTextEntry = YES;
        _passwordTextField = loginCell.valueTextField;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.delegate = self;
        return loginCell;
    }
}

#pragma mark
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_passwordTextField])
    {
        [textField resignFirstResponder];
    }
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


// 勾选服务条款
- (void)isCheckboxSelected
{
    self.checkboxButton.selected = !self.checkboxButton.selected;
    self.isAgreementSelected = !self.isAgreementSelected;
}

// 查看服务协议
- (void)checkAgreement
{
    MYSUserAgreementViewController *agreeCtrl = [[MYSUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreeCtrl animated:YES];
}

// 注册
- (void)clickRegisterButton
{
    [self hiddenKeyboard];
    
    self.mobile = [_telTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *captcha = [_captchaTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validatePassword:password captacha:captcha mobliePhone:self.mobile])
    {
        if (self.isAgreementSelected) {
            [self registerWithMobilePhone:self.mobile password:password captcha:captcha userType:@"0"];
//            MYSRegisterSecondTableViewController *se = [[MYSRegisterSecondTableViewController alloc] init];
//            [self.navigationController pushViewController:se animated:YES];
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

#pragma mark - API

// 调用后台获取验证码接口
- (void)fetchCaptchaWithUserMobilePhone:(NSString *)mobile
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"get_code"];
    NSDictionary *parameters = @{@"mobile": mobile};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
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
        NSLog(@"Error: %@", error);
        _captchaButton.userInteractionEnabled = YES;
    }];
}


// 调用后台注册接口
- (void)registerWithMobilePhone:(NSString *)mobile password:(NSString *)password captcha:(NSString *)captcha userType:(NSString *)type
{
    [self hiddenKeyboard];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"register/checkcode"];
    NSDictionary *parameters = @{@"mobile": mobile, @"passwd": password, @"code": captcha, @"user_type": type, @"register_from": @"1"};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        if ([state isEqualToString:@"111"]) {
            MYSRegisterSecondTableViewController *se = [[MYSRegisterSecondTableViewController alloc] init];
            [self.navigationController pushViewController:se animated:YES];
            
            // 保存注册信息到内存
            MYSUserInfoManager *userInfoManager = [MYSUserInfoManager shareInstance];
            userInfoManager.phone = self.telTextField.text;
            userInfoManager.userId = [responseObject objectForKey:@"uid"];
            userInfoManager.cookie = [responseObject objectForKey:@"cookie"];
            
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


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hiddenKeyboard
{
    if ([self.telTextField isFirstResponder])
    {
        [self.telTextField resignFirstResponder];
    }
    
    if ([self.captchaTextField isFirstResponder])
    {
        [self.captchaTextField resignFirstResponder];
    }
    
    if ([self.passwordTextField isFirstResponder])
    {
        [self.passwordTextField resignFirstResponder];
    }
}

@end
