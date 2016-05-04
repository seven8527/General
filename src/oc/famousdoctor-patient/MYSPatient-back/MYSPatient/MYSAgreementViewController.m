//
//  MYSAgreementViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSAgreementViewController.h"
#import "UIColor+Hex.h"


@interface MYSAgreementViewController ()

@end

@implementation MYSAgreementViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
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
    self.title = @"名医生用户协议";
    
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


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
