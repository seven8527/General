//
//  TEPatientViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientViewController.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEAppDelegate.h"
#import "TEPatient.h"
#import "TEHttpTools.h"

@interface TEPatientViewController ()
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation TEPatientViewController

#pragma mark - DataSource

- (void)loadDataSource {
    [self fetchPatient];
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
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentIndex = -1;
            [self.dataSource removeAllObjects];
            [self loadDataSource];
        });
    };
    
    [reach startNotifier];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"健康档案";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }

    if (indexPath.row == [self.dataSource count] - 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor colorWithHex:0x00947d];
        TEPatientModel *patient = [self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = patient.patientName;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        TEPatientModel *patient = [self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = patient.patientName;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApplicationDelegate.addPatientProtal = TEAddPatientPotalPersonal;
    if (indexPath.row == [self.dataSource count] - 1) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEAddPatientViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEAddPatientViewControllerProtocol)];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEHealthArchiveDetailViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEHealthArchiveDetailViewControllerProtocol)];
        TEPatientModel *patient = [self.dataSource objectAtIndex:indexPath.row];
        viewController.patientId = patient.patientId;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - API methods

// 获取所有患者
- (void)fetchPatient
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/patient"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEPatient *patient = [[TEPatient alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:patient.patients];
        
        TEPatientModel *patientModel = [[TEPatientModel alloc] init];
        patientModel.patientId = @"-1";
        patientModel.patientName = @"新建健康档案";
        [self.dataSource addObject:patientModel];
        
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
//        TEPatient *patient = [[TEPatient alloc] initWithDictionary:responseObject error:nil];
//        [self.dataSource addObjectsFromArray:patient.patients];
//        
//        TEPatientModel *patientModel = [[TEPatientModel alloc] init];
//        patientModel.patientId = @"-1";
//        patientModel.patientName = @"新建健康档案";
//        [self.dataSource addObject:patientModel];
//        
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
//    }];
}

@end
