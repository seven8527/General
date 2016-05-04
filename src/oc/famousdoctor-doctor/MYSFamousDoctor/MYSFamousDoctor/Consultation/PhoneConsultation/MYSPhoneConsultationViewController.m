//
//  MYSPhoneConsultationViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPhoneConsultationViewController.h"
#import "MYSPhoneConsultationDetailViewController.h"
#import "MJRefresh.h"

#define BTN_COLOR [UIColor colorWithRed:0/255.0f green:164/255.0f blue:143/255.0f alpha:1]

@interface MYSPhoneConsultationViewController ()

@end

@implementation MYSPhoneConsultationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"电话咨询";
    selectUnCallFlag = YES;
    pageNum = 0;
    
    [self setTabBtnColor];
    [self initTabBtn];
    
    mCallData = [[NSMutableArray alloc] init];
    mUnCallData = [[NSMutableArray alloc] init];
    
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

/**
 *  初始化Tab按钮
 */
- (void)initTabBtn
{
    unCallBtn.layer.borderColor = [BTN_COLOR CGColor];
    unCallBtn.layer.borderWidth = 1.0f;
    
    callBtn.layer.borderColor = [BTN_COLOR CGColor];
    callBtn.layer.borderWidth = 1.0f;
}

/**
 *  未通话按钮点击事件
 */
- (IBAction)unCallBtnClick:(id)sender
{
    // 设定选择Flag
    selectUnCallFlag = YES;
    [self setTabBtnColor];
    
    [mTableView reloadData];
}

/**
 *  通话按钮点击事件
 */
- (IBAction)callBtnClick:(id)sender
{
    // 设定选择Flag
    selectUnCallFlag = NO;
    [self setTabBtnColor];
    
    [mTableView reloadData];
}

/**
 *  通过Flag设定按钮颜色
 */
- (void)setTabBtnColor
{
    UIColor *unCallBgColor;
    UIColor *unCallTextColor;
    UIColor *callBgColor;
    UIColor *callTextColor;
    
    if (selectUnCallFlag)
    {
        unCallBgColor = BTN_COLOR;
        unCallTextColor = [UIColor whiteColor];
        
        callBgColor = [UIColor whiteColor];
        callTextColor = BTN_COLOR;
    } else {
        unCallBgColor = [UIColor whiteColor];
        unCallTextColor = BTN_COLOR;
        
        callBgColor = BTN_COLOR;
        callTextColor = [UIColor whiteColor];
    }
    
    unCallBtn.backgroundColor = unCallBgColor;
    [unCallBtn setTitleColor:unCallTextColor forState:UIControlStateNormal];
    
    callBtn.backgroundColor = callBgColor;
    [callBtn setTitleColor:callTextColor forState:UIControlStateNormal];
}

#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectUnCallFlag)
    {
        return [mUnCallData count];
    } else {
        return [mCallData count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic = nil;
    if (selectUnCallFlag)
    {
        dic = [mUnCallData objectAtIndex:indexPath.row];
    } else {
        dic = [mCallData objectAtIndex:indexPath.row];
    }
    
    NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
    if (1 == audit_status)
    {   // 没有预定时间
        return 180;
    } else {
        // 有预定时间
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic = nil;
    if (selectUnCallFlag)
    {
        dic = [mUnCallData objectAtIndex:indexPath.row];
    } else {
        dic = [mCallData objectAtIndex:indexPath.row];
    }
    
    NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
    if (1 == audit_status)
    {   // 没有预定时间
        NSString *cellName = @"MYSPhoneConsultationTableViewCell1";
        MYSPhoneConsultationTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (nil == cell)
        {
            [tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        }
        cell.delegate = self;
        [cell sendValue:dic];
        
        return cell;
    } else {
        // 有预定时间
        NSString *cellName = @"MYSPhoneConsultationTableViewCell";
        MYSPhoneConsultationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (nil == cell)
        {
            [tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        }
        cell.delegate = self;
        [cell sendValue:dic];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic;
    if (selectUnCallFlag)
    {
        dic = [mUnCallData objectAtIndex:indexPath.row];
    } else {
        dic = [mCallData objectAtIndex:indexPath.row];
    }
    
    NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
    
    MYSPhoneConsultationDetailViewController *detailCtrl = [[MYSPhoneConsultationDetailViewController alloc] init];
    [detailCtrl sendValue:[dic objectForKey:@"billno"] audit_status:audit_status];
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (void)cellBtnClick:(id)dic
{
    NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
    
    MYSPhoneConsultationDetailViewController *detailCtrl = [[MYSPhoneConsultationDetailViewController alloc] init];
    [detailCtrl sendValue:[dic objectForKey:@"billno"] audit_status:audit_status];
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (void)cell1BtnClick:(id)dic
{
    NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
    
    MYSPhoneConsultationDetailViewController *detailCtrl = [[MYSPhoneConsultationDetailViewController alloc] init];
    [detailCtrl sendValue:[dic objectForKey:@"billno"] audit_status:audit_status];
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

#pragma mark
#pragma mark 获取电话咨询列表请求
- (void)getNetListRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consulting/index_new"];
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:userInfo.userId forKey:@"doctor_uid"];
    [parameters setValue:FAMOUS_STATUS_PHO forKey:@"type"];
    [parameters setValue:[NSString stringWithFormat:@"%ld", pageNum * kPageSize] forKey:@"start"];
    [parameters setValue:[NSString stringWithFormat:@"%ld", (pageNum + 1) * kPageSize] forKey:@"end"];
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSString *state = [[responseObject objectForKey:@"status"] stringValue];
        if ([@"1" isEqualToString:state]) {
            
            if (0 == pageNum)
            {
                mUnCallData = [[NSMutableArray alloc] init];
                mCallData = [[NSMutableArray alloc] init];
            }
            
            pageNum++;
            // 请求成功
            id message = [responseObject objectForKey:@"message"];
            for (id dic in message)
            {
                NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
                if (3 == audit_status)
                {   // 完成的场合
                    [mCallData addObject:dic];
                } else {
                    // 未完成的场合
                    [mUnCallData addObject:dic];
                }
            }
            [mTableView reloadData];
        } else {
            [self showAlert:@"目前没有电话咨询"];
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
