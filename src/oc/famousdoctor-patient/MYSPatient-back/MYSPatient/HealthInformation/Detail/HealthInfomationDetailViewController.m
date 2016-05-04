//
//  HealthInfomationDetailViewController.m
//  MYSPatient
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "HealthInfomationDetailViewController.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "HealthInfomationDetailTableViewCell.h"

@interface HealthInfomationDetailViewController ()

@end

@implementation HealthInfomationDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资讯详情";
    [self initNavgBarLeftBtn];
    
    mData = [[NSArray alloc] init];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    mID = @"1011";
    [self sendDetailRequest];
}

- (void)initNavgBarLeftBtn
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 显示的时候禁止导航栏穿透
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark 健康资讯详细请求
- (void)sendDetailRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"health_info/detail"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:mID forKey:@"id"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status)
        {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
            mData = [[NSArray alloc] initWithObjects:data, nil];
            [mTableView reloadData];
        } else {
            [Utils showMessage:@"暂时没有详情数据"];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [mData objectAtIndex:indexPath.row];
    
    NSString *title = [Utils checkObjIsNull:[item objectForKey:@"title"]];
    NSString *content = [Utils checkObjIsNull:[item objectForKey:@"content"]];
    return [HealthInfomationDetailTableViewCell calculateCellHeight:title content:content];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthInfomationDetailTableViewCell *cell = [[HealthInfomationDetailTableViewCell alloc] init];
    [cell sendValue:[mData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 显示的时候禁止导航栏穿透
    self.navigationController.navigationBar.translucent = YES;
}
@end
