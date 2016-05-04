//
//  TEPaySuccessViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPaySuccessViewController.h"
#import "UIColor+Hex.h"
#import "TEHomeViewController.h"
#import "TEExpertViewController.h"
#import "TEPersonalViewController.h"
#import "TEOrderViewController.h"
#import "NSString+CalculateTextSize.h"
#import "TEAppDelegate.h"
#import "TEConsultViewController.h"
#import "UITabBarItem+Universal.h"

#define MESSAGE  @"电话咨询/面对面咨询：\n您已成功付款，稍后客服人员会与您确定详细的咨询时间，时间确定后您可以在电话咨询/面对面咨询详情中查看具体的咨询时间。\n"


@interface TEPaySuccessViewController ()

@end

@implementation TEPaySuccessViewController

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
    self.title = @"支付成功";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    CGSize promptSize  = [@"付款成功!" boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    CGFloat origin = (kScreen_Width - promptSize.width) / 2;
    
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.text = @"付款成功!";
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
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(21, 30, 277, 51);
    [loginButton setTitle:@"查看咨询" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(checkConsult) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loginButton];
    
    CGSize messageSize = [MESSAGE boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.frame = CGRectMake(16, 91, messageSize.width, messageSize.height);
    instructionLabel.font = [UIFont boldSystemFontOfSize:14];
    instructionLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
    instructionLabel.numberOfLines = 0;
    instructionLabel.text = MESSAGE;
    [footerView addSubview:instructionLabel];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Bussiness

// 跳转到个人中心的咨询详情页
- (void)checkConsult
{
    
    if (ApplicationDelegate.payProtal == 1) {
        
        for (UIViewController *ctrl in self.navigationController.viewControllers) {
            
            
            if ([ctrl isMemberOfClass:[TEHomeViewController class]]) {
                [self.navigationController popToViewController:ctrl animated:YES];
            } else if ([ctrl isMemberOfClass:[TEExpertViewController class]]) {
                [self.navigationController popToViewController:ctrl animated:YES];
            } else if ([ctrl isMemberOfClass:[TEConsultViewController class]]) {
                self.tabBarController.selectedIndex = 3;
                UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                UIViewController <TEPersonalViewControllerProtocol> *personalViewController = [[JSObjection defaultInjector] getObject:@protocol(TEPersonalViewControllerProtocol)];
                personalViewController.title = @"个人中心";
                personalViewController.tabBarItem = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"tab_user0.png"] selectedImage:[UIImage imageNamed:@"tab_user1.png"]];
                
                if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
                    UIViewController <TEConsultViewControllerProtocol> *consultViewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
                    consultViewController.title = @"网络咨询";
                    consultViewController.consultType = @"0";
                    consultViewController.hidesBottomBarWhenPushed = YES;
                    
                    UIViewController <TECompleteConsultDetailsViewControllerProtocol> *completeViewController = [[JSObjection defaultInjector] getObject:@protocol(TECompleteConsultDetailsViewControllerProtocol)];
                    completeViewController.hidesBottomBarWhenPushed = YES;
                    completeViewController.TEConfirmConsultType = TEConfirmConsultOnline;
                    completeViewController.orderNumber = ApplicationDelegate.orderId;
                    
                    [navController setViewControllers:@[personalViewController, consultViewController, completeViewController]];
                    
                } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
                    UIViewController <TEConsultViewControllerProtocol> *consultViewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
                    consultViewController.title = @"电话咨询";
                    consultViewController.consultType = @"1";
                    consultViewController.hidesBottomBarWhenPushed = YES;
                    
                    
                    UIViewController <TECompleteConsultDetailsViewControllerProtocol> *completeViewController = [[JSObjection defaultInjector] getObject:@protocol(TECompleteConsultDetailsViewControllerProtocol)];
                    completeViewController.hidesBottomBarWhenPushed = YES;
                    completeViewController.TEConfirmConsultType = TEConfirmConsultPhone;
                    completeViewController.orderNumber = ApplicationDelegate.orderId;
                    
                    [navController setViewControllers:@[personalViewController, consultViewController, completeViewController]];
  
                } else {
                    UIViewController <TEConsultViewControllerProtocol> *consultViewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
                    consultViewController.title = @"面对面咨询";
                    consultViewController.consultType = @"2";
                    consultViewController.hidesBottomBarWhenPushed = YES;
                    
                    
                    UIViewController <TECompleteConsultDetailsViewControllerProtocol> *completeViewController = [[JSObjection defaultInjector] getObject:@protocol(TECompleteConsultDetailsViewControllerProtocol)];
                    completeViewController.hidesBottomBarWhenPushed = YES;
                    completeViewController.TEConfirmConsultType = TEConfirmConsultOffLine;
                    completeViewController.orderNumber = ApplicationDelegate.orderId;
                    
                    [navController setViewControllers:@[personalViewController, consultViewController, completeViewController]];

                }
            }
        }
    } else {
        
        self.tabBarController.selectedIndex = 3;
        UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
        if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
            UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
            viewController.title = @"网络咨询";
            viewController.consultType = @"0";
            viewController.hidesBottomBarWhenPushed = YES;
            [navController pushViewController:viewController animated:NO];
            
            UIViewController <TECompleteConsultDetailsViewControllerProtocol> *viewController1 = [[JSObjection defaultInjector] getObject:@protocol(TECompleteConsultDetailsViewControllerProtocol)];
            viewController1.hidesBottomBarWhenPushed = YES;
            viewController1.TEConfirmConsultType = TEConfirmConsultOnline;
            viewController1.orderNumber = ApplicationDelegate.orderId;
            [navController pushViewController:viewController1 animated:NO];
            
        } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
            UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
            viewController.title = @"电话咨询";
            viewController.consultType = @"1";
            [navController pushViewController:viewController animated:NO];
            
            UIViewController <TECompleteConsultDetailsViewControllerProtocol> *viewController1 = [[JSObjection defaultInjector] getObject:@protocol(TECompleteConsultDetailsViewControllerProtocol)];
            viewController1.hidesBottomBarWhenPushed = YES;
            viewController1.TEConfirmConsultType = TEConfirmConsultPhone;
            viewController1.orderNumber = ApplicationDelegate.orderId;
            [navController pushViewController:viewController1 animated:NO];
            
        } else {
            UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
            viewController.title = @"面对面咨询";
            viewController.consultType = @"2";
            viewController.hidesBottomBarWhenPushed = YES;
            [navController pushViewController:viewController animated:NO];
            
            UIViewController <TECompleteConsultDetailsViewControllerProtocol> *viewController1 = [[JSObjection defaultInjector] getObject:@protocol(TECompleteConsultDetailsViewControllerProtocol)];
            viewController1.hidesBottomBarWhenPushed = YES;
            viewController1.TEConfirmConsultType = TEConfirmConsultOffLine;
            viewController1.orderNumber = ApplicationDelegate.orderId;
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
}



@end
