//
//  TEExpertColumnViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertColumnViewController.h"
#import "TEExpertColumn.h"
#import "SVPullToRefresh.h"
#import "TEHttpTools.h"

@interface TEExpertColumnViewController ()
@property (nonatomic, assign) NSInteger currentPage; // 当前是第几页
@property (nonatomic, assign) NSInteger totalPage; // 总页数
@property (nonatomic, assign) NSInteger number; // 每页显示几条记录
@end

@implementation TEExpertColumnViewController

#pragma mark - DataSource

- (void)loadDataSource {
    [self fetchExpertColumn];
}

#pragma mark - UIViewController lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutUI];
    
    self.title = @"专家专栏";
    
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
    
    __weak TEExpertColumnViewController *weakSelf = self;
    
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    TEExpertArticleModel *article = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = article.title;
    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEExpertArticleViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertArticleViewControllerProtocol)];
    viewController.articleId = [(TEExpertArticleModel *)[self.dataSource objectAtIndex:indexPath.row] articleId];
    [self pushNewViewController:viewController];
}

// 加载更多
- (void)addMoreRow
{
    __weak TEExpertColumnViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self fetchExpertColumn];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}


#pragma mark - API methods

// 获取专家专栏里的文章列表
- (void)fetchExpertColumn
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"special"];
    NSDictionary *parameters = @{@"doctorid": self.expertId, @"start": [NSString stringWithFormat:@"%d", _currentPage * _number], @"end": [NSString stringWithFormat:@"%d", _number]};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEExpertColumn *expertColumn = [[TEExpertColumn alloc] initWithDictionary:responseObject error:nil];
        _totalPage = (expertColumn.total % _number == 0) ? expertColumn.total / _number : expertColumn.total / _number + 1;
        [self.dataSource addObjectsFromArray:expertColumn.articles];
        
        if ([self.dataSource count] == 0) {
            self.titleForEmpty = [@"当前没有" stringByAppendingString:self.title];
        }
        
        [self.tableView reloadData];
        _currentPage++;
        
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
//
//        TEExpertColumn *expertColumn = [[TEExpertColumn alloc] initWithDictionary:responseObject error:nil];
//        _totalPage = (expertColumn.total % _number == 0) ? expertColumn.total / _number : expertColumn.total / _number + 1;
//        [self.dataSource addObjectsFromArray:expertColumn.articles];
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
