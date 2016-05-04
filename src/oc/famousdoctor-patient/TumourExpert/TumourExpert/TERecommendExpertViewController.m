//
//  TERecommendExpertViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TERecommendExpertViewController.h"
#import "TEExpertCell.h"
#import "TEExpertModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "UIImageView+NetLoading.h"

@interface TERecommendExpertViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *consultCount;
@end

@implementation TERecommendExpertViewController


- (void)setExperts:(NSArray *)experts
{
    _experts = experts;
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.scrollEnabled = NO;
    //    self.tableView.contentInset =UIEdgeInsetsMake(0, 0, 320, 0);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.3;
    [footerView addSubview:lineView];
    
    
    UIButton *loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loadMoreButton.frame = CGRectMake(10, 10, 300, 34);
    [loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"hone_button_more_default"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)]forState:UIControlStateNormal];
    [loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"hone_button_more_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)]forState:UIControlStateHighlighted];
    [loadMoreButton setTitleColor:[UIColor colorWithHex:0x9e9e9e] forState:UIControlStateNormal];
    [loadMoreButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
    loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:14];

    [loadMoreButton addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loadMoreButton];
    self.tableView.tableFooterView = footerView;

    self.tableView.backgroundColor = [UIColor clearColor];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.experts.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"expert";
    TEExpertCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TEExpertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    TEExpertModel *expert = [self.experts objectAtIndex:indexPath.row];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *expertId = [(TEExpertModel *)[self.experts objectAtIndex:indexPath.row] expertId];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:expertId forKey:@"expertId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"expertChoose" object:nil userInfo:userInfo];
 
}


- (void)loadMore
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"推荐专家" forKey:@"homeslidertitle"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMore" object:nil userInfo:userInfo];
    
}

@end
