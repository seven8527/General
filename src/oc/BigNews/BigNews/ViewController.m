//
//  ViewController.m
//  BigNews
//
//  Created by Owen on 15-8-12.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "ViewController.h"
#import "BNHomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(100, 200, 50, 50);
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    [button setTintColor:[UIColor redColor] ];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(btnGO) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self setLeftBarImgBtn:nil];
    [self setTitle:@"main root"];
}
-(void)btnGO
{
    BNHomeViewController *home = [[BNHomeViewController alloc]init];
    [self.navigationController pushViewController:home animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)settitle:(NSString *)title
//{
//    [super settitle:title];
//}
-(void)leftBtnAction:(id)sender
{
    NSLog(@"返回按钮被点击child");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
