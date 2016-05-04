//
//  MYSHealthRecordsBloodGlucoseListViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsBloodGlucoseListViewController.h"
#import "UIColor+Hex.h"
#import "MYSHealthRecordsListCell.h"

@interface MYSHealthRecordsBloodGlucoseListViewController ()

@end

@implementation MYSHealthRecordsBloodGlucoseListViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"列表";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableviewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 健康档案血压列表
    static NSString *healthRecordsList = @"healthRecordsList";
    
    MYSHealthRecordsListCell *healthRecordsListCell = [tableView dequeueReusableCellWithIdentifier:healthRecordsList];
    
    if (healthRecordsListCell == nil) {
        healthRecordsListCell = [[MYSHealthRecordsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:healthRecordsList];
    }
    healthRecordsListCell.separatorInset = UIEdgeInsetsMake(0, 38, 0, 0);
    healthRecordsListCell.identification = 2;
    healthRecordsListCell.model = nil;
    
    return healthRecordsListCell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
