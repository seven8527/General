//
//  LoginViewController.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/18.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableViewCell.h"

@interface LoginViewController ()
@property(nonatomic, weak) UIImageView *imageview;
@property (nonatomic, strong) UITextField * userName_tf;
@property (nonatomic, strong) UITextField * passWord_tf;

@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UIButton * registerButton;
@property (nonatomic, strong) UIButton * forgetPwdButton;

@property (nonatomic, weak) UIView * leftLineView;
@property (nonatomic, weak) UIView * rightLineView;
@property (nonatomic, weak) UILabel * thirdLoginTitleLabel;

@property (nonatomic, weak) UIButton * qqLoginButton;
@property (nonatomic, weak) UIButton * weixinLoginButton;
@property (nonatomic, weak) UIButton * sinaLoginButton;


@property (nonatomic, weak) UILabel * qqLabel;
@property (nonatomic, weak) UILabel * weixinLabel;
@property (nonatomic, weak) UILabel * sinaLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)configUI
{
    self.title = @"登录";
}

-(void)layoutUI
{

    //设置tableview 属性
    self.tableView.rowHeight = 48;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xebebeb);
    self.tableView.separatorColor =UIColorFromRGB(0xd1d1d1);

    //添加键盘监听
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    //设置背景色 、但是没用的
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    UIImageView *imageview = [UIImageView newAutoLayoutView];
    [imageview sd_setImageWithURL:[NSURL URLWithString:@"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=1a66bbc85fafa40f3c939d9dcd59377d/9358d109b3de9c82b8cef5756981800a18d843a4.jpg"]
                 placeholderImage:ImageNamed(@"nav_button1")];
    _imageview = imageview;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    [headerView addSubview:imageview];
    
    //登录按钮
    _loginButton = [UIButton newAutoLayoutView];
    [_loginButton setTitle:@"登    录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 5.0;
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _loginButton.backgroundColor = UIColorFromRGB(0x00907f);
    [_loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_loginButton];

    //忘记密码
    _forgetPwdButton = [UIButton newAutoLayoutView];
    [_forgetPwdButton  setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPwdButton setTitleColor:UIColorFromRGB(0x00907f) forState:UIControlStateNormal];
    [_forgetPwdButton addTarget:self action:@selector(forgetPwdButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _forgetPwdButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [footerView addSubview:_forgetPwdButton];
    
    // 第三方登录的label
    UILabel *thirdLoginLabel = [UILabel newAutoLayoutView];
    thirdLoginLabel.textColor = UIColorFromRGB(0xb9b9b9);
    thirdLoginLabel.font = [UIFont systemFontOfSize:12];
    thirdLoginLabel.text = @"第三方登录";
    thirdLoginLabel.textAlignment = NSTextAlignmentCenter;
    _thirdLoginTitleLabel = thirdLoginLabel;
    [footerView addSubview:_thirdLoginTitleLabel];
    
    
    // 分割线 左边
    UIView *leftLineView = [UIView newAutoLayoutView];
    leftLineView.backgroundColor = UIColorFromRGB(0xb9b9b9);
    _leftLineView = leftLineView;
    [footerView addSubview:_leftLineView];
    
    // 分隔线 右边
    UIView *rightLineView = [UIView newAutoLayoutView];
    rightLineView.backgroundColor = UIColorFromRGB(0xb9b9b9);
    _rightLineView  = rightLineView;
    [footerView addSubview:_rightLineView];
    
    //微信 登录按钮 放在中间
    
    UIButton *weixinLoginButton = [UIButton newAutoLayoutView ];
    [weixinLoginButton setImage:ImageNamed(@"login_weixin") forState:UIControlStateNormal];
    [weixinLoginButton addTarget:self action:@selector(weixinLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _weixinLoginButton = weixinLoginButton;
    [footerView addSubview:weixinLoginButton];
    
    
    //qq登录 按钮
    UIButton *qqLoginButton = [UIButton newAutoLayoutView];
    [qqLoginButton setImage:ImageNamed(@"login_qq") forState:UIControlStateNormal ];
    [qqLoginButton addTarget:self action:@selector(qqLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _qqLoginButton = qqLoginButton;
    [footerView addSubview:_qqLoginButton];
    
    //微博 登录
    UIButton *sinaLoginButton = [UIButton newAutoLayoutView];
    [sinaLoginButton setImage:ImageNamed(@"login_weibo") forState:UIControlStateNormal];
    [sinaLoginButton addTarget:self action:@selector(sinaLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _sinaLoginButton = sinaLoginButton;
    [footerView addSubview:_sinaLoginButton];
    
    
    //微信 Label
    UILabel *weixinLabel =[UILabel newAutoLayoutView];
    weixinLabel.text = @"微信";
    weixinLabel.textColor = UIColorFromRGB(0x9b9b9b);
    weixinLabel.font = [UIFont systemFontOfSize:10];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    _weixinLabel= weixinLabel;
    [footerView addSubview:_weixinLabel];
    
    //qq Label
    UILabel *qqLabel = [UILabel newAutoLayoutView];
    qqLabel.text =@"QQ";
    qqLabel.textColor = UIColorFromRGB(0x9b9b9b);
    qqLabel.font = [UIFont systemFontOfSize:10];
    qqLabel.textAlignment = NSTextAlignmentCenter ;
    _qqLabel = qqLabel;
    [footerView addSubview:_qqLabel];
    
    //sina Label
    UILabel *sinaLabel = [UILabel newAutoLayoutView];
    sinaLabel.text =@"新浪";
    sinaLabel.textColor = UIColorFromRGB(0x9b9b9b);
    sinaLabel.font = [UIFont systemFontOfSize:10];
    sinaLabel.textAlignment = NSTextAlignmentCenter ;
    _sinaLabel = sinaLabel;
    [footerView addSubview:_sinaLabel];
    
    
    self.tableView.tableFooterView = footerView;
    self.tableView.tableHeaderView = headerView;
    
    
    [self updateViewConstraints];
}

-(void)updateViewConstraints{
    
    [_imageview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:60];
    [_imageview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_imageview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [_imageview autoSetDimension:ALDimensionHeight toSize:80];
    
    [_loginButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [_loginButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_loginButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [_loginButton autoSetDimension:ALDimensionHeight toSize:44];
    
    //添加 忘记密码按钮
    [_forgetPwdButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginButton withOffset:15];
    [_forgetPwdButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [_forgetPwdButton autoSetDimension:ALDimensionHeight toSize:30];
    [_forgetPwdButton autoSetDimension:ALDimensionWidth toSize:70];
    
    //第三方等的 label
    [_thirdLoginTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.forgetPwdButton withOffset:11 ];
    [_thirdLoginTitleLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.tableView ];
    [_thirdLoginTitleLabel autoSetDimension:ALDimensionHeight toSize:18];
    [_thirdLoginTitleLabel autoSetDimension:ALDimensionWidth toSize:90 ];
    
    //左边横线
    [_leftLineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.forgetPwdButton withOffset:20];
    [_leftLineView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.thirdLoginTitleLabel withOffset:-10];
    [_leftLineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_leftLineView autoSetDimension:ALDimensionHeight toSize:1];
    
    
    //右边边横线
    [_rightLineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.forgetPwdButton withOffset:20];
    [_rightLineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight  ofView:self.thirdLoginTitleLabel withOffset:10];
    [_rightLineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [_rightLineView  autoSetDimension:ALDimensionHeight toSize:1];
    
    //中间的微信登录 约束
    [_weixinLoginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.thirdLoginTitleLabel withOffset:20];
    [_weixinLoginButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.tableView];
    [_weixinLoginButton autoSetDimensionsToSize:CGSizeMake(49, 49)];
    
    //左边的qq登录
    [self.qqLoginButton  autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.thirdLoginTitleLabel withOffset:20];
    [self.qqLoginButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.weixinLoginButton withOffset:-50];
    [self.qqLoginButton autoSetDimensionsToSize:CGSizeMake(49, 49)];
    
    //右边的新浪登录
    [self.sinaLoginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.thirdLoginTitleLabel withOffset:20];
    [self.sinaLoginButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.weixinLoginButton withOffset:50];
    [self.sinaLoginButton autoSetDimensionsToSize:CGSizeMake(49, 49)];
    
    
    //中间的微信 label
    [self.weixinLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.weixinLoginButton ];
    [self.weixinLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.weixinLoginButton];
    [self.weixinLabel autoSetDimensionsToSize:CGSizeMake(20, 60)];
    
    //左边的 qq label
    [self.qqLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.qqLoginButton ];
    [self.qqLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.qqLoginButton];
    [self.qqLabel autoSetDimensionsToSize:CGSizeMake(20, 60)];
    
    //右边的 sina label
    [self.sinaLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.sinaLoginButton ];
    [self.sinaLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.sinaLoginButton];
    [self.sinaLabel autoSetDimensionsToSize:CGSizeMake(20, 60)];
    
    [super updateViewConstraints];
}

//忘记密码监听事件
-(void)forgetPwdButtonClicked
{
    ALERT(@"忘记密码了？");
}
//登录监听事件
-(void) loginButtonClicked{
    NSString *userName = _userName_tf.text;
    NSString *passWord = _passWord_tf.text;
    if([userName isEqualToString:@"13201903556"])
    {
        if ([passWord isEqualToString:@"123456"]) {
            ALERT(@"登录成功");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            ALERT(@"密码错误");
        }
    }
    else
    {
        ALERT(@"账户不存在");
    }
}

//微信登录
-(void)weixinLoginButtonClicked
{
    
}

//qq登录
-(void)qqLoginButtonClicked
{
    
}

//新浪登录
-(void)sinaLoginButtonClicked
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellIdentifier";
    
    LoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell =[[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row ==0) {
        cell.image.image = ImageNamed(@"login_icon1_");
        cell.text.delegate = self;
        cell.text.placeholder = @"输入用户名";
        cell.text.textColor = UIColorFromRGB(0x525252);
        _userName_tf = cell.text;
    }
    else
    {
        cell.image.image = ImageNamed(@"login_icon2_");
        cell.text.delegate = self;
        cell.text.placeholder = @"输入密码";
        cell.text.textColor = UIColorFromRGB(0x525252);
        cell.text.secureTextEntry = YES;
        _passWord_tf = cell.text;

    }
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
-(void) hideKeyboard{
    [self.tableView endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
