//
//  MYSMyReplyViewController.m
//  MYSFamousDoctor
//
//  我的回复
//
//  Created by lyc on 15/4/14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyReplyViewController.h"
#import "MYSMyReplyTableViewCell.h"
#import "MYSMyReplyDetailViewController.h"
#import "MJRefresh.h"

@interface MYSMyReplyViewController ()

@end

@implementation MYSMyReplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的回复";
    [mTableView setBackgroundColor:[UIColor colorFromHexRGB:KEDEDEDColor]];
    pageNum = 0;
    mData = [[NSMutableArray alloc] init];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    // 1.注册cell
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 2.集成刷新控件
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self headerRereshing];
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
    [self sendMyReplyListRequest];
}

- (void)footerRereshing
{
    [self sendMyReplyListRequest];
}

#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic = [mData objectAtIndex:indexPath.row];
    
    id mainDic = [dic objectForKey:@"main"];
    id reply = [mainDic objectForKey:@"reply"];
    
    // 提问内容
    NSString *question_title = [mainDic objectForKey:@"question_title"];
    // 回答内容
    NSString *reply_title = [reply objectForKey:@"content"];
    
    return [MYSMyReplyTableViewCell calculateCellHeight:question_title reply:reply_title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"MYSMyReplyTableViewCell";
    
    MYSMyReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == cell)
    {
        cell = [[MYSMyReplyTableViewCell alloc] init];
    }
    
    [cell sendValue:[mData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic = [mData objectAtIndex:indexPath.row];
    id main = [dic objectForKey:@"main"];
    MYSMyReplyDetailViewController *detailCtrl = [[MYSMyReplyDetailViewController alloc] init];
    [detailCtrl sendValue:[main objectForKey:@"pfid"]];
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

#pragma mark
#pragma mark 发送列表请求
- (void)sendMyReplyListRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"myanswer_list"];
    
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:userInfo.userId forKey:@"uid"];
    [parameters setValue:[NSString stringWithFormat:@"%ld", pageNum * kPageSize] forKey:@"start"];
    [parameters setValue:[NSString stringWithFormat:@"%ld", (pageNum + 1) * kPageSize] forKey:@"end"];
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        totalNum = [[responseObject objectForKey:@"total"] integerValue];
        if ([@"0" isEqualToString:state])
        {
            [self showAlert:@"没有回复信息"];
        } else if ([@"-1" isEqualToString:state]) {
            [self showAlert:@"登录用户异常"];
        } else {
            if (0 == pageNum)
            {
                mData = [[NSMutableArray alloc] init];
            }
            
            NSArray *responseData = [responseObject objectForKey:@"message"];
            if (responseData && [NSNull null] != responseData && [responseData count] > 0)
            {
                pageNum++;
                [mData addObjectsFromArray:responseData];
                [mTableView reloadData];
            }
        }
        [mTableView headerEndRefreshing];
        [mTableView footerEndRefreshing];
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        [self showAlert:@"请求失败"];
        [mTableView headerEndRefreshing];
        [mTableView footerEndRefreshing];
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
