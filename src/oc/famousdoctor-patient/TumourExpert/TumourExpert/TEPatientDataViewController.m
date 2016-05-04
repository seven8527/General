//
//  TEPatientDataViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientDataViewController.h"
#import "TEPatientData.h"
#import "TEHttpTools.h"

// 审核状态
typedef NS_ENUM(NSInteger, TEAuditState) {
    TEAuditStateNotAudit         = 0,  // 未审核
    TEAuditStateAuditing         = 1,  // 审核中
    TEAuditStateAuditApproved    = 2,  // 审核通过
};

@interface TEPatientDataViewController ()
@end

@implementation TEPatientDataViewController

#pragma mark - DataSource

- (void)loadDataSource {
    [self fetchPatientData];
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
    
    self.title = @"患者资料";
    
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

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    TEPatientDataModel *patientData = [self.dataSource objectAtIndex:indexPath.row];
    if ([patientData.patientDataName length] > 15) {
        cell.textLabel.text = [patientData.patientDataName substringToIndex:15];
    } else {
        cell.textLabel.text = patientData.patientDataName;
    }

    if (patientData.auditState == TEAuditStateNotAudit) {
        cell.detailTextLabel.text = @"未审核";
    } else if (patientData.auditState == TEAuditStateAuditing) {
        cell.detailTextLabel.text = @"正在审核";
    } else if (patientData.auditState == TEAuditStateAuditApproved) {
        cell.detailTextLabel.text = @"审核通过";
    }

    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TEPatientDataModel *patientData = [self.dataSource objectAtIndex:indexPath.row];
    if (patientData.billno && ![patientData.billno isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"资料已提交给专家" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEPatientDataPreviewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientDataPreviewViewControllerProtocol)];
        viewController.patientId = self.patientId;
        
        viewController.patientDataId = patientData.patientDataId;
        [self pushNewViewController:viewController];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - API methods

// 获取患者资料列表
- (void)fetchPatientData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/means"];
    NSDictionary *parameters = @{@"patientid": self.patientId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"----%@", responseObject);
        TEPatientData *patient = [[TEPatientData alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:patient.patientDatas];
        
        if ([self.dataSource count] == 0) {
            self.titleForEmpty = @"当前没有患者资料";
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
//        NSLog(@"----%@", responseObject);
//        TEPatientData *patient = [[TEPatientData alloc] initWithDictionary:responseObject error:nil];
//        [self.dataSource addObjectsFromArray:patient.patientDatas];
//        
//        if ([self.dataSource count] == 0) {
//            self.titleForEmpty = @"当前没有患者资料";
//        }
//
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
//    }];
}

@end
