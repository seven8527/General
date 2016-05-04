//
//  MYSNetConsultationViewController.m
//  MYSFamousDoctor
//
//  网络咨询
//
//  Created by lyc on 15/4/10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSNetConsultationViewController.h"
#import "MJRefresh.h"
#import "MYSNetReplyViewController.h"
#import "MYSNetConsultationDetailViewController.h"

#define BTN_COLOR [UIColor colorWithRed:0/255.0f green:164/255.0f blue:143/255.0f alpha:1]

@interface MYSNetConsultationViewController ()

@end

@implementation MYSNetConsultationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"网络咨询";
    
    selectUnFinishFlag = YES;
    
    pageNum = 0;
    mUnFinishData = [[NSMutableArray alloc] init];
    mFinishData = [[NSMutableArray alloc] init];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    [self initBtnStatus];

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
    [self getNetListRequest];
}

- (void)footerRereshing
{
    [self getNetListRequest];
}

- (void)initBtnStatus
{
    unCompleteBtn.backgroundColor = BTN_COLOR;
    [unCompleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    unCompleteBtn.layer.borderColor = [BTN_COLOR CGColor];
    unCompleteBtn.layer.borderWidth = 1.0f;
    
    completeBtn.backgroundColor = [UIColor clearColor];
    [completeBtn setTitleColor:BTN_COLOR forState:UIControlStateNormal];
    completeBtn.layer.borderColor = [BTN_COLOR CGColor];
    completeBtn.layer.borderWidth = 1.0f;
}

/**
 *  完成按钮点击事件
 */
- (IBAction)completeBtnClick:(id)sender
{
    // 转变选择的Flag
    selectUnFinishFlag = NO;
    unCompleteBtn.backgroundColor = [UIColor clearColor];
    [unCompleteBtn setTitleColor:BTN_COLOR forState:UIControlStateNormal];
    
    completeBtn.backgroundColor = BTN_COLOR;
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 点击tab后重新刷新
    [mTableView reloadData];
}

/**
 *  未完成按钮点击事件
 */
- (IBAction)unCompleteBtnBtnClick:(id)sender
{
    // 转变选择的Flag
    selectUnFinishFlag = YES;
    unCompleteBtn.backgroundColor = BTN_COLOR;
    [unCompleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    completeBtn.backgroundColor = [UIColor clearColor];
    [completeBtn setTitleColor:BTN_COLOR forState:UIControlStateNormal];
    
    // 点击tab后重新刷新
    [mTableView reloadData];
}

#pragma mark
#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectUnFinishFlag)
    {
        return [mUnFinishData count];
    } else {
        return [mFinishData count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectUnFinishFlag)
    {   // 未完成
        id dic = [mUnFinishData objectAtIndex:indexPath.row];
        return [MYSNetConsultationTableViewCell calculateCellHeight:[dic objectForKey:@"question"]];
    } else {
        // 已完成
        id dic = [mFinishData objectAtIndex:indexPath.row];
        return [MYSNetConsultationTableViewCell calculateCellHeight:[dic objectForKey:@"question"]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"MYSNetConsultationTableViewCell";
    MYSNetConsultationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (nil == cell)
    {
        cell = [[MYSNetConsultationTableViewCell alloc] init];
    }
    
    if (selectUnFinishFlag)
    {
        [cell sendValue:[mUnFinishData objectAtIndex:indexPath.row]];
    } else {
        [cell sendValue:[mFinishData objectAtIndex:indexPath.row]];
    }
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic;
    if (selectUnFinishFlag)
    {
        dic = [mUnFinishData objectAtIndex:indexPath.row];
    } else {
        dic = [mFinishData objectAtIndex:indexPath.row];
    }
    
    MYSNetConsultationDetailViewController *detail = [[MYSNetConsultationDetailViewController alloc] init];
    [detail sendValue:[dic objectForKey:@"billno"]];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)cellBtnClick:(id)dic
{
    NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
    if (3 == audit_status) {
        MYSNetConsultationDetailViewController *detail = [[MYSNetConsultationDetailViewController alloc] init];
        [detail sendValue:[dic objectForKey:@"billno"]];
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        MYSNetReplyViewController *netReplyCtrl = [[MYSNetReplyViewController alloc] init];
        [netReplyCtrl sendValue:[dic objectForKey:@"billno"]];
        [self.navigationController pushViewController:netReplyCtrl animated:YES];
    }
}

#pragma mark
#pragma mark 获取网络咨询列表请求
- (void)getNetListRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consulting/index_new"];
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:userInfo.userId forKey:@"doctor_uid"];
    [parameters setValue:FAMOUS_STATUS_NET forKey:@"type"];
    [parameters setValue:[NSString stringWithFormat:@"%ld", pageNum * kPageSize] forKey:@"start"];
    [parameters setValue:[NSString stringWithFormat:@"%ld", (pageNum + 1) * kPageSize] forKey:@"end"];
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSString *state = [[responseObject objectForKey:@"status"] stringValue];
        if ([@"1" isEqualToString:state]) {
            
            if (0 == pageNum)
            {
                mUnFinishData = [[NSMutableArray alloc] init];
                mFinishData = [[NSMutableArray alloc] init];
            }
            
            pageNum++;
            // 请求成功
            id message = [responseObject objectForKey:@"message"];
            for (id dic in message)
            {
                NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
                if (3 == audit_status)
                {   // 完成的场合
                    [mFinishData addObject:dic];
                } else {
                    // 未完成的场合
                    [mUnFinishData addObject:dic];
                }
            }
            [mTableView reloadData];
        } else {
            [self showAlert:@"目前没有网络咨询"];
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
