//
//  MYSPatientQuestionsViewController.m
//  MYSFamousDoctor
//
//  患者提问
//
//  Created by lyc on 15/4/14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPatientQuestionsViewController.h"
#import "MJRefresh.h"
#import "MYSPatientQuestionsDetailViewController.h"

@interface MYSPatientQuestionsViewController ()

@end

@implementation MYSPatientQuestionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"患者提问";
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
    [self getPatientQuestionsListRequest];
}

- (void)footerRereshing
{
    [self getPatientQuestionsListRequest];
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
    return [MYSPatientQuestionsTableViewCell calculateCellHeight:[dic objectForKey:@"question_title"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //id dic = [mData objectAtIndex:indexPath.row];
    NSString *cellName = @"MYSPatientQuestionsTableViewCell";
    
    MYSPatientQuestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == cell)
    {
        cell = [[MYSPatientQuestionsTableViewCell alloc] init];
    }
    cell.delegate = self;
    [cell sendValue:[mData objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark
#pragma mark cell的我要回复按钮点击代理
- (void)cellBtnClick:(id)dic
{
    NSLog(@"%@", dic);
    
    MYSPatientQuestionsDetailViewController *questionDetailCtrl = [[MYSPatientQuestionsDetailViewController alloc] init];
    [questionDetailCtrl sendValue:[dic objectForKey:@"pfid"]];
    [self.navigationController pushViewController:questionDetailCtrl animated:YES];
}

#pragma mark
#pragma mark 获取患者提问列表请求
- (void)getPatientQuestionsListRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"question_list"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[NSString stringWithFormat:@"%ld", pageNum * kPageSize] forKey:@"start"];
    [parameters setValue:[NSString stringWithFormat:@"%ld", (pageNum + 1) * kPageSize] forKey:@"end"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        if ([@"0" isEqualToString:state])
        {
            [self showAlert:@"目前没有患者提问"];
        } else {
            if (0 == pageNum)
            {
                mData = [[NSMutableArray alloc] init];
            }
            
            // 请求成功
            NSArray *responseData = [responseObject objectForKey:@"list"];
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
