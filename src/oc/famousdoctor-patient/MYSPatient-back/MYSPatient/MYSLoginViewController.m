//
//  MYSLoginViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSLoginViewController.h"
#import "MYSLoginCell.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"
#import "UtilsMacro.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "MYSUserModel.h"
#import "AppDelegate.h"
#import "MYSExpertGroupViewController.h"
#import "AESCrypt.h"
#import "MYSThirdLoginViewController.h"

@interface MYSLoginViewController () <UITextFieldDelegate, MYSThirdLoginViewControllerDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, weak) UIButton *loginButton;
@property (nonatomic, weak) UIButton *resetButton;

@property (nonatomic, weak) UIView *leftLineView;
@property (nonatomic, weak) UIView *rightLineView;
@property (nonatomic, weak) UILabel *lineLabel;
@property (nonatomic, weak) UIButton *qqBtn;
@property (nonatomic, weak) UIButton *weixinBtn;
@property (nonatomic, weak) UIButton *weiboBtn;
//@property (nonatomic, weak) MYSThirdPartyLoginView *thirdPartyLoginView;

@end

@implementation MYSLoginViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _accountTextField.text = @"";
    _passwordTextField.text = @"";
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiBoLoginSuccess:) name:@"weiBoLoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiXinLoginSuccess:) name:@"weiXinLoginSuccess" object:nil];
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
    
    self.tableView.rowHeight = 48;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.tableView.separatorColor = [UIColor colorFromHexRGB:KD1D1D1Color];
    
    // 添加手势退出键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tap];
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(registerAccount)];
    rightBarButton.tintColor = [UIColor colorFromHexRGB:K747474Color];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    // 引导页过来的无注册按钮
    if (self.isHiddenRegisterButton) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 180)];
    // 登录
    UIButton *loginButton = [UIButton newAutoLayoutView];
    [loginButton setTitle:@"登    录" forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 5.0;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    self.loginButton = loginButton;
    [footerView addSubview:loginButton];
    
    // 忘记密码
    UIButton *resetButton = [UIButton newAutoLayoutView];
    [resetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [resetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    resetButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [resetButton addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    [footerView addSubview:resetButton];
    self.resetButton = resetButton;
    
    // 第三方登陆分割线
    UIView *leftLineView = [UIView newAutoLayoutView];
    [leftLineView setBackgroundColor:[UIColor colorFromHexRGB:@"b9b9b9"]];
    [footerView addSubview:leftLineView];
    self.leftLineView = leftLineView;
    
    UIView *rightLineView = [UIView newAutoLayoutView];
    [rightLineView setBackgroundColor:[UIColor colorFromHexRGB:@"b9b9b9"]];
    [footerView addSubview:rightLineView];
    self.rightLineView = rightLineView;
    
    // 第三方登陆标题
    UILabel *lineLabel = [UILabel newAutoLayoutView];
    lineLabel.text = @"第三方账号登陆";
    lineLabel.font = [UIFont systemFontOfSize:12];
    lineLabel.textColor = [UIColor colorFromHexRGB:@"626262"];
    lineLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:lineLabel];
    self.lineLabel = lineLabel;
    
    // QQ登陆
    UIButton *qqBtn = [UIButton newAutoLayoutView];
    [qqBtn setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(qqBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:qqBtn];
    self.qqBtn = qqBtn;
    
    // 微信登陆
    UIButton *weixinBtn = [UIButton newAutoLayoutView];
    [weixinBtn setImage:[UIImage imageNamed:@"login_weixin"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:weixinBtn];
    self.weixinBtn = weixinBtn;
    
    // 微博登陆
    UIButton *weiboBtn = [UIButton newAutoLayoutView];
    [weiboBtn setImage:[UIImage imageNamed:@"login_weibo"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:weiboBtn];
    self.weiboBtn = weiboBtn;
    
    self.tableView.tableFooterView = footerView;
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        self.didSetupConstraints = YES;
        
        [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [self.loginButton autoSetDimension:ALDimensionHeight toSize:44];
        
        
        [self.resetButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginButton withOffset:15];
        [self.resetButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.resetButton autoSetDimension:ALDimensionHeight toSize:30];
        [self.resetButton autoSetDimension:ALDimensionWidth toSize:70];

        [self.lineLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.resetButton withOffset:11];
        [self.lineLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
        [self.lineLabel autoSetDimension:ALDimensionHeight toSize:18];
        [self.lineLabel autoSetDimension:ALDimensionWidth toSize:90];
        
        [self.leftLineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.resetButton withOffset:20];
        [self.leftLineView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.lineLabel withOffset:-5];
        [self.leftLineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.leftLineView autoSetDimension:ALDimensionHeight toSize:1];
        
        [self.rightLineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.resetButton withOffset:20];
        [self.rightLineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineLabel withOffset:5];
        [self.rightLineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.rightLineView autoSetDimension:ALDimensionHeight toSize:1];

        [self.weixinBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lineLabel withOffset:25];
        [self.weixinBtn autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
        [self.weixinBtn autoSetDimension:ALDimensionHeight toSize:49];
        [self.weixinBtn autoSetDimension:ALDimensionWidth toSize:49];
        
        [self.qqBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lineLabel withOffset:25];
        [self.qqBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.weixinBtn withOffset:-50];
        [self.qqBtn autoSetDimension:ALDimensionHeight toSize:49];
        [self.qqBtn autoSetDimension:ALDimensionWidth toSize:49];
        
        [self.weiboBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lineLabel withOffset:25];
        [self.weiboBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.weixinBtn withOffset:50];
        [self.weiboBtn autoSetDimension:ALDimensionHeight toSize:49];
        [self.weiboBtn autoSetDimension:ALDimensionWidth toSize:49];
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
    
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"login_icon1_"];
        cell.valueTextField.delegate = self;
        cell.valueTextField.placeholder = @"手机号";
        cell.valueTextField.textColor = [UIColor colorFromHexRGB:K525252Color];
        _accountTextField = cell.valueTextField;
    } else if (indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"login_icon2_"];
        cell.valueTextField.delegate = self;
        cell.valueTextField.placeholder = @"密码";
        cell.valueTextField.secureTextEntry = YES;
        cell.valueTextField.textColor = [UIColor colorFromHexRGB:K525252Color];
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

// 登录
- (void)login
{
    // 去除空格
    NSString *account = [_accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if([self validateAccount:account password:password]) {
        [self loginWithAccount:account password:password source:self.source methodForSelector:self.aSelector instance:self.instance];
    }
}

// 找回密码
- (void)resetPassword
{
//    self.hidesBottomBarWhenPushed = YES;
    UIViewController <MYSFindPassWordViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSFindPassWordViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}


// 注册
- (void)registerAccount
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <MYSRegisterViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSRegisterViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - API

// 调用后台登录接口
- (void)loginWithAccount:(NSString *)account password:(NSString *)password source:(Class)source methodForSelector:(SEL)initializer instance:(id)instance
{
    [self hideKeyboard];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"login"];
    NSDictionary *parameters = @{@"email": account, @"password":password};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        MYSUserModel *user = [[MYSUserModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = user.state;
        if ([state isEqualToString:@"1"]) {
            ApplicationDelegate.userId = user.userId;
            ApplicationDelegate.isLogin = YES;
            ApplicationDelegate.account = account;
            ApplicationDelegate.cookie = user.cookie;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exchangeUser" object:nil];

            if ([NSStringFromClass(source) isEqualToString:@"AppDelegate"]) { 
                ApplicationDelegate.tabBarController.selectedIndex = 1;
            } else if ([NSStringFromClass(source) isEqualToString:@"MYSUserGuideViewController"])  {
                [self.delegate willDismissLogin];
            }


            [self saveAccount:account password:password];
            
//            [self dismissViewControllerAnimated:YES completion:^{
//                buildObjectWithInitializer(source, initializer, instance);
//
//            }];
            [self.navigationController popViewControllerAnimated:YES];
//            [self performSelector:@selector(prveBulidInfo) withObject:nil afterDelay:0.55];
        } else if ([state isEqualToString:@"-100"]) {
            [Utils showMessage:@"密码错误"];
        } else if ([state isEqualToString:@"-403"]) {
            [Utils showMessage:@"该用户已被拉入黑名单"];
        } else if ([state isEqualToString:@"-404"]) {
            [Utils showMessage:@"登录账户不是普通用户"];
        } else if ([state isEqualToString:@"-405"]) {
            [Utils showMessage:@"用户名不存在"];
        } else if ([state isEqualToString:@"-503"]) {
            [Utils showMessage:@"用户名密码锁定"];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
}


#pragma mark - Validate

// 验证账号和手机
- (BOOL)validateAccount:(NSString *)account password:(NSString *)password
{
    if (![account length] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [_accountTextField becomeFirstResponder];
        return NO;
    }
    
    if (![password length] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [_passwordTextField becomeFirstResponder];
        return NO;
    }
    
    return YES;
}


// 隐藏键盘
- (void)hideKeyboard
{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

// 返回
- (void)clickLeftBarButton
{
    [self hideKeyboard];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


static void buildObjectWithInitializer(Class klass, SEL initializer, id instance) {
    //- (void)buildObjectWithInitializer:(Class)klass initializer:(SEL)initializer {
    NSMethodSignature *signature = [klass methodSignatureForSelector:initializer];
    BOOL isClassMethod = signature != nil && initializer != @selector(init);
    
    if (!isClassMethod) {
        signature = [klass instanceMethodSignatureForSelector:initializer];
    }
    
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:isClassMethod ? klass : instance];
        [invocation setSelector:initializer];
        //        for (int i = 0; i < arguments.count; i++) {
        //            __unsafe_unretained id argument = [arguments objectAtIndex:i];
        //            [invocation setArgument:&argument atIndex:i + 2];
        //        }
        [invocation invoke];
        //[invocation getReturnValue:&instance];
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

#pragma mark
#pragma mark 第三方登陆按钮点击事件
- (void)qqBtnClick
{
    NSLog(@"开启QQ第三方登陆");
    
    [self hideKeyboard];
    
    // 添加QQ第三方登陆注册 start
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APP_ID andDelegate:self];
    _tencentOAuth.redirectURI = @"www.qq.com";
    _tencentPermissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", nil];
    [_tencentOAuth authorize:_tencentPermissions inSafari:NO];
    // 添加QQ第三方登陆注册 end
}

- (void)weixinBtnClick
{
    NSLog(@"开启微信第三方登陆");
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"huakangWX";
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
}

- (void)weiboBtnClick
{
    NSLog(@"开启微博第三方登陆");
    
    // 添加微博第三方登陆注册 start
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_REDIRECT_URI;
    [WeiboSDK sendRequest:request];
    
    // 添加微博第三方登陆注册 end
}

#pragma QQ第三方登陆代理
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {   // 记录登录用户的OpenID
        _tencentOpenID = _tencentOAuth.openId;
        if (!_tencentOpenID || _tencentOpenID.length <= 0)
        {
            [Utils showMessage:@"登录不成功,未获取到用户OpenID"];
            return;
        }
        [self checkThirdPartyLoginAccount:_tencentOpenID t_type:TYPE_QQ];
    } else {
        NSLog(@"登录不成功 没有获取accesstoken");
        [Utils showMessage:@"QQ第三方登陆失败"];
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"用户取消登录");
    } else {
        NSLog(@"登录失败");
    }
}

-(void)tencentDidNotNetWork
{
    [Utils showMessage:@"无网络连接，请设置网络"];
}

#pragma mark 微博第三方登陆成功通知
/**
 *  微博第三方登陆成功通知
 */
- (void)weiBoLoginSuccess:(NSNotification *)notification
{
    NSString *weiBoOpenID = notification.object;
    
    if (!weiBoOpenID || weiBoOpenID.length <= 0)
    {
        [Utils showMessage:@"登录不成功,未获取到用户OpenID"];
        return;
    }
    [self checkThirdPartyLoginAccount:weiBoOpenID t_type:TYPE_WB];
}

#pragma mark 微信第三方登陆成功通知
/**
 *  微信第三方登陆成功通知
 */
- (void)weiXinLoginSuccess:(NSNotification *)notification
{
    NSString *weiXinCode = notification.object;
    
    if (!weiXinCode || weiXinCode.length <= 0)
    {
        [Utils showMessage:@"登录不成功,未获取到用户OpenID"];
        return;
    }
    [self checkThirdPartyLoginAccount:weiXinCode t_type:TYPE_WX];
}

/**
 *  检测第三方登陆账号
 */
- (void)checkThirdPartyLoginAccount:(NSString *)t_uid t_type:(NSString *)t_type
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"login/thirdLogin"];
    
    NSDictionary *parameters = @{@"t_uid": t_uid, @"user_type":t_type};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        NSInteger state = [[responseObject objectForKey:@"state"] integerValue];
        
        if (1 == state)
        {   // 已经绑定
            ApplicationDelegate.userId = [responseObject objectForKey:@"uid"];
            ApplicationDelegate.isLogin = YES;
            ApplicationDelegate.account = [responseObject objectForKey:@"mobile"];
            ApplicationDelegate.cookie = [responseObject objectForKey:@"cookie"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exchangeUser" object:nil];
            
            [self saveAccount:[responseObject objectForKey:@"mobile"] password:@""];

            if ([NSStringFromClass(self.source) isEqualToString:@"AppDelegate"])
            {
                ApplicationDelegate.tabBarController.selectedIndex = 1;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
//            buildObjectWithInitializer(self.source, self.aSelector, self.instance);
//            [self performSelector:@selector(prveBulidInfo) withObject:nil afterDelay:0.55];
        }
        //状态码:-2  第三方类型 并且 第三方登录 不能为空
        if (-503 == state)
        {   // 该用户已锁定
            [Utils showMessage:@"该用户已锁定"];
        }
        if (-403 == state)
        {   // 已经拉黑
            [Utils showMessage:@"该用户已经拉黑"];
        }
        if (-1 == state)
        {   // 未绑定用户
            MYSThirdLoginViewController *thirdLoginCtrl = [[MYSThirdLoginViewController alloc] init];
            [thirdLoginCtrl sendValue:t_uid type:t_type source:self.source];
            thirdLoginCtrl.delegate = self;
            [self.navigationController pushViewController:thirdLoginCtrl animated:YES];
        }
        if (-2 == state)
        {   // 参数不正确
            [Utils showMessage:@"第三方类型并且第三方登录不能为空"];
        }
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
}

- (void)prveBulidInfo
{
     buildObjectWithInitializer(self.source, self.aSelector, self.instance);;
}

- (void)thirdLoginSuccess
{
//    buildObjectWithInitializer(self.source, self.aSelector, self.instance);
//    [self performSelector:@selector(prveBulidInfo) withObject:nil afterDelay:0.55];
}

@end
