//
//  TEHealthArchiveDetailViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHealthArchiveDetailViewController.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEAppDelegate.h"
#import "TEPatient.h"
#import "TEPatientData.h"
#import "TEHealthArchiveDetail.h"
#import "TEHealthArchiveDataInfoModel.h"
#import "TEHttpTools.h"

@interface TEHealthArchiveDetailViewController ()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) TEHealthArchiveUserInfoModel *userInfo;
@end

@implementation TEHealthArchiveDetailViewController

#pragma mark - DataSource

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
        self.data = [[NSMutableArray alloc] initWithCapacity:1];
        self.userInfo = [[TEHealthArchiveUserInfoModel alloc] init];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentIndex = -1;
            [self.data removeAllObjects];
            [self fetchPatientData];
        });
    };
    
    [reach startNotifier];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"健康档案详情";
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    }
    
    return self.data.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        if (self.userInfo.patientName) {
            cell.textLabel.text = [self.userInfo.patientName stringByAppendingString:@"基本资料"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == [self.data count] - 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor colorWithHex:0x00947d];
            TEHealthArchiveDataInfoModel *patient = [self.data objectAtIndex:indexPath.row];
            cell.textLabel.text = patient.patientDataName;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor blackColor];
            TEHealthArchiveDataInfoModel *patient = [self.data objectAtIndex:indexPath.row];
            cell.textLabel.text = patient.patientDataName;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
    }

    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEEditPatientViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEEditPatientViewControllerProtocol)];
        viewController.patientId = self.patientId;
        if (self.userInfo.archiveNumber) {
            viewController.archiveNumber = [@"档案号:" stringByAppendingString:self.userInfo.archiveNumber];
        } else {
            viewController.archiveNumber = @"";
        }
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == [self.data count] - 1) {
            UIViewController <TEPatientBasicDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientBasicDataViewControllerProtocol)];
            viewController.patientId = self.patientId;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <TEPatientDataPreviewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientDataPreviewViewControllerProtocol)];
            TEHealthArchiveDataInfoModel *patient = [self.data objectAtIndex:indexPath.row];
            viewController.patientId = patient.patientId;
            viewController.patientDataId = patient.patientDataId;
            [self pushNewViewController:viewController];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
    return 50;
}
    
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.userInfo.archiveNumber) {
            return [@"档案号:" stringByAppendingString:self.userInfo.archiveNumber];
        } else {
            return @"";
        }
    }
    
    return @"";
}

#pragma mark - API methods

// 获取患者资料列表
- (void)fetchPatientData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"health_details"];
    NSDictionary *parameters = @{@"patient_id": self.patientId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"----%@", responseObject);
        
        TEHealthArchiveDetail *health = [[TEHealthArchiveDetail alloc] initWithDictionary:responseObject error:nil];
        self.userInfo = health.userInfo;
        [self.data addObjectsFromArray:health.datas];
        
        TEHealthArchiveDataInfoModel *patientModel = [[TEHealthArchiveDataInfoModel alloc] init];
        patientModel.patientDataId = @"-1";
        patientModel.patientDataName = @"新增记录";
        [self.data addObject:patientModel];
        
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
//        
//        TEHealthArchiveDetail *health = [[TEHealthArchiveDetail alloc] initWithDictionary:responseObject error:nil];
//        self.userInfo = health.userInfo;
//        [self.data addObjectsFromArray:health.datas];
//        
//        TEHealthArchiveDataInfoModel *patientModel = [[TEHealthArchiveDataInfoModel alloc] init];
//        patientModel.patientDataId = @"-1";
//        patientModel.patientDataName = @"新增记录";
//        [self.data addObject:patientModel];
//        
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
//    }];
}

@end
