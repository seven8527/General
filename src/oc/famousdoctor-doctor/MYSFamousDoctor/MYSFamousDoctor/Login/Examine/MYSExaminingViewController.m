//
//  MYSExaminingViewController.m
//  MYSFamousDoctor
//
//  提交信息成功-正在审核
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExaminingViewController.h"

@interface MYSExaminingViewController ()

@end

@implementation MYSExaminingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)callBtnClick:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"telprompt://%@", @"4006118211"];
    NSURL *URL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)backButtonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
