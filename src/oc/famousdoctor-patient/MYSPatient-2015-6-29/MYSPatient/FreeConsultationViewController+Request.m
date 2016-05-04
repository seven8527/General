//
//  FreeConsultationViewController+Request.m
//  MYSPatient
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "FreeConsultationViewController+Request.h"
#import "HttpTool.h"
#import "MYSExpertGroupDoctorModel.h"

#define INFO_PAGE_SIZE 10

@implementation FreeConsultationViewController (Request)

#pragma mark 最新回复请求
- (void)sendNewReplayRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"latest_reply"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)(INFO_PAGE_SIZE * newReplayPageNum)] forKey:@"start"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)(INFO_PAGE_SIZE * (newReplayPageNum + 1))] forKey:@"end"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        id status = [responseObject objectForKey:@"status"];
        if (![@"0" isEqualToString:status])
        {
            NSArray *list = [responseObject objectForKey:@"list"];
            if ([Utils checkObjNoNull:list])
            {
                if (0 == newReplayPageNum)
                {   // 第1页的场合，清除所有的数据，然后再追加
                    [newReplayArr removeAllObjects];
                }
                [newReplayArr addObjectsFromArray:list];
                [mTableView reloadData];
                newReplayPageNum++;
            }
        } else {
            [Utils showMessage:@"暂时没有更多最新回复数据"];
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

#pragma mark 活跃医生请求
- (void)sendDoctorRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"active_doctor"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)(INFO_PAGE_SIZE * doctorPageNum)] forKey:@"start"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)(INFO_PAGE_SIZE * (doctorPageNum + 1))] forKey:@"end"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        
        id status = [responseObject objectForKey:@"status"];
        if (![@"0" isEqualToString:status])
        {
            NSArray *list = [responseObject objectForKey:@"message"];
            if ([Utils checkObjNoNull:list])
            {
                if (0 == doctorPageNum)
                {   // 第1页的场合，清除所有的数据，然后再追加
                    [doctorArr removeAllObjects];
                }
                for (id item in list)
                {
                    MYSExpertGroupDoctorModel *doctorModel = [[MYSExpertGroupDoctorModel alloc] init];
                    doctorModel.doctorId = [Utils checkObjIsNull:[item objectForKey:@"uid"]];
                    doctorModel.doctorName = [Utils checkObjIsNull:[item objectForKey:@"doctor_name"]];
                    doctorModel.headPortrait = [Utils checkObjIsNull:[item objectForKey:@"pic"]];
                    doctorModel.hospital = [Utils checkObjIsNull:[item objectForKey:@"title"]];
                    doctorModel.department = [Utils checkObjIsNull:[item objectForKey:@"keshi"]];
                    doctorModel.qualifications = [Utils checkObjIsNull:[item objectForKey:@"qualifications"]];
                    doctorModel.attentionState = @"";
                    doctorModel.doctorType = @"1";
                    
                    [doctorArr addObject:doctorModel];
                }
    
                [mTableView reloadData];
                doctorPageNum++;
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
