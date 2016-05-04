//
//  UIBaseViewController.m
//  Express
//
//  Created by Owen on 15/11/3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "UIBaseViewController.h"
#import "Const.h"

@implementation UIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor                            = [UIColor whiteColor];
    // 设置导航背景
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(K00C3D5Color);
    //[[UINavigationBar appearance]setTintColor:UIColorFromRGB(0xcf0414)];
    NSShadow *shadow                                     = [[NSShadow alloc] init];
    shadow.shadowOffset                                  = CGSizeZero;
    // 统一设置标题字体大小、颜色，并去掉文字阴影
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(KFFFCD1Color),  NSFontAttributeName: [UIFont boldSystemFontOfSize:18],  NSShadowAttributeName: shadow}];

    [self.tabBarController.tabBar setHidden:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  标题栏左侧图片设置
 *
 *  @param imageName 传入图片的名称
 */
- (void)setLeftBarImgBtn:(NSString *)imageName
{
    UIBarButtonItem *leftBarButton                       = [[UIBarButtonItem alloc] initWithImage:ImageNamed(imageName==nil?@"button_back_":imageName) style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAction:)];
    leftBarButton.tintColor                              = UIColorFromRGB(KFFFCD1Color);
    self.navigationItem.leftBarButtonItem                = leftBarButton;
}

/**
 *  标题栏左侧文字设置
 *
 *  @param text 需要设置的文本
 */
- (void)setLeftBarTextBtn:(NSString *)text
{
    UIBarButtonItem *leftBarButton                       = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAction:)];
    leftBarButton.tintColor                              = UIColorFromRGB(KFFFCD1Color);
    self.navigationItem.leftBarButtonItem                = leftBarButton;
}

/**
 *  左侧返回按钮, 自动调用该方法
 *
 *  @param sender
 */
-(void) leftBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  设置标题栏右侧图片
 *
 *  @param imageName 传入图片的名称
 */
- (void)setRightBarImgBtn:(NSString *)imageName{
    UIBarButtonItem *rightBarButton                      = [[UIBarButtonItem alloc] initWithImage:ImageNamed(imageName) style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
    rightBarButton.tintColor                             = UIColorFromRGB(KFFFCD1Color);
    self.navigationItem.rightBarButtonItem               = rightBarButton;
}

/**
 *  设置标题栏右侧文本内容
 *
 *  @param text 文本内容
 */
- (void)setRightBarTextBtn:(NSString *)text{
    UIBarButtonItem *rightBarButton                      = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
    rightBarButton.tintColor                             = UIColorFromRGB(KFFFCD1Color);
    self.navigationItem.rightBarButtonItem               = rightBarButton;
}

/**
 *  子类需要重写该方法以实现 标题栏目右侧按钮的相关功能
 *
 *  @param sender sender description
 */
-(void) rightBtnAction:(id)sender
{
  
}
@end
