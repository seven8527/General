//
//  TEHomeViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeViewController.h"
#import "TEExpertCell.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEHome.h"
#import "TEExpertModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <JDStatusBarNotification.h>
#import "TEHomePicCollectionViewCell.h"
#import "TEHomeNosologyCollectionViewCell.h"
#import "TEHomeSliderViewController.h"
#import "CycleScrollView.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "TEHomeSearchViewController.h"
#import "UIImageView+NetLoading.h"



#define homePicCollectionHeight 112

@interface TEHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate,TEHomeSearchViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *experts;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *nosologArray;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) NSMutableArray *healthInfoArray;
@property (nonatomic, strong) NSMutableArray *expertColumnArray;
@property (nonatomic, strong) CycleScrollView *mainScorllView;
@property (nonatomic, strong) UICollectionView *nosologCollectionView;
@property (nonatomic, strong) UIPageControl *picPageControl;
@property (nonatomic, assign) NSInteger currentItem;
@property (nonatomic, strong) TEHomeSliderViewController *sliderVC;
@property (nonatomic, copy) NSString *currentHomeSliderVCIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation TEHomeViewController

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        _experts = [NSMutableArray array];
        
        _picArray = [NSMutableArray array];
        
        _nosologArray = [NSMutableArray array];
        
        _healthInfoArray = [NSMutableArray array];
        
        _expertColumnArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expertChoose:) name:@"expertChoose" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(healthInfoChoose:) name:@"healthInfoChoose" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(articleChoose:) name:@"articleChoose" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeSliderChange:) name:@"homeSliderChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMore:) name:@"loadMore" object:nil];
    
    [super viewDidLoad];
    
    [self layoutUI];
    
    [self updateStyle];
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reachability.isReachableViaWWAN) {
                [JDStatusBarNotification showWithStatus:@"当前网络环境为非WiFi网络，建议您在WiFi网络下进行上传图片等操作。" dismissAfter:2.0 styleName:@"style"];
            }
            [_experts removeAllObjects];
            [_picArray removeAllObjects];
            [_nosologArray removeAllObjects];
            [_healthInfoArray removeAllObjects];
            [_expertColumnArray removeAllObjects];
            [self.sliderVC.view removeFromSuperview];
            [self fetchHomeData];
        });
    };
    
    [reach startNotifier];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mainScorllView resumeTimer];
    
}


- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.mainScorllView pauseTimer];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI

// UI布局
- (void)layoutUI
{
    self.scrollView  = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    
    // Create a search bar
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreen_Width, 44.0f)];
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 7.5f, 29.0f, 29.0f)];
    titleImageView.backgroundColor = [UIColor clearColor];
    titleImageView.image = [UIImage imageNamed:@"home_logo.png"];
    [titleView addSubview:titleImageView];
    
    // searchView
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(40.0f, 0.0f, kScreen_Width - 67.0f, 44.0f)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(search)];
    [searchView addGestureRecognizer:tap];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreen_Width - 67.0f, 44.0f)];
    searchBar.delegate = self;
    searchBar.userInteractionEnabled = NO;
    searchBar.placeholder = @"找医生，疾病，科室，医院";
    //    searchBar.tintColor = [UIColor clearColor];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar = searchBar;
    [searchView addSubview:searchBar];
    [titleView addSubview:searchView];
    self.navigationItem.titleView =titleView;
    
    
    // 焦点图
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, homePicCollectionHeight) animationDuration:3.0];
    [self.scrollView addSubview:self.mainScorllView];
    
    
    // 1.流水布局
    UICollectionViewFlowLayout *nosologyLayout = [[UICollectionViewFlowLayout alloc] init];
    nosologyLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 2.每个cell的尺寸
    nosologyLayout.itemSize = CGSizeMake(106, 106);
    // 3.设置cell之间的水平间距
    nosologyLayout.minimumInteritemSpacing = 0;
    // 4.设置cell之间的垂直间距
    nosologyLayout.minimumLineSpacing = 1;
    // 5.设置四周的内边距
    nosologyLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *nosologCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:nosologyLayout];
    nosologCollectionView.scrollEnabled = NO;
    nosologCollectionView.showsHorizontalScrollIndicator = NO;
    nosologCollectionView.backgroundColor = [UIColor clearColor];
    nosologCollectionView.delegate = self;
    nosologCollectionView.dataSource = self;
    [nosologCollectionView registerClass:[TEHomeNosologyCollectionViewCell class] forCellWithReuseIdentifier:@"nosology"];
    self.nosologCollectionView = nosologCollectionView;
    [self.scrollView addSubview:nosologCollectionView];
    
    
    
}



#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nosologArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TEHomeNosologyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nosology" forIndexPath:indexPath];
    if (_nosologArray.count > 0) {
        TEHomeDepartmentModel *departMentModel = self.nosologArray[indexPath.row];
        cell.title = departMentModel.departmentName;
        cell.picString = departMentModel.picUrl;
        cell.picSelectUrl = departMentModel.picSelectUrl;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.nosologCollectionView) {
        TEHomeDepartmentModel *departMentModel = self.nosologArray[indexPath.row];
        if (![departMentModel.depatmentId isEqualToString:@"-1"]) {
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <TEExpertOfDepartmentViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertOfDepartmentViewControllerProtocol)];
            TEHomeDepartmentModel *departmentModel = self.nosologArray[indexPath.row];
            viewController.title = departmentModel.departmentName;
            viewController.departmentId = departmentModel.depatmentId;
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
    }
    
}



- (void)search
{
    [self.mainScorllView pauseTimer];
    TEHomeSearchViewController *homeSearch = [[TEHomeSearchViewController alloc] init];
    homeSearch.delegate = self;
    homeSearch.view.frame = [UIScreen mainScreen].bounds;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeSearch];
    [self presentViewController:nav animated:NO completion:^{
    }];
}

#pragma mark - TEHomeSearchViewDelegate

- (void)homeSearchViewController:(TEHomeSearchViewController *)viewControler searchWithText:(NSString *)text
{
    self.keyword = text;
    self.hidesBottomBarWhenPushed = YES;
    
    UIViewController <TESearchResultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TESearchResultViewControllerProtocol)];
    viewController.title = @"搜索结果";
    viewController.keyword = self.keyword;
    viewController.searchType = @"all";
    viewController.searchId = @"";
    self.searchBar.text = @"";
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - API methods

// 获取首页数据
- (void)fetchHomeData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"amount"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        TEHomeSliderViewController *sliderVC = [[TEHomeSliderViewController alloc] init];
        self.sliderVC = sliderVC;
        [self.scrollView addSubview:sliderVC.view];
        
        TEHome *home = [[TEHome alloc] initWithDictionary:responseObject error:nil];
        [_nosologArray addObjectsFromArray:home.departments];
        [_experts addObjectsFromArray:home.experts];
        self.sliderVC.expers = _experts;
        self.nosologCollectionView.frame = CGRectMake(0, homePicCollectionHeight, self.view.frame.size.width, ((self.nosologArray.count - 1) / 3  + 1 )* 106 + 10);
        
        [_healthInfoArray addObjectsFromArray:home.healthInfos];
        self.sliderVC.healthInfos = _healthInfoArray;
        
        [_expertColumnArray addObjectsFromArray:home.expertColumns];
        
        self.sliderVC.expertColumns = _expertColumnArray;
        
        [_picArray addObjectsFromArray:home.focusPictures];
        
        [self.nosologCollectionView reloadData];
        
        
        if (self.picArray.count > 0) {
            
            // 根据图片数组个数 获得轮播图
            NSMutableArray *viewsArray = [self pageScrollViewArrayWithArray:self.picArray];
            
            self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return viewsArray[pageIndex];
            };
            
            __block NSArray *blockPicArray = self.picArray;
            self.mainScorllView.totalPagesCount = ^NSInteger(void){
                return blockPicArray.count;
            };
            
            __weak TEHomeViewController *mySelf = self;
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                NSLog(@"点击了第%d个",pageIndex);
                
                mySelf.hidesBottomBarWhenPushed = YES;
                UIViewController <TEHealthInfoViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEHealthInfoViewControllerProtocol)];
                if (blockPicArray.count > 2) {
                    viewController.healthInfoId = [blockPicArray[pageIndex] healthInfoID];
                } else if(blockPicArray.count == 2) {
                    viewController.healthInfoId = [blockPicArray[pageIndex % 2] healthInfoID];
                } else {
                    viewController.healthInfoId = [blockPicArray[0] healthInfoID];
                }
                
                [mySelf pushNewViewController:viewController];
                mySelf.hidesBottomBarWhenPushed = NO;
                
            };
        }

        self.sliderVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.nosologCollectionView.frame), kScreen_Width, 500);
        self.scrollView.contentSize = CGSizeMake(kScreen_Width, CGRectGetMaxY(self.nosologCollectionView.frame) + self.experts.count * 70 + 100);
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
    }];
}


//  根据图片的数量选择图片轮播的显示
- (NSMutableArray *)pageScrollViewArrayWithArray:(NSArray *)picArray
{
     NSMutableArray *viewsArray = [@[] mutableCopy];
        if (picArray.count > 2) {
            for (int i = 0; i < picArray.count; ++i) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, homePicCollectionHeight)];
                
                [imageView accordingToNetLoadImagewithUrlstr:[picArray[i] focusPicUrl] and:@"logo.png"];
                
                [viewsArray addObject:imageView];
            }
        } else if (picArray.count == 2) {
            for (int i = 0; i < self.picArray.count * 2 ; ++i) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, homePicCollectionHeight)];

                [imageView accordingToNetLoadImagewithUrlstr:[picArray[i % 2] focusPicUrl] and:@"logo.png"];
                
                [viewsArray addObject:imageView];
            }
        } else {
            for (int i = 0; i < picArray.count * 4; ++i) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, homePicCollectionHeight)];

                [imageView accordingToNetLoadImagewithUrlstr:[picArray[0] focusPicUrl] and:@"logo.png"];
                
                [viewsArray addObject:imageView];
            }
            
        }
    
    return  viewsArray;
}

#pragma mark - Bussiness methods

- (void)switchChange:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.tableView.tableHeaderView = self.searchBar;
    } else {
        self.tableView.tableHeaderView = nil;
    }
}


// 找专家
- (void)seekExpert:(id)sender
{
    self.tabBarController.selectedIndex = 1;
}


// 分诊医生
- (void)triage:(id)sender
{
    self.tabBarController.selectedIndex = 2;
}

// 更多专家
- (void)moreExpert:(id)sender
{
    self.tabBarController.selectedIndex = 1;
}


/**
 *  自定义状态栏通知的样式
 */
- (void)updateStyle
{
    [JDStatusBarNotification addStyleNamed:@"style" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        style.font = [UIFont systemFontOfSize:14];
        style.textColor = [UIColor whiteColor];
        style.barColor = [UIColor colorWithHex:0x666666 alpha:0.95];
        style.animationType = JDStatusBarAnimationTypeFade;
        
        return style;
    }];
}

// 接受推荐专家的通知
- (void)expertChoose:(NSNotification *)notification
{
    
    NSDictionary *infoDict = notification.userInfo;
    
    NSString *expertId = [infoDict objectForKey:@"expertId"];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEExpertDetailViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertDetailViewControllerProtocol)];
    viewController.expertId = expertId;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)healthInfoChoose:(NSNotification *)notification
{
    
    NSDictionary *infoDict = notification.userInfo;
    
    NSString *healthInfoId = [infoDict objectForKey:@"healthInfoId"];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEHealthInfoViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEHealthInfoViewControllerProtocol)];
    viewController.healthInfoId = healthInfoId;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)articleChoose:(NSNotification *)notification
{
    NSDictionary *infoDict = notification.userInfo;
    
    NSString *expertId = [infoDict objectForKey:@"articleId"];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEExpertArticleViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertArticleViewControllerProtocol)];
    viewController.articleId = expertId;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

/**
 *  slider切换通知
 *
 *  @param notification 通知
 */
- (void)homeSliderChange:(NSNotification *)notification
{
    NSDictionary *infoDict = notification.userInfo;
    
    NSString *index = [infoDict objectForKey:@"index"];
    
    
    self.currentHomeSliderVCIndex = index;
    
    if ([index isEqualToString:@"0"]) {
        self.scrollView.contentSize = CGSizeMake(kScreen_Width, CGRectGetMaxY(self.nosologCollectionView.frame) + self.experts.count * 70 + 100);
    } else if ([index isEqualToString:@"1"]) {
        self.scrollView.contentSize = CGSizeMake(kScreen_Width, CGRectGetMaxY(self.nosologCollectionView.frame) + self.healthInfoArray.count * 44 + 100);
    } else if ([index isEqualToString:@"2"]) {
        self.scrollView.contentSize = CGSizeMake(kScreen_Width, CGRectGetMaxY(self.nosologCollectionView.frame) + self.expertColumnArray.count * 44 + 100);
    }
    
    
}


/**
 *  点击加载更多
 *
 *  @param notification 通知
 */
- (void)loadMore:(NSNotification *)notification
{
    
    NSDictionary *infoDict = notification.userInfo;
    NSString *title = [infoDict objectForKey:@"homeslidertitle"];
    
    if ([title isEqualToString:@"推荐专家"]) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEHomeRecommendExpertListViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEHomeRecommendExpertListViewControllerProtocol)];
        viewController.title = title;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    } else if ([title isEqualToString:@"健康资讯"]) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEHomeHealthInfoListViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEHomeHealthInfoListViewControllerProtocol)];
        viewController.title = title;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    } else if ([title isEqualToString:@"专家专栏"]) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEHomeExpertColumnListViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEHomeExpertColumnListViewControllerProtocol)];
        viewController.title = title;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end
