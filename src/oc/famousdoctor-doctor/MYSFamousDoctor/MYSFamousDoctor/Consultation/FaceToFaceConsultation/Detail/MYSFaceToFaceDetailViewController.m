//
//  MYSFaceToFaceDetailViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSFaceToFaceDetailViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface MYSFaceToFaceDetailViewController ()
{
    NSArray *JYDImageArr;
    NSArray *BGImageArr;
    NSArray *OtherImageArr;
}

@end

@implementation MYSFaceToFaceDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查看详情";
    
    mData = [[NSMutableArray alloc] init];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    [self getDetailRequest];
    
    topBillNo.text = mBillNo;
    topBillNo1.text = mBillNo;
}

- (void)sendValue:(NSString *)billno audit_status:(NSInteger)audit_status
{
    mBillNo = billno;
    mAudit_status = audit_status;
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
    if ([dic isKindOfClass:[UITableViewCell class]])
    {
        if (0 == indexPath.row)
        {
            if (1 != mAudit_status)
            {
                return 230;
            } else {
                return 215;
            }
        } else if (1 == indexPath.row) {
            return 232;
        } else if (2 == indexPath.row || [mData count] - 1) {
            return 10;
        } else {
            return 0;
        }
    } else {
        if ([@"0" isEqualToString:[dic objectForKey:@"status"]])
        {   // status == 0 按钮title展开
            return [MYSNetDetailTableViewCell calculateCellHeight:[dic objectForKey:@"content"]];
        } else {
            // status == 0 按钮title收起
            return [MYSNetDetailAllTableViewCell calculateCellHeight:[dic objectForKey:@"content"]];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dic = [mData objectAtIndex:indexPath.row];
    
    if ([dic isKindOfClass:[UITableViewCell class]])
    {
        return dic;
    } else {
        if ([@"0" isEqualToString:[dic objectForKey:@"status"]])
        {   // status == 0 按钮title展开
            MYSNetDetailTableViewCell *cell = [[MYSNetDetailTableViewCell alloc] init];
            cell.delegate = self;
            [cell sendValue:dic];
            return cell;
        } else {
            // status == 0 按钮title收起
            MYSNetDetailAllTableViewCell *cell = [[MYSNetDetailAllTableViewCell alloc] init];
            cell.delegate = self;
            [cell sendValue:dic];
            return cell;
        }
    }
}

- (void)detailCellZhanKaiBtnClick
{
    [mTableView reloadData];
}

- (void)detailCellShouQiBtnClick
{
    [mTableView reloadData];
}

#pragma mark
#pragma mark 发送获取详细信息请求
- (void)getDetailRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"pmid_info"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:mBillNo forKey:@"billno"];
    [parameters setValue:FAMOUS_STATUS_FTF	 forKey:@"type"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if (!responseObject || [NSNull null] == responseObject || nil == responseObject)
        {
            return;
        }
        
        // 设定头部、中部信息
        [self sendTopAndMiddleValue:responseObject];
        
        // 请求成功
        if (1 != mAudit_status)
        {
            [mData addObject:topCell1];
        } else {
            [mData addObject:topCell2];
        }
        [mData addObject:middleCell];
        [mData addObject:marginCell];
        // 当前症状
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[responseObject objectForKey:@"c9"] forKey:@"content"];
        [dic setObject:@"当前症状与体征" forKey:@"title"];
        [dic setObject:@"user" forKey:@"type"];
        [dic setObject:@"0" forKey:@"status"];
        [dic setObject:@"other" forKey:@"countType"];
        [mData addObject:dic];
        // 就医情况
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[responseObject objectForKey:@"c10"] forKey:@"content"];
        [dic setObject:@"咨询问题及以往就医情况" forKey:@"title"];
        [dic setObject:@"user" forKey:@"type"];
        [dic setObject:@"0" forKey:@"status"];
        [dic setObject:@"other" forKey:@"countType"];
        [mData addObject:dic];
        // 希望得到医生何种帮助
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[responseObject objectForKey:@"question"] forKey:@"content"];
        [dic setObject:@"希望得到医生何种帮助" forKey:@"title"];
        [dic setObject:@"user" forKey:@"type"];
        [dic setObject:@"0" forKey:@"status"];
        [dic setObject:@"end" forKey:@"countType"];
        [mData addObject:dic];
        
        [mData addObject:marginCell];
        
        [mTableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        [self showAlert:@"请求失败"];
    }];
}

- (void)sendTopAndMiddleValue:(id)responseObject
{
    NSString *picURL = [responseObject objectForKey:@"pic"];
    NSString *pName = [responseObject objectForKey:@"patient_name"];
    // 患者性别
    NSString *pSex = @"男";
    if ([@"0" isEqualToString:[responseObject objectForKey:@"patient_sex"]])
    {
        pSex = @"女";
    }
    // 患者年龄
    NSString *pAge = [NSString stringWithFormat:@"%@岁", [MYSUtils getAgeFromID:[responseObject objectForKey:@"identity"]]];
    NSString *userInfo = [NSString stringWithFormat:@"%@  %@  %@", pName, pSex, pAge];
    
    NSString *typeStr = [MYSUtils getOderStatus:mAudit_status];
    
    if (1 != mAudit_status)
    {   // 有确认时间
        [topImage sd_setImageWithURL:[NSURL URLWithString:picURL] placeholderImage:[UIImage imageNamed:@"favicon_man"]];
        // 用户信息
        topUserInfo.text = userInfo;
        topUserHeight.text = [MYSUtils checkHeight:[responseObject objectForKey:@"patient_height"]];
        topUserweight.text = [MYSUtils checkWeight:[responseObject objectForKey:@"patient_weight"]];
        topAddDate.text = [responseObject objectForKey:@"add_date"];
        topType.text = typeStr;
        topQueRenTime.text = [NSString stringWithFormat:@"%@~%@", [responseObject objectForKey:@"referral_date"], [responseObject objectForKey:@"referral_date_end"]];
        topQiWangTime.text = [NSString stringWithFormat:@"%@~%@", [responseObject objectForKey:@"user_tel_time"], [responseObject objectForKey:@"user_tel_time_end"]];
    } else {
        // 没有确认时间
        [topImage1 sd_setImageWithURL:[NSURL URLWithString:picURL] placeholderImage:[UIImage imageNamed:@"favicon_man"]];
        // 用户信息
        topUserInfo1.text = userInfo;
        topUserHeight1.text = [NSString stringWithFormat:@"%@cm", [responseObject objectForKey:@"patient_height"]];
        topUserweight1.text = [NSString stringWithFormat:@"%@kg", [responseObject objectForKey:@"patient_weight"]];
        topAddDate1.text = [responseObject objectForKey:@"add_date"];
        topType1.text = typeStr;
        topQiWangTime1.text = [NSString stringWithFormat:@"%@~%@", [responseObject objectForKey:@"user_tel_time"], [responseObject objectForKey:@"user_tel_time_end"]];
    }
    
    // 检验单
    NSString *JYDUrlStr = [responseObject objectForKey:@"c4"];
    if (JYDUrlStr && [NSNull null] != JYDUrlStr && ![@"" isEqualToString:JYDUrlStr])
    {
        NSArray *JYDUrls = [JYDUrlStr componentsSeparatedByString:@","];
        jianYanDanURLArr = JYDUrls;
        for (NSInteger i = 0; i < [JYDUrls count]; i++)
        {
            NSURL *url = [NSURL URLWithString:[JYDUrls objectAtIndex:i]];
            [[JYDImageArr objectAtIndex:i] sd_setImageWithURL:url placeholderImage:nil];
        }
    }
    // 检查报告单
    NSString *BGUrlStr = [responseObject objectForKey:@"c5"];
    if (BGUrlStr && [NSNull null] != BGUrlStr && ![@"" isEqualToString:BGUrlStr])
    {
        NSArray *BGUrls = [BGUrlStr componentsSeparatedByString:@","];
        jianChaBaoGaoURLArr = BGUrls;
        for (NSInteger i = 0; i < [BGUrls count]; i++)
        {
            NSURL *url = [NSURL URLWithString:[BGUrls objectAtIndex:i]];
            [[BGImageArr objectAtIndex:i] sd_setImageWithURL:url placeholderImage:nil];
        }
    }
    // 其它资料
    NSString *OtherUrlStr = [responseObject objectForKey:@"c7"];
    if (OtherUrlStr && [NSNull null] != OtherUrlStr && ![@"" isEqualToString:OtherUrlStr])
    {
        NSArray *otherUrls = [OtherUrlStr componentsSeparatedByString:@","];
        qiTaZiLiaoURLArr = otherUrls;
        for (NSInteger i = 0; i < [otherUrls count]; i++)
        {
            NSURL *url = [NSURL URLWithString:[otherUrls objectAtIndex:i]];
            [[OtherImageArr objectAtIndex:i] sd_setImageWithURL:url placeholderImage:nil];
        }
    }
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

#pragma mark
#pragma mark 按钮点击事件
// 检验单按钮点击事件
- (IBAction)jianYanDanBtnClick:(id)sender
{
    if ([jianYanDanURLArr count] > 0)
    {
        [self showPhotoBrowser:jianYanDanURLArr];
    }
}

// 检查报告按钮点击事件
- (IBAction)jianChaBaoGaoBtnClick:(id)sender
{
    if ([jianChaBaoGaoURLArr count] > 0)
    {
        [self showPhotoBrowser:jianChaBaoGaoURLArr];
    }
}

// 其他资料按钮点击事件
- (IBAction)qiTaZiLiaoBtnClick:(id)sender
{
    if ([qiTaZiLiaoURLArr count] > 0)
    {
        [self showPhotoBrowser:qiTaZiLiaoURLArr];
    }
}

- (void)showPhotoBrowser:(NSArray *)arr
{
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.hiddenPhotoLoadingView = NO;
    browser.currentPhotoIndex = 0;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [arr count]; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[arr objectAtIndex:i]];
        [photos addObject:photo];
    }
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
