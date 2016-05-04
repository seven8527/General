//
//  MYSPersonalViewController.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-1-7.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalViewController.h"
#import "AppDelegate.h"
#import "MYSPersonalSliderViewController.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "MYSUserModel.h"
#import "MYSOrderModel.h"
#import "Order.h"
#import "PartnerConfig.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import <UIButton+WebCache.h>
#import "MYSFoundationCommon.h"

#define topViewHeight 176
#define iconImageViewWidth 60
#define iconImageViewTopMargin 49
#define nameToIconMargin 10
#define editWidth 22

@interface MYSPersonalViewController () <MYSPersonalAccountManagerViewDelegate,MYSExpertGroupConsultChooseUserViewControllerDelegate>
@property (nonatomic, weak) UIImageView *backTopView;
@property (nonatomic, strong) MYSUserModel *userModel;
@property (nonatomic, strong) MYSPersonalSliderViewController *sliderVC;
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, weak) UIButton *headPortraitButton;
@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation MYSPersonalViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeUser:) name:@"exchangeUser" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollUp) name:@"scrollUp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollDown) name:@"scrollDown" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeUser:) name:@"exchangeUser" object:nil];
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 查看订单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalCheckOrderButton:) name:@"personalCheckOrderButton" object:nil];
    
    // 去支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalClickPayButton:) name:@"personalClickPayButton" object:nil];
    
    // 选择查看就诊记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalMedicalRecordSelect:) name:@"personalMedicalRecordSelect" object:nil];
    
    // 添加就诊记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalMedicalRecordAddNewRecord:) name:@"personalMedicalRecordAddNewRecord" object:nil];
    
    // 用户管理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalMedicalRecordUserManager:) name:@"personalMedicalRecordUserManager" object:nil];
    
    // 选中免费咨询
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalConsultations:) name:@"personalConsultatins" object:nil];
    
    [self fetchPersonalData];

    UIImageView *backTopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, topViewHeight)];
    backTopView.userInteractionEnabled = YES;
    backTopView.image = [UIImage imageNamed:@"zoe_bg_"];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - iconImageViewWidth)/2 , iconImageViewTopMargin, iconImageViewWidth, iconImageViewWidth)];
    iconImageView.layer.cornerRadius = iconImageViewWidth / 2;
    iconImageView.clipsToBounds = YES;
    [backTopView addSubview:iconImageView];
    
//    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - editWidth - 9, 31, editWidth, editWidth)];
//    [editButton addTarget:self action:@selector(clickEdidButton) forControlEvents:UIControlEventTouchUpInside];
//    [editButton setImage:[UIImage imageNamed:@"zoe_icon_edit_"] forState:UIControlStateNormal];
//    [backTopView addSubview:editButton];
    
    UIButton *headPortraitButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - iconImageViewWidth)/2 , iconImageViewTopMargin, iconImageViewWidth, iconImageViewWidth)];
    headPortraitButton.layer.cornerRadius = iconImageViewWidth / 2;
    headPortraitButton.clipsToBounds = YES;
    [headPortraitButton addTarget:self action:@selector(clickEdidButton) forControlEvents:UIControlEventTouchUpInside];
    self.headPortraitButton = headPortraitButton;
    [backTopView addSubview:headPortraitButton];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + nameToIconMargin, kScreen_Width, 16)];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor colorFromHexRGB:KFFFFFFColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel = nameLabel;
    [backTopView addSubview:nameLabel];
    
    
//    UIImageView *telImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(iconImageView.frame) - 30, CGRectGetMaxY(nameLabel.frame) + 16, 10, 13)];
//    telImageView.backgroundColor = [UIColor orangeColor];
//    [backTopView addSubview:telImageView];
//    
//    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(telImageView.frame) + 5, CGRectGetMaxY(nameLabel.frame) + 17, kScreen_Width - CGRectGetMaxX(telImageView.frame) - 5 , 13)];
//    telLabel.font = [UIFont systemFontOfSize:14];
//    telLabel.textColor = [UIColor colorFromHexRGB:KFFFFFFColor];
//    telLabel.backgroundColor = [UIColor clearColor];
//    telLabel.text = @"18254314210";
//    [backTopView addSubview:telLabel];


    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreen_Width, kScreen_Height + topViewHeight - 44) style:UITableViewStylePlain];
    [self.view addSubview:mainTableView];
    mainTableView.scrollEnabled = NO;
    self.mainTableView = mainTableView;
    mainTableView.tableHeaderView = backTopView;
    
    
    MYSPersonalSliderViewController *sliderVC = [[MYSPersonalSliderViewController alloc] init];
    self.sliderVC = sliderVC;
    sliderVC.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    mainTableView.tableFooterView = sliderVC.view;

}

// 更换账号
- (void)exchangeUser:(NSNotification *)notification
{
    [self fetchPersonalData];
}

// 设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 账号管理局
- (void)clickEdidButton
{
    UIViewController <MYSPersonalAccountManagerViewControllerPrototol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalAccountManagerViewControllerPrototol)];
    viewController.userModel = self.userModel;
    viewController.iconImage = self.headPortraitButton.imageView.image;
    viewController.delegate = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark MYSPersonalAccountManagerViewControllerDelegate

- (void)expertGroupConsultChooseUserViewControllerDidSelectedIndex:(NSInteger)patientIndex
{
    NSDictionary *userInfo = @{@"choosePatientIndex": [NSString stringWithFormat:@"%ld",(long)patientIndex]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"personalChoosePatient" object:nil userInfo:userInfo];
}

#pragma mark  persoanlAccountManagerDelegate

- (void)personalAccountManagerChangeInfo
{
    [self fetchPersonalData];
}

// 去支付
- (void)personalClickPayButton:(NSNotification *)notification
{
    MYSOrderModel *orderModel = notification.object;
    
    [self payWithOrderModel:orderModel];
    
}


// 查看订单
- (void)personalCheckOrderButton:(NSNotification *)notification
{
    LOG(@"点击查看订单");
    
    NSDictionary *userInfo = notification.userInfo;
    UIViewController <MYSPersonalCheckOrderDetailsViewControllerPrototol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalCheckOrderDetailsViewControllerPrototol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.orderId = [userInfo objectForKey:@"orderId"];
    viewController.consultType = [userInfo objectForKey:@"consultType"];
    viewController.doctorPic = [userInfo objectForKey:@"doctorPic"];
    viewController.patientImage = [userInfo objectForKey:@"patientPic"];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

// 选择记录
- (void)personalMedicalRecordSelect:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    MYSExpertGroupPatientModel *patientModel = [userInfo objectForKey:@"patientModel"];
    NSString *medicalId = [[userInfo objectForKey:@"patientRecord"] recordID];
    NSString *orderNumber = [[userInfo objectForKey:@"patientRecord"] orderNumber];
    UIViewController <MYSPersonalCheckMedicalRecordViewControllerPrototol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalCheckMedicalRecordViewControllerPrototol)];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.medicalId = medicalId;
    viewController.patientModel = patientModel;
    viewController.orderNumber = orderNumber;
    self.hidesBottomBarWhenPushed = NO;
}

// 增添记录
- (void)personalMedicalRecordAddNewRecord:(NSNotification *)notification
{
    MYSExpertGroupPatientModel *patientModel = notification.object;
    UIViewController <MYSExpertGroupConsultAddNewRecordViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultAddNewRecordViewControllerProtocol)];
    viewController.patientModel = patientModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

// 用户管理
- (void)personalMedicalRecordUserManager:(NSNotification *)notification
{
    UIViewController <MYSExpertGroupConsultChooseUserViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultChooseUserViewControllerProtocol)];
    viewController.delegate = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

// 免费咨询
- (void)personalConsultations:(NSNotification *)notification
{
    UIViewController <MYSPersonalFreeConsultationDetailsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalFreeConsultationDetailsViewControllerProtocol)];
    viewController.pfid = [notification.userInfo objectForKey:@"pfid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)scrollUp
{
    [UIView animateWithDuration:1 animations:^{
        self.mainTableView.frame = CGRectMake(0, -topViewHeight, kScreen_Width, kScreen_Height + topViewHeight - 44);
    }];
}

- (void)scrollDown
{
    [UIView animateWithDuration:1 animations:^{
        self.mainTableView.frame = CGRectMake(0, -20, kScreen_Width, kScreen_Height + topViewHeight - 44);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 支付

- (void)payWithOrderModel:(MYSOrderModel *)orderModel
{
    ApplicationDelegate.payEntrance = 2;
    if ([orderModel.payType isEqualToString:@"1"]) {
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
         */
        NSString *appScheme = @"MYSPatient";
        NSString *orderInfo = [self getOrderInfo:orderModel];
        NSString *signedStr = [self doRsa:orderInfo];
        
        LOG(@"signedStr:%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderInfo, signedStr, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            LOG(@"reslut = %@",resultDic);
            NSString *resultStatus = resultDic[@"resultStatus"];
            if([resultStatus isEqualToString:@"9000"])//成功代码
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccessPersonal" object:nil];
                UIViewController <MYSExpertGroupPaySuccessViewrProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupPaySuccessViewrProtocol)];
                viewController.consultType = [NSString stringWithFormat:@"%d",orderModel.orderType];
                if (orderModel.patientPic.length > 5) {
                    viewController.patientImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:orderModel.patientPic]]];
                } else {
                    viewController.patientImage = [UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:orderModel.gender andBirthday:orderModel.birthday]];
                }
                viewController.orderId= orderModel.orderId;
                viewController.doctorPic = orderModel.doctorPic;
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:NO];
                
            } else {
                UIViewController <MYSExpertGroupPayFailureViewProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupPayFailureViewProtocol)];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:NO];
                
            }
        }];
        
    } else {
        
        
    }
    
}

-(NSString*)getOrderInfo:(MYSOrderModel *)orderModel
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = orderModel.orderId; //订单ID
    LOG(@"trade orderId:%@", orderModel.orderId);
    order.productName = orderModel.expertName; //商品标题
    order.productDescription = orderModel.expertTitle; //商品描述
    order.amount = orderModel.orderRealPrice; //商品价格
    order.notifyURL = [kURL_PAY stringByAppendingString:@"apliay/notify.php"]; //回调URL
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    //    self.orderId = orderModel.orderId;
    
    return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}


#pragma mark - API methods

// 获取个人资料
- (void)fetchPersonalData
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"center"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        MYSUserModel *userModel = [[MYSUserModel alloc] initWithDictionary:responseObject error:nil];
        self.userModel = userModel;
        if (userModel.userName.length > 0) {
            self.nameLabel.text = userModel.userName;
        } else {
            self.nameLabel.text = @"点击头像编辑账号";
        }
        
        [self.headPortraitButton sd_setImageWithURL:[NSURL URLWithString:self.userModel.pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"favicon_man"]];
        [self.headPortraitButton sd_setImageWithURL:[NSURL URLWithString:self.userModel.pic] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"favicon_man"]];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
    }];
}

@end
