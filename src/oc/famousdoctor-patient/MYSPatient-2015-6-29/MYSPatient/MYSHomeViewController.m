//
//  MYSHomeViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHomeViewController.h"
#import "UIColor+Hex.h"
#import "UASearchBar.h"
#import "AppDelegate.h"
#import "MYSHomeCell.h"
#import "MYSStoreManager.h"
#import "HttpTool.h"
#import "MYSHomeFocusPictureModel.h"
#import "CycleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HealthInformationViewController.h"
#import "FreeConsultationViewController.h"

#define homePicCollectionHeight 190

@interface MYSHomeViewController () <UASearchBarDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIScrollView *backScrollView;
//@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, weak) UIView *bottomView;
//@property (nonatomic, weak) UIImageView *logoImageView;
//@property (nonatomic, weak) UASearchBar *searchView;
@property (nonatomic, weak) UIButton *expertGroupButton; // 名医圈
@property (nonatomic, weak) UILabel *expertGroupTipLabel; // 精准咨询
@property (nonatomic, weak) UIButton *directorGroupButton; // 疾病大全
@property (nonatomic, weak) UILabel *directorTipGroupLabel; // 免费咨询
@property (nonatomic, weak) UIButton *healthArchivesButton; // 健康档案
@property (nonatomic, weak) UIButton *searchButton; // 主任医师团
@property (nonatomic, weak) UIImageView *verticalLine; // 横线
@property (nonatomic, weak) UIImageView *horizontalLine; // 竖线
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) CycleScrollView *mainScorllView;
@end

@implementation MYSHomeViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

- (void)loadDataSource
{
    self.dataSource = [[MYSStoreManager sharedStoreManager] getHomeConfigureAray];
}

- (NSMutableArray *)picArray
{
    if (_picArray == nil) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
     [self.mainScorllView resumeTimer];
    
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.backScrollView.contentSize = CGSizeMake(kScreen_Width, CGRectGetMaxY(self.searchButton.frame) + 30  + 44);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
     [self.mainScorllView pauseTimer];
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    [self fetchHomeData];
    
    [self loadDataSource];
    
    // 滚动界面
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    backScrollView.scrollEnabled = YES;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.backgroundColor = [UIColor whiteColor];
    self.backScrollView = backScrollView;
    [self.view addSubview:backScrollView];

//    // logo界面
//    UIImageView *logoImageView = [UIImageView newAutoLayoutView];
//    logoImageView.backgroundColor = [UIColor redColor];
//    self.logoImageView = logoImageView;
//    logoImageView.userInteractionEnabled = YES;
//    if (iPhone6Plus) {
//        logoImageView.image = [UIImage imageNamed:@"home_bg_1242"];
//    } else if (iPhone6) {
//         logoImageView.image = [UIImage imageNamed:@"home_bg_750"];
//    } else {
//         logoImageView.image = [UIImage imageNamed:@"home_bg_640"];
//    }
//    [self.backScrollView addSubview:logoImageView];
//    
//    
//    // 搜索框
//     CGFloat topMargin = 0.0; // 搜索框距离顶部距离
//    
//    CGFloat tableviewToSearchMargin = 0.0; // tableView 距离searcH
//    
//    if (iPhone6Plus) {
//        topMargin = 780/3 + 20;
//        tableviewToSearchMargin = 162/3;
//    } else if (iPhone6) {
//        topMargin = 484/2 + 20;
//        tableviewToSearchMargin = 80/2;
//    } else {
//        topMargin = 394/2 ;
//        tableviewToSearchMargin = 76/2;
//    }
//    
//    UASearchBar *searchView = [[UASearchBar alloc] initWithFrame:CGRectMake(57/2, topMargin, self.view.frame.size.width - 57, 33)];
//    searchView.delegate = self;
//    searchView.backgroundColor = [UIColor clearColor];
//    searchView.placeHolder = @"搜索医生/疾病";
//    [searchView setSearchIcon:@"home_search"];
//    searchView.delegate = (id)self;
//    self.searchView = searchView;
//    [self.logoImageView addSubview:searchView];
    
//    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame) + tableviewToSearchMargin, kScreen_Width, kScreen_Height - 210) style:UITableViewStylePlain];
//    mainTableView.dataSource = self;
//    mainTableView.delegate = self;
//    mainTableView.scrollEnabled = NO;
//    self.mainTableView = mainTableView;
//    [self.view addSubview:mainTableView];
//    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat focuImageHeight;
    if (iPhone6Plus) {
        focuImageHeight = 209;
    } else if (iPhone6) {
        focuImageHeight = 190;
    } else {
        focuImageHeight = 161;
    }
    
    // 焦点图
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, focuImageHeight) animationDuration:3.0];
    [self.backScrollView addSubview:self.mainScorllView];
    
    UIView *bottomView = [UIView newAutoLayoutView];
    self.bottomView = bottomView;
    [self.backScrollView  addSubview:bottomView];
    
    
    //名医汇
    UIButton *expertGroupButton = [UIButton newAutoLayoutView];
    expertGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    expertGroupButton.backgroundColor = [UIColor whiteColor];
    [expertGroupButton setTitleColor:[UIColor colorFromHexRGB:K333333Color] forState:UIControlStateNormal];
    [expertGroupButton setTitle:@"名医汇" forState:UIControlStateNormal];
    [expertGroupButton setImage:[UIImage imageNamed:@"home_icon1_"]forState:UIControlStateNormal];
//    expertGroupButton.layer.cornerRadius = 5;
    [expertGroupButton addTarget:self action:@selector(clickExpertGroupButton) forControlEvents:UIControlEventTouchUpInside];
    self.expertGroupButton = expertGroupButton;
    [self.backScrollView addSubview:expertGroupButton];
    
    
    // 名医汇——精准咨询
    UILabel *expertGroupTipLabel = [UILabel newAutoLayoutView];
    expertGroupTipLabel.backgroundColor = [UIColor clearColor];
    expertGroupTipLabel.text = @"精准咨询";
    expertGroupTipLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    expertGroupTipLabel.textAlignment = NSTextAlignmentCenter;
    self.expertGroupTipLabel = expertGroupTipLabel;
    [expertGroupButton addSubview:expertGroupTipLabel];
    
    
    
    // 主任医师团
    UIButton *directorGroupButton = [UIButton newAutoLayoutView];
    directorGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;
     directorGroupButton.backgroundColor = [UIColor whiteColor];
    [directorGroupButton setTitleColor:[UIColor colorFromHexRGB:K333333Color] forState:UIControlStateNormal];
    [directorGroupButton setTitle:@"主任医师团" forState:UIControlStateNormal];
    [directorGroupButton setImage:[UIImage imageNamed:@"home_icon2_"]forState:UIControlStateNormal];
    [directorGroupButton addTarget:self action:@selector(clickDirectorGroupButton) forControlEvents:UIControlEventTouchUpInside];
//    directorGroupButton.layer.cornerRadius = 5;
    self.directorGroupButton = directorGroupButton;
    [self.backScrollView addSubview:directorGroupButton];
    
    // 主任医师团——免费咨询
    UILabel *directorTipGroupLabel = [UILabel newAutoLayoutView];
    directorTipGroupLabel.backgroundColor = [UIColor clearColor];
    directorTipGroupLabel.text = @"免费咨询";
    directorTipGroupLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    directorTipGroupLabel.textAlignment = NSTextAlignmentCenter;
    self.directorTipGroupLabel = directorTipGroupLabel;
    [directorGroupButton addSubview:directorTipGroupLabel];
    
    
    // 400健康助理
    UIButton *healthArchivesButton = [UIButton newAutoLayoutView];
    healthArchivesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    healthArchivesButton.backgroundColor = [UIColor colorFromHexRGB:K398CCCColor];
     healthArchivesButton.backgroundColor = [UIColor whiteColor];
    [healthArchivesButton setTitleColor:[UIColor  colorFromHexRGB:K333333Color] forState:UIControlStateNormal];
    [healthArchivesButton setTitle:@"健康资讯" forState:UIControlStateNormal];
    [healthArchivesButton setImage:[UIImage imageNamed:@"home_health_info"]forState:UIControlStateNormal];
//    [healthArchivesButton addTarget:self action:@selector(clickHealthArchivesButton) forControlEvents:UIControlEventTouchUpInside];
    [healthArchivesButton addTarget:self action:@selector(clickHealthInfomationButton) forControlEvents:UIControlEventTouchUpInside];
//    healthArchivesButton.layer.cornerRadius = 5;
    self.healthArchivesButton = healthArchivesButton;
    [self.backScrollView addSubview:healthArchivesButton];
    
    // 搜索
    UIButton *searchButton = [UIButton newAutoLayoutView];
    searchButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton setTitleColor:[UIColor  colorFromHexRGB:K333333Color] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"home_icon4_"]forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(clickSearchButton) forControlEvents:UIControlEventTouchUpInside];
//    searchButton.layer.cornerRadius = 5;
    
    
    // 竖线
    UIImageView *verticalLine = [UIImageView newAutoLayoutView];
    [self.backScrollView addSubview:verticalLine];
    verticalLine.image = [[UIImage imageNamed:@"home_line_vertical_"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    self.verticalLine = verticalLine;
    
    
    // 横线
    UIImageView *horizontalLine = [UIImageView newAutoLayoutView];
    [self.backScrollView addSubview:horizontalLine];
    horizontalLine.image = [[UIImage imageNamed:@"home_line_crosswise_"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    self.horizontalLine = horizontalLine;
    
    
    if(iPhone6Plus) {
        expertGroupButton.titleLabel.font = [UIFont systemFontOfSize:18];
        expertGroupTipLabel.font = [UIFont systemFontOfSize:14];
        directorGroupButton.titleLabel.font = [UIFont systemFontOfSize:18];
        directorTipGroupLabel.font = [UIFont systemFontOfSize:14];
        healthArchivesButton.titleLabel.font = [UIFont systemFontOfSize:18];
        searchButton.titleLabel.font = [UIFont systemFontOfSize:18];
    } else{
        expertGroupButton.titleLabel.font = [UIFont systemFontOfSize:14];
        expertGroupTipLabel.font = [UIFont systemFontOfSize:13];
        directorGroupButton.titleLabel.font = [UIFont systemFontOfSize:14];
        directorTipGroupLabel.font = [UIFont systemFontOfSize:13];
        healthArchivesButton.titleLabel.font = [UIFont systemFontOfSize:14];
        searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    self.searchButton = searchButton;
    [self.backScrollView addSubview:searchButton];
    
//
    // 更新约束
    [self.backScrollView setNeedsUpdateConstraints];
    
}

-(void)tap {
    LOG(@"tap a button");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"hello" message:@"willingseal" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alertView show];
    
}


- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        // logo及头部背景
//        [self.logoImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
//        [self.logoImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
//        [self.logoImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
//        if (iPhone6Plus) {
//            [self.logoImageView autoSetDimension:ALDimensionHeight toSize:(1044/3)];
//        } else if (iPhone6) {
//            [self.logoImageView autoSetDimension:ALDimensionHeight toSize:(630/2)];
//        } else {
//           [self.logoImageView autoSetDimension:ALDimensionHeight toSize:(534/2)];
//        }
//
//        
//        [self.logoImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        // 名医圈
        [self.expertGroupButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:1];
        [self.expertGroupButton autoSetDimension:ALDimensionWidth toSize:kScreen_Width/2];
        if (iPhone6Plus) {
            [self.expertGroupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mainScorllView withOffset:56/3];
            [self.expertGroupButton autoSetDimension:ALDimensionHeight toSize:600/3];
            [self.expertGroupButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(87/3, (([UIScreen mainScreen].bounds.size.width)/2 - 196/3)/2, 600/3 - 196/3 - 87/3 , (([UIScreen mainScreen].bounds.size.width)/2 - 196/3)/2)];
            [self.expertGroupButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.expertGroupButton.imageView.frame) + 68/3, 0, 208/3, 0)];
            [self.horizontalLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.expertGroupButton withOffset:58/3];
            [self.horizontalLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.searchButton withOffset:-58/3];
        } else if (iPhone6) {
            [self.expertGroupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mainScorllView withOffset:60/2];
            [self.expertGroupButton autoSetDimension:ALDimensionHeight toSize:349/2];
            [self.expertGroupButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(72/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2, 349/2 - 72/2 - 101/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2)];
            [self.expertGroupButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.expertGroupButton.imageView.frame) + 35/2, 0, 120/2, 0)];
            [self.horizontalLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.expertGroupButton withOffset:44/2];
            [self.horizontalLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.searchButton withOffset:-44/2];
        } else {
            [self.expertGroupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mainScorllView withOffset:40/2];
            [self.expertGroupButton autoSetDimension:ALDimensionHeight toSize:290/2];
            [self.expertGroupButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(40/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2, 290/2 - 101/2 - 40/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2)];
            [self.expertGroupButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.expertGroupButton.imageView.frame) + 28/2, 0, 92/2, 0)];
            [self.horizontalLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.expertGroupButton withOffset:30/2];
            [self.horizontalLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.searchButton withOffset:-30/2];
        }
        
        
        
        // 主任医师团
        
        [self.directorGroupButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.expertGroupButton withOffset:1];
//        [self.directorGroupButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-30];
        [self.directorGroupButton autoSetDimension:ALDimensionWidth toSize:kScreen_Width/2];
        if (iPhone6Plus) {
            [self.directorGroupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mainScorllView withOffset:56/3];
            [self.directorGroupButton autoSetDimension:ALDimensionHeight toSize:600/3];
            [self.directorGroupButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(87/3, (([UIScreen mainScreen].bounds.size.width)/2 - 196/3)/2, 600/3 - 196/3 - 87/3 , (([UIScreen mainScreen].bounds.size.width)/2 - 196/3)/2)];
            [self.directorGroupButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.directorGroupButton.imageView.frame) + 68/3, 0, 208/3, 0)];
            
        } else if (iPhone6) {
            
            [self.directorGroupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mainScorllView withOffset:60/2];
            [self.directorGroupButton autoSetDimension:ALDimensionHeight toSize:349/2];
            [self.directorGroupButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(72/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2, 349/2 - 72/2 - 101/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2)];
            [self.directorGroupButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.directorGroupButton.imageView.frame) + 35/2, 0, 120/2, 0)];
        } else {
            [self.directorGroupButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mainScorllView withOffset:40/2];
            [self.directorGroupButton autoSetDimension:ALDimensionHeight toSize:290/2];
            [self.directorGroupButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(40/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2, 290/2 - 101/2 - 40/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2)];
            [self.directorGroupButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.directorGroupButton.imageView.frame) + 28/2, 0, 92/2, 0)];
        }
        
        
        // 400健康助手
        [self.healthArchivesButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:1];
        [self.healthArchivesButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.expertGroupButton withOffset:1];
        [self.healthArchivesButton autoSetDimension:ALDimensionWidth toSize:kScreen_Width/2];
        
        if (iPhone6Plus) {
            [self.healthArchivesButton autoSetDimension:ALDimensionHeight toSize:490/3];
            [self.healthArchivesButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(108/3, (([UIScreen mainScreen].bounds.size.width)/2 - 196/3)/2, 490/3 - 196/3 - 108/3 , (([UIScreen mainScreen].bounds.size.width)/2 - 196/3)/2)];
            [self.healthArchivesButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.healthArchivesButton.imageView.frame) + 65/3, 0, 73/3, 0)];
            
        } else if (iPhone6) {
            [self.healthArchivesButton autoSetDimension:ALDimensionHeight toSize:262/2];
            [self.healthArchivesButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(72/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2, 262/2 - 101/2 - 72/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2)];
            [self.healthArchivesButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.healthArchivesButton.imageView.frame) + 35/2, 0, 32/2, 0)];
        } else {
            [self.healthArchivesButton autoSetDimension:ALDimensionHeight toSize:221/2];
            [self.healthArchivesButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(40/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2, 221/2 - 101/2 - 40/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2)];
            [self.healthArchivesButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.healthArchivesButton.imageView.frame) + 28/2, 0, 22/2, 0)];
        }
        
        
        // 主任医师团
        
//        [self.searchButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.searchButton autoSetDimension:ALDimensionWidth toSize:kScreen_Width/2];
        [self.searchButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.directorGroupButton withOffset:1];
        [self.searchButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.healthArchivesButton withOffset:1];
        if (iPhone6Plus) {
            [self.searchButton autoSetDimension:ALDimensionHeight toSize:490/3];
            [self.searchButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(108/3, ((kScreen_Width)/2 - 196/3)/2, 490/3 - 196/3 - 108/3 , ((kScreen_Width)/2 - 196/3)/2)];
            [self.searchButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.searchButton.imageView.frame) + 65/3, 0, 73/3, 0)];
        } else if (iPhone6) {
            [self.searchButton autoSetDimension:ALDimensionHeight toSize:262/2];
            [self.searchButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(72/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2, 262/2 - 101/2 - 72/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2)];
            [self.searchButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.searchButton.imageView.frame) + 35/2, 0, 32/2, 0)];
        } else {
            [self.searchButton autoSetDimension:ALDimensionHeight toSize:221/2];
            [self.searchButton.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(40/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2, 221/2 - 101/2 - 40/2, (([UIScreen mainScreen].bounds.size.width)/2 - 101/2)/2)];
            [self.searchButton.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CGRectGetMaxY(self.searchButton.imageView.frame) + 28/2, 0, 22/2, 0)];
        }
        
        [self.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.expertGroupButton withOffset:0];
        [self.bottomView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.expertGroupButton withOffset:0];
        [self.bottomView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.directorGroupButton withOffset:0];
        [self.bottomView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.searchButton withOffset:0];

        
        [self.expertGroupTipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.expertGroupTipLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.expertGroupTipLabel autoSetDimension:ALDimensionHeight toSize:15];
        
        
        [self.directorTipGroupLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.directorTipGroupLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.directorTipGroupLabel autoSetDimension:ALDimensionHeight toSize:15];
        
        if(iPhone6Plus) {
            [self.expertGroupTipLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:106/3];
            [self.directorTipGroupLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:106/3];
        } else if (iPhone6) {
            [self.expertGroupTipLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:70/2];
            [self.directorTipGroupLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:70/2];
        } else {
            [self.expertGroupTipLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:41/2];
            [self.directorTipGroupLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:41/2];
        }
        
        [self.verticalLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.expertGroupButton withOffset:0];
        [self.verticalLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kScreen_Width/2];
        [self.verticalLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.healthArchivesButton withOffset:0];
        [self.verticalLine autoSetDimension:ALDimensionWidth toSize:1];
        
        
        [self.horizontalLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.expertGroupButton withOffset:0];
        [self.horizontalLine autoSetDimension:ALDimensionHeight toSize:1];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
    
}

#pragma mark UASearchBarDelegate

//- (void)searchBarTextDidBeginEditing:(UASearchBar *)searchBar
//{
//    [searchBar resignFirstResponder]; // 不让键盘弹出
//
//    UIViewController <MYSSearchViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSSearchViewControllerProtocol)];
////    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
////    [self presentViewController:nav animated:YES completion:nil];
//     self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewController animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//}

// 名医汇
- (void)clickExpertGroupButton
{
    UIViewController <MYSExpertGroupViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 主任医师团
- (void)clickDirectorGroupButton
{
    if (ApplicationDelegate.isLogin) {
        [self reflectDirectorGroup];
    } else {
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        loginViewController.source = NSClassFromString(@"MYSHomeViewController");
        loginViewController.aSelector = @selector(reflectDirectorGroup);
        loginViewController.instance = self;
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//        [self presentViewController:navController animated:YES completion:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }

}

// 跳转主任医师团
- (void)reflectDirectorGroup
{
    FreeConsultationViewController *freeCtrl = [[FreeConsultationViewController alloc] init];
    freeCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:freeCtrl animated:YES];
//    UIViewController <MYSDirectorGroupViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSDirectorGroupViewControllerProtocol)];
//    [self.navigationController pushViewController:viewController animated:YES];
}

// 搜索
- (void)clickSearchButton
{
    UIViewController <MYSSearchViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSSearchViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 疾病大全
- (void)clickdirectorGroupButton
{
    UIViewController <MYSDiseasesViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSDiseasesViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

// 健康助理
- (void)clickHealthArchivesButton
{
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"4006-118-221" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self callCustomerServiceHotlineWithTel:@"4006-118-221"];
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"4006-118-221" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        [alertView show];
    }
}

/**
 *  健康资讯按钮点击事件
 */
- (void)clickHealthInfomationButton
{
    HealthInformationViewController *healthInfoCtrl = [[HealthInformationViewController alloc] init];
    healthInfoCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:healthInfoCtrl animated:YES];
}

#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self callCustomerServiceHotlineWithTel:alertView.message];
    }
}

// 拨打客服专线
- (void)callCustomerServiceHotlineWithTel:(NSString *)tel
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (void)reflectHealthArchives
{
    UIViewController <MYSHealthRecordsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSHealthRecordsViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - API methods

- (void)fetchHomeDataA
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"active"];
    [HttpTool post:URLString params:nil success:^(id responseObject) {
        LOG(@"%@",responseObject);
        NSArray *tempPicArray = [responseObject objectForKey:@"message"];
        for (NSDictionary *pidDic in tempPicArray) {
            NSString *imagePath = [pidDic objectForKey:@"image_path"];
            NSString *url = [pidDic objectForKey:@"url"];
            LOG(@"%@       %@", imagePath, url);
        }
    } failure:^(NSError *error) {
        ;
    }];
}

// 获取首页数据
- (void)fetchHomeData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"active"];
    
    [HttpTool post:URLString params:nil success:^(id responseObject) {
        LOG(@"%@",responseObject);
        NSArray *tempPicArray = [responseObject objectForKey:@"message"];
        
        for (NSDictionary *picDic in tempPicArray) {
            MYSHomeFocusPictureModel *focusPicModel = [[MYSHomeFocusPictureModel alloc] initWithDictionary:picDic error:nil];
            [self.picArray addObject:focusPicModel];
        }
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

            __weak MYSHomeViewController *mySelf = self;
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                LOG(@"点击了第%ld个",(long)pageIndex);

                mySelf.hidesBottomBarWhenPushed = YES;
                UIViewController <MYSBannerViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSBannerViewControllerProtocol)];
                if (blockPicArray.count > 2) {
                    viewController.contentUrl = [blockPicArray[pageIndex] contentUrl];
                } else if(blockPicArray.count == 2) {
                    viewController.contentUrl = [blockPicArray[pageIndex % 2] contentUrl];
                } else {
                    viewController.contentUrl = [blockPicArray[0] contentUrl];
                }
                LOG(@"%lu",(unsigned long)viewController.contentUrl.length);
                if(viewController.contentUrl.length > 0){
                    [mySelf.navigationController pushViewController:viewController animated:YES];
                    mySelf.hidesBottomBarWhenPushed = NO;
                }
            };
        }

        
        
    } failure:^(NSError *error) {
        
    }];
}


//  根据图片的数量选择图片轮播的显示
- (NSMutableArray *)pageScrollViewArrayWithArray:(NSArray *)picArray
{
    NSMutableArray *viewsArray = [@[] mutableCopy];
    if (picArray.count > 2) {
        for (int i = 0; i < picArray.count; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, homePicCollectionHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[picArray[i] picUrl]] placeholderImage:nil];
            [viewsArray addObject:imageView];
        }
    } else if (picArray.count == 2) {
        for (int i = 0; i < self.picArray.count * 2 ; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, homePicCollectionHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[picArray[i % 2] picUrl]] placeholderImage:nil];
            [viewsArray addObject:imageView];
        }
    } else {
        for (int i = 0; i < picArray.count * 4; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, homePicCollectionHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[picArray[0] picUrl]] placeholderImage:nil];
            [viewsArray addObject:imageView];
        }
        
    }
    
    return  viewsArray;
}

@end
