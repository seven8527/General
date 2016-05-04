//
//  TEPayFailureViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPayFailureViewController.h"
#import "TEHomeViewController.h"
#import "TEExpertViewController.h"
#import "TETriageViewController.h"
#import "TEOrderSuccessViewController.h"
#import "TEOrderViewController.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"

@interface TEPayFailureViewController ()

@end

@implementation TEPayFailureViewController

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
    self.title = @"支付失败";
    
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

    // 支付失败图标
    UIImageView *failureImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 50) / 2, 28, 50, 50)];
    failureImageView.image = [UIImage imageNamed:@"icon_fail.png"];
    [headerView addSubview:failureImageView];
    
    // 支付失败标签
    CGSize boundingSize = CGSizeMake(300, CGFLOAT_MAX);
    CGSize promptSize  = [@"支付失败!" boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    CGFloat origin = (kScreen_Width - promptSize.width) / 2;
    
    UILabel *failureLabel = [[UILabel alloc] init];
    failureLabel.text = @"支付失败!";
    failureLabel.font = [UIFont boldSystemFontOfSize:17];
    failureLabel.textColor = [UIColor colorWithHex:0x383838];
    failureLabel.textAlignment = NSTextAlignmentCenter;
    CGSize successSize  = [failureLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    failureLabel.frame = CGRectMake(origin, 99, successSize.width, 21);
    [headerView addSubview:failureLabel];


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
    [loginButton setTitle:@"返回重新支付" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loginButton];
    self.tableView.tableFooterView = footerView;

}

#pragma mark - Bussiness

// 重新支付
- (void)pay:(id)sender
{
    for (UIViewController *ctrl in self.navigationController.viewControllers) {
        if ([ctrl isMemberOfClass:[TEOrderSuccessViewController class]]) {
            [self.navigationController popToViewController:ctrl animated:YES];
        } else if ([ctrl isMemberOfClass:[TEPaymentConsultDetailsViewController class]]) {
            [self.navigationController popToViewController:ctrl animated:YES];
        }
    }
}

@end
