//
//  MYSPersonalChangePhoneNumberViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalChangePhoneNumberViewController.h"
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

@interface MYSPersonalChangePhoneNumberViewController () <UITextFieldDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, copy)  NSString *mobile;
@property (nonatomic, strong) UITextField *telTextField;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) UIButton *captchaButton; // 获取手机验证码
@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation MYSPersonalChangePhoneNumberViewController

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
    
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:self.commitButton];
    [self.commitButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:self.commitButton];
    [self.commitButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"更换手机号";
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
    
    // 确定
    UIButton *commitButton = [UIButton newAutoLayoutView];
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 5.0;
    [commitButton addTarget:self action:@selector(clickCommitButton) forControlEvents:UIControlEventTouchUpInside];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [commitButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    self.commitButton = commitButton;
    [footerView addSubview:commitButton];
    
    self.tableView.tableFooterView = footerView;
    
    [self updateViewConstraints];
}


- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        self.didSetupConstraints = YES;

        [self.commitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.commitButton autoSetDimension:ALDimensionWidth toSize:kScreen_Width-30];
        [self.commitButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [self.commitButton autoSetDimension:ALDimensionHeight toSize:44];
        
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
    return 2;
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

// 点击确认按钮
- (void)clickCommitButton
{
    // 去除空格
    NSString *mobile = [_telTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *captcha = [_captchaTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if([self validateMobilePhone:mobile captcha:captcha]) {
        [self changeMobilePhone:mobile captcha:captcha];
    }
}



// 点击获取手机验证码按钮
- (void)clickCaptcha
{
    [_telTextField resignFirstResponder];
    [_telTextField setEnabled:NO];
    _captchaButton.userInteractionEnabled = NO;
    
    // 去除空格
    NSString *mobile = [_telTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self validateMobilePhone:mobile]) {
        [self fetchCaptchaWithMobilePhone:mobile];
    }
    
}


// 隐藏键盘
- (void)hideKeyboard
{
    [self.telTextField resignFirstResponder];
    [self.captchaTextField resignFirstResponder];
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
                [_telTextField setEnabled:YES];
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

#pragma mark - API

// 调用后台获取验证码接口
- (void)fetchCaptchaWithMobilePhone:(NSString *)mobile
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"change_mobile"];
    NSDictionary *parameters = @{@"id": ApplicationDelegate.userId, @"mobile": mobile};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSResultModel *result = [[MYSResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"99"]) {
            [self startTimer];
        } else if ([state isEqualToString:@"-4"]) {
            [_telTextField setEnabled:YES];
            _captchaButton.userInteractionEnabled = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-9"]) {
            [_telTextField setEnabled:YES];
            _captchaButton.userInteractionEnabled = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已注册，请输入新的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } failure:^(NSError *error) {
        [_telTextField setEnabled:YES];
        _captchaButton.userInteractionEnabled = YES;
        LOG(@"Error: %@", error);
    }];
}


// 调用后台更换手机号接口
- (void)changeMobilePhone:(NSString *)mobile captcha:(NSString *)captcha
{
    [self hideKeyboard];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"change_mobile/checkcode"];
    NSDictionary *parameters = @{@"id": ApplicationDelegate.userId, @"mobile": mobile, @"mobile_confirm_code": captcha};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSResultModel *result = [[MYSResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"2"]) {
            if ([self.delegate respondsToSelector:@selector(changePhoneNumberViewControllerDidSelected:)]) {
                [self.delegate changePhoneNumberViewControllerDidSelected:mobile];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号更换成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([state isEqualToString:@"-2"]) {
            [self.captchaTextField becomeFirstResponder];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号更换失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

#pragma mark - Validate

// 验证手机, 密码
- (BOOL)validateMobilePhone:(NSString *)mobilePhone  captcha:(NSString *)captcha
{
    if ([mobilePhone length] != 11) {
        [self.telTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([captcha length] == 0) {
        [self.captchaTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

- (BOOL)validateMobilePhone:(NSString *)mobilePhone
{
    if (![ValidateTools  validateMobile:mobilePhone]) {
        _captchaButton.userInteractionEnabled = YES;
        [_telTextField setEnabled:YES];
        [self.telTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
        return NO;
    }
    
    return YES;
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
