//
//  HealthInformationViewController.m
//  MYSPatient
//
//  健康资讯
//
//  Created by lyc on 15/5/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "HealthInformationViewController.h"
#import "UIColor+Hex.h"
#import "HealthInformationViewController+Request.h"
#import "HealthInformationTableViewCell.h"

@interface HealthInformationViewController ()

@end

@implementation HealthInformationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"健康资讯";
    [self initNavgBarLeftBtn];
    
    // 初始化默认选中第一个（咨询头条）
    selectIndex = 0;
    
    // 初始化页码
    zxttPageNum = 0;
    jkysPageNum = 0;
    
    // 资讯头条数据存储数组
    zxttDataArr = [[NSMutableArray alloc] init];
    // 健康饮食数据存储数组
    jkysDataArr = [[NSMutableArray alloc] init];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    [self sendZXTTRequest];
    
    // 1.注册cell
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    // 2.集成刷新控件
    [self setupRefresh];
}

- (void)initNavgBarLeftBtn
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 显示的时候禁止导航栏穿透
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 隐藏的时候允许导航栏穿透
    self.navigationController.navigationBar.translucent = YES;
}

- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (0 == selectIndex)
    {   // 0:咨询头条
        zxttPageNum = 0;
        [self sendZXTTRequest];
    } else {
        // 1:健康饮食
        jkysPageNum = 0;
        [self sendJKYSRequest];
    }
}

- (void)footerRereshing
{
    if (0 == selectIndex)
    {   // 0:咨询头条
        [self sendZXTTRequest];
    } else {
        // 1:健康饮食
        [self sendJKYSRequest];
    }
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == selectIndex)
    {   // 0:咨询头条
        return [zxttDataArr count];
    } else {
        // 1:健康饮食
        return [jkysDataArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"HealthInformationTableViewCell";
    
    HealthInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == cell)
    {
        [tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
        cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    }
    
    id item;
    if (0 == selectIndex)
    {   // 0:咨询头条
        item = [zxttDataArr objectAtIndex:indexPath.row];
    } else {
        // 1:健康饮食
        item = [jkysDataArr objectAtIndex:indexPath.row];
    }
    [cell sendValue:item];
    return cell;
}

/**
 *  Tab按钮点击事件
 */
- (IBAction)tabBarBtnClick:(id)sender
{
    selectIndex = ((UIButton *)sender).tag - 40000;
    if (0 == selectIndex)
    {   // 0:咨询头条
        [zxttBtn setTitleColor:[UIColor colorFromHexRGB:k00947DColor] forState:UIControlStateNormal];
        [jkysBtn setTitleColor:[UIColor colorFromHexRGB:K333333Color] forState:UIControlStateNormal];
        [zxttLineView setBackgroundColor:[UIColor colorFromHexRGB:k00947DColor]];
        [jkysLineView setBackgroundColor:[UIColor clearColor]];
        
        [mTableView reloadData];
        if ([zxttDataArr count] == 0)
        {   // 界面没有数据的时候切换时会加载界面，有数据的场合不会重新加载
            [self sendZXTTRequest];
        }
    }
    if (1 == selectIndex)
    {   // 1:健康饮食
        [zxttBtn setTitleColor:[UIColor colorFromHexRGB:K333333Color] forState:UIControlStateNormal];
        [jkysBtn setTitleColor:[UIColor colorFromHexRGB:k00947DColor] forState:UIControlStateNormal];
        [zxttLineView setBackgroundColor:[UIColor clearColor]];
        [jkysLineView setBackgroundColor:[UIColor colorFromHexRGB:k00947DColor]];

        [mTableView reloadData];
        if ([jkysDataArr count] == 0)
        {   // 界面没有数据的时候切换时会加载界面，有数据的场合不会重新加载
            [self sendJKYSRequest];
        }
    }
}

@end
