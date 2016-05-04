//
//  MYSNetConsultationDetailViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSNetConsultationDetailViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface MYSNetConsultationDetailViewController ()
{
    NSArray *JYDImageArr;
    NSArray *BGImageArr;
    NSArray *OtherImageArr;
}

@end

@implementation MYSNetConsultationDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查看详情";
    
    JYDImageArr = [[NSArray alloc] initWithObjects:middleJYDImage1, middleJYDImage2, middleJYDImage3, nil];
    BGImageArr = [[NSArray alloc] initWithObjects:middleBGImage1, middleBGImage2, middleBGImage3, nil];
    OtherImageArr = [[NSArray alloc] initWithObjects:middleOtherImage1, middleOtherImage2, middleOtherImage3, nil];
    
    mData = [[NSMutableArray alloc] init];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    [self getDetailRequest];
}

- (void)sendValue:(NSString *)billno
{
    mBillNo = billno;
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
        return ((UITableViewCell *)dic).tag - 40000;
    } else {
        if ([@"user" isEqualToString:[dic objectForKey:@"type"]])
        {
            if ([@"0" isEqualToString:[dic objectForKey:@"status"]])
            {   // status == 0 按钮title展开
                return [MYSNetDetailTableViewCell calculateCellHeight:[dic objectForKey:@"content"]];
            } else {
                // status == 0 按钮title收起
                return [MYSNetDetailAllTableViewCell calculateCellHeight:[dic objectForKey:@"content"]];
            }
        } else {
            return [MYSNetDetailDocTableViewCell calculateCellHeight:[dic objectForKey:@"content"]];
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
        if ([@"user" isEqualToString:[dic objectForKey:@"type"]])
        {
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
        } else {
            MYSNetDetailDocTableViewCell *cell = [[MYSNetDetailDocTableViewCell alloc] init];
            [cell sendValue:dic];
            return cell;
        }
    }
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
    [parameters setValue:FAMOUS_STATUS_NET forKey:@"type"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if (!responseObject || [NSNull null] == responseObject || nil == responseObject)
        {
            return;
        }
        // 设定头部、中部信息
        [self sendTopAndMiddleValue:responseObject];
        
        // 请求成功
        [mData addObject:topCell];
        [mData addObject:middleCell];
        [mData addObject:fenGeCell];
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
        // 当前症状
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[responseObject objectForKey:@"question"] forKey:@"content"];
        [dic setObject:@"希望得到医生何种帮助" forKey:@"title"];
        [dic setObject:@"user" forKey:@"type"];
        [dic setObject:@"0" forKey:@"status"];
        [dic setObject:@"end" forKey:@"countType"];
        [mData addObject:dic];
        
        [mData addObject:fenGeCell];
        // 医生回复
        NSString *doctor_answer = [responseObject objectForKey:@"doctor_answer"];
        if (doctor_answer && [NSNull null] != doctor_answer && ![@"" isEqualToString:doctor_answer])
        {
            dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[responseObject objectForKey:@"doctor_answer"] forKey:@"content"];
            [dic setObject:@"doctor" forKey:@"type"];
            [mData addObject:dic];
            [mData addObject:fenGeCell];
        }
        
        [mTableView reloadData];
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        [self showAlert:@"请求失败"];
    }];
}

- (void)detailCellZhanKaiBtnClick
{
    [mTableView reloadData];
}

- (void)detailCellShouQiBtnClick
{
    [mTableView reloadData];
}

- (void)sendTopAndMiddleValue:(id)responseObject
{
    NSString *picURL = [responseObject objectForKey:@"pic"];
    [topImage sd_setImageWithURL:[NSURL URLWithString:picURL] placeholderImage:[UIImage imageNamed:@"favicon_man"]];
    
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
    
    // 用户信息
    topUserInfo.text = userInfo;
    topUserHeight.text = [NSString stringWithFormat:@"%@cm", [responseObject objectForKey:@"patient_height"]];
    topUserweight.text = [NSString stringWithFormat:@"%@kg", [responseObject objectForKey:@"patient_weight"]];
    topUserSickness.text = [responseObject objectForKey:@"c10"];
    topHospital.text = [responseObject objectForKey:@"c2"];
    topDateTime.text = [responseObject objectForKey:@"c1"];
    
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
