//
//  TEHomeHealthInfoListViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeHealthInfoListViewController.h"
#import "TEHomeHealthInfo.h"
#import "TEInformationAndColumnCell.h"
#import "SVPullToRefresh.h"
#import "TEHttpTools.h"

@interface TEHomeHealthInfoListViewController ()
@property (nonatomic, assign) NSInteger currentPage; // 当前是第几页
@property (nonatomic, assign) NSInteger totalPage; // 总页数
@property (nonatomic, assign) NSInteger number; // 每页显示几条记录
@end

@implementation TEHomeHealthInfoListViewController

#pragma mark - DataSource

- (void)loadDataSource {
    [self fetchHealthInfo];
}

#pragma mark - UIViewController lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutUI];
    
    self.title = @"健康资讯";
    
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
    
    __weak TEHomeHealthInfoListViewController *weakSelf = self;
    
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
    
    TEInformationAndColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TEInformationAndColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.picImageView.image = [UIImage imageNamed:@"hone_icon_message_default"];
    TEHomeHealthInfoModel *healthInfo = [self.dataSource objectAtIndex:indexPath.row];
    cell.titleLable.text = healthInfo.healthName;
    
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEHealthInfoViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEHealthInfoViewControllerProtocol)];
    viewController.healthInfoId = [(TEHomeHealthInfoModel *)[self.dataSource objectAtIndex:indexPath.row] healthInfoId];
    [self pushNewViewController:viewController];
}

// 加载更多
- (void)addMoreRow
{
    __weak TEHomeHealthInfoListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchHealthInfo];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}


#pragma mark - API methods

// 获取健康资讯的列表
- (void)fetchHealthInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"article/health_article"];
    NSDictionary *parameters = @{@"start": [NSString stringWithFormat:@"%d", _currentPage * _number], @"end": [NSString stringWithFormat:@"%d", _number]};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEHomeHealthInfo *healthInfo = [[TEHomeHealthInfo alloc] initWithDictionary:responseObject error:nil];
        _totalPage = (healthInfo.count % _number == 0) ? healthInfo.count / _number : healthInfo.count / _number + 1;
        [self.dataSource addObjectsFromArray:healthInfo.healthInfos];
        
        if ([self.dataSource count] == 0) {
            self.titleForEmpty = [@"当前没有" stringByAppendingString:self.title];
        }
        
        [self.tableView reloadData];
        _currentPage++;
        
        [hud hide:YES];

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        TEHomeHealthInfo *healthInfo = [[TEHomeHealthInfo alloc] initWithDictionary:responseObject error:nil];
//        _totalPage = (healthInfo.count % _number == 0) ? healthInfo.count / _number : healthInfo.count / _number + 1;
//        [self.dataSource addObjectsFromArray:healthInfo.healthInfos];
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
//        NSLog(@"Error: %@", error);
//        [hud hide:YES];
//    }];
}

@end
