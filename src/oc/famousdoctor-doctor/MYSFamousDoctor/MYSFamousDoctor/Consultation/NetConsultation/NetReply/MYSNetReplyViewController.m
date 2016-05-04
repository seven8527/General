//
//  MYSNetReplyViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSNetReplyViewController.h"

@interface MYSNetReplyViewController ()

@end

@implementation MYSNetReplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"回复";
    
    if ([@"" isEqualToString:contentView.text])
    {
        contentView.text = @"回复内容";
        contentView.textColor = [UIColor colorFromHexRGB:KB5B5B5Color];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([@"回复内容" isEqualToString:contentView.text])
    {
        contentView.text = @"";
        contentView.textColor = [UIColor colorFromHexRGB:K333333Color];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([@"" isEqualToString:contentView.text])
    {
        contentView.text = @"回复内容";
        contentView.textColor = [UIColor colorFromHexRGB:KB5B5B5Color];
    }
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //自定义导航栏返回按钮
    replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52, 24)];
    [replyBtn setTitle:@"发布" forState:UIControlStateNormal];
    [replyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    replyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    replyBtn.layer.cornerRadius = 4;
    [replyBtn setBackgroundColor:[UIColor colorFromHexRGB:K00A48FColor]];
    [replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *replyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:replyBtn];
    self.navigationItem.rightBarButtonItem = replyBarButtonItem;
}

- (void)sendValue:(NSString *)billno
{
    mBillNo = billno;
}

- (void)replyBtnClick
{
    [self hiddenKeyboard];
    
    if (!mBillNo && [@"" isEqualToString:mBillNo])
    {
        [self showAlert:@"订单号异常"];
    } else {
        if ([@"" isEqualToString:contentView.text] || [@"回复内容" isEqualToString:contentView.text])
        {
            [contentView becomeFirstResponder];
            [self showAlert:@"请输入回复信息"];
        } else {
            [self getNetListRequest];
        }
    }
}

- (void)hiddenKeyboard
{
    if ([contentView isFirstResponder])
    {
        [contentView resignFirstResponder];
    }
}

#pragma mark
#pragma mark 获取网络咨询列表请求
- (void)getNetListRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"doctor_netanswer"];
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setValue:userInfo.cookie forKey:@"cookie"];
    [parameters setValue:userInfo.userId forKey:@"uid"];
    [parameters setValue:@"0" forKey:@"type"];
    [parameters setValue:mBillNo forKey:@"billno"];
    [parameters setValue:contentView.text forKey:@"content"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSString *state = [responseObject objectForKey:@"state"];
        if ([@"201" isEqualToString:state]) {
            [self showAlert:@"回复成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showAlert:@"回复失败"];
        }
        
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
