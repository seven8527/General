//
//  MYSExpertGroupConfirmNetworkConsultViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-27.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConfirmNetworkConsultViewController.h"
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
#import "AppDelegate.h"
#import "HttpTool.h"
#import "MYSOrderModel.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PartnerConfig.h"
#import "MYSExpertGroupPatientRecordDataModel.h"

#define shortLineWidth (kScreen_Width - topButtonWidth * 3 - topSubViewMargin * 6)/6
#define lineTopMargin 20
#define topButtonWidth 21
#define topSubViewMargin 6.5
#define longLineWidth  2 * shortLineWidth


@interface MYSExpertGroupConfirmNetworkConsultViewController () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MYSExpertGroupChoosePayTypeViewDelegate,MYSExpertGroupConfirmExpandCellDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, assign) NSInteger currentTapIndex;
@property (nonatomic, assign) BOOL symptomOpenStatus;
@property (nonatomic, assign) BOOL questionOpenStatus;
@property (nonatomic, assign) BOOL helpOpenStatus;
@property (nonatomic, copy) NSString *payType; // 付款方式
@property (nonatomic, strong) MYSOrderModel *orderModel;
@end

@implementation MYSExpertGroupConfirmNetworkConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认信息";
    
    self.orderModel = [[MYSOrderModel alloc] init];
    
    self.symptomOpenStatus = NO;
    self.questionOpenStatus = NO;
    self.helpOpenStatus = NO;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 50) style:UITableViewStylePlain];
    //添加下滑手势
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    swipeDown.delegate = self;
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [mainTableView addGestureRecognizer:swipeDown];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView = mainTableView;
    [self.view addSubview:mainTableView];
    
    [self layoutTableViewHeaderView];
    
    [self layoutBottomView];
    
    
}


#pragma  mark LayoutUI

// 设置tableview的头部
- (void) layoutTableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 63)];
    headerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.mainTableView.tableHeaderView = headerView;
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, lineTopMargin, shortLineWidth, 3)];
    leftLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:leftLine];
    
    UIButton *firstButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLine.frame) + topSubViewMargin, 10, topButtonWidth, topButtonWidth)];
    firstButton.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    firstButton.layer.cornerRadius = 10.5;
    firstButton.clipsToBounds = YES;
    firstButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [firstButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [firstButton setTitle:@"1" forState:UIControlStateNormal];
    [headerView addSubview:firstButton];
    
    UIView *firstLongLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstButton.frame) + topSubViewMargin, lineTopMargin, longLineWidth, 3)];
    firstLongLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:firstLongLine];
    
    UIButton *secondButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstLongLine.frame) + topSubViewMargin, 10, topButtonWidth, topButtonWidth)];
    secondButton.backgroundColor = [UIColor colorFromHexRGB:K00907FColor];;
    secondButton.layer.cornerRadius = 10.5;
    secondButton.clipsToBounds = YES;
    secondButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [secondButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [secondButton setTitle:@"2" forState:UIControlStateNormal];
    [headerView addSubview:secondButton];
    
    UIView *secondLongLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondButton.frame) + topSubViewMargin, lineTopMargin, longLineWidth, 3)];
    secondLongLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:secondLongLine];
    
    UIButton *threeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondLongLine.frame) + topSubViewMargin, 10, topButtonWidth, topButtonWidth)];
    threeButton.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];;
    threeButton.layer.cornerRadius = 10.5;
    threeButton.clipsToBounds = YES;
    threeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [threeButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [threeButton setTitle:@"3" forState:UIControlStateNormal];
    [headerView addSubview:threeButton];
    
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(threeButton.frame) + topSubViewMargin, lineTopMargin, shortLineWidth, 3)];
    rightLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:rightLine];
    
    
    UILabel *fillInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/3, 12)];
    fillInfoLabel.textAlignment = NSTextAlignmentCenter;
    fillInfoLabel.text = @"填写就医资料";
    fillInfoLabel.font = [UIFont systemFontOfSize:12];
    fillInfoLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:fillInfoLabel];
    
    UILabel *confirmInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fillInfoLabel.frame), CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/3, 12)];
    confirmInfoLabel.font = [UIFont systemFontOfSize:12];
    confirmInfoLabel.textAlignment = NSTextAlignmentCenter;
    confirmInfoLabel.text = @"确认信息";
    confirmInfoLabel.textColor = [UIColor colorFromHexRGB:K00907FColor];
    [headerView addSubview:confirmInfoLabel];
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(confirmInfoLabel.frame), CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/3, 12)];
    payLabel.font = [UIFont systemFontOfSize:12];
    payLabel.textAlignment = NSTextAlignmentCenter;
    payLabel.text = @"在线支付";
    payLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:payLabel];
    
}


// 设置底部控件
- (void)layoutBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 50, kScreen_Width, 50)];
    bottomView.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    [bottomView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [bottomView.layer setBorderWidth:0.5];
    [self.view addSubview:bottomView];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 85 - 10, 7.5, 86, 35)];
    commitButton.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
    [commitButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    commitButton.layer.cornerRadius = 5;
    [commitButton.layer setBorderWidth:1];
    [commitButton.layer setBorderColor:[UIColor colorFromHexRGB:K00907FColor].CGColor];
    [commitButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    [commitButton setTitle:@"去支付" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(clickCommitButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:commitButton];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - CGRectGetWidth(commitButton.frame) - 24, 50)];
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.textAlignment = NSTextAlignmentRight;
    NSArray *words = @[@{@"付款:  ": [UIFont systemFontOfSize:14]},
                       @{[@"￥" stringByAppendingString:[self.askModel price]]: [UIFont systemFontOfSize:16]}];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *wordToColorMapping in words) {
        for (NSString *word in wordToColorMapping) {
            UIFont *font = [wordToColorMapping objectForKey:word];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor colorFromHexRGB:KEF8004Color], NSFontAttributeName : font};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
            [string appendAttributedString:subString];
        }
    }
    
    priceLabel.attributedText = string;
    [bottomView addSubview:priceLabel];
    
}

#pragma mark tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.consultType isEqualToString:@"网络咨询"]) {
        return 8;
    } else if([self.consultType isEqualToString:@"电话咨询"]){
        return 10;
    } else {
        return 9;
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
    expertGroupConsultChooseRecordCell.tipLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    expertGroupConsultChooseRecordCell.disclosureIndicator.hidden = YES;
    expertGroupConsultChooseRecordCell.disclosureIndicator.frame = CGRectZero;
    
    // 时间
    static NSString *addNewRecordVisitingTime = @"addNewRecordVisitingTime";
    MYSExpertGroupAddNewRecordVisitingTimeCell *addNewRecordVisitingTimeCell = [tableView dequeueReusableCellWithIdentifier:addNewRecordVisitingTime];
    if (addNewRecordVisitingTimeCell == nil) {
        addNewRecordVisitingTimeCell = [[MYSExpertGroupAddNewRecordVisitingTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addNewRecordVisitingTime];
    }
    addNewRecordVisitingTimeCell.valueTextField.textColor = [UIColor colorFromHexRGB:K747474Color];
    
    
    // 可展开cell
    static NSString *confirmExpand = @"confirmExpand";
    MYSExpertGroupConfirmExpandCell *expertGroupConfirmExpandCell = [tableView dequeueReusableCellWithIdentifier:confirmExpand];
    if (expertGroupConfirmExpandCell == nil) {
        expertGroupConfirmExpandCell = [[MYSExpertGroupConfirmExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:confirmExpand];
    }
    expertGroupConfirmExpandCell.titleTipLabel.font = [UIFont systemFontOfSize:14];
    expertGroupConfirmExpandCell.titleTipLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    expertGroupConfirmExpandCell.contentLabel.font = [UIFont systemFontOfSize:14];
    expertGroupConfirmExpandCell.contentLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row == 0) {
        expertGroupConsultDoctorCell.consultType = self.consultType;
        expertGroupConsultDoctorCell.askModel = self.askModel;
        expertGroupConsultDoctorCell.accessoryType = UITableViewCellAccessoryNone;
        expertGroupConsultDoctorCell.userInteractionEnabled = NO;
        return expertGroupConsultDoctorCell;
    } else if(indexPath.row == 1){
        expertGroupConsultSelectUserCell.patientModel = self.patientModel;
        expertGroupConsultSelectUserCell.textLabel.text = @"咨询用户";
        expertGroupConsultSelectUserCell.detailTextLabel.text = @"未选择";
        return expertGroupConsultSelectUserCell;
    } else if(indexPath.row == 2){
        expertGroupConsultChooseRecordCell.detailTextLabel.text = @"未选择";
        expertGroupConsultChooseRecordCell.tipLabel.text = @"就诊记录";
        expertGroupConsultChooseRecordCell.testArray = self.recordArray;
        expertGroupConsultChooseRecordCell.userInteractionEnabled = NO;
        return expertGroupConsultChooseRecordCell;
    } else if(indexPath.row == 3){
        addNewRecordVisitingTimeCell.valueTextField.enabled = NO;
        addNewRecordVisitingTimeCell.infoLabel.text = @"付款方式";
        addNewRecordVisitingTimeCell.selectionStyle = UITableViewCellSelectionStyleGray;
        addNewRecordVisitingTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        addNewRecordVisitingTimeCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
        addNewRecordVisitingTimeCell.valueTextField.placeholder = @"未选择";
        addNewRecordVisitingTimeCell.valueTextField.text = self.payType;
        return addNewRecordVisitingTimeCell;
    } else if(indexPath.row == 4){
//        expertGroupConfirmExpandCell.isOpen = self.symptomOpenStatus
//        expertGroupConfirmExpandCell.expandHeight = 57;
//        expertGroupConfirmExpandCell.contentStr = self.symptom;
//        expertGroupConfirmExpandCell.isOpen = self.symptomOpenStatus;
//        expertGroupConfirmExpandCell.tipStr = @"当前症状及体征";
//        expertGroupConfirmExpandCell.index = indexPath.row;
//        expertGroupConfirmExpandCell.delegate = self;
//        expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        expertGroupConfirmExpandCell.expandHeight = 57;
        expertGroupConfirmExpandCell.isOpen = self.symptomOpenStatus;
        expertGroupConfirmExpandCell.tipStr = @"当前症状及体征";
        expertGroupConfirmExpandCell.contentStr = self.symptom;
        expertGroupConfirmExpandCell.index = indexPath.row;
        expertGroupConfirmExpandCell.delegate = self;
        expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return expertGroupConfirmExpandCell;
    } else if (indexPath.row == 5) {
//        expertGroupConfirmExpandCell.expandHeight = 57;
//        expertGroupConfirmExpandCell.isOpen = self.questionOpenStatus;
//        expertGroupConfirmExpandCell.contentStr = self.situation;
//        expertGroupConfirmExpandCell.tipStr = @"咨询问题及以往就医情况";
//        expertGroupConfirmExpandCell.index = indexPath.row;
//        expertGroupConfirmExpandCell.delegate = self;
//        expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return expertGroupConfirmExpandCell;
        
        expertGroupConfirmExpandCell.expandHeight = 57;
        expertGroupConfirmExpandCell.isOpen = self.questionOpenStatus;
        expertGroupConfirmExpandCell.tipStr = @"咨询问题及以往就医情况";
        expertGroupConfirmExpandCell.contentStr = self.situation;
        expertGroupConfirmExpandCell.index = indexPath.row;
        expertGroupConfirmExpandCell.delegate = self;
        expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return expertGroupConfirmExpandCell;

        
    } else if (indexPath.row == 6){
//        expertGroupConfirmExpandCell.expandHeight = 57;
//        expertGroupConfirmExpandCell.isOpen = self.helpOpenStatus;
//        expertGroupConfirmExpandCell.contentStr = self.help;
//        expertGroupConfirmExpandCell.tipStr = @"希望得到医生何种帮助";
//        expertGroupConfirmExpandCell.index = indexPath.row;
//        expertGroupConfirmExpandCell.delegate = self;
//        expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return expertGroupConfirmExpandCell;
        
        expertGroupConfirmExpandCell.expandHeight = 57;
        expertGroupConfirmExpandCell.isOpen = self.helpOpenStatus;
        expertGroupConfirmExpandCell.tipStr = @"希望得到医生何种帮助";
        expertGroupConfirmExpandCell.contentStr = self.help;
        expertGroupConfirmExpandCell.index = indexPath.row;
        expertGroupConfirmExpandCell.delegate = self;
        expertGroupConfirmExpandCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return expertGroupConfirmExpandCell;

    } else if(indexPath.row == 8){
        expertGroupConsultSelectUserCell.model = nil;
        if ([self.consultType isEqualToString:@"电话咨询"]) {
            expertGroupConsultSelectUserCell.textLabel.text = @"期望咨询开始时间";
            expertGroupConsultSelectUserCell.detailTextLabel.text = self.consultStartTime;
        } else {
            expertGroupConsultSelectUserCell.textLabel.text = @"期望咨询时间";
            expertGroupConsultSelectUserCell.detailTextLabel.text = self.consultStartTime;
        }
        return expertGroupConsultSelectUserCell;
    } else if(indexPath.row == 9){
        expertGroupConsultSelectUserCell.model = nil;
        expertGroupConsultSelectUserCell.textLabel.text = @"期望咨询结束时间";
        expertGroupConsultSelectUserCell.detailTextLabel.text = self.consultEndTime;
        return expertGroupConsultSelectUserCell;
    } else {
        expertGroupConsultSelectUserCell.model = nil;
        expertGroupConsultSelectUserCell.textLabel.text = @"电话";
        expertGroupConsultSelectUserCell.detailTextLabel.text = self.phone;
        return expertGroupConsultSelectUserCell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        return 88;
    } else if (indexPath.row == 2) {
        if (self.recordArray.count == 2) {
            return 88;
        }else {
            return 44;
        }
    } else if(indexPath.row == 3){
        return 44;
    } else if (indexPath.row == 1){
        return 44;
    } else if(indexPath.row == 4){
        return [MYSFoundationCommon expandCellHeightWithText:self.symptom withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT) unExpandHeight:57 withOpenStatus:self.symptomOpenStatus topHeight:30 andBottomHeight:23 andBottomMargin:14];
    } else if (indexPath.row == 5) {
        return [MYSFoundationCommon expandCellHeightWithText:self.situation withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT) unExpandHeight:57 withOpenStatus:self.questionOpenStatus topHeight:30 andBottomHeight:23 andBottomMargin:14];
    } else if(indexPath.row == 6 ){
        return [MYSFoundationCommon expandCellHeightWithText:self.help withFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT) unExpandHeight:57 withOpenStatus:self.helpOpenStatus topHeight:30 andBottomHeight:23 andBottomMargin:14];
    } else {
        return 44;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        NSArray *imageArray = [NSArray arrayWithObjects:@"consult_icon_zfb_", nil];
        NSArray *titleArray = [NSArray arrayWithObjects:@"支付宝", nil];
        MYSExpertGroupChoosePayTypeView *payTypeView = [MYSExpertGroupChoosePayTypeView actionSheetWithCancelButtonTitle:@"取消" withImageArray:imageArray andTitleArray:titleArray];
        payTypeView.delegate = self;
        [payTypeView showInView:self.navigationController.view];
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
                
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 15, bounds.size.height-lineHeight, bounds.size.width - 15, lineHeight);
                
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


- (void)expertGroupConfirmExpandCellDidClickStatusWithIndex:(NSInteger)index andStatusOpen:(BOOL)isOpen
{
    self.currentTapIndex = index;
    
    if (index == 4) {
        self.symptomOpenStatus = isOpen;
        self.questionOpenStatus = NO;
        self.helpOpenStatus = NO;
        
    } else if (index == 5) {
        self.questionOpenStatus = isOpen;
        self.helpOpenStatus = NO;
        self.symptomOpenStatus = NO;
    } else if(index == 6){
        self.symptomOpenStatus = NO;
        self.questionOpenStatus = NO;
        self.helpOpenStatus = isOpen;
        
    }
    [self.mainTableView reloadData];
}


#pragma mark  MYSExpertGroupChoosePayTypeViewDelegate


- (void)actionSheet:(MYSExpertGroupChoosePayTypeView *)actionSheet payType:(NSString *)payType
{
    LOG(@"%@",payType);
    //    if ([payType isEqualToString:@"支付宝"]) {
    
    //    }
    
    self.payType = payType;
    
    [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

// 验证电话和患者
- (BOOL)validatePayType:(NSString *)payType
{
    if (self.payType.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

#pragma mark 提交订单

// 提交订单
- (void)clickCommitButton
{
    if ([self validatePayType:self.payType]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在提交";
        
        
        NSString *URLString = [kURL_ROOT stringByAppendingString:@"conorder/get_order"];
        NSString *type;
        if ([self.consultType isEqualToString:@"电话咨询"]) {
            type = @"1";
        } else if ([self.consultType isEqualToString:@"网络咨询"]) {
            type = @"0";
        } else {
            type = @"2";
        }
        
        NSString *payMode;
        
        if ([self.payType isEqualToString:@"支付宝"]) {
            payMode = @"1";
            //        } else if ([self.payModeName isEqualToString:@"网银"]) {
            //            payMode = @"2";
            //        } else if ([self.payModeName isEqualToString:@"网银转账"]) {
            //            payMode = @"3";
            //        } else if([self.payModeName isEqualToString:@"银行汇款"]) {
            //            payMode = @"4";
            //        } else {
            //            payMode = @"5";
        }
        
        if (self.help.length == 0) {
            self.help = @"";
        }
        
        MYSExpertGroupPatientRecordDataModel  *patientData = self.recordArray[0];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        if ([self.consultType isEqualToString:@"网络咨询"]) {
            NSDictionary *onlineConsult = @{@"cookie": ApplicationDelegate.cookie,@"uid": ApplicationDelegate.userId, @"type": type, @"doctor_id": self.askModel.expertId, @"pay_type":payMode, @"price": self.askModel.price, @"proid": self.askModel.productId, @"medical_id": patientData.recordID, @"sult": self.symptom, @"description": self.situation, @"question": self.help, @"patientid": self.patientModel.patientId, @"phone": self.phone};
            [parameters setDictionary:onlineConsult];
            
        } else if ([self.consultType isEqualToString:@"电话咨询"]) {
            
            NSDictionary *phoneConsult = @{@"cookie": ApplicationDelegate.cookie,@"uid": ApplicationDelegate.userId, @"type": type, @"doctor_id": self.askModel.expertId, @"pay_type":payMode, @"price": self.askModel.price, @"proid": self.askModel.productId, @"medical_id": patientData.recordID, @"sult": self.symptom, @"description": self.situation, @"question": self.help, @"patientid": self.patientModel.patientId, @"phone": self.phone, @"time_begin": self.consultStartTime, @"time_end": self.consultEndTime};
            [parameters setDictionary:phoneConsult];
            
            
        } else if ([self.consultType isEqualToString:@"面对面咨询"]) {
            NSDictionary *offlineConsult = @{@"cookie": ApplicationDelegate.cookie,@"uid": ApplicationDelegate.userId, @"type": type, @"doctor_id": self.askModel.expertId, @"pay_type":payMode, @"price": self.askModel.price, @"proid": self.askModel.productId, @"medical_id": patientData.recordID, @"sult": self.symptom, @"description": self.situation, @"question": self.help, @"patientid": self.patientModel.patientId, @"phone": self.phone,@"referral_date": self.consultStartTime };
            [parameters setDictionary:offlineConsult];
        }
        LOG(@"%@",self.help);
        [HttpTool post:URLString params:parameters success:^(id responseObject) {
            LOG(@"----%@", responseObject);
            [hud hide:YES];
                NSString *orderNumber = [responseObject objectForKey:@"billno"];
                self.orderModel.orderId = orderNumber;
                self.orderModel.orderPrice = self.askModel.price;
                self.orderModel.expertName = self.askModel.expertName;
                self.orderModel.expertTitle = self.consultType;
                self.orderModel.orderType = [payMode intValue];
                [self pay];
        } failure:^(NSError *error) {
            LOG(@"%@",error);
            [hud hide:YES];
        }];
        
    }
}

#pragma mark 支付

- (void)pay
{
    ApplicationDelegate.payEntrance = 1;
    if ([self.payType isEqualToString:@"支付宝"]) {
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
         */
        NSString *appScheme = @"MYSPatient";
        NSString *orderInfo = [self getOrderInfo:self.orderModel];
        NSString *signedStr = [self doRsa:orderInfo];
        
        LOG(@"signedStr:%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderInfo, signedStr, @"RSA"];
        LOG(@"%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            LOG(@"reslut = %@",resultDic);
            NSString *resultStatus = resultDic[@"resultStatus"];
            if([resultStatus isEqualToString:@"9000"])//成功代码
            {
                UIViewController <MYSExpertGroupPaySuccessViewrProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupPaySuccessViewrProtocol)];
                NSString *type;
                if ([self.consultType isEqualToString:@"电话咨询"]) {
                    type = @"1";
                } else if ([self.consultType isEqualToString:@"网络咨询"]) {
                    type = @"0";
                } else {
                    type = @"2";
                }
                viewController.consultType = type;
                if (self.patientModel.patientIcon.length > 5) {
                    viewController.patientImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.patientModel.patientIcon]]];
                } else {
                     viewController.patientImage = [UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:self.patientModel.patientSex andBirthday:self.patientModel.patientBirthday]];
                }
                viewController.orderId= self.orderModel.orderId;
                viewController.doctorPic = self.askModel.expertIcon;
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
                viewController.hidesBottomBarWhenPushed = NO;

            } else {
                UIViewController <MYSExpertGroupPayFailureViewProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupPayFailureViewProtocol)];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];

            }
        }];

    } else {

        
    }

}

-(NSString*)getOrderInfo:(MYSOrderModel *)orderModel
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = orderModel.orderId; //订单ID
    LOG(@"trade orderId:%@", orderModel.orderId);
    order.productName = orderModel.expertName; //商品标题
    order.productDescription = orderModel.expertTitle; //商品描述
    order.amount = orderModel.orderPrice; //商品价格
    order.notifyURL = [kURL_PAY stringByAppendingString:@"apliay/notify.php"]; //回调URL
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
//    self.orderId = orderModel.orderId;
    
    return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

//支持多手势识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)swipeDown
{
    [self.mainTableView endEditing:YES];
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
