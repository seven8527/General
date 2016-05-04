//
//  BNSettingViewController.m
//  BigNews
//
//  Created by Owen on 15-8-14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNSettingViewController.h"

@interface BNSettingViewController ()


@end

@implementation BNSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"更多"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}





@end
