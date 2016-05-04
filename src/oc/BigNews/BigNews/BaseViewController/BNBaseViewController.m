//
//  BNBaseViewController.m
//  BigNews
//
//  Created by Owen on 15-8-12.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNBaseViewController.h"
#import "Const.h"

@implementation BNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航背景
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(K00C3D5Color);
//    [[UINavigationBar appearance]setTintColor:UIColorFromRGB(0xcf0414)];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    // 统一设置标题字体大小、颜色，并去掉文字阴影
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(KFFFCD1Color),  NSFontAttributeName: [UIFont boldSystemFontOfSize:18],  NSShadowAttributeName: shadow}];
    
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLeftBarImgBtn:(NSString *)imageName
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:ImageNamed(imageName==nil?@"button_back_":imageName) style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAction:)];
    leftBarButton.tintColor = UIColorFromRGB(KFFFCD1Color);
    self.navigationItem.leftBarButtonItem = leftBarButton;
}
- (void)setLeftBarTextBtn:(NSString *)text
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAction:)];
    leftBarButton.tintColor = UIColorFromRGB(KFFFCD1Color);
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

-(void) leftBtnAction:(id)sender
{
//    NSLog(@"返回按钮被点击 pp");
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)setNavTitle:(NSString *)title
//{
//    self.navigationItem.title = title;
//}

- (void)setRightBarImgBtn:(NSString *)imageName{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:ImageNamed(imageName) style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
    rightBarButton.tintColor = UIColorFromRGB(KFFFCD1Color);
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setRightBarTextBtn:(NSString *)text{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
    rightBarButton.tintColor = UIColorFromRGB(KFFFCD1Color);
    self.navigationItem.rightBarButtonItem = rightBarButton;
}
-(void) rightBtnAction:(id)sender
{
    //    NSLog(@"返回按钮被点击 pp");
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
