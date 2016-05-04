//
//  MYSAboutUsViewController.m
//  MYSFamousDoctor
//
//  关于我们
//
//  Created by lyc on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSAboutUsViewController.h"

@interface MYSAboutUsViewController ()

@end

@implementation MYSAboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"useragreement/about_us"];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    [mWebView loadRequest:request];
}

@end
