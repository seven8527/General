//
//  MYSExpertGroupPaySuccessViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-28.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupPaySuccessViewController.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"
#import "AppDelegate.h"
#import "MYSExpertGroupViewController.h"
#import "UITabBarItem+Universal.h"
#import "MYSPersonalViewController.h"

#define picWidth 60

@interface MYSExpertGroupPaySuccessViewController ()

@end

@implementation MYSExpertGroupPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KFAFAFAColor];
    self.title = @"支付成功";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    [self setupSubview];
   
}

- (void)setPatientImage:(UIImage *)patientImage
{
    _patientImage = patientImage;
}

- (void)setupSubview
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 202)];
    backView.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
    [self.view addSubview:backView];
    
    
    UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - picWidth)/ 2, 50, picWidth, picWidth)];
    picImageView.backgroundColor = [UIColor clearColor];
    picImageView.image = [UIImage imageNamed:@"consult_icon_succeed_"];
    [backView addSubview:picImageView];
    
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(picImageView.frame) + 26, kScreen_Width, 20)];
    successLabel.font = [UIFont systemFontOfSize:21];
    successLabel.backgroundColor = [UIColor clearColor];
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.textColor = [UIColor colorFromHexRGB:K69AE42Color];
    successLabel.text = @"恭喜您，付款成功!";
    [backView addSubview:successLabel];
    
    
    UIButton *viewOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame) + 30, kScreen_Width - 30, 44)];
    [viewOrderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    viewOrderButton.layer.cornerRadius = 5.0;
    viewOrderButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [viewOrderButton addTarget:self action:@selector(viewOrder) forControlEvents:UIControlEventTouchUpInside];
    [viewOrderButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:viewOrderButton];
    [viewOrderButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:viewOrderButton];
    [viewOrderButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
    [self.view addSubview:viewOrderButton];
    
   }


- (void)clickLeftBarButton
{
    
}

- (void)viewOrder
{
    // 从咨询而来
    if (ApplicationDelegate.payEntrance == 1) {
    
        self.tabBarController.selectedIndex = 1;
        UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
        UIViewController <MYSPersonalViewControllerPrototol> *personalViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalViewControllerPrototol)];
        personalViewController.title = @"个人中心";
        personalViewController.tabBarItem = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"nav_button12"] selectedImage:[UIImage imageNamed:@"nav_button2"]];
        
        UIViewController <MYSPersonalCheckOrderDetailsViewControllerPrototol> *checkOrderDetailsVC = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalCheckOrderDetailsViewControllerPrototol)];
        checkOrderDetailsVC.hidesBottomBarWhenPushed = YES;
        checkOrderDetailsVC.orderId = self.orderId;
        checkOrderDetailsVC.consultType = self.consultType;
        checkOrderDetailsVC.doctorPic = self.doctorPic;
        checkOrderDetailsVC.patientImage = self.patientImage;
         [navController setViewControllers:@[personalViewController, checkOrderDetailsVC]];
        for(UIViewController *ctrl in self.navigationController.childViewControllers) {
            if ([ctrl isMemberOfClass:[MYSExpertGroupViewController class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
//         checkOrderDetailsVC.hidesBottomBarWhenPushed = NO;
        
    } else {
        self.tabBarController.selectedIndex = 1;
        UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];

        for(UIViewController *ctrl in self.navigationController.childViewControllers) {
            if ([ctrl isMemberOfClass:[MYSPersonalViewController class]]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        UIViewController <MYSPersonalCheckOrderDetailsViewControllerPrototol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalCheckOrderDetailsViewControllerPrototol)];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.orderId = self.orderId;
        viewController.consultType = self.consultType;
        viewController.doctorPic = self.doctorPic;
        viewController.patientImage = self.patientImage;
        [navController pushViewController:viewController animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    }
}
@end
