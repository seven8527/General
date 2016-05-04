//
//  TEBaseViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-3.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseViewController.h"
#import "TEFoundationCommon.h"

@interface TEBaseViewController ()

@property (nonatomic, copy) TEBarButtonItemActionBlock barbuttonItemAction;

@end

@implementation TEBaseViewController


- (void)clickedBarButtonItemAction
{
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }
}

#pragma mark - Public Method

- (void)configureBarbuttonItemStyle:(TEBarbuttonItemStyle)style action:(TEBarButtonItemActionBlock)action
{
    switch (style) {
        case TEBarbuttonItemStyleSetting: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_set"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case TEBarbuttonItemStyleMore: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case TEBarbuttonItemStyleCamera: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album_add_photo"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        default:
            break;
    }
    self.barbuttonItemAction = action;
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController *)newViewController
{
    [self.navigationController pushViewController:newViewController animated:YES];
}

#pragma mark - Loading

- (void)showLoading
{
    [self showLoadingWithText:nil];
}

- (void)showLoadingWithText:(NSString *)text
{
    [self showLoadingWithText:text onView:self.view];
}

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view
{
    
}

- (void)showSuccess
{
    
}

- (void)showError
{
    
}

- (void)hideLoading
{
    
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.view.bounds = CGRectMake(0, -[TEFoundationCommon getAdapterHeight], self.view.frame.size.width, self.view.frame.size.height);
    }
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.unreachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Failmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"似乎已断开与互联网的连接";
            [HUD hide:YES afterDelay:2];
        });
    };
    
    [reach startNotifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
