//
//  MYSMoreViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMoreViewController.h"
#import "MYSStoreManager.h"
#import "UtilsMacro.h"
#import "UIColor+Hex.h"
#import "MYSVersionTools.h"
#import "AppDelegate.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"
#import "AESCrypt.h"

@interface MYSMoreViewController () <UIAlertViewDelegate, MYSSettingViewControllerDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIButton *logoutButton;
@end

@implementation MYSMoreViewController

- (void)loadDataSource
{
    self.dataSource = [[MYSStoreManager sharedStoreManager] getMoreConfigureAray];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // 设置tableview
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    [self layoutUI];
    
    [self loadDataSource];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    if (!ApplicationDelegate.isLogin) {
        self.logoutButton.hidden = YES;
    } else {
        self.logoutButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

- (void)layoutUI
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 127)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *logoutButton = [UIButton newAutoLayoutView];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:18];
    logoutButton.layer.borderWidth = 1;
    logoutButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    logoutButton.layer.borderColor = [UIColor colorFromHexRGB:KEB3C00Color].CGColor;
    logoutButton.layer.cornerRadius = 5.0;
    [logoutButton setTitleColor:[UIColor colorFromHexRGB:KEB3C00Color] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(clickLogoutButton) forControlEvents:UIControlEventTouchUpInside];
    self.logoutButton = logoutButton;
    [footerView addSubview:logoutButton];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.logoutButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.logoutButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [self.logoutButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25];
    [self.logoutButton autoSetDimension:ALDimensionHeight toSize:44];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataSource[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"more";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    }
    
    if(indexPath.section == 1 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSArray *tempArray = self.dataSource[indexPath.section];
    NSDictionary *tempDict = tempArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[tempDict objectForKey:@"icon"]];
    cell.textLabel.text = [tempDict objectForKey:@"title"];
    cell.detailTextLabel.text = [tempDict objectForKey:@"detail"];
    cell.separatorInset = UIEdgeInsetsMake(0, 51, 0, 10);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *tempArray = self.dataSource[indexPath.section];
    NSDictionary *tempDict = tempArray[indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[MYSVersionTools sharedInstance] openAppReviews];
        } else if (indexPath.row == 1) {
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <MYSFeedBackViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSFeedBackViewControllerProtocol)];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            if (IOS8_OR_LATER) {
               UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[tempDict objectForKey:@"detail"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self callCustomerServiceHotlineWithTel:[tempDict objectForKey:@"detail"]];
                }];
                [alertVC addAction:cancelAction];
                [alertVC addAction:okAction];
                [self presentViewController:alertVC animated:YES completion:nil];
                
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[tempDict objectForKey:@"detail"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
                [alertView show];
            }
        } else if (indexPath.row == 1) {
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <MYSAboutUsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSAboutUsViewControllerProtocol)];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } 
    }
    
//    if (indexPath.row == 0) {
//        if (!ApplicationDelegate.isLogin) {
//            UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
//            loginViewController.title = @"登录";
//            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//            [self presentViewController:navController animated:YES completion:nil];
//        } else {
//            self.hidesBottomBarWhenPushed = YES;
//            UIViewController <MYSSettingViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSSettingViewControllerProtocol)];
//            viewController.delegate = self;
//            [self.navigationController pushViewController:viewController animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
//        }
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self callCustomerServiceHotlineWithTel:alertView.message];
    }
}

// 拨打客服专线
- (void)callCustomerServiceHotlineWithTel:(NSString *)tel
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}


/**
 *  设置cell的圆角
 *
 *  @param tableView taleview
 *  @param cell      cell
 *  @param indexPath indexpath
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        
        if (tableView == self.tableView) {
            
            CGFloat cornerRadius = 0.f;
            
            cell.backgroundColor = UIColor.clearColor;
            
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            
            CGMutablePathRef pathRef = CGPathCreateMutable();
            
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
            
            BOOL addLine = NO;
            
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                
            } else if (indexPath.row == 0) {
                
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                
                addLine = YES;
                
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
                
            } else {
                
                CGPathAddRect(pathRef, nil, bounds);
                
                addLine = YES;
                
            }
            
            layer.path = pathRef;
            
            CFRelease(pathRef);
            
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            
            
            if (addLine == YES) {
                
                CALayer *lineLayer = [[CALayer alloc] init];
                
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 51, bounds.size.height-lineHeight, bounds.size.width - 66, lineHeight);
                
                lineLayer.backgroundColor = [UIColor colorFromHexRGB:KD1D1D1Color].CGColor;
                
                [layer addSublayer:lineLayer];
                
            }
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            
            [testView.layer insertSublayer:layer atIndex:0];
            
            testView.backgroundColor = UIColor.clearColor;
            
            cell.backgroundView = testView;
            
        }
        
    }
    
}

#pragma mark settingDelegate

//- (void)clickLogoutButton
//{
//    UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//    [self presentViewController:nav animated:YES completion:nil];
//
//}

- (void)clickLogoutButton
{
    //[ShareSDK cancelAuthWithType:ApplicationDelegate.thirdVendorType];
    ApplicationDelegate.userId = nil;
    ApplicationDelegate.isLogin = NO;
    ApplicationDelegate.cookie = nil;
    
    UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
    // 退出登录时，设定保存的账号密码为空
    [self saveAccount:@"" password:@""];
}

/**
 *  保存登录的账号和密码
 *
 *  @param account  登录的账号
 *  @param password 登录的密码
 */
- (void)saveAccount:(NSString *)account password:(NSString *)password
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"MYSUserLogin"];
    password = [AESCrypt encrypt:password password:@"mingyisheng"];
    NSDictionary *dict = @{@"Account": account, @"Password": password};
    [settings setObject:dict forKey:@"MYSUserLogin"];
    [settings synchronize];
}

@end
