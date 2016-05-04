//
//  MYSExpertGroupDoctorHomeViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDoctorHomeViewController.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSExpertGroupSliderViewController.h"
#import "MYSExpertGroupDoctorModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HttpTool.h"
#import "AppDelegate.h"
#import "MYSDoctorHome.h"
#import "MYSResultModel.h"

#define topViewHeight 88

@interface MYSExpertGroupDoctorHomeViewController () //<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MYSExpertGroupSliderViewController *sliderVC;
@property (nonatomic, strong) MYSExpertGroupExpertiseViewController *expertiseVC;
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UITableView *mainScrollView;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UITextField *positionalLabel;
@property (nonatomic, weak) UIImageView *hospitalImageView;
@property (nonatomic, weak) UIButton *hospitalButton;
@property (nonatomic, weak) UIImageView *departmentImageView;
@property (nonatomic, weak) UIButton *departmentButton;
@property (nonatomic, weak) UIButton *shareButton;
@property (nonatomic, weak) UILabel *concernedLabel;
@property (nonatomic, weak) UILabel *concerneNumberLabel;
@property (nonatomic, strong) MYSDoctorHomeIntroducesModel *doctorHomeIntroducesModel;

@property (nonatomic, weak) UIView *separateLine;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIButton *picAskButton;
@property (nonatomic, weak) UIButton *phoneAskButton;
@property (nonatomic, weak) UIButton *offLineAskButton;
@end

@implementation MYSExpertGroupDoctorHomeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self layoutUI];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

// UI布局
- (void)layoutUI
{
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 88)];
    self.headerView = headerView;

    
    UIImageView *iconImageView = [UIImageView newAutoLayoutView];
    iconImageView.layer.cornerRadius = 30;
    iconImageView.clipsToBounds = YES;
    self.iconImageView = iconImageView;
    [headerView addSubview:iconImageView];
    
    UILabel *nameLabel = [UILabel newAutoLayoutView];
    nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel = nameLabel;
    [headerView addSubview:nameLabel];
    
    UITextField *positionalLabel = [UITextField newAutoLayoutView];
    positionalLabel.textAlignment = NSTextAlignmentCenter;
    positionalLabel.textColor = [UIColor colorFromHexRGB:KFFFFFFColor];
    positionalLabel.layer.cornerRadius = 3;
    positionalLabel.font = [UIFont systemFontOfSize:12];
    positionalLabel.clipsToBounds = YES;
    positionalLabel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 1)];
    positionalLabel.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 1)];
    positionalLabel.rightViewMode = UITextFieldViewModeAlways;
    positionalLabel.leftViewMode = UITextFieldViewModeAlways;
    positionalLabel.userInteractionEnabled = NO;
    self.positionalLabel = positionalLabel;
    [headerView addSubview:positionalLabel];
    
    
    UIImageView *hospitalImageView = [UIImageView newAutoLayoutView];
    [headerView addSubview:hospitalImageView];
    self.hospitalImageView = hospitalImageView;
    
    UIButton *hospitalButton = [UIButton newAutoLayoutView];
    hospitalButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [hospitalButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
    hospitalButton.userInteractionEnabled = NO;
    self.hospitalButton = hospitalButton;
    [headerView addSubview:hospitalButton];
    
    
    UIImageView *departmentImageView = [UIImageView newAutoLayoutView];
    [headerView addSubview:departmentImageView];
    self.departmentImageView = departmentImageView;
    
    UIButton *departmentButton = [UIButton newAutoLayoutView];
    departmentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [departmentButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
    departmentButton.userInteractionEnabled = NO;
    self.departmentButton = departmentButton;
    [headerView addSubview:departmentButton];

    
    // 分隔线
    UIView *separateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 87, kScreen_Width, 1)];
    self.separateLine = separateLineView;
    [headerView addSubview:separateLineView];

    CGFloat consultHeight = 44;
    if ([self.doctorType isEqualToString:@"0"]) { // 名医汇
        consultHeight = 0;
    } else {
        consultHeight = 44;
    }
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-44+consultHeight) style:UITableViewStylePlain];
    [self.view addSubview:mainTableView];
    mainTableView.scrollEnabled = NO;
    self.mainTableView = mainTableView;
    mainTableView.tableHeaderView = headerView;

    
    MYSExpertGroupExpertiseViewController *expertiseVC = [[MYSExpertGroupExpertiseViewController alloc] init];
    expertiseVC.consultHeight = consultHeight;
    mainTableView.tableFooterView = expertiseVC.view;
    self.expertiseVC = expertiseVC;

    
    if ([self.doctorType isEqualToString:@"0"]) { // 名医汇
        UIView *bottomView = [UIView newAutoLayoutView];
        [bottomView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [bottomView.layer setBorderWidth:0.5];
        self.bottomView = bottomView;
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        
        // 网络咨询按钮
        UIButton *picAskButton = [UIButton newAutoLayoutView];
        picAskButton.tag = 0;
        [picAskButton setTitle:@"网络咨询" forState:UIControlStateNormal];
        [picAskButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [picAskButton.layer setBorderWidth:1];
        [picAskButton.layer setBorderColor:[UIColor colorFromHexRGB:K00907FColor].CGColor];
        picAskButton.layer.cornerRadius = 5;
        [picAskButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
        [picAskButton addTarget:self action:@selector(askNetworkExpert) forControlEvents:UIControlEventTouchUpInside];
        self.picAskButton = picAskButton;
        [bottomView addSubview:picAskButton];
        
        // 电话咨询按钮
        UIButton *phoneAskButton = [UIButton newAutoLayoutView];
        phoneAskButton.tag = 1;
        [phoneAskButton setTitle:@"电话咨询" forState:UIControlStateNormal];
        [phoneAskButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [phoneAskButton.layer setBorderWidth:1];
        [phoneAskButton.layer setBorderColor:[UIColor colorFromHexRGB:K69AF41Color].CGColor];
        phoneAskButton.layer.cornerRadius = 5;
        [phoneAskButton setTitleColor:[UIColor colorFromHexRGB:K69AF41Color] forState:UIControlStateNormal];
        [phoneAskButton addTarget:self action:@selector(askPhoneExpert) forControlEvents:UIControlEventTouchUpInside];
        self.phoneAskButton = phoneAskButton;
        [bottomView addSubview:phoneAskButton];
        
        // 面对面咨询按钮
        UIButton *offLineAskButton = [UIButton newAutoLayoutView];
        offLineAskButton.tag = 2;
        offLineAskButton.layer.cornerRadius = 5;
        [offLineAskButton setTitle:@"面对面咨询" forState:UIControlStateNormal];
        [offLineAskButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [offLineAskButton.layer setBorderWidth:1];
        [offLineAskButton.layer setBorderColor:[UIColor colorFromHexRGB:KEF8004Color].CGColor];
        [offLineAskButton setTitleColor:[UIColor colorFromHexRGB:KEF8004Color] forState:UIControlStateNormal];
        [offLineAskButton addTarget:self action:@selector(askOfflineExpert) forControlEvents:UIControlEventTouchUpInside];
        self.offLineAskButton = offLineAskButton;
        [bottomView addSubview:offLineAskButton];
        
        self.bottomView.hidden = YES;

    }
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.iconImageView autoSetDimensionsToSize:CGSizeMake(60, 60)];
        
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:15];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
        [self.nameLabel autoSetDimension:ALDimensionHeight toSize:15];
        
        [self.hospitalImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:15];
        [self.hospitalImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:12];
        [self.hospitalImageView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        
        
        [self.hospitalButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.hospitalImageView withOffset:5];
        [self.hospitalButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:12];
        [self.hospitalButton autoSetDimension:ALDimensionHeight toSize:12];
        
        [self.departmentImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:15];
        [self.departmentImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
        [self.departmentImageView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        
        
        [self.departmentButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.departmentImageView withOffset:5];
        [self.departmentButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
        [self.departmentButton autoSetDimension:ALDimensionHeight toSize:11];
        [self.positionalLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
        [self.positionalLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel withOffset:11];
        [self.positionalLabel autoSetDimension:ALDimensionHeight toSize:16];

        if ([self.doctorType isEqualToString:@"0"]) { // 名医汇
            [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [self.bottomView autoSetDimensionsToSize:CGSizeMake(kScreen_Width, 44)];
            
            [self.picAskButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
            [self.picAskButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4.5];
            [self.picAskButton autoSetDimensionsToSize:CGSizeMake(93, 35)];
            
            [self.offLineAskButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
            [self.offLineAskButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4.5];
            [self.offLineAskButton autoSetDimensionsToSize:CGSizeMake(93, 35)];
            
            [self.phoneAskButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.picAskButton withOffset:(kScreen_Width - 93 * 3 - 10 * 2)/2 ];
            [self.phoneAskButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4.5];
            [self.phoneAskButton autoSetDimensionsToSize:CGSizeMake(93, 35)];

        }
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
    
}


// 网络咨询
- (void)askNetworkExpert
{
    if (ApplicationDelegate.isLogin) {
        [self reflectAskNetWorkExpert];
    } else {
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        loginViewController.source = NSClassFromString(@"MYSExpertGroupDoctorHomeViewController");
        loginViewController.aSelector = @selector(reflectAskNetWorkExpert);
        loginViewController.instance = self;
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//        [self presentViewController:navController animated:YES completion:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (void)reflectAskNetWorkExpert
{
    UIViewController <MYSExpertGroupNetworkConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupNetworkConsultViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorId = self.doctorId;
    [self.navigationController pushViewController:viewController animated:YES];
}




// 电话咨询
- (void)askPhoneExpert
{
    if (ApplicationDelegate.isLogin) {
        [self reflectAskPhoneExpert];
    } else {
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        loginViewController.source = NSClassFromString(@"MYSExpertGroupDoctorHomeViewController");
        loginViewController.aSelector = @selector(reflectAskPhoneExpert);
        loginViewController.instance = self;
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//        [self presentViewController:navController animated:YES completion:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }

}


- (void)reflectAskPhoneExpert
{
    UIViewController <MYSExpertGroupPhoneConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupPhoneConsultViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorId = self.doctorId;
    [self.navigationController pushViewController:viewController animated:YES];
}

// 面对面咨询
- (void)askOfflineExpert
{
    if (ApplicationDelegate.isLogin) {
        [self reflectAskOfflineExpert];
    } else {
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        loginViewController.source = NSClassFromString(@"MYSExpertGroupDoctorHomeViewController");
        loginViewController.aSelector = @selector(reflectAskOfflineExpert);
        loginViewController.instance = self;
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//        [self presentViewController:navController animated:YES completion:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }

}

- (void)reflectAskOfflineExpert
{
    UIViewController <MYSExpertGroupOfflineConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupOfflineConsultViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorId = self.doctorId;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)scrollUp
{
    [UIView animateWithDuration:1 animations:^{
        self.mainTableView.frame = CGRectMake(0, - topViewHeight, kScreen_Width, kScreen_Height + topViewHeight - 44);
    }];
}

- (void)scrollDown
{
    [UIView animateWithDuration:1 animations:^{
        self.mainTableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height + topViewHeight - 44);
    }];
}

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}


- (void)setDoctorId:(NSString *)doctorId
{
    _doctorId = doctorId;
    
    [self doctorHomeByDoctorId:doctorId];
}

#pragma mark 关注医生

- (void)addAttention
{
    if (!ApplicationDelegate.isLogin) { // 未登录
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navController animated:YES completion:nil];
    } else { // 已登录
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在加载";
        
        NSString *URLString = [kURL stringByAppendingString:@"attention/add"];
        NSDictionary *parameters = @{@"attention_id": [self.doctorHomeIntroducesModel doctorId], @"uid": ApplicationDelegate.userId};
        [HttpTool get:URLString params:parameters success:^(id responseObject) {
            LOG(@"Success: %@", responseObject);
            MYSResultModel *result = [[MYSResultModel alloc] initWithDictionary:responseObject error:nil];
            
            if ([result.state isEqualToString:@"-2"] || [result.state isEqualToString:@"1"]) {
                self.doctorHomeIntroducesModel.attentionState = @"1";
                
                [self setUIWithModel:self.doctorHomeIntroducesModel];
            }
            
            [hud hide:YES];
        } failure:^(NSError *error) {
            LOG(@"Error: %@", error);
            [hud hide:YES];
        }];
        
    }
}


#pragma mark 取消医生

- (void)cancelAttention
{
    if (!ApplicationDelegate.isLogin) { // 未登录
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navController animated:YES completion:nil];
    } else { // 已登录
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在加载";
        
        NSString *URLString = [kURL stringByAppendingString:@"attention/del"];
        NSDictionary *parameters = @{@"attention_id": [self.doctorHomeIntroducesModel doctorId], @"uid": ApplicationDelegate.userId};
        [HttpTool get:URLString params:parameters success:^(id responseObject) {
            LOG(@"Success: %@", responseObject);
            MYSResultModel *result = [[MYSResultModel alloc] initWithDictionary:responseObject error:nil];
            
            if ([result.state isEqualToString:@"1"]) {
                self.doctorHomeIntroducesModel.attentionState = @"0";
                
                [self setUIWithModel:self.doctorHomeIntroducesModel];
            }

            [hud hide:YES];
        } failure:^(NSError *error) {
            LOG(@"Error: %@", error);
            [hud hide:YES];
        }];
    }
}

#pragma mark 通过医生id获取医生主页

- (void)doctorHomeByDoctorId:(NSString *)doctorId
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *userId = @"";
    if (ApplicationDelegate.isLogin) {
        userId = ApplicationDelegate.userId;
    } else {
        userId = @"";
    }
    NSString *URLString = [kURL stringByAppendingString:@"doctor-home"];
    NSDictionary *parameters = @{@"did": doctorId, @"uid": userId};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSDoctorHome *doctorHome = [[MYSDoctorHome alloc] initWithDictionary:responseObject error:nil];
        MYSDoctorHomeIntroducesModel *introductesModel = doctorHome.introducesModel;
        LOG(@"\n姓名：%@  \n医院：%@  \n科室：%@  \n擅长：%@  \n简介：%@", introductesModel.doctorName, introductesModel.hospital, introductesModel.department, introductesModel.territory, introductesModel.introduce);
        self.doctorHomeIntroducesModel = introductesModel;
        [self setUIWithModel:self.doctorHomeIntroducesModel];
        
        self.expertiseVC.model = doctorHome;
        for (MYSDoctorHomeDynamicModel *dynamicModel in doctorHome.dynamicArray) {
            LOG(@"标题：%@  时间：%@", dynamicModel.title, dynamicModel.addTime);
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

- (void)setUIWithModel:(MYSDoctorHomeIntroducesModel *)introductesModel
{
    
    self.title = [introductesModel doctorName];
    self.nameLabel.text = [introductesModel doctorName];
    if ([introductesModel qualifications]) {
        self.positionalLabel.hidden = NO;
        self.positionalLabel.text = [introductesModel qualifications];
        self.positionalLabel.backgroundColor = [UIColor colorFromHexRGB:KEF8004Color];
    } else {
        self.positionalLabel.hidden = YES;
    }
    
    self.separateLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.hospitalImageView.image = [UIImage imageNamed:@"doctor_icon1_"];
    self.departmentImageView.image = [UIImage imageNamed:@"doctor_icon2_"];
    [self.hospitalButton setTitle:[introductesModel hospital] forState:UIControlStateNormal];
    [self.departmentButton setTitle:[introductesModel department] forState:UIControlStateNormal];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:introductesModel.headPortrait] placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
    self.bottomView.hidden = NO;
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
