//
//  MYSExpertGroupDynamicViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDynamicViewController.h"
#import "MYSExpertGroupDynamicFrame.h"
#import "MYSExpertGroupDynamicCell.h"
#import "MYSDoctorHome.h"
#import "HttpTool.h"
#import "MJRefresh/MJRefresh.h"
#import "MYSDoctorMoreDynamicModel.h"


#define perpagerNumber 5

@interface MYSExpertGroupDynamicViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, assign) int currentPage;
//@property (nonatomic, assign) int perPageNumber;
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@end

@implementation MYSExpertGroupDynamicViewController

- (NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *sadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 60) / 2, (kScreen_Height - 160) / 2 -60, 60, 60)];
    sadImageView.image = [UIImage imageNamed:@"search_icon_none_"];
    self.sadImageView = sadImageView;
    sadImageView.hidden = YES;
    [self.view addSubview:sadImageView];
    
    UILabel *sadTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sadImageView.frame) + 10, kScreen_Width, 40)];
    self.sadTextLabel = sadTextLabel;
    sadTextLabel.hidden = YES;
    sadTextLabel.textColor = [UIColor lightGrayColor];
    sadTextLabel.text = @"无最新相关动态";
    sadTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sadTextLabel];
    
    [self.tableView addSubview:sadImageView];
    [self.tableView addSubview:sadTextLabel];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.currentPage = 1;
    
    // 加载更多
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.tableView addFooterWithCallback:^{
        if (vc.contentArray.count < [[(MYSDoctorHome *)vc.model count] integerValue]) {
            NSInteger end = perpagerNumber;
            
            [vc getMoreDynamicWithEnd:[NSString stringWithFormat:@"%ld",(long)end]];
//            [vc findDoctorByDepartmentId:self.departmentId scrollPositonTop:NO];
            [vc.tableView footerEndRefreshing];
        } else {
            vc.tableView.footerRefreshingText = @"已加载全部数据";
            [vc.tableView footerEndRefreshing];
        }
    }];

    
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dynamic = @"dynamic";
    MYSExpertGroupDynamicCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:dynamic];
    if (dynamicCell == nil) {
        dynamicCell = [[MYSExpertGroupDynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamic];
    }
    dynamicCell.separatorInset = UIEdgeInsetsMake(0, 37, 0, 0);
    dynamicCell.dynamicFrame = self.contentArray[indexPath.row];
    return dynamicCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSExpertGroupDynamicFrame *dynamicFrame = self.contentArray[indexPath.row];
    return dynamicFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MYSExpertGroupDynamicFrame *dynamicFrame = self.contentArray[indexPath.row];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[[dynamicFrame dynamicModel] dynamicId]forKey:@"expertGroupDynamic"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"expertGroupDynamic" object:nil userInfo:userInfo];
}


- (void)setModel:(id)model
{
    _model = model;
    
    for (MYSDoctorHomeDynamicModel *dynamicModel in [model dynamicArray]) {
        MYSExpertGroupDynamicFrame *frame = [[MYSExpertGroupDynamicFrame alloc] init];
        
        frame.dynamicModel = dynamicModel;
        [self.contentArray addObject:frame];
        
    }
    if(self.contentArray.count == 0) {
        self.sadTextLabel.hidden = NO;
        self.sadImageView.hidden = NO;
    }
    [self.tableView reloadData];
}

float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    LOG(@"开始拖动");
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (lastContentOffset > scrollView.contentOffset.y) {
        LOG(@"12向下滚动");
        if(self.tableView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    } else {
        LOG(@"12向上滚动");
        if(self.tableView.contentOffset.y > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        LOG(@"向上滚动");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
    }else{
        LOG(@"向下滚动");
        if(self.tableView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    }
}

#pragma mark api  获取更多动态
- (void)getMoreDynamicWithEnd:(NSString *)end
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    

    
    NSString *URLString = [kURL stringByAppendingString:@"dynamic/list"];
    NSDictionary *parameters = @{@"did": [[self.model introducesModel] doctorId], @"start": [NSString stringWithFormat:@"%lu",(unsigned long)self.contentArray.count], @"end": end};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        
        for (NSDictionary *dict in responseObject) {
            MYSDoctorHomeDynamicModel *dynamicModel = [[MYSDoctorHomeDynamicModel alloc] initWithDictionary:dict error:nil];
            
            MYSExpertGroupDynamicFrame *expertGroupDynamicFrame = [[MYSExpertGroupDynamicFrame alloc] init];
            expertGroupDynamicFrame.dynamicModel = dynamicModel;
            [self.contentArray addObject:expertGroupDynamicFrame];
        }
//       MYSDoctorMoreDynamicModel *doctorHome = [[MYSDoctorMoreDynamicModel alloc] initWithDictionary:responseObject error:nil];
//        
//        [self.contentArray addObjectsFromArray:responseObject];
        
        [self.tableView reloadData];
//        MYSDoctorHomeIntroducesModel *introductesModel = doctorHome.introducesModel;
//        LOG(@"\n姓名：%@  \n医院：%@  \n科室：%@  \n擅长：%@  \n简介：%@", introductesModel.doctorName, introductesModel.hospital, introductesModel.department, introductesModel.territory, introductesModel.introduce);
//        
//        [self setUIWithModel:introductesModel];
//        
//        self.sliderVC.model = doctorHome;
//        for (MYSDoctorHomeDynamicModel *dynamicModel in doctorHome.dynamicArray) {
//            LOG(@"标题：%@  时间：%@", dynamicModel.title, dynamicModel.addTime);
//        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}


@end
