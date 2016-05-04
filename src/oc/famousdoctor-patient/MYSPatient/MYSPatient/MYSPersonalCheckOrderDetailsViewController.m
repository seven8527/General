//
//  MYSPersonalCheckOrderDetailsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalCheckOrderDetailsViewController.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "MYSExpertGroupConsultDoctorCell.h"
#import "MYSExpertGroupConsultSelectUserCell.h"
#import "MYSExpertGroupConsultDescriptionCell.h"
#import "MYSExpertGroupConsultChooseRecordCell.h"
#import "MYSExpertGroupAddNewRecordVisitingTimeCell.h"
#import "MYSExpertGroupChoosePayTypeView.h"
#import "MYSExpertGroupPaySuccessViewController.h"
#import "MYSExpertGroupConfirmExpandCell.h"
#import "HttpTool.h"
#import "MYSPersonalOrderDetailsModel.h"
#import "MYSPersonalOrderDetails.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MYSPersonalCheckOrderDetailsViewController () <UITableViewDataSource,UITableViewDelegate,MYSExpertGroupConfirmExpandCellDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *testRecordArray;
@property (nonatomic, assign) NSInteger currentTapIndex;
@property (nonatomic, assign) BOOL symptomOpenStatus;
@property (nonatomic, assign) BOOL questionOpenStatus;
@property (nonatomic, assign) BOOL helpOpenStatus;
@property (nonatomic, assign) BOOL answerStatus;
@property (nonatomic, strong)  MYSPersonalOrderDetailsModel *orderDetails;
@end

@implementation MYSPersonalCheckOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单查询";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.symptomOpenStatus = NO;
    self.questionOpenStatus = NO;
    self.helpOpenStatus = NO;
    self.answerStatus = NO;
    
    [self fetchPatientData];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (NSMutableArray *)testRecordArray
{
    if (_testRecordArray == nil) {
        _testRecordArray = [NSMutableArray array];
    }
    return _testRecordArray;
}

- (void)setDoctorPic:(NSString *)doctorPic
{
    _doctorPic = doctorPic;
}

#pragma mark tableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([self.consultType isEqualToString:@"0"]) { // 网络咨询
            return 5;
        } else if ([self.consultType isEqualToString:@"1"]) { // 电话咨询
            return 7;
        } else if ([self.consultType isEqualToString:@"2"]) { // 面对面咨询
            return 6;
        }
        return 6;
    } else {
        if ([self.consultType isEqualToString:@"0"]) {
            if (self.orderDetails.expertAnswer) {
                return 4;
            }
        }
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 医生介绍
    static NSString *expertGroupConsultDoctor = @"expertGroupConsultDoctor";
    MYSExpertGroupConsultDoctorCell *expertGroupConsultDoctorCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConsultDoctor];
    if (expertGroupConsultDoctorCell == nil) {
        expertGroupConsultDoctorCell = [[MYSExpertGroupConsultDoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expertGroupConsultDoctor];
    }
    expertGroupConsultDoctorCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 咨询用户
    static NSString *expertGroupConsultSelectUser = @"expertGroupConsultSelectUser";
    MYSExpertGroupConsultSelectUserCell *expertGroupConsultSelectUserCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConsultSelectUser];
    if (expertGroupConsultSelectUserCell == nil) {
        expertGroupConsultSelectUserCell = [[MYSExpertGroupConsultSelectUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:expertGroupConsultSelectUser];
    }
    expertGroupConsultSelectUserCell.nameLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    expertGroupConsultSelectUserCell.nameLabel.font = [UIFont systemFontOfSize:14];
    expertGroupConsultSelectUserCell.textLabel.textColor = [UIColor colorFromHexRGB:K484848Color];
    expertGroupConsultSelectUserCell.textLabel.font = [UIFont systemFontOfSize:16];
    expertGroupConsultSelectUserCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // 就诊记录
    static NSString *expertGroupConsultChooseRecord = @"expertGroupConsultChooseRecord";
    MYSExpertGroupConsultChooseRecordCell *expertGroupConsultChooseRecordCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConsultChooseRecord];
    if (expertGroupConsultChooseRecordCell == nil) {
        expertGroupConsultChooseRecordCell = [[MYSExpertGroupConsultChooseRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:expertGroupConsultChooseRecord];
    }
    expertGroupConsultChooseRecordCell.tipLabel.textColor = [UIColor colorFromHexRGB:K484848Color];
     expertGroupConsultChooseRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // 订单信息
    static NSString *personalCheckOrderDetailsInfo = @"personalCheckOrderDetailsInfo";
    UITableViewCell *personalCheckOrderDetailsInfoCell = [tableView dequeueReusableCellWithIdentifier:personalCheckOrderDetailsInfo];
    if (personalCheckOrderDetailsInfoCell == nil) {
        personalCheckOrderDetailsInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:personalCheckOrderDetailsInfo];
    }
    personalCheckOrderDetailsInfoCell.textLabel.textColor = [UIColor colorFromHexRGB:K484848Color];
    personalCheckOrderDetailsInfoCell.textLabel.font = [UIFont systemFontOfSize:16];
    personalCheckOrderDetailsInfoCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    personalCheckOrderDetailsInfoCell.detailTextLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    personalCheckOrderDetailsInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // 可展开cell
    static NSString *confirmExpand = @"confirmExpand";
    MYSExpertGroupConfirmExpandCell *expertGroupConfirmExpandCell = [tableView dequeueReusableCellWithIdentifier:confirmExpand];
    if (expertGroupConfirmExpandCell == nil) {
        expertGroupConfirmExpandCell = [[MYSExpertGroupConfirmExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:confirmExpand];
    }
    expertGroupConfirmExpandCell.titleTipLabel.font = [UIFont boldSystemFontOfSize:14];
    expertGroupConfirmExpandCell.titleTipLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    expertGroupConfirmExpandCell.contentLabel.font = [UIFont systemFontOfSize:14];
    expertGroupConfirmExpandCell.contentLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *consult = @"";
            if ([self.consultType isEqualToString:@"0"]) { // 网络咨询
                consult = @"网络咨询";
            } else if ([self.consultType isEqualToString:@"1"]) { // 电话咨询
                consult = @"电话咨询";
            } else if ([self.consultType isEqualToString:@"2"]) { // 面对面咨询
                consult = @"面对面咨询";
            }
            expertGroupConsultDoctorCell.consultType = consult;
            expertGroupConsultDoctorCell.askModel = [[MYSExpertGroupAskModel alloc] init];
            expertGroupConsultDoctorCell.accessoryType = UITableViewCellAccessoryNone;
            expertGroupConsultDoctorCell.userInteractionEnabled = NO;
            expertGroupConsultDoctorCell.orderDetails = self.orderDetails;
            expertGroupConsultDoctorCell.doctorPic = self.doctorPic;
            return expertGroupConsultDoctorCell;
        } else if(indexPath.row == 1){
            expertGroupConsultSelectUserCell.accessoryType = UITableViewCellAccessoryNone;
            expertGroupConsultSelectUserCell.model = nil;
            expertGroupConsultSelectUserCell.textLabel.text = @"咨询用户";
            expertGroupConsultSelectUserCell.nameLabel.text = self.orderDetails.patientName;
            expertGroupConsultSelectUserCell.patientPic = self.patientImage;
            expertGroupConsultSelectUserCell.textLabel.textColor = [UIColor colorFromHexRGB:K484848Color];
            return expertGroupConsultSelectUserCell;
        } else if(indexPath.row == 2){
            expertGroupConsultChooseRecordCell.disclosureIndicator.frame = CGRectZero;
            expertGroupConsultChooseRecordCell.disclosureIndicator.hidden = YES;
            expertGroupConsultChooseRecordCell.detailTextLabel.text = @"未选择";
            expertGroupConsultChooseRecordCell.tipLabel.text = @"就诊记录";
            expertGroupConsultChooseRecordCell.tipLabel.font = [UIFont systemFontOfSize:16];
            expertGroupConsultChooseRecordCell.testArray = self.testRecordArray;
            expertGroupConsultChooseRecordCell.firstLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
            expertGroupConsultChooseRecordCell.tipLabel.textColor = [UIColor colorFromHexRGB:K484848Color];
            return expertGroupConsultChooseRecordCell;
        } else if(indexPath.row == 3){
            personalCheckOrderDetailsInfoCell.textLabel.text = @"付款方式";
            personalCheckOrderDetailsInfoCell.accessoryType = UITableViewCellAccessoryNone;
            personalCheckOrderDetailsInfoCell.detailTextLabel.text = @"支付宝";
            return personalCheckOrderDetailsInfoCell;
        } else if (indexPath.row == 4) {
            personalCheckOrderDetailsInfoCell.textLabel.text = @"电话";
            personalCheckOrderDetailsInfoCell.accessoryType = UITableViewCellAccessoryNone;
            personalCheckOrderDetailsInfoCell.detailTextLabel.text = self.orderDetails.phone;
            return personalCheckOrderDetailsInfoCell;
        } else if(indexPath.row == 5){
            if ([self.consultType isEqualToString:@"2"]) {
                personalCheckOrderDetailsInfoCell.textLabel.text = @"期望咨询时间";
                personalCheckOrderDetailsInfoCell.detailTextLabel.text = self.orderDetails.expectTime;
            } else {
                 personalCheckOrderDetailsInfoCell.textLabel.text = @"期望咨询开始时间";
                personalCheckOrderDetailsInfoCell.detailTextLabel.text = self.orderDetails.expectStartTime;
            }
            personalCheckOrderDetailsInfoCell.accessoryType = UITableViewCellAccessoryNone;
            return personalCheckOrderDetailsInfoCell;
        } else {
            personalCheckOrderDetailsInfoCell.textLabel.text = @"期望咨询结束时间";
            personalCheckOrderDetailsInfoCell.detailTextLabel.text = self.orderDetails.expectEndTime;
            personalCheckOrderDetailsInfoCell.accessoryType = UITableViewCellAccessoryNone;
            return personalCheckOrderDetailsInfoCell;

        }
    } else {
        if(indexPath.row == 0){
            expertGroupConfirmExpandCell.expandHeight = 57;
            expertGroupConfirmExpandCell.isOpen = self.symptomOpenStatus;
            expertGroupConfirmExpandCell.tipStr = @"当前症状及体征";
            expertGroupConfirmExpandCell.index = indexPath.row;
            expertGroupConfirmExpandCell.delegate = self;
            expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
            expertGroupConfirmExpandCell.contentStr = self.orderDetails.symptom;
            return expertGroupConfirmExpandCell;
        } else if (indexPath.row == 1) {
            expertGroupConfirmExpandCell.expandHeight = 57;
            expertGroupConfirmExpandCell.isOpen = self.questionOpenStatus;
            expertGroupConfirmExpandCell.tipStr = @"咨询问题及以往就医情况";
            expertGroupConfirmExpandCell.index = indexPath.row;
            expertGroupConfirmExpandCell.delegate = self;
            expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
            expertGroupConfirmExpandCell.contentStr = self.orderDetails.desDetails;
            return expertGroupConfirmExpandCell;
            
        } else if(indexPath.row == 2){
            expertGroupConfirmExpandCell.expandHeight = 57;
            expertGroupConfirmExpandCell.isOpen = self.helpOpenStatus;
            expertGroupConfirmExpandCell.tipStr = @"希望得到医生何种帮助";
            expertGroupConfirmExpandCell.index = indexPath.row;
            expertGroupConfirmExpandCell.delegate = self;
            expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
            expertGroupConfirmExpandCell.contentStr = self.orderDetails.help;
            return expertGroupConfirmExpandCell;
        } else {
            expertGroupConfirmExpandCell.expandHeight = 57;
            expertGroupConfirmExpandCell.isOpen = self.answerStatus;
            expertGroupConfirmExpandCell.tipStr = @"医生回复";
            expertGroupConfirmExpandCell.index = indexPath.row;
            expertGroupConfirmExpandCell.delegate = self;
            expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
            expertGroupConfirmExpandCell.contentStr = self.orderDetails.expertAnswer;
            return expertGroupConfirmExpandCell;

        }
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 88;
        } else {
            return 44;
        }
    } else {
        if(indexPath.row == 0){
            return [MYSFoundationCommon expandCellHeightWithText:self.orderDetails.symptom withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT) unExpandHeight:57 withOpenStatus:self.symptomOpenStatus topHeight:30 andBottomHeight:23 andBottomMargin:14];
        } else if (indexPath.row == 1) {
            return [MYSFoundationCommon expandCellHeightWithText:self.orderDetails.desDetails withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT) unExpandHeight:57 withOpenStatus:self.questionOpenStatus topHeight:30 andBottomHeight:23 andBottomMargin:14];
        } else if(indexPath.row == 2){
            return [MYSFoundationCommon expandCellHeightWithText:self.orderDetails.help withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT) unExpandHeight:57 withOpenStatus:self.helpOpenStatus topHeight:30 andBottomHeight:23 andBottomMargin:14];
        } else if(indexPath.row == 3) {
            return [MYSFoundationCommon expandCellHeightWithText:self.orderDetails.expertAnswer withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT) unExpandHeight:57 withOpenStatus:self.answerStatus topHeight:30 andBottomHeight:23 andBottomMargin:14];
        }
    }
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeadrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    sectionHeadrView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
    topLine.alpha = 0.8;
    topLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [sectionHeadrView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 14.5, kScreen_Width, 0.5)];
    bottomLine.alpha = 0.8;
    bottomLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [sectionHeadrView addSubview:bottomLine];
    sectionHeadrView.frame = CGRectZero;
    if (section == 0) {
        topLine.hidden = YES;
    } else {
        topLine.hidden = NO;
    }
    return sectionHeadrView;
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
        
        if (tableView == self.tableView) {
            
            CGFloat cornerRadius = 0.f;
            
            cell.backgroundColor = UIColor.clearColor;
            
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            
            CGMutablePathRef pathRef = CGPathCreateMutable();
            
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
            
            BOOL addLine = NO;
            if (indexPath.section == 0) {
                if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    
                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                    
                } else if (indexPath.row == 0) {
                    
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                    
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                    
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                    
                    addLine = YES;
                }
                
            } else {
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
                    addLine = YES;
                } else {
                    
                    CGPathAddRect(pathRef, nil, bounds);
                    
                    addLine = YES;
                    
                }
            }
            layer.path = pathRef;
            
            CFRelease(pathRef);
            
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            
            
            if (addLine == YES) {
                
                CALayer *lineLayer = [[CALayer alloc] init];
                
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                if (indexPath.section == 1) {
                    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                    }else {
                       lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 15, bounds.size.height-lineHeight, bounds.size.width - 15, lineHeight);
                    }
                } else {
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 15, bounds.size.height-lineHeight, bounds.size.width - 15, lineHeight);
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


#pragma mark MYSExpertGroupConfirmExpandCellDelegate

- (void)expertGroupConfirmExpandCellDidClickStatusWithIndex:(NSInteger)index andStatusOpen:(BOOL)isOpen
{
    self.currentTapIndex = index;
    
    if (index == 0) {
        self.symptomOpenStatus = isOpen;
        self.questionOpenStatus = NO;
        self.helpOpenStatus = NO;
        self.answerStatus = NO;
    } else if (index == 1) {
        self.questionOpenStatus = isOpen;
        self.helpOpenStatus = NO;
        self.symptomOpenStatus = NO;
        self.answerStatus = NO;
    } else if(index == 2){
        self.symptomOpenStatus = NO;
        self.questionOpenStatus = NO;
        self.answerStatus = NO;
        self.helpOpenStatus = isOpen;
    } else if (index == 3) {
        self.symptomOpenStatus = NO;
        self.questionOpenStatus = NO;
        self.helpOpenStatus = NO;
        self.answerStatus = isOpen;

    }
    
    [self.tableView reloadData];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API methods

// 获取患者订单详情
- (void)fetchPatientData
{
    
    UIView *view = self.view.window;
    if (!view) {
        view = self.view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    [self.testRecordArray removeAllObjects];
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"conorder/view_order"];
    NSDictionary *parameters = @{@"billno": self.orderId, @"type": self.consultType};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"----%@", responseObject);
        if([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
        MYSPersonalOrderDetails *patient = [[MYSPersonalOrderDetails alloc] initWithDictionary:responseObject error:nil];
        self.orderDetails = patient.orderDetails;
        [self.testRecordArray addObject:patient.orderDetails.healthFile];
        [self.tableView reloadData];
        [hud hide:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单错误,请返回" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            [alert show];
            [hud hide:YES];
        }
        
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
