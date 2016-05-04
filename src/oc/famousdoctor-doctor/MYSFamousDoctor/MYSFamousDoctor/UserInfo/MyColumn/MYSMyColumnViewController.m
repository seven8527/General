//
//  MYSMyColumnViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyColumnViewController.h"
#import "MYSMyColumuTableViewCell.h"
#import "MYSMyColumnDetailViewController.h"
#import "MJRefresh.h"

@interface MYSMyColumnViewController ()

@end

@implementation MYSMyColumnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的专栏";
    
    pageNum = 0;
    mData = [[NSMutableArray alloc] init];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    // 1.注册cell
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // 2.集成刷新控件
    [self setupRefresh];
    
    [self getMyColumuListRquest];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [mTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [mTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)headerRereshing
{
    pageNum = 0;
    mData = [[NSMutableArray alloc] init];
    [self getMyColumuListRquest];
}

- (void)footerRereshing
{
    [self getMyColumuListRquest];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MYSMyColumuTableViewCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic = [mData objectAtIndex:indexPath.row];
    
    NSString *cellName = @"MYSMyColumuTableViewCell";
    MYSMyColumuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == cell)
    {
        cell = [[MYSMyColumuTableViewCell alloc] init];
    }
    NSString *view_time = [dic objectForKey:@"view_time"];
    if (!view_time || [NSNull null] == view_time || [@"" isEqualToString:view_time])
    {
        view_time = @"0";
    }
    [cell sendTitle:[dic objectForKey:@"title"] time:[dic objectForKey:@"add_date"] count:view_time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic = [mData objectAtIndex:indexPath.row];
    MYSMyColumnDetailViewController *detail = [[MYSMyColumnDetailViewController alloc] init];
    [detail sendValue:[dic objectForKey:@"dcaid"]];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark
#pragma mark 个人专栏列表请求
/**
 *  发送请求
 */
- (void)getMyColumuListRquest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"doctor_special"];
    
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[NSString stringWithFormat:@"%ld", pageNum * kPageSize] forKey:@"start"];
    [parameters setValue:[NSString stringWithFormat:@"%ld", (pageNum + 1) * kPageSize] forKey:@"end"];
    [parameters setValue:userInfo.userId forKey:@"uid"];

    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSString *state = [responseObject objectForKey:@"state"];
        if ([@"0" isEqualToString:state])
        {
            [self showAlert:@"目前没有发表文章"];
        } else {
            // 请求成功
            NSArray *responseData = [responseObject objectForKey:@"message"];
            // 判断数据是否存在
            if (responseData && [NSNull null] != responseData && [responseData count] > 0)
            {
                pageNum++;
                [mData addObjectsFromArray:responseData];
                // 重新加载TableView
                [mTableView reloadData];
            }
        }
        [mTableView headerEndRefreshing];
        [mTableView footerEndRefreshing];
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [mTableView headerEndRefreshing];
        [mTableView footerEndRefreshing];
        [hud hide:YES];
        [self showAlert:@"请求失败"];
    }];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
