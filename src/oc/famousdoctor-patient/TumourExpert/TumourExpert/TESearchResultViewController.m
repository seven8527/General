//
//  TESearchResultViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESearchResultViewController.h"
#import "TEUITools.h"
#import "TEExpertCell.h"
#import "TEExpertModel.h"
#import "TEExpert.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SVPullToRefresh.h"
#import "UIImageView+NetLoading.h"
#import "TEHttpTools.h"

@interface TESearchResultViewController ()
@property (nonatomic, assign) NSInteger currentPage; // 当前是第几页
@property (nonatomic, assign) NSInteger totalPage; // 总页数
@property (nonatomic, assign) NSInteger number; // 每页显示几条记录
@end

@implementation TESearchResultViewController

#pragma mark - DataSource

- (void)loadDataSource {
    [self searchExpert];
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutUI];
    
    _number = 10;
    _currentPage = 0;
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataSource removeAllObjects];
            _currentPage = 0;
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

#pragma mark - UI

// UI布局
- (void)layoutUI
{
    //修复下拉刷新位置错误 代码开始
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    //修复下拉刷新位置错误  代码结束
    
    __weak TESearchResultViewController *weakSelf = self;
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (weakSelf.currentPage < weakSelf.totalPage) {
            [weakSelf addMoreRow];
        } else {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
    }];
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
    
    if (consultTotalCount != nil) {
        cell.consultCountLabel.text = [NSString stringWithFormat:@"咨询:%@",consultTotalCount];
    } else {
        cell.consultCountLabel.text = @"咨询:";
    }
    
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

// 加载更多
- (void)addMoreRow
{
    __weak TESearchResultViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self searchExpert];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

// 获取专家列表
- (void)searchExpert
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    
    NSString *URLString = @"";
    NSDictionary *parameters = nil;
    
    
    if ([self.searchType isEqualToString:@"all"]) {
        URLString = [kURL_ROOT stringByAppendingString:@"search"];
        parameters = @{@"keyword": self.keyword, @"start": [NSString stringWithFormat:@"%d", _currentPage * _number], @"end": [NSString stringWithFormat:@"%d", _number]};
    } else if ([self.searchType isEqualToString:@"disease"]) {
        URLString = [kURL_ROOT stringByAppendingString:@"app_search"];
        parameters = @{@"did": self.searchId, @"start": [NSString stringWithFormat:@"%d", _currentPage * _number], @"end": [NSString stringWithFormat:@"%d", _number]};
    } else if ([self.searchType isEqualToString:@"hospital"]) {
        URLString = [kURL_ROOT stringByAppendingString:@"app_search"];
        parameters = @{@"hid": self.searchId, @"start": [NSString stringWithFormat:@"%d", _currentPage * _number], @"end": [NSString stringWithFormat:@"%d", _number]};
    }
    
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEExpert *doctor = [[TEExpert alloc] initWithDictionary:responseObject error:nil];
        _totalPage = (doctor.total % _number == 0) ? doctor.total / _number : doctor.total / _number + 1;
        [self.dataSource addObjectsFromArray:doctor.experts];
        
        if ([self.dataSource count] == 0) {
            self.titleForEmpty = [@"当前没有" stringByAppendingString:self.title];
        }
        
        [self.tableView reloadData];
        _currentPage++;
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        [hud hide:YES];
    }];

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        TEExpert *doctor = [[TEExpert alloc] initWithDictionary:responseObject error:nil];
//        _totalPage = (doctor.total % _number == 0) ? doctor.total / _number : doctor.total / _number + 1;
//        [self.dataSource addObjectsFromArray:doctor.experts];
//        
//        if ([self.dataSource count] == 0) {
//            self.titleForEmpty = [@"当前没有" stringByAppendingString:self.title];
//        }
//        
//        [self.tableView reloadData];
//        _currentPage++;
//        
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", [operation responseString]);
//        [hud hide:YES];
//    }];
}



@end
