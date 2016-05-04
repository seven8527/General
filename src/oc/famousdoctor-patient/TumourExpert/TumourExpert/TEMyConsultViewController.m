//
//  TEMyConsultViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEMyConsultViewController.h"
#import "TEStoreManager.h"
#import "TERemindModel.h"
#import "TEAppDelegate.h"
#import "UIView+TEBadgeVifew.h"
#import "TEHttpTools.h"

@interface TEMyConsultViewController ()
@property (nonatomic, assign) int textConsultCount;
@property (nonatomic, assign) int phoneConsultCount;
@property (nonatomic, assign) int referralConsultCount;
@end

@implementation TEMyConsultViewController

#pragma mark - DataSource

- (void)loadDataSource
{
    self.dataSource = [[TEStoreManager sharedStoreManager] getConsultConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self remind];
        });
    };
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的咨询";
    
    [self loadDataSource];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"type"];
        
        if (indexPath.row == 0 && _textConsultCount > 0) {
            cell.contentView.badgeViewFrame = CGRectMake(250, 12, 50, 20);
            cell.contentView.badgeView.font = [UIFont systemFontOfSize:13];
            cell.contentView.badgeView.text = @"new";
            cell.contentView.badgeView.textColor = [UIColor whiteColor];
            cell.contentView.badgeView.badgeColor = [UIColor redColor];
        }
        if (indexPath.row == 0 && _phoneConsultCount > 0) {
            cell.contentView.badgeViewFrame = CGRectMake(250, 12, 50, 20);
            cell.contentView.badgeView.font = [UIFont systemFontOfSize:13];
            cell.contentView.badgeView.text = @"new";
            cell.contentView.badgeView.textColor = [UIColor whiteColor];
            cell.contentView.badgeView.badgeColor = [UIColor redColor];
        }
        if (indexPath.row == 0 && _referralConsultCount > 0) {
            cell.contentView.badgeViewFrame = CGRectMake(250, 12, 50, 20);
            cell.contentView.badgeView.font = [UIFont systemFontOfSize:13];
            cell.contentView.badgeView.text = @"new";
            cell.contentView.badgeView.textColor = [UIColor whiteColor];
            cell.contentView.badgeView.badgeColor = [UIColor redColor];
        }
    }

    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultViewControllerProtocol)];
    if (indexPath.row < self.dataSource.count) {
        viewController.title = [self.dataSource[indexPath.row] valueForKey:@"type"];
        viewController.consultType = [self.dataSource[indexPath.row] valueForKey:@"value"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

// 调用后台提醒接口
- (void)remind
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"remind"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        TERemindModel *remind = [[TERemindModel alloc] initWithDictionary:responseObject error:nil];
        _textConsultCount = remind.text;
        _phoneConsultCount = remind.phone;
        _referralConsultCount = remind.refer;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"---------%@", responseObject);
//        
//        
//        TERemindModel *remind = [[TERemindModel alloc] initWithDictionary:responseObject error:nil];
//        _textConsultCount = remind.text;
//        _phoneConsultCount = remind.phone;
//        _referralConsultCount = remind.refer;
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

@end
