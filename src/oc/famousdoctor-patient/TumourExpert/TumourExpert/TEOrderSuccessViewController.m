//
//  TEOrderSuccessViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderSuccessViewController.h"
#import "TEHomeViewController.h"
#import "TEExpertViewController.h"
#import "TEOrderViewController.h"
#import "TETriageViewController.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEOrderModel.h"
#import "TEAppDelegate.h"

#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"


#import "TEUITools.h"

#import "TEExpertDetailViewController.h"
#import "TETextConsultViewController.h"
#import "TEPhoneConsultViewController.h"
#import "TEOfflineConsultViewController.h"
#import "TEConfirmConsultViewController.h"

#import "TEHttpTools.h"


@interface TEOrderSuccessViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *checkOrderButton;
@end

@implementation TEOrderSuccessViewController

#pragma mark - UIViewController lifecycle

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
    // 设置标题
    self.title = @"咨询提交成功";
    
    self.navigationItem.hidesBackButton = YES;
}

// UI布局
- (void)layoutUI
{
    self.tableView.scrollEnabled = NO;
    
    // 表头
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 160)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    // 支付成功图标
    UIImageView *successImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 50) / 2, 28, 50, 50)];
    successImageView.image = [UIImage imageNamed:@"icon_succeed.png"];
    [headerView addSubview:successImageView];
    
    // 支付成功标签
    CGSize boundingSize = CGSizeMake(300, CGFLOAT_MAX);
    CGSize promptSize  = [@"恭喜您咨询提交成功！" boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    CGFloat origin = (kScreen_Width - promptSize.width) / 2;
    
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"恭喜您咨询提交成功！";
    successLabel.font = [UIFont boldSystemFontOfSize:17];
    successLabel.textColor = [UIColor colorWithHex:0x383838];
    successLabel.textAlignment = NSTextAlignmentCenter;
    CGSize successSize  = [successLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    successLabel.frame = CGRectMake(origin, 99, successSize.width, 21);
    [headerView addSubview:successLabel];
    
    // 表尾
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreen_Height - 160)];
    footerView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    
    // 画线
    UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    UIImage *image = [UIImage imageNamed:@"line_d1d1d1.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    separatorLine.image = image;
    [footerView addSubview:separatorLine];
    
    CGFloat margin = 20;
    CGFloat buttonWidth = (kScreen_Width - margin * 3) / 2;
    // 去支付按钮
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [payButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    payButton.frame = CGRectMake((kScreen_Width + margin) * 0.5, 50, buttonWidth, 40);
    [payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:payButton];
    self.payButton = payButton;
    [footerView addSubview:payButton];
    
    // 查看订单按钮
    UIButton *checkOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkOrderButton setTitle:@"查看咨询" forState:UIControlStateNormal];
    [checkOrderButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [checkOrderButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    checkOrderButton.frame = CGRectMake( margin, 50, buttonWidth, 40);
    [checkOrderButton addTarget:self action:@selector(checkOrderDetails) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:checkOrderButton];
    self.checkOrderButton = checkOrderButton;
    [footerView addSubview:checkOrderButton];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Bussiness

// 跳转到个人中心的订单页
- (void)checkOrderDetails
{

        self.tabBarController.selectedIndex = 3;
        UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
        if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
            UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
            viewController.title = @"网络咨询";
            viewController.consultType = @"0";
            viewController.hidesBottomBarWhenPushed = YES;
            [navController pushViewController:viewController animated:NO];
            
            UIViewController <TEPaymentConsultDetailsViewControllerProtocol> *viewController1 = [[JSObjection defaultInjector] getObject:@protocol(TEPaymentConsultDetailsViewControllerProtocol)];
            viewController1.hidesBottomBarWhenPushed = YES;
            viewController1.TEConfirmConsultType = TEConfirmConsultOnline;
            viewController1.patientId = self.patientId;
            viewController1.patientName = self.patientName;
            viewController1.orderNumber = self.orderId;
            [navController pushViewController:viewController1 animated:NO];
            
        } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
            UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
            viewController.title = @"电话咨询";
            viewController.consultType = @"1";
            [navController pushViewController:viewController animated:NO];
            
            UIViewController <TEPaymentConsultDetailsViewControllerProtocol> *viewController1 = [[JSObjection defaultInjector] getObject:@protocol(TEPaymentConsultDetailsViewControllerProtocol)];
            viewController1.hidesBottomBarWhenPushed = YES;
            viewController1.TEConfirmConsultType = TEConfirmConsultPhone;
            viewController1.patientId = self.patientId;
            viewController1.patientName = self.patientName;
            viewController1.orderNumber = self.orderId;
            [navController pushViewController:viewController1 animated:NO];
            
        } else {
            UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
            viewController.title = @"面对面咨询";
            viewController.consultType = @"2";
            viewController.hidesBottomBarWhenPushed = YES;
            [navController pushViewController:viewController animated:NO];
            
            UIViewController <TEPaymentConsultDetailsViewControllerProtocol> *viewController1 = [[JSObjection defaultInjector] getObject:@protocol(TEPaymentConsultDetailsViewControllerProtocol)];
            viewController1.hidesBottomBarWhenPushed = YES;
            viewController1.TEConfirmConsultType = TEConfirmConsultOffLine;
            viewController1.patientId = self.patientId;
            viewController1.patientName = self.patientName;
            viewController1.orderNumber = self.orderId;
            [navController pushViewController:viewController1 animated:NO];
            
        }

    
    // 主页，找专家页的内容回退到顶部
    for (UIViewController *ctrl in self.navigationController.viewControllers) {
        if ([ctrl isMemberOfClass:[TEHomeViewController class]]) {
            [self.navigationController popToViewController:ctrl animated:YES];
        } else if ([ctrl isMemberOfClass:[TEExpertViewController class]]) {
            [self.navigationController popToViewController:ctrl animated:YES];
        }
    }
}

- (void)finishedPay
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"paysuccess"];
    NSDictionary *parameters = @{@"billno": self.orderId, @"cookie": ApplicationDelegate.cookie, @"pay_type": self.payType};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        //TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - Bussiness method

// 点击支付
- (void)pay:(id)sender
{
    if (self.orderModel.orderType == 1) {
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
         */
        
        
        NSString *appScheme = @"SINOTumourExpert";
        NSString *orderInfo = [self getOrderInfo:self.orderModel];
        NSString *signedStr = [self doRsa:orderInfo];
        
        NSLog(@"signedStr:%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderInfo, signedStr, @"RSA"];
        
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
        ApplicationDelegate.orderId = self.orderId;
        ApplicationDelegate.payType = self.payType;
        ApplicationDelegate.TEConfirmConsultType = self.TEConfirmConsultType;
        ApplicationDelegate.payProtal = 0;
    } else {
        UIViewController <TEPayInfoViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayInfoViewControllerProtocol)];
        if (self.orderModel.orderState == 0) {
            viewController.payStatue = @"0";
        } else {
            viewController.payStatue = @"1";
        }
        
        viewController.payTime = @"";
        viewController.payPrice = self.orderModel.orderPrice;
        if (self.orderModel.orderType  == 1) {
            viewController.payModeName = @"支付宝";
        } else if (self.orderModel.orderType  == 2) {
            viewController.payModeName = @"网银";
        } else if (self.orderModel.orderType  == 3) {
            viewController.payModeName = @"网银转账";
        } else if (self.orderModel.orderType  == 4) {
            viewController.payModeName = @"银行汇款";
        } else {
            viewController.payModeName = @"其他";
        }

        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(NSString*)getOrderInfo:(TEOrderModel *)orderModel
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = orderModel.orderId; //订单ID
	order.productName = orderModel.expertName; //商品标题
	order.productDescription = orderModel.expertTitle; //商品描述
	order.amount = orderModel.orderPrice; //商品价格
    order.notifyURL = [kURL stringByAppendingString:@"apliay/notify.php"]; //回调URL
    
    self.orderId = orderModel.orderId;
	
	return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                
                NSLog(@"验证签名成功");
                
                //验证签名成功，交易结果无篡改
                //[self finishedPay];
                
                UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                UIViewController <TEPaySuccessViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPaySuccessViewControllerProtocol)];
                viewController.TEConfirmConsultType = self.TEConfirmConsultType;
                viewController.hidesBottomBarWhenPushed = YES;
                [navController pushViewController:viewController animated:NO];
                
                for (UIViewController *ctrl in navController.viewControllers) {
                    if ([ctrl isMemberOfClass:[TEHomeViewController class]]) {
                        [self.tabBarController.navigationController popToViewController:ctrl animated:YES];
                    } else if ([ctrl isMemberOfClass:[TEExpertViewController class]]) {
                        [self.tabBarController.navigationController popToViewController:ctrl animated:YES];
                    } 
                }
                
			}
        }
        else
        {
            //交易失败
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <TEPayFailureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayFailureViewControllerProtocol)];
            [self.navigationController pushViewController:viewController animated:YES];
            NSLog(@"交易失败");
        }
    }
    else
    {
        //失败
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEPayFailureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayFailureViewControllerProtocol)];
        [self.navigationController pushViewController:viewController animated:YES];
        
        NSLog(@"失败");
    }
    
}

@end
