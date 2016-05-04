//
//  TEPersonalDataViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPersonalDataViewController.h"
#import "TEAppDelegate.h"
#import "TEUserModel.h"
#import "TEStoreManager.h"
#import "TEUITools.h"
#import "TEFoundationCommon.h"
#import "TERegisterCell.h"
#import "TEHttpTools.h"


@interface TEPersonalDataViewController ()
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) TEUserModel *userModel;

@end

@implementation TEPersonalDataViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[TEStoreManager sharedStoreManager] getPersonalDataConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchPersonalData];
        });
    };
    
    [reach startNotifier];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDataSource];
    
    [self configUI];
    
    [self layoutUI];
}


// UI设置
- (void)configUI
{
    self.title = @"基本资料";
}

// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editPersonalData:)];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 50;
            break;
        case 1:
            return 30;
            break;
        default:
            return 4;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.dataSource[indexPath.section][indexPath.row] valueForKey:@"title"];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = self.userModel.userName;
                break;
            case 1:
                cell.detailTextLabel.text = self.userModel.mobilephone;
                break;
            case 2:
                cell.detailTextLabel.text = self.userModel.email;
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = self.userModel.trueName;
                break;
            case 1:
                cell.detailTextLabel.text = self.userModel.gender;
                break;
            case 2:
                cell.detailTextLabel.text = self.userModel.birthday;
                break;
            case 3:
                cell.detailTextLabel.text = self.userModel.phone;
                break;
            case 4:
            {
                NSString *address = @"";
                if (self.userModel.province && ![self.userModel.province isEqualToString:@"0"]) {
                    address = [address stringByAppendingString:self.userModel.province];
                }
                if (self.userModel.city && ! [self.userModel.city isEqualToString:@"0"]) {
                    address = [address stringByAppendingString:self.userModel.city];
                }
                if (self.userModel.region && ! [self.userModel.region isEqualToString:@"0"]) {
                    address = [address stringByAppendingString:self.userModel.region];
                }
                cell.detailTextLabel.text = address;

                break;
            }
            case 5:
                cell.detailTextLabel.text = self.userModel.detailedAddress;
                break;
                
            default:
                break;
        }
        
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"账号资料";
    } else {
        return @"个人信息";
    }
}


#pragma mark - Bussiness methods

- (void)editPersonalData:(UIBarButtonItem *)sender
{
    ApplicationDelegate.patientDataProtal = TEPatientDataPortalPersonal;
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEEditPersonalDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEEditPersonalDataViewControllerProtocol)];
    viewController.userModel = self.userModel;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - API methods

// 获取个人资料
- (void)fetchPersonalData
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"center"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEUserModel *user = [[TEUserModel alloc] initWithDictionary:responseObject error:nil];
        self.userModel = user;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEUserModel *user = [[TEUserModel alloc] initWithDictionary:responseObject error:nil];
//        self.userModel = user;
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

@end
