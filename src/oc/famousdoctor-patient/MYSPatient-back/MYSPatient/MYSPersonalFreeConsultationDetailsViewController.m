//
//  MYSPersonalFreeConsultationDetailsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalFreeConsultationDetailsViewController.h"
#import "MYSPersonalFreeConsultDetailsQuestionTableViewCell.h"
#import "MYSPersonalFreeConsultDetailsReplyTableViewCell.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "HttpTool.h"
#import "MYSFreeConsult.h"
#import "AppDelegate.h"

@interface MYSPersonalFreeConsultationDetailsViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UITextField *replyField;
@property (nonatomic, weak) UIButton *replyButton;
@property (nonatomic, strong) MYSFreeConsult *freeConsult;
@end

@implementation MYSPersonalFreeConsultationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"免费咨询详情";
    
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShow:)
                                                 name: UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHide:)
                                                 name: UIKeyboardWillHideNotification object:nil];
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView = mainTableView;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    
    [self layoutBottomView];
}

- (void)layoutBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 49, kScreen_Width, 49)];
    bottomView.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    bottomView.hidden = YES;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    lineView.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [bottomView addSubview:lineView];
    
    UITextField *replyField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, kScreen_Width -20 - 65 - 7, 35)];
    replyField.leftViewMode = UITextFieldViewModeAlways;
    replyField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    replyField.placeholder = @"回复医生";
    replyField.layer.borderWidth = 1.0;
    replyField.layer.borderColor = [UIColor colorFromHexRGB:KC2C2C2Color].CGColor;
    replyField.layer.cornerRadius = 5;
    replyField.clipsToBounds = YES;
    self.replyField = replyField;
    replyField.delegate = self;
    [bottomView addSubview:replyField];
    
    UIButton *replyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(replyField.frame) + 7, 7, 65, 35)];
    replyButton.layer.borderWidth = 1.0;
    replyButton.layer.borderColor = [UIColor colorFromHexRGB:K00907FColor].CGColor;
    [replyButton setTitle:@"回复" forState:UIControlStateNormal];
    replyButton.layer.cornerRadius = 5.0;
    replyButton.clipsToBounds = YES;
    [replyButton addTarget:self action:@selector(clickReplyButton) forControlEvents:UIControlEventTouchUpInside];
    [replyButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    [bottomView addSubview:replyButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    self.mainTableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height-50);
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIKeyboardDidShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIKeyboardDidHideNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 10;

    if ([[[self.freeConsult.plusAskArray lastObject] isReply] isEqualToString:@"1"]) {
        return (self.freeConsult.plusAskArray.count + 1) * 2;
    } else {
        if (self.freeConsult.plusAskArray.count > 0) {
            return (self.freeConsult.plusAskArray.count + 1) * 2 - 1;
        } else {
            if ([self.freeConsult.briefAskModel.isReply isEqualToString:@"1"]) {
                return 2;
            } else {
                return 1;
            }
        }
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *freeConsultDetailsQuestion = @"freeConsultDetailsQuestion";
    MYSPersonalFreeConsultDetailsQuestionTableViewCell *freeConsultDetailsQuestionCell = [tableView dequeueReusableCellWithIdentifier:freeConsultDetailsQuestion];
    if (freeConsultDetailsQuestionCell == nil) {
        freeConsultDetailsQuestionCell = [[MYSPersonalFreeConsultDetailsQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:freeConsultDetailsQuestion];
    }
    
    static NSString *freeConsultDetailsReply = @"freeConsultDetailsReply";
    MYSPersonalFreeConsultDetailsReplyTableViewCell *freeConsultDetailsReplyCell = [tableView dequeueReusableCellWithIdentifier:freeConsultDetailsReply];
    if (freeConsultDetailsReplyCell == nil) {
        freeConsultDetailsReplyCell = [[MYSPersonalFreeConsultDetailsReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:freeConsultDetailsReply];
    }
    
    if (indexPath.row == 0) {
        if(self.freeConsult.briefAskModel) {
            freeConsultDetailsQuestionCell.briefAskModel = self.freeConsult.briefAskModel;
        }
        return freeConsultDetailsQuestionCell;
    } else {
        if (indexPath.row == 1) {
            freeConsultDetailsReplyCell.userInfoModel = self.freeConsult.briefAskModel.doctorModel;
            freeConsultDetailsReplyCell.contentModel = self.freeConsult.briefAskModel.answerModel;
        } else {
            if (indexPath.row %2 == 0) {
                 freeConsultDetailsReplyCell.userInfoModel = self.freeConsult.briefAskModel.patientModel;
                freeConsultDetailsReplyCell.contentModel = self.freeConsult.plusAskArray[indexPath.row/2 - 1];
               
            } else {
                 freeConsultDetailsReplyCell.userInfoModel = self.freeConsult.briefAskModel.doctorModel;
                freeConsultDetailsReplyCell.contentModel = [self.freeConsult.plusAskArray[indexPath.row/2 - 1] answerModel];
                
            }
        }
        return freeConsultDetailsReplyCell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return [MYSFoundationCommon sizeWithText:self.freeConsult.briefAskModel.question withFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(kScreen_Width - 30, MAXFLOAT)].height + 55 + 14;
    } else {
        if (indexPath.row == 1) {
            return [MYSFoundationCommon sizeWithText:self.freeConsult.briefAskModel.answerModel.content withFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(kScreen_Width - 30, MAXFLOAT)].height + 55 + 14;
        } else {
            if (indexPath.row %2 == 0) {
                return [MYSFoundationCommon sizeWithText:[self.freeConsult.plusAskArray[indexPath.row/2 - 1] question] withFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(kScreen_Width - 70, MAXFLOAT)].height + 55 + 14;
            } else {
                return [MYSFoundationCommon sizeWithText:[[self.freeConsult.plusAskArray[indexPath.row/2 - 1] answerModel] content] withFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(kScreen_Width - 70, MAXFLOAT)].height + 55 + 14;
            }
        }
    }
}




/**
 *  设置cell的圆角及分割线
 *
 *  @param tableView taleview
 *  @param cell      cell
 *  @param indexPath indexpath
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        
        if (tableView == self.mainTableView) {
            
            CGFloat cornerRadius = 0.f;
            
            cell.backgroundColor = UIColor.clearColor;
            
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            
            CGMutablePathRef pathRef = CGPathCreateMutable();
            
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
            
            BOOL addLine = NO;
            
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                
            } else if (indexPath.row == 0) {
                
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                
                addLine = YES;
                
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
                
            } else {
                
                CGPathAddRect(pathRef, nil, bounds);
                
                addLine = YES;
                
            }
            
            layer.path = pathRef;
            
            CFRelease(pathRef);
            
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            
            
            if (addLine == YES) {
                
                CALayer *lineLayer = [[CALayer alloc] init];
                
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                if(indexPath.row == 0) {
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                } else {
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 50, bounds.size.height-lineHeight, bounds.size.width - 50, lineHeight);
                }
                lineLayer.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color].CGColor;
                
                [layer addSublayer:lineLayer];
                
            }
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            
            [testView.layer insertSublayer:layer atIndex:0];
            
            testView.backgroundColor = UIColor.clearColor;
            
            cell.backgroundView = testView;
            
        }
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//自定义键盘打开时触发的事件
-(void) keyboardShow: (NSNotification *)notif
{
    [UIView animateWithDuration:[[notif.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue]animations:^{
        LOG(@"%f",[[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height);
//        CGFloat height = self.addNewUserView.frame.size.height;
        self.mainTableView.frame =  CGRectMake(0, 0, kScreen_Width, kScreen_Height - [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height - 49 - 44);
        self.bottomView.frame = CGRectMake(0, kScreen_Height - 49 - [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height - 44 , kScreen_Width, 49);
    }];
}

//自定义键盘关闭时触发的事件
-(void) keyboardHide: (NSNotification *)notif {
    [UIView animateWithDuration:[[notif.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue]animations:^{
//        CGFloat height = self.addNewUserView.frame.size.height;
        self.mainTableView.frame =  CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        self.bottomView.frame = CGRectMake(0, kScreen_Height - 49, kScreen_Width, 49);
    }];
    
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setPfid:(NSString *)pfid
{
    _pfid = pfid;
    
    [self fetchConsultDetails];
    
}


- (void)clickReplyButton
{
    if ([self validateQuestion:self.replyField.text andPatientID:self.freeConsult.briefAskModel.patientID andPfid:self.freeConsult.briefAskModel.pfID]) {
        [self freeConsultPlusQuestion:self.replyField.text andPatientID:self.freeConsult.briefAskModel.patientID andPfid:self.freeConsult.briefAskModel.pfID];
    }
}

#pragma mark - Validate

// 验证电话和患者
- (BOOL)validateQuestion:(NSString *)question andPatientID:(NSString *)patientID andPfid:(NSString *)pfid
{
    
    if (patientID == nil || [patientID length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择咨询者" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (question.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写咨询问题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (question.length > 500) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写500字以内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

#pragma mark - API methods

// 获取免费咨询详情
- (void)fetchConsultDetails
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"view_consultation"];
    NSDictionary *parameters = @{@"pfid": self.pfid};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%@", responseObject);
        MYSFreeConsult *freeConsult = [[MYSFreeConsult alloc] initWithDictionary:responseObject error:nil];
        self.freeConsult = freeConsult;
        if(freeConsult.plusAskArray.count > 0){
            if ([[[freeConsult.plusAskArray lastObject] isReply] isEqualToString:@"1"]) {
                self.mainTableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height - 40);
                self.bottomView.hidden = NO;
            } else {
                self.mainTableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
                self.bottomView.hidden = YES;
            }
        } else {
            if([freeConsult.briefAskModel.isReply isEqualToString:@"1"]){
                self.mainTableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height - 40);
                self.bottomView.hidden = NO;
            } else {
                self.mainTableView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
                self.bottomView.hidden = YES;
            }
        }
        LOG(@"%@",freeConsult);
        [self.mainTableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"\n----------------------------------------------------------%@",error);
        [hud hide:YES];
    }];
    
}


// 调用后台免费咨询接口
- (void)freeConsultPlusQuestion:(NSString *)question andPatientID:(NSString *)patientID andPfid:(NSString *)pfid
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"free_consult"];
    NSDictionary *parameters = @{@"pfid": pfid, @"uid": ApplicationDelegate.userId, @"pid": patientID, @"question_title": question,@"cookie": ApplicationDelegate.cookie};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        int state = [[responseObject valueForKey:@"state"] intValue];
        if (state == 1) {
            hud.labelText = @"提交成功";
            self.freeConsult = nil;
            [self.replyField resignFirstResponder];
            [hud hide:YES afterDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fetchConsultDetails];
            });
            
        } else {
            hud.labelText = @"提交失败";
            [self.replyField resignFirstResponder];
            [hud hide:YES afterDelay:1];
        }

    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
    }];
}



@end
