//
//  MYSPatientQuestionsDetailViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPatientQuestionsDetailViewController.h"
#import "MYSMyReplyDetailTableViewCell.h"

@interface MYSPatientQuestionsDetailViewController ()

@end

@implementation MYSPatientQuestionsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"咨询详情";
    [mTableView setBackgroundColor:[UIColor colorFromHexRGB:KEDEDEDColor]];
    
    [self addKeyboardNotification];
    [self initInputView];
    
    mData = [[NSMutableArray alloc] init];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    [self sendMyReplyDetailRequest];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [mTableView addGestureRecognizer:singleRecognizer];
    
    isReply = NO;
}

- (void)tapClick
{
    if ([textView isFirstResponder])
    {
        [textView resignFirstResponder];
    }
}
- (void)sendValue:(NSString *)ID
{
    questionID = ID;
}

- (void)addKeyboardNotification
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            inputView.frame = CGRectMake(0, self.view.frame.size.height - height - inputView.frame.size.height, inputView.frame.size.width, inputView.frame.size.height);
        }];
    });
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            inputView.frame = CGRectMake(0, self.view.frame.size.height - inputView.frame.size.height, inputView.frame.size.width, inputView.frame.size.height);
        }];
    });
}

- (void)initInputView
{
    textView.layer.borderColor = [[UIColor colorFromHexRGB:KB3B3B3Color] CGColor];
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 4;
    
    replyBtn.layer.borderColor = [[UIColor colorFromHexRGB:K00907FColor] CGColor];
    replyBtn.layer.borderWidth = 1;
    replyBtn.layer.cornerRadius = 4;
    [replyBtn setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    
    tipsView.layer.cornerRadius = 3;
}

#pragma mark
#pragma mark 回复按钮点击事件
/**
 *  回复按钮点击事件
 */
- (IBAction)replyBtnClick:(id)sender
{
    [self hiddenKeyboard];
    if (isReply)
    {
        [self showAlert:@"目前不能进行回复操作"];
    } else {
        if ([@"" isEqualToString:textView.text])
        {
            [self showAlert:@"请输入回复信息"];
        } else {
            [self sendMyReplyRequest];
        }
    }
}

- (void)hiddenKeyboard
{
    if ([textView isFirstResponder])
    {
        [textView resignFirstResponder];
    }
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
    
    return [MYSMyReplyDetailTableViewCell calculateCellHeight:[dic objectForKey:@"content"] type:[dic objectForKey:@"type"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"MYSMyReplyDetailTableViewCell";
    
    MYSMyReplyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == cell)
    {
        cell = [[MYSMyReplyDetailTableViewCell alloc] init];
    }
    
    [cell sendValue:[mData objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark
#pragma mark 发送列表请求
- (void)sendMyReplyDetailRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"question_article"];
    
    if (!questionID || [@"" isEqualToString:questionID])
    {
        [hud hide:YES];
        [self showAlert:@"回复信息查询异常"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:questionID forKey:@"pfid"];
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        
        if (![@"-1" isEqualToString:state])
        {
            // 第一条患者提问
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            // 患者姓名
            NSString *pName = [responseObject objectForKey:@"patient_name"];
            // 患者性别
            NSString *pSex = @"男";
            if ([@"0" isEqualToString:[responseObject objectForKey:@"sex"]])
            {
                pSex = @"女";
            }
            // 患者年龄
            NSString *ageStr = [responseObject objectForKey:@"age"];
            if ([NSNull null] == ageStr)
            {
                ageStr = @"0";
            }
            NSString *pAge = [NSString stringWithFormat:@"%@岁", ageStr];
            [dic setValue:[NSString stringWithFormat:@"%@  %@  %@", pName, pSex, pAge] forKey:@"name"];
            [dic setValue:[responseObject objectForKey:@"question_title"] forKey:@"content"];
            [dic setValue:[responseObject objectForKey:@"pic"] forKey:@"pic"];
            [dic setValue:[responseObject objectForKey:@"add_time"] forKey:@"add_time"];
            [dic setValue:@"0" forKey:@"kind"];
            [dic setValue:@"first" forKey:@"type"];
            [mData addObject:dic];
            
            [mTableView reloadData];
        } else {
            [self showAlert:@"请求失败"];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        [self showAlert:@"请求失败"];
    }];
}

#pragma mark
#pragma mark 发送我的回复请求
- (void)sendMyReplyRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"freeconsulta_answer"];
    
    if (!questionID || [@"" isEqualToString:questionID])
    {
        [hud hide:YES];
        [self showAlert:@"回复信息查询异常"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:questionID forKey:@"pfid"];
    [parameters setValue:userInfo.userId forKey:@"uid"];
    [parameters setValue:textView.text forKey:@"answer"];
    [parameters setValue:@"0" forKey:@"type"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSString *state = [[responseObject objectForKey:@"status"] stringValue];
        if ([@"1" isEqualToString:state])
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:userInfo.doctor_name forKey:@"name"];
            [dic setValue:textView.text forKey:@"content"];
            [dic setValue:userInfo.doctor_pic forKey:@"pic"];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"yyyy/MM/dd HH:mm";
            [dic setValue:[format stringFromDate:[NSDate date]] forKey:@"add_time"];
            [dic setValue:@"1" forKey:@"kind"];
            [dic setValue:@"other" forKey:@"type"];
            [mData addObject:dic];
            
            [mTableView reloadData];
            textView.text = @"";
            isReply = YES;
        } else {
            [self showAlert:@"回复信息失败"];
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

@end
