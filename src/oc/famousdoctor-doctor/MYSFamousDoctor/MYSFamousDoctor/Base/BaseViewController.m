//
//  BaseViewController.m
//  MYSFamousDoctor
//
//  Created by Mr.L on 15/4/8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    
    // 设置导航背景
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    // 统一设置标题字体大小、颜色，并去掉文字阴影
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorFromHexRGB:K333333Color],
                                                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                                       NSShadowAttributeName: shadow}];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
