//
//  MYSExpertGroupPayFailureViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-28.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupPayFailureViewController.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"
#import "UITabBarItem+Universal.h"
#import "MYSExpertGroupViewController.h"
#import "AppDelegate.h"
#import "MYSExpertGroupDoctorHomeViewController.h"
#import "MYSExpertGroupNetworkConsultViewController.h"
#import "MYSExpertGroupConfirmNetworkConsultViewController.h"

#define picWidth 60
@interface MYSExpertGroupPayFailureViewController ()

@end

@implementation MYSExpertGroupPayFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KFAFAFAColor];
    self.title = @"支付失败";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    [self setupSubview];
    
}


- (void)setupSubview
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 202)];
    backView.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
    [self.view addSubview:backView];
    
    
    UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - picWidth)/ 2, 50, picWidth, picWidth)];
    picImageView.backgroundColor = [UIColor clearColor];
    picImageView.image = [UIImage imageNamed:@"consult_icon_failure_"];
    [backView addSubview:picImageView];
    
    
    UILabel *failureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(picImageView.frame) + 26, kScreen_Width, 20)];
    failureLabel.font = [UIFont systemFontOfSize:21];
    failureLabel.backgroundColor = [UIColor clearColor];
    failureLabel.textColor = [UIColor colorFromHexRGB:KEB3C00Color];
    failureLabel.text = @"很遗憾，支付失败!";
    failureLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:failureLabel];
    
    
    UIButton *viewOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame) + 30, kScreen_Width - 30, 44)];
    [viewOrderButton setTitle:@"返回重新支付" forState:UIControlStateNormal];
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
        [navController setViewControllers:@[personalViewController]];
        for(UIViewController *ctrl in self.navigationController.childViewControllers) {
            if ([ctrl isMemberOfClass:[MYSExpertGroupViewController class]]) {
//                [self.navigationController popToViewController:ctrl animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
//            } else if ([ctrl isMemberOfClass:[MYSExpertGroupDoctorHomeViewController class]]) {
//                [self.navigationController popToViewController:ctrl animated:YES];
//            } else if ([ctrl isMemberOfClass:[MYSExpertGroupNetworkConsultViewController class]]) {
//                [self.navigationController popToViewController:ctrl animated:YES];
//            } else if ([ctrl isMemberOfClass:[MYSExpertGroupConfirmNetworkConsultViewController class]]) {
//               
//            }
        }
        
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

    
//    UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
//    UIViewController <MYSPersonalViewControllerPrototol> *personalViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalViewControllerPrototol)];
//    personalViewController.title = @"个人中心";
//    personalViewController.tabBarItem = [UITabBarItem itemWithTitle:@"个人中心" image:[UIImage imageNamed:@"nav_button12"] selectedImage:[UIImage imageNamed:@"nav_button2"]];
//     [navController setViewControllers:@[personalViewController]];
//    // 重新支付
//    for (UIViewController *ctrl in self.navigationController.viewControllers) {
//        if ([ctrl isMemberOfClass:[TEOrderSuccessViewController class]]) {
//            [self.navigationController popToViewController:ctrl animated:YES];
//        } else if ([ctrl isMemberOfClass:[TEPaymentConsultDetailsViewController class]]) {
//            [self.navigationController popToViewController:ctrl animated:YES];
//        }
//    }
}

@end
