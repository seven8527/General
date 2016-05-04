//
//  MYSMyColumnDetailViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyColumnDetailViewController.h"
#import "MYSMyColumnDetailTableViewCell.h"

@interface MYSMyColumnDetailViewController ()

@end

@implementation MYSMyColumnDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getMyColumuDetailRquest];
}

- (void)sendValue:(NSString *)dcaid
{
    mDcaid = dcaid;
}

#pragma mark
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [MYSUtils checkIsNull:[mDic objectForKey:@"title"]];
    NSString *content = [MYSUtils checkIsNull:[mDic objectForKey:@"contents"]];
    return [MYSMyColumnDetailTableViewCell calculateCellHeight:title content:content];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSMyColumnDetailTableViewCell * cell = [[MYSMyColumnDetailTableViewCell alloc] init];
    [cell sendValue:mDic];
    return cell;
}

#pragma mark
#pragma mark 个人专栏详细请求
/**
 *  发送请求
 */
- (void)getMyColumuDetailRquest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"special_article"];
        
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:mDcaid forKey:@"dcaid"];
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        mDic = responseObject;
        
        mTableView.delegate = self;
        mTableView.dataSource = self;
        [mTableView reloadData];

        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
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
