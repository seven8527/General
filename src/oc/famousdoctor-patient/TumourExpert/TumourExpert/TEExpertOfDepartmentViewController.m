//
//  TEExpertOfDepartmentViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertOfDepartmentViewController.h"
#import "TEUITools.h"
#import "TEExpertCell.h"
#import "TEExpertModel.h"
#import "TEExpert.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+NetLoading.h"
#import "TEHttpTools.h"

@interface TEExpertOfDepartmentViewController ()
@end

@implementation TEExpertOfDepartmentViewController

#pragma mark - DataSource

- (void)loadDataSource {
    [self fetchExpertOfDepartment];
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    TEExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TEExpertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    TEExpertModel *expert = [self.dataSource objectAtIndex:indexPath.row];
    cell.doctorLabel.text = expert.expertName;
    cell.titleLabel.text = expert.expertTitle;
    cell.hospitalLabel.text = expert.hospitalName;
    cell.departmentLabel.text = expert.department;
    if (expert.area != nil) {
        cell.areaLabel.text = [NSString stringWithFormat:@"地区:%@",expert.area];
    } else {
        cell.areaLabel.text = @"地区:";
    }
    int total = [expert.onlineconsultCount intValue] + [expert.offlineconsultCount intValue] + [expert.phoneConsultCount intValue];
    NSString *consultTotalCount = [NSString stringWithFormat:@"%d人",total];
    cell.consultCountLabel.text = [NSString stringWithFormat:@"咨询:%@",consultTotalCount];

    [cell.iconImageView accordingToNetLoadImagewithUrlstr:expert.expertIcon and:@"logo.png"];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEExpertDetailViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertDetailViewControllerProtocol)];
    viewController.expertId = [(TEExpertModel *)[self.dataSource objectAtIndex:indexPath.row] expertId];
    [self pushNewViewController:viewController];
    self.hidesBottomBarWhenPushed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

#pragma mark - API methods

// 获取科室下的专家列表
- (void)fetchExpertOfDepartment
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"dempart_doctor_all"];
    NSDictionary *parameters = @{@"pnid": self.departmentId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEExpert *doctor = [[TEExpert alloc] initWithDictionary:responseObject error:nil];
        [self.dataSource addObjectsFromArray:doctor.experts];
        
        if ([self.dataSource count] == 0) {
            self.titleForEmpty = [NSString stringWithFormat:@"没有%@的专家", self.title];
        }
        
        [self.tableView reloadData];
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEExpert *doctor = [[TEExpert alloc] initWithDictionary:responseObject error:nil];
//        [self.dataSource addObjectsFromArray:doctor.experts];
//        
//        if ([self.dataSource count] == 0) {
//            self.titleForEmpty = [NSString stringWithFormat:@"没有%@的专家", self.title];
//        }
//        
//        [self.tableView reloadData];
//        
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [hud hide:YES];
//    }];
}

@end
