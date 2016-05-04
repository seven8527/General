//
//  MYSExamineFailViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExamineFailViewController.h"
#import "MYSRegisterSecondTableViewController.h"

@interface MYSExamineFailViewController ()

@end

@implementation MYSExamineFailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    infoBtn.layer.cornerRadius = 5;
}

- (IBAction)infoBtn:(id)sender
{
    MYSRegisterSecondTableViewController *infoCtrl = [[MYSRegisterSecondTableViewController alloc] init];
    [self.navigationController pushViewController:infoCtrl animated:YES];
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
