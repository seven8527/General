//
//  HealthInformationViewController+Request.m
//  MYSPatient
//
//  Created by lyc on 15/5/20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "HealthInformationViewController+Request.h"
#import "HttpTool.h"

#define INFO_PAGE_SIZE 10

@implementation HealthInformationViewController (Request)

#pragma mark 咨询头条请求
- (void)sendZXTTRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"health_info/top"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)(INFO_PAGE_SIZE * zxttPageNum)] forKey:@"start"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)(INFO_PAGE_SIZE * (zxttPageNum + 1))] forKey:@"end"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status)
        {
            id data = [responseObject objectForKey:@"data"];
            if ([Utils checkObjNoNull:data])
            {
                NSArray *list = [data objectForKey:@"list"];
                if ([Utils checkObjNoNull:list])
                {
                    if (0 == zxttPageNum)
                    {   // 第1页的场合，清除所有的数据，然后再追加
                        [zxttDataArr removeAllObjects];
                    }
                    [zxttDataArr addObjectsFromArray:list];
                    [mTableView reloadData];
                    zxttPageNum++;
                }
            }
        } else {
            [Utils showMessage:@"暂时没有更多咨询头条数据"];
        }
        
        [mTableView headerEndRefreshing];
        [mTableView footerEndRefreshing];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [mTableView headerEndRefreshing];
        [mTableView footerEndRefreshing];
        [hud hide:YES];
    }];
}

#pragma mark 健康饮食请求
- (void)sendJKYSRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"health_info/diet"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)(INFO_PAGE_SIZE * jkysPageNum)] forKey:@"start"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)(INFO_PAGE_SIZE * (jkysPageNum+ 1))] forKey:@"end"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status)
        {
            id data = [responseObject objectForKey:@"data"];
            if ([Utils checkObjNoNull:data])
            {
                NSArray *list = [data objectForKey:@"list"];
                if ([Utils checkObjNoNull:list])
                {
                    if (0 == jkysPageNum)
                    {   // 第1页的场合，清除所有的数据，然后再追加
                        [jkysDataArr removeAllObjects];
                    }
                    [jkysDataArr addObjectsFromArray:list];
                    [mTableView reloadData];
                    jkysPageNum++;
                }
            }
        } else {
            [Utils showMessage:@"暂时没有更多咨询头条数据"];
        }
        [mTableView headerEndRefreshing];
        [mTableView footerEndRefreshing];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [mTableView headerEndRefreshing];
        [mTableView footerEndRefreshing];
        [hud hide:YES];
    }];
}

@end
