//
//  MYSUserAgreementViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSUserAgreementViewController.h"

@interface MYSUserAgreementViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation MYSUserAgreementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册协议";
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/useragreement", kURL_ROOT]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    [mWebView loadRequest:request];
    mWebView.delegate = self;
    
    hud = [MBProgressHUD showHUDAddedTo:mWebView animated:YES];
    hud.labelText = @"正在加载";
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [hud show:YES];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
    NSLog(@"sd");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [hud hide:YES];
    NSLog(@"sd");
}

@end
