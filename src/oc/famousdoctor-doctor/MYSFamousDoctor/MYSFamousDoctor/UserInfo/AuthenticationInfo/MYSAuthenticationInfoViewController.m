//
//  MYSAuthenticationInfoViewController.m
//  MYSFamousDoctor
//
//  认证资料
//
//  Created by lyc on 15/4/10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSAuthenticationInfoViewController.h"
#import "MYSBeGoodAtViewController.h"
#import "MYSMyAuthenticationViewController.h"

@interface MYSAuthenticationInfoViewController ()

@end

@implementation MYSAuthenticationInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"认证资料";
    
    [self sendModifyRequest];
    
    mData = [[NSMutableArray alloc] init];
    [mData addObject:headCell];
    [mData addObject:topCell];
    [mData addObject:middleCell];
    [mData addObject:bottomCell];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 65/2;
}

#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%lf", ((UITableViewCell *)[mData objectAtIndex:indexPath.row]).bounds.size.height);
    
    return ((UITableViewCell *)[mData objectAtIndex:indexPath.row]).bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [mData objectAtIndex:indexPath.row];
}

/**
 *  擅长按钮点击事件
 */
- (IBAction)beGoodAtBtnClick:(id)sender
{
    MYSBeGoodAtViewController *beGoodAtCtrl = [[MYSBeGoodAtViewController alloc] init];
    [beGoodAtCtrl sendValue:mShanchang];
    [self.navigationController pushViewController:beGoodAtCtrl animated:YES];
}

/**
 *  相关证件按钮点击事件
 */
- (IBAction)credentialsBtnClick:(id)sender
{
    MYSMyAuthenticationViewController *myCtrl = [[MYSMyAuthenticationViewController alloc] init];
    [myCtrl sendValue:authentication_occupation];
    [self.navigationController pushViewController:myCtrl animated:YES];
}

#pragma mark
#pragma mark 发送请求信息
- (void)sendModifyRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"doctor_infos"];
    
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    NSDictionary *parameters = @{@"uid": userInfo.userId};
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        //NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        
        id result = responseObject;
        
        NSString *imageUrl = [MYSUtils checkIsNull:[result objectForKey:@"pic"]];
        NSURL  *url = [NSURL URLWithString:imageUrl];
        [headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
        
        // 姓名
        docName.text = [MYSUtils checkIsNull:[result objectForKey:@"doctor_name"]];
        // 座机
        NSString *phone = [result objectForKey:@"phone"];
        if (!phone || nil == phone || [@"" isEqualToString:phone])
        {
            docTelephone.text = @"未填写";
        } else {
            docTelephone.text = phone;
        }
        // 手机号
        NSString *cellPhone = [result objectForKey:@"doctor_mobile"];
        if (!cellPhone || nil == cellPhone || [@"" isEqualToString:cellPhone])
        {
            docCellphone.text = @"未填写";
        } else {
            docCellphone.text = cellPhone;
        }
        // 职称
        docZhicheng.text = [MYSUtils checkIsNull:[result objectForKey:@"clinical_title"]];
        // 擅长
        docShanchang.text = [MYSUtils checkIsNull:[result objectForKey:@"territory"]];
        mShanchang = [MYSUtils checkIsNull:[result objectForKey:@"territory"]];
        // 所在医院
        docYiyuan.text = [MYSUtils checkIsNull:[result objectForKey:@"doctor_hospital"]];
        // 坐在科室
        docKeshi.text = [MYSUtils checkIsNull:[result objectForKey:@"doctor_department"]];
        
        authentication_occupation = [MYSUtils checkIsNull:[result objectForKey:@"authentication_occupation"]];
        
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
