//
//  MYSMyReplyDetailViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyReplyDetailViewController.h"
#import "MYSMyReplyDetailTableViewCell.h"

#define INPUT_VIEW_H 50
#define INPUT_TEXT_H 35
#define INPUT_BTN_W 65
#define kPadding 5

@interface MYSMyReplyDetailViewController ()
{
    CGFloat inputH;
    CGFloat inputTextH;
}

@end

@implementation MYSMyReplyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"咨询详情";
    [mTableView setBackgroundColor:[UIColor colorFromHexRGB:KEDEDEDColor]];
    [self.view setBackgroundColor:[UIColor colorFromHexRGB:KEDEDEDColor]];
    [self sendMyReplyDetailRequest];
    
    [self initInputView];
    [self addKeyboardNotification];
    
    isReply = YES;
    
    // 初始化时隐藏输入框
    [self resetTableViewFrame];
    
    mData = [[NSMutableArray alloc] init];
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [mTableView addGestureRecognizer:singleRecognizer];
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
    myReplyID = ID;
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
    inputH = kScreen_Height - kNavgBar_Height - kStatusBar_Height - inputView.frame.size.height - height;
    inputTextH = textView.frame.size.height;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            inputView.frame = CGRectMake(0, inputH, inputView.frame.size.width, inputView.frame.size.height);
        }];
    });
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            inputView.frame = CGRectMake(0, kScreen_Height - kNavgBar_Height - kStatusBar_Height - inputView.frame.size.height, inputView.frame.size.width, inputView.frame.size.height);
            mTableView.frame = CGRectMake(mTableView.frame.origin.x, mTableView.frame.origin.y, mTableView.frame.size.width, kScreen_Height- kNavgBar_Height - kStatusBar_Height- inputView.frame.size.height);
        }];
    });
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

- (void)initInputView
{
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - kNavgBar_Height - kStatusBar_Height - INPUT_VIEW_H, kScreen_Width, INPUT_VIEW_H)];
    [inputView setBackgroundColor:[UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1]];
    [self.view addSubview:inputView];
    
    textView = [[SZTextView alloc] initWithFrame:CGRectMake(10, (INPUT_VIEW_H - INPUT_TEXT_H) / 2, kScreen_Width - INPUT_BTN_W - 10 * 3, INPUT_TEXT_H)];
    textView.layer.borderColor = [[UIColor colorFromHexRGB:KB3B3B3Color] CGColor];
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 4;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.placeholder = @"输入内容";
    textView.delegate = self;
    [inputView addSubview:textView];

    replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 10 - INPUT_BTN_W, (INPUT_VIEW_H - INPUT_TEXT_H) / 2, INPUT_BTN_W, INPUT_TEXT_H)];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [replyBtn addTarget:self action:@selector(replyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [replyBtn setTitleColor:[UIColor colorFromHexRGB:K00907FColor]  forState:UIControlStateNormal];
    [replyBtn setBackgroundColor:[UIColor whiteColor]];
    replyBtn.layer.borderColor = [[UIColor colorFromHexRGB:K00907FColor] CGColor];
    replyBtn.layer.borderWidth = 1;
    replyBtn.layer.cornerRadius = 4;
    [inputView addSubview:replyBtn];
}

#pragma mark - Text View Delegate
- (void)textViewDidChange:(UITextView *)theTextView
{
    CGFloat height = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)].height + kPadding;
    
    if (height < 100)
    {
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, height);
        inputView.frame = CGRectMake(inputView.frame.origin.x, inputH - height + inputTextH, inputView.frame.size.width, height + 15);
        replyBtn.frame = CGRectMake(replyBtn.frame.origin.x, (inputView.frame.size.height - INPUT_TEXT_H) / 2, INPUT_BTN_W, INPUT_TEXT_H);
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
    //id dic = [mData objectAtIndex:indexPath.row];
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
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"myanswer_article"];
    
    if (!myReplyID || [@"" isEqualToString:myReplyID])
    {
        [hud hide:YES];
        [self showAlert:@"回复信息查询异常"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:myReplyID forKey:@"pfid"];
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        id main = [responseObject objectForKey:@"main"];
        NSString *state = [NSString stringWithFormat:@"%@", [main objectForKey:@"state"]];
        
        if (![@"-1" isEqualToString:state])
        {
            id main = [responseObject objectForKey:@"main"];
            id doctor = [main objectForKey:@"doctor"];
            id patient = [main objectForKey:@"patient"];
            id reply = [main objectForKey:@"reply"];
            isReply = [[main objectForKey:@"is_reply"] boolValue];
            replyID = [main objectForKey:@"pfid"];
            
            docPicUrl = [doctor objectForKey:@"pic"];
            docName = [doctor objectForKey:@"doctor_name"];
            
            NSArray *children = [responseObject objectForKey:@"children"];
            
            // 第一条患者提问
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSString *pName = @"未知用户";
            NSString *pSex = @"性别不详";
            NSString *ageStr = @"0";
            NSString *pPic = @"";
            if (patient && [NSNull null] != patient)
            {
                // 患者姓名
                pName = [patient objectForKey:@"patient_name"];
                // 患者性别
                pSex = @"男";
                if ([@"0" isEqualToString:[patient objectForKey:@"sex"]])
                {
                    pSex = @"女";
                }
                // 患者年龄
                ageStr = [MYSUtils getAgeFromID:[patient objectForKey:@"identity"]];
                if ([NSNull null] == ageStr)
                {
                    ageStr = @"0";
                }
                pPic = [patient objectForKey:@"pic"];
            }
            
            NSString *pAge = [NSString stringWithFormat:@"%@岁", ageStr];
            [dic setValue:[NSString stringWithFormat:@"%@  %@  %@", pName, pSex, pAge] forKey:@"name"];
            [dic setValue:[main objectForKey:@"question_title"] forKey:@"content"];
            [dic setValue:pPic forKey:@"pic"];
            [dic setValue:[main objectForKey:@"add_time"] forKey:@"add_time"];
            [dic setValue:@"0" forKey:@"kind"];
            [dic setValue:@"first" forKey:@"type"];
            [mData addObject:dic];

            if (isReply && reply && [NSNull null] != reply)
            {
                // 第一条医生回答
                dic = [[NSMutableDictionary alloc] init];
                [dic setValue:docName forKey:@"name"];
                [dic setValue:[reply objectForKey:@"content"] forKey:@"content"];
                [dic setValue:docPicUrl forKey:@"pic"];
                [dic setValue:[reply objectForKey:@"add_time"] forKey:@"add_time"];
                [dic setValue:@"1" forKey:@"kind"];
                [dic setValue:@"other" forKey:@"type"];
                [mData addObject:dic];
                
                if (children && [NSNull null] != children)
                {
                    for (id item in children)
                    {
                        // 非一次患者提问
                        dic = [[NSMutableDictionary alloc] init];
                        [dic setValue:pName forKey:@"name"];
                        [dic setValue:[item objectForKey:@"question_title"] forKey:@"content"];
                        [dic setValue:pPic forKey:@"pic"];
                        [dic setValue:[item objectForKey:@"add_time"] forKey:@"add_time"];
                        [dic setValue:@"0" forKey:@"kind"];
                        [dic setValue:@"other" forKey:@"type"];
                        
                        replyID = [item objectForKey:@"pfid"];
                        
                        [mData addObject:dic];
                        
                        isReply = [[item objectForKey:@"is_reply"] boolValue];
                        id nextReply = [item objectForKey:@"reply"];
                        
                        if (isReply && nextReply && [NSNull null] != nextReply)
                        {
                            // 非一次医生回答
                            dic = [[NSMutableDictionary alloc] init];
                            [dic setValue:[doctor objectForKey:@"doctor_name"] forKey:@"name"];
                            [dic setValue:[nextReply objectForKey:@"content"] forKey:@"content"];
                            [dic setValue:[doctor objectForKey:@"pic"] forKey:@"pic"];
                            [dic setValue:[nextReply objectForKey:@"add_time"] forKey:@"add_time"];
                            [dic setValue:@"1" forKey:@"kind"];
                            [dic setValue:@"other" forKey:@"type"];
                            [mData addObject:dic];
                        }
                    }
                }
            }
            if (isReply)
            {
                [self resetTableViewFrame];
            } else {
                inputView.hidden = NO;
            }
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

- (void)resetTableViewFrame
{
    inputView.hidden = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0 animations:^{
//            mTableView.frame = CGRectMake(mTableView.frame.origin.x, mTableView.frame.origin.y, mTableView.frame.size.width, kScreen_Height - kNavgBar_Height - kStatusBar_Height);
//        }];
//    });
    
    [self.view addSubview:mTableView];
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:mTableView
                                       attribute:NSLayoutAttributeBottom
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.view
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1
                                       constant:0];
    [self.view addConstraint:myConstraint];
}

#pragma mark
#pragma mark 发送我的回复请求
- (void)sendMyReplyRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"freeconsulta_answer"];
    
    if (!myReplyID || [@"" isEqualToString:myReplyID])
    {
        [hud hide:YES];
        [self showAlert:@"回复信息查询异常"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:replyID forKey:@"pfid"];
    [parameters setValue:userInfo.userId forKey:@"uid"];
    [parameters setValue:textView.text forKey:@"answer"];
    [parameters setValue:@"1" forKey:@"type"];
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSString *state = [[responseObject objectForKey:@"status"] stringValue];
        if ([@"1" isEqualToString:state])
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:docName forKey:@"name"];
            [dic setValue:textView.text forKey:@"content"];
            [dic setValue:docPicUrl forKey:@"pic"];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"yyyy/MM/dd HH:mm";
            [dic setValue:[format stringFromDate:[NSDate date]] forKey:@"add_time"];
            [dic setValue:@"1" forKey:@"kind"];
            [dic setValue:@"other" forKey:@"type"];
            [mData addObject:dic];
            
            // 回复完成后，变成不可回复状态
            isReply = YES;
            [self resetTableViewFrame];
            [mTableView reloadData];
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
