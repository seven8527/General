//
//  TEChoosePatientDataViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEChoosePatientDataViewController.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEAppDelegate.h"
#import "TEPatientData.h"
#import "TEHttpTools.h"

@interface TEChoosePatientDataViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *patientDatas;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation TEChoosePatientDataViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_patientDatas removeAllObjects];
            [self fetchPatientData];
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

- (void) viewDidLoad
{
    _patientDatas = [NSMutableArray array];
    
    self.currentIndex = -1;
    
    [self configUI];
    
    [self layoutUI];
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"选择患者资料";
}

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.patientDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    if (indexPath.row == self.currentIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == [self.patientDatas count] - 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor colorWithHex:0x00947d];
        cell.textLabel.text = @"添加患者资料";
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        TEPatientDataModel *patientData = [self.patientDatas objectAtIndex:indexPath.row];
        cell.textLabel.text = patientData.patientDataName;
    }
    
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.patientDatas count] - 1) {
        ApplicationDelegate.patientDataProtal = TEPatientDataPortalConsult;
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEPatientBasicDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientBasicDataViewControllerProtocol)];
        viewController.patientId = self.patientId;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        if (indexPath.row == self.currentIndex) {
            return;
        }
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        UITableViewCell *newCell = [aTableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone) {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        UITableViewCell *oldCell = [aTableView cellForRowAtIndexPath:oldIndexPath];
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.currentIndex = indexPath.row;
        
        TEPatientDataModel *patient = [self.patientDatas objectAtIndex:indexPath.row];
        [self.delegate didSelectedPatientDataId:patient.patientDataId patientDataName:patient.patientDataName];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - API methods

// 获取患者资料列表
- (void)fetchPatientData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";

    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/choose_means"];
    NSDictionary *parameters = @{@"patientid": self.patientId, @"type": self.consultType};
    
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"----%@", responseObject);
        TEPatientData *patient = [[TEPatientData alloc] initWithDictionary:responseObject error:nil];
        [_patientDatas addObjectsFromArray:patient.patientDatas];
        [_patientDatas addObject:@"添加患者资料"];
        
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
//        [_patientDatas addObjectsFromArray:patient.patientDatas];
//        [_patientDatas addObject:@"添加患者资料"];
//        
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
//    }];
}

@end
