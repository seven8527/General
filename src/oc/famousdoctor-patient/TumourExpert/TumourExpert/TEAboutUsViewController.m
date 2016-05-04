//
//  TEAboutUsViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAboutUsViewController.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEStoreManager.h"
#import "TEAboutAppView.h"
#import "TEVersionTools.h"

@interface TEAboutUsViewController ()
@property (nonatomic, strong) TEAboutAppView *aboutAppView;
@end

@implementation TEAboutUsViewController

#pragma mark - Propertys

- (TEAboutAppView *)aboutAppView
{
    if (!_aboutAppView) {
        _aboutAppView = [[TEAboutAppView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 149)];
    }
    
    return _aboutAppView;
}

#pragma mark - DataSource

- (void)loadDataSource
{
    self.dataSource = [[TEStoreManager sharedStoreManager] getAboutConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    self.tableView.tableHeaderView = self.aboutAppView;
    
    // 版权标签
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.text = @"华康云医 版权所有";
    copyrightLabel.font = [UIFont boldSystemFontOfSize:12];
    copyrightLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    CGSize copyrightSize = [copyrightLabel.text boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) font:[UIFont boldSystemFontOfSize:12]];
    copyrightLabel.frame = CGRectMake((kScreen_Width - copyrightSize.width) / 2, kScreen_Height - 105, copyrightSize.width, 21);
    [self.tableView addSubview:copyrightLabel];

    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
        cell.detailTextLabel.text = [self.dataSource[indexPath.row] valueForKey:@"value"];
        cell.detailTextLabel.textColor = [UIColor colorWithHex:0xe47929];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self actionSheetCall];
    } else if (indexPath.row == 1) {
        [self pushFeedback];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006118221"]];
        }
    }
}

#pragma mark - ActionSheet

// 拨打客服电话
- (void)actionSheetCall
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话：4006-118-221"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles:@"确定", nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 1;
}

/**
 *  进入反馈意见页面
 */
- (void)pushFeedback
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEFeedbackViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEFeedbackViewControllerProtocol)];
    [self pushNewViewController:viewController];
}


@end
