//
//  TEConsultViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsultViewController.h"
#import "TEConsultCell.h"
#import "TEAppDelegate.h"
#import "TEConsult.h"
#import "UIView+TEBadgeVifew.h"
#import "TEHttpTools.h"

// 咨询类型
typedef NS_ENUM(NSInteger, TEConsultType) {
    TEConsultTypeText       = 0,  // 网络咨询
    TEConsultTypePhone      = 1,  // 电话咨询
    TEConsultTypeReferral   = 2,  // 线下咨询
};

@interface TEConsultViewController ()
@end

@implementation TEConsultViewController

#pragma mark - DataSource

- (void)loadDataSource {
    [self fetchAllConsult];
}

#pragma mark - UIViewController lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataSource removeAllObjects];
            [self loadDataSource];
        });
    };
    
    [reach startNotifier];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    TEConsultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TEConsultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    TEConsultModel *consult = [self.dataSource objectAtIndex:indexPath.row];
    cell.timeLabel.text = consult.orderTime;
    cell.doctorLabel.text = consult.expertName;
    cell.patientLabel.text = consult.patientName;
    
    if (consult.consultState == 0) {
        cell.stateLabel.text = @"待审核";
    } else if (consult.consultState == 1) {
        cell.stateLabel.text = @"已通过";
    } else if (consult.consultState == 2) {
        cell.stateLabel.text = @"等待咨询";
    } else if (consult.consultState == 3) {
        cell.stateLabel.text = @"已完成";
    } else if (consult.consultState == 4) {
        cell.stateLabel.text = @"已取消";
    } else if (consult.consultState == 5) {
        cell.stateLabel.text = @"爽约";
    } else if (consult.consultState == 7) {
        cell.stateLabel.text = @"退款申请中";
    } else if (consult.consultState == 8) {
        cell.stateLabel.text = @"退款已审核";
    } else if (consult.consultState == 9) {
        cell.stateLabel.text = @"已退款";
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.hidesBottomBarWhenPushed = YES;
    
    TEConsultModel *consultModel = self.dataSource[indexPath.row];
    if (consultModel.isPaySuccess == 1 || consultModel.consultState == 4) {
        UIViewController <TECompleteConsultDetailsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TECompleteConsultDetailsViewControllerProtocol)];
        if ([self.consultType isEqualToString:@"0"]) {
            viewController.TEConfirmConsultType = TEConfirmConsultOnline;
        } else if ([self.consultType isEqualToString:@"1"]) {
            viewController.TEConfirmConsultType = TEConfirmConsultPhone;
        } else {
            viewController.TEConfirmConsultType = TEConfirmConsultOffLine;
        }
        
        viewController.orderNumber = consultModel.orderNo;
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else {
        UIViewController <TEPaymentConsultDetailsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPaymentConsultDetailsViewControllerProtocol)];
        if ([self.consultType isEqualToString:@"0"]) {
            viewController.TEConfirmConsultType = TEConfirmConsultOnline;
        } else if ([self.consultType isEqualToString:@"1"]) {
            viewController.TEConfirmConsultType = TEConfirmConsultPhone;
        } else {
            viewController.TEConfirmConsultType = TEConfirmConsultOffLine;
        }
        
        viewController.orderNumber = consultModel.orderNo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
    }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


#pragma mark - API methods

// 获取咨询列表
- (void)fetchAllConsult
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult_list"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId, @"type": self.consultType};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEConsult *consult = [[TEConsult alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:consult.consults];
        
        if ([self.dataSource count] == 0) {
            self.titleForEmpty = [@"当前没有" stringByAppendingString:self.title];
        }
        
        [self.tableView reloadData];
        
        [hud hide:YES];
    } failure:^(NSError *error) {
       [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEConsult *consult = [[TEConsult alloc] initWithDictionary:responseObject error:nil];
//        [self.dataSource addObjectsFromArray:consult.consults];
//        
//        if ([self.dataSource count] == 0) {
//            self.titleForEmpty = [@"当前没有" stringByAppendingString:self.title];
//        }
//        
//        [self.tableView reloadData];
//        
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
//    }];
}

@end
