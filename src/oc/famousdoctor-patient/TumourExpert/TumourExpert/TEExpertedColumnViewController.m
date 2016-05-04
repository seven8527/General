//
//  TEExpertedColumnViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertedColumnViewController.h"
#import "TEInformationAndColumnCell.h"
#import "UIColor+Hex.h"
#import "TEHomeExpertColumnModel.h"

@interface TEExpertedColumnViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation TEExpertedColumnViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.scrollEnabled = NO;

    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.3;
    [footerView addSubview:lineView];
    UIButton *loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadMoreButton setTitleColor:[UIColor colorWithHex:0x9e9e9e] forState:UIControlStateNormal];
    loadMoreButton.frame = CGRectMake(10, 10, 300, 34);
    [loadMoreButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
    loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"hone_button_more_default"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)]forState:UIControlStateNormal];
    [loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"hone_button_more_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)]forState:UIControlStateHighlighted];
    [loadMoreButton addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:loadMoreButton];
    self.tableView.tableFooterView = footerView;

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expertColumns.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"informationAndColumn";
    TEInformationAndColumnCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TEInformationAndColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.picImageView.image = [UIImage imageNamed:@"hone_icon_column_default"];
    TEHomeExpertColumnModel *expertColumn = self.expertColumns[indexPath.row];
    cell.titleLable.text = expertColumn.expertConlumnName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *articleId = [(TEHomeExpertColumnModel *)[self.expertColumns objectAtIndex:indexPath.row] expertConlumnId];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:articleId forKey:@"articleId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"articleChoose" object:nil userInfo:userInfo];
}

- (void)loadMore
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"专家专栏" forKey:@"homeslidertitle"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMore" object:nil userInfo:userInfo];
    
}

@end
