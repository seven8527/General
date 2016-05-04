//
//  MYSUserGuideViewController.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSUserGuideViewController.h"
#import "UIColor+Hex.h"

@interface MYSUserGuideViewController () <MYSLoginViewControllerDelegate, MYSRegisterViewControllerDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *skipButton;
@property (nonatomic, weak) UIButton *loginButton;
@property (nonatomic, weak) UIButton *registerButton;
@end

@implementation MYSUserGuideViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeLaunchView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)makeLaunchView
{
    
    NSArray *arr = [NSArray array];
    if (iPhone6Plus) {
        arr = @[@"guide1_1242X2208.png", @"guide2_1242X2208.png", @"guide3_1242X2208.png"];
    } else if (iPhone6) {
        arr = @[@"guide1_750X1334.png", @"guide2_750X1334.png", @"guide3_750X1334.png"];
    } else if (iPhone5) {
        arr = @[@"guide1_640X1136.png", @"guide2_640X1136.png", @"guide3_640X1136.png"];
    } else {
        arr = @[@"guide1_640X960.png", @"guide2_640X960.png", @"guide3_640X960.png"];
    }
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWeight = [UIScreen mainScreen].bounds.size.width;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView = scrollView;
    scrollView.backgroundColor = [UIColor colorFromHexRGB:KD9FAF6Color];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(screenWeight*arr.count, screenHeight);
    scrollView.pagingEnabled = YES;
    for (int i = 0; i < arr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*screenWeight, 0, screenWeight, screenHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:arr[i]];
        [scrollView addSubview:imageView];
        if (i == 2) {

            

            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (iPhone6Plus) {
                loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
               loginButton.frame = CGRectMake(screenWeight*2 + 20, screenHeight - 65, (screenWeight - 50) / 2, 45);
            } else if (iPhone6) {
                loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
                loginButton.frame = CGRectMake(screenWeight*2 + 20, screenHeight - 60, (screenWeight - 50) / 2, 40);
            } else {
                loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
                loginButton.frame = CGRectMake(screenWeight*2 + 20, screenHeight - 55, (screenWeight - 50) / 2, 35);
            }
            
            [loginButton setTitle:@"登录" forState:UIControlStateNormal];
            loginButton.layer.borderWidth = 1;
            loginButton.layer.backgroundColor = [UIColor colorFromHexRGB:K00A693Color].CGColor;
            loginButton.layer.borderColor = [UIColor colorFromHexRGB:K00A693Color].CGColor;
            loginButton.layer.cornerRadius = 5.0;
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
            self.loginButton = loginButton;
            [scrollView addSubview:loginButton];
            
            UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (iPhone6Plus) {
                registerButton.frame = CGRectMake(screenWeight*2+screenWeight/2+5, screenHeight - 65, (screenWeight - 50) / 2, 45);
                 registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
            } else if (iPhone6) {
                registerButton.frame = CGRectMake(screenWeight*2+screenWeight/2+5, screenHeight - 60, (screenWeight - 50) / 2, 40);
                 registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
            } else {
                registerButton.frame =  CGRectMake(screenWeight*2+screenWeight/2+5, screenHeight - 55, (screenWeight - 50) / 2, 35);
                 registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
            }

            [registerButton setTitle:@"注册" forState:UIControlStateNormal];
            registerButton.layer.borderWidth = 1;
            registerButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
            registerButton.layer.borderColor = [UIColor colorFromHexRGB:K00907FColor].CGColor;
            registerButton.layer.cornerRadius = 5.0;
            [registerButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
            [registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
            self.registerButton = registerButton;
            [scrollView addSubview:registerButton];
            
            
            UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
            skipButton.frame = CGRectMake(screenWeight*2 + (kScreen_Width - 120)/2, CGRectGetMinY(loginButton.frame) - 50, 120, 35);
            [skipButton setTitle:@"立即体验" forState:UIControlStateNormal];
            [skipButton setImage:[UIImage imageNamed:@"skip.png"] forState:UIControlStateNormal];
            if(iPhone6Plus){
                skipButton.titleLabel.font = [UIFont systemFontOfSize:23];
            } else if (iPhone6) {
                skipButton.titleLabel.font = [UIFont systemFontOfSize:21];
            } else {
                skipButton.titleLabel.font = [UIFont systemFontOfSize:18];
            }
            //skipButton.layer.borderWidth = 1;
            //skipButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
            //skipButton.layer.borderColor = [UIColor colorFromHexRGB:K00907FColor].CGColor;
            //skipButton.layer.cornerRadius = 5.0;
            //[skipButton setCenter:CGPointMake(screenWeight*2 + screenWeight / 2, screenHeight - 107 + 35)];
            [skipButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
            
            CGRect imageF = skipButton.imageView.frame;
            skipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -skipButton.imageView.frame.size.width *2, 0, 0);
            skipButton.imageEdgeInsets = UIEdgeInsetsMake(0, skipButton.frame.size.width - imageF.size.width *2, 0,0);
            
            
            [skipButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
            self.skipButton = skipButton;
            [scrollView addSubview:skipButton];

        }
    }
    
    [self.view addSubview:scrollView];
    
}


- (void)closeView
{
    [self.delegate willDismissUserGuide];
}

- (void)clickLoginButton
{
    UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
    loginViewController.title = @"登录";
    loginViewController.source = NSClassFromString(@"MYSUserGuideViewController");
    loginViewController.isHiddenRegisterButton = YES;
    loginViewController.delegate = self;
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//    [self presentViewController:navController animated:YES completion:nil];
    
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)clickRegisterButton
{
    UIViewController <MYSRegisterViewControllerProtocol> *registerViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSRegisterViewControllerProtocol)];
    registerViewController.title = @"注册";
    registerViewController.isGuidePortal = YES;
    registerViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:registerViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)willDismissLogin
{
    [self closeView];
}

- (void)willDismissRegister
{
    [self closeView];
}

@end
