//
//  TEAgreementViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-25.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAgreementViewController.h"

@interface TEAgreementViewController ()

@end

@implementation TEAgreementViewController

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
    self.title = @"名医生注册协议";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

// UI布局
- (void)layoutUI
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"agreement" withExtension:@"html"];
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"useragreement"];
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

@end
