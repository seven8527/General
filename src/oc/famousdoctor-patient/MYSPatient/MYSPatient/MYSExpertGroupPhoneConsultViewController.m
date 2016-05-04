//
//  MYSExpertGroupPhoneConsultViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-27.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupPhoneConsultViewController.h"
#import "UIColor+Hex.h"	#import "MYSFoundationCommon.h"
#import "MYSExpertGroupConsultDoctorCell.h"
#import "MYSExpertGroupConsultSelectUserCell.h"
#import "MYSExpertGroupConsultDescriptionCell.h"
#import "MYSExpertGroupConsultChooseRecordCell.h"
#import "MYSExpertGroupAddNewRecordTextFiledCell.h"
#import "MYSExpertGroupAddNewRecordVisitingTimeCell.h"
#import "UUDatePicker.h"
#import "MYSExpertGroupAskModel.h"
#import "MYSExpertGroupPatientModel.h"
#import "HttpTool.h"
#import "ValidateTools.h"

#define shortLineWidth (kScreen_Width - topButtonWidth * 3 - topSubViewMargin * 6)/6
#define lineTopMargin 20
#define topButtonWidth 21
#define topSubViewMargin 6.5
#define longLineWidth  2 * shortLineWidth

@interface MYSExpertGroupPhoneConsultViewController ()  <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MYSExpertGroupConsultChooseUserViewControllerDelegate,MYSExpertGroupDetailsDescriptionViewControllerDelegate,MYSExpertGroupConsultChooseMedicalRecordsViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *testRecordArray;
@property (nonatomic, strong) UITextField *consultStartTimeFiled;
@property (nonatomic, strong) UITextField *consultEndTimeFiled;
@property (nonatomic, strong) UUDatePicker *datePicker;
@property (nonatomic, strong) UITextView *descriptionView;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) MYSExpertGroupAskModel *askModel;
@property (nonatomic, weak) UILabel *priceLabel; // 价格
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@property (nonatomic, copy) NSString *symptom; // 症状
@property (nonatomic, copy) NSString *situation; // 就医情况
@property (nonatomic, copy) NSString *help; // 何种帮助
@end

@implementation MYSExpertGroupPhoneConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电话咨询";
    
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShow:)
                                                 name: UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHide:)
                                                 name: UIKeyboardWillHideNotification object:nil];
    
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
    
    [self layoutTableViewFooterView];
    
}
- (void)setDoctorId:(NSString *)doctorId
{
    _doctorId = doctorId;
    
    [self fetchAsk];
}


- (NSMutableArray *)testRecordArray
{
    if (_testRecordArray == nil) {
        _testRecordArray = [NSMutableArray arrayWithObjects:@"未选择", nil];
    }
    return _testRecordArray;
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
    firstButton.backgroundColor = [UIColor colorFromHexRGB:K00907FColor];
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
    secondButton.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];;
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
    fillInfoLabel.textColor = [UIColor colorFromHexRGB:K00907FColor];
    [headerView addSubview:fillInfoLabel];
    
    UILabel *confirmInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fillInfoLabel.frame), CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/3, 12)];
    confirmInfoLabel.font = [UIFont systemFontOfSize:12];
    confirmInfoLabel.textAlignment = NSTextAlignmentCenter;
    confirmInfoLabel.text = @"确认信息";
    confirmInfoLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:confirmInfoLabel];
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(confirmInfoLabel.frame), CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/3, 12)];
    payLabel.font = [UIFont systemFontOfSize:12];
    payLabel.textAlignment = NSTextAlignmentCenter;
    payLabel.text = @"在线支付";
    payLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:payLabel];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headerView.frame) - 1, kScreen_Width, 1)];
    bottomLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    bottomLine.alpha = 0.8;
    [headerView addSubview:bottomLine];
    
}

- (void)layoutTableViewFooterView
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    topLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    topLine.alpha = 0.5;
    [footerView addSubview:topLine];
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreen_Width - 20, 13)];
    tipLabel.text = @"用户咨询须知";
    tipLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:tipLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    // 段落设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = 25.f;
    paragraphStyle.minimumLineHeight = 15.f;
    paragraphStyle.firstLineHeadIndent = 0.f;
    paragraphStyle.headIndent = 6.f;
    paragraphStyle.lineSpacing = 5.f;
    paragraphStyle.alignment = NSTextAlignmentNatural;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorFromHexRGB:K9E9E9EColor]};
    contentLabel.attributedText = [[NSAttributedString alloc] initWithString:@"1 请您真实、全面地填写相关内容;\n2 您提交的资料越详细，专家的建议越准确;\n3 如有疑问请致电客服热线4006-118-221，我们的工作时间为周一至周日早8点————晚21点。" attributes:attributes];
    CGSize contentSize = [contentLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    contentLabel.frame = CGRectMake(10, CGRectGetMaxY(tipLabel.frame) + 10, contentSize.width, contentSize.height);
    [footerView addSubview:contentLabel];
    footerView.frame = CGRectMake(0, 0, kScreen_Width, CGRectGetMaxY(contentLabel.frame));
    self.mainTableView.tableFooterView = footerView;
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
    [commitButton addTarget:self action:@selector(clickCommitButton) forControlEvents:UIControlEventTouchUpInside];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [bottomView addSubview:commitButton];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - CGRectGetWidth(commitButton.frame) - 24, 50)];
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel = priceLabel;
    [bottomView addSubview:priceLabel];
    
}


#pragma mark tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    } else {
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
    
    // 咨询用户
    static NSString *expertGroupConsultSelectUser = @"expertGroupConsultSelectUser";
    MYSExpertGroupConsultSelectUserCell *expertGroupConsultSelectUserCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConsultSelectUser];
    if (expertGroupConsultSelectUserCell == nil) {
        expertGroupConsultSelectUserCell = [[MYSExpertGroupConsultSelectUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:expertGroupConsultSelectUser];
    }
    expertGroupConsultSelectUserCell.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    expertGroupConsultSelectUserCell.textLabel.font = [UIFont systemFontOfSize:16];
    expertGroupConsultSelectUserCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
         expertGroupConsultSelectUserCell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    // 帮助cell
    static NSString *expertGroupAddNewRecordTextFiled = @"ExpertGroupAddNewRecordTextFiledCell";
    MYSExpertGroupAddNewRecordTextFiledCell * expertGroupAddNewRecordTextFiledCell = [tableView dequeueReusableCellWithIdentifier:expertGroupAddNewRecordTextFiled];
    if (expertGroupAddNewRecordTextFiledCell == nil) {
        expertGroupAddNewRecordTextFiledCell = [[MYSExpertGroupAddNewRecordTextFiledCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:expertGroupAddNewRecordTextFiled];
    }
    expertGroupAddNewRecordTextFiledCell.textLabel.font = [UIFont systemFontOfSize:16];
    expertGroupAddNewRecordTextFiledCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    expertGroupAddNewRecordTextFiledCell.detailTextLabel.textColor = [UIColor colorWithRed:196/255 green:196/255 blue:196/255 alpha:0.3];
    expertGroupAddNewRecordTextFiledCell.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    expertGroupAddNewRecordTextFiledCell.infoLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    expertGroupAddNewRecordTextFiledCell.infoLabel.text = @"";
    
    
    // 就诊记录
    static NSString *expertGroupConsultChooseRecord = @"expertGroupConsultChooseRecord";
    MYSExpertGroupConsultChooseRecordCell *expertGroupConsultChooseRecordCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConsultChooseRecord];
    if (expertGroupConsultChooseRecordCell == nil) {
        expertGroupConsultChooseRecordCell = [[MYSExpertGroupConsultChooseRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:expertGroupConsultChooseRecord];
    }
    expertGroupConsultChooseRecordCell.tipLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    
    
    MYSExpertGroupAddNewRecordVisitingTimeCell *addNewRecordVisitingTimeCell = [[MYSExpertGroupAddNewRecordVisitingTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            expertGroupConsultDoctorCell.consultType = @"电话咨询";
            expertGroupConsultDoctorCell.askModel = self.askModel;
            expertGroupConsultDoctorCell.accessoryType = UITableViewCellAccessoryNone;
            expertGroupConsultDoctorCell.userInteractionEnabled = NO;
            return expertGroupConsultDoctorCell;
        } else if(indexPath.row == 1){
            expertGroupConsultSelectUserCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            expertGroupConsultSelectUserCell.model = self.patientModel;
            expertGroupConsultSelectUserCell.textLabel.text = @"咨询用户";
            expertGroupConsultSelectUserCell.detailTextLabel.text = @"未选择";
            return expertGroupConsultSelectUserCell;
        } else if(indexPath.row == 2){
            expertGroupConsultChooseRecordCell.detailTextLabel.text = @"未选择";
            expertGroupConsultChooseRecordCell.tipLabel.text = @"就诊记录";
            expertGroupConsultChooseRecordCell.testArray = self.testRecordArray;
            return expertGroupConsultChooseRecordCell;
        } else if(indexPath.row == 3){
            expertGroupAddNewRecordTextFiledCell.valueTextField.enabled = NO;
            expertGroupAddNewRecordTextFiledCell.textLabel.text = @"当前症状与体征";
              expertGroupAddNewRecordTextFiledCell.infoLabel.text = @"";
            expertGroupAddNewRecordTextFiledCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            expertGroupAddNewRecordTextFiledCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
            expertGroupAddNewRecordTextFiledCell.valueTextField.placeholder = @"";
            expertGroupAddNewRecordTextFiledCell.valueTextField.alpha = 0;
            if(self.symptom.length > 0) {
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.text = @"已填写";
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
            } else {
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.text = @"未填写";
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
            }
            expertGroupAddNewRecordTextFiledCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            return expertGroupAddNewRecordTextFiledCell;
        } else if (indexPath.row == 4) {
            expertGroupAddNewRecordTextFiledCell.valueTextField.enabled = NO;
            expertGroupAddNewRecordTextFiledCell.textLabel.text = @"咨询问题及以往就医情况";
              expertGroupAddNewRecordTextFiledCell.infoLabel.text = @"";
            expertGroupAddNewRecordTextFiledCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            expertGroupAddNewRecordTextFiledCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
            expertGroupAddNewRecordTextFiledCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            expertGroupAddNewRecordTextFiledCell.valueTextField.placeholder = @"";
            expertGroupAddNewRecordTextFiledCell.valueTextField.alpha = 0;
            if(self.situation.length > 0) {
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.text = @"已填写";
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
            } else {
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.text = @"未填写";
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
            }
            return expertGroupAddNewRecordTextFiledCell;
        } else {
            expertGroupAddNewRecordTextFiledCell.valueTextField.enabled = NO;
            expertGroupAddNewRecordTextFiledCell.infoLabel.text = @"";
            expertGroupAddNewRecordTextFiledCell.textLabel.text = @"希望得到医生何种帮助";
            expertGroupAddNewRecordTextFiledCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            expertGroupAddNewRecordTextFiledCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            expertGroupAddNewRecordTextFiledCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
            expertGroupAddNewRecordTextFiledCell.valueTextField.placeholder = @"";
            expertGroupAddNewRecordTextFiledCell.valueTextField.alpha = 0;
            if(self.help.length > 0) {
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.text = @"已填写";
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
            } else {
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.text = @"未填写";
                expertGroupAddNewRecordTextFiledCell.detailTextLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
            }
            return expertGroupAddNewRecordTextFiledCell;
        }
    } else {
        if (indexPath.row == 0) {
            expertGroupAddNewRecordTextFiledCell.valueTextField.enabled = YES;
            expertGroupAddNewRecordTextFiledCell.infoLabel.text = @"电话";
            expertGroupAddNewRecordTextFiledCell.textLabel.text = @"";
            expertGroupAddNewRecordTextFiledCell.selectionStyle = UITableViewCellSelectionStyleNone;
            expertGroupAddNewRecordTextFiledCell.valueTextField.placeholder = @"未填写";
            expertGroupAddNewRecordTextFiledCell.valueTextField.alpha = 1;
            expertGroupAddNewRecordTextFiledCell.detailTextLabel.text = @"";
            expertGroupAddNewRecordTextFiledCell.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            expertGroupAddNewRecordTextFiledCell.accessoryType = UITableViewCellAccessoryNone;
            _phoneTextField = expertGroupAddNewRecordTextFiledCell.valueTextField;
            _phoneTextField.delegate = self;
            return expertGroupAddNewRecordTextFiledCell;
            
        } else if(indexPath.row == 1){
            addNewRecordVisitingTimeCell.valueTextField.enabled = NO;
            addNewRecordVisitingTimeCell.infoLabel.text = @"期望咨询开始时间";
            addNewRecordVisitingTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            addNewRecordVisitingTimeCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
            addNewRecordVisitingTimeCell.valueTextField.placeholder = @"未选择";
            _consultStartTimeFiled = addNewRecordVisitingTimeCell.valueTextField;
            return addNewRecordVisitingTimeCell;
        } else {
            addNewRecordVisitingTimeCell.valueTextField.enabled = NO;
            addNewRecordVisitingTimeCell.infoLabel.text = @"期望咨询结束时间";
            addNewRecordVisitingTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            addNewRecordVisitingTimeCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
            addNewRecordVisitingTimeCell.valueTextField.placeholder = @"未选择";
            _consultEndTimeFiled = addNewRecordVisitingTimeCell.valueTextField;
            return addNewRecordVisitingTimeCell;
        }
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            return 88;
        } else if (indexPath.row == 2) {
            if (self.testRecordArray.count == 2) {
                return 88;
            }else {
                return 44;
            }
        } else {
            return 44;
        }
        
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    } else {
        return 15;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeadrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    if(section == 1) {
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
        topLine.alpha = 0.8;
        topLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
        [sectionHeadrView addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 14.5, kScreen_Width, 0.5)];
        bottomLine.alpha = 0.8;
        bottomLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
        [sectionHeadrView addSubview:bottomLine];
    } else {
        sectionHeadrView.frame = CGRectZero;
    }
    return sectionHeadrView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIViewController <MYSExpertGroupConsultChooseUserViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultChooseUserViewControllerProtocol)];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        } else if (indexPath.row == 2) {
            if (self.patientModel.patientId) {
                UIViewController <MYSExpertGroupConsultChooseMedicalRecordsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultChooseMedicalRecordsViewControllerProtocol)];
                viewController.delegate = self;
                viewController.patientModel = self.patientModel;
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择患者" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            
        } else if (indexPath.row == 3) {
            UIViewController <MYSExpertGroupDetailsDescriptionViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDetailsDescriptionViewControllerProtocol)];
            viewController.mark = 1;
            viewController.tipText = @"当前最主要的异常感受与表现（症状与体征）";
            viewController.contentStr = self.symptom;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        } else if (indexPath.row == 4) {
            UIViewController <MYSExpertGroupDetailsDescriptionViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDetailsDescriptionViewControllerProtocol)];
            viewController.tipText = @"当前最主要的异常感受与表现（症状与体征）";
            viewController.mark = 2;
            viewController.contentStr = self.situation;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        } else if (indexPath.row == 5) {
            UIViewController <MYSExpertGroupDetailsDescriptionViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDetailsDescriptionViewControllerProtocol)];
            viewController.delegate = self;
            viewController.mark = 3;
            viewController.contentStr = self.help;
            viewController.tipText = @"当前最主要的异常感受与表现（症状与体征）";
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else {
        [self swipeDown];
        self.mainTableView.frame = CGRectMake(0, -200 + 50, kScreen_Width, kScreen_Height - 50);
        if (indexPath.row == 1) {
            [self featchCurrentTimeWithIndex:indexPath.row];
            [self setupDataPickerWithIndex:indexPath.row];
        } else if (indexPath.row == 2) {
            [self featchCurrentTimeWithIndex:indexPath.row];
            [self setupDataPickerWithIndex:indexPath.row];
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 键盘通知

//自定义键盘打开时触发的事件
-(void) keyboardShow: (NSNotification *)notif
{
    
    [UIView animateWithDuration:[[notif.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue]animations:^{
        LOG(@"%f",[[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height);
        CGFloat height = self.mainTableView.frame.size.height;
        self.mainTableView.frame =  CGRectMake(0, - [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height + 50, kScreen_Width, height);
    }];
}

//自定义键盘关闭时触发的事件
-(void) keyboardHide: (NSNotification *)notif {
    [UIView animateWithDuration:[[notif.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue]animations:^{
        CGFloat height = self.mainTableView.frame.size.height;
        self.mainTableView.frame =  CGRectMake(0, 0, kScreen_Width, height);
    }];
    
}


// 获取当前时间
- (void)featchCurrentTimeWithIndex:(NSInteger )index
{
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    NSInteger y = [dd year];
    NSInteger m = [dd month];
    NSInteger d = [dd day];
    
    NSInteger hour = [dd hour];
    NSInteger min = [dd minute];
    if (index == 1) {
        _consultStartTimeFiled.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)y,(long)m,(long)d,(long)hour,(long)min];
    } else {
        _consultEndTimeFiled.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)y,(long)m,(long)d,(long)hour,(long)min];;
    }
}

#pragma mark MYSExpertGroupDetailsDescriptionViewControllerDelegate

- (void)expertGroupDetailsDescriptionViewSavedWithContentStr:(NSString *)contentStr withMark:(int)mark
{
    if (mark == 1) {
        self.symptom = contentStr;
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } else if (mark == 2) {
        self.situation = contentStr;
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        self.help = contentStr;
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark MYSExpertGroupConsultChooseUserViewControllerDelegate

- (void)expertGroupConsultChooseUserViewControllerDidSelected:(MYSExpertGroupPatientModel *)patientModel
{
    self.patientModel = patientModel;
     [self.testRecordArray replaceObjectAtIndex:0 withObject:@"未选择"];
    [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark MYSExpertGroupConsultChooseMedicalRecordsViewControllerDelegate
- (void)expertGroupConsultChooseMedicalRecordsDidSelectedMedicalRecordModel:(id)medicalRecordModel
{
    [self.testRecordArray replaceObjectAtIndex:0 withObject:medicalRecordModel];
    [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


// 日期选择器
- (void)setupDataPickerWithIndex:(NSInteger)index
{
    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    dataView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    dataView.tag = 99;
    [self.view addSubview:dataView];
    NSDate *now = [NSDate date];
    UUDatePicker *datePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, kScreen_Height, kScreen_Width, 200) PickerStyle:UUDateStyle_YearMonthDayHourMinute didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        if (index == 1) {
            _consultStartTimeFiled.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
        } else {
            _consultEndTimeFiled.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
        }
        
    }];
    self.datePicker = datePicker;
    datePicker.minLimitDate = now;
    datePicker.ScrollToDate = now;
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.25;
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePickerView:)];
    tapGR.numberOfTapsRequired    = 1;
    tapGR.numberOfTouchesRequired = 1;
    [dataView addGestureRecognizer:tapGR];
    [self.view addSubview:datePicker];
    
    _datePicker.frame = CGRectMake(0, kScreen_Height - 200, kScreen_Width, 200);
    _datePicker.tag = 1;
    [self.view addSubview:_datePicker];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
    
}

// 移除日期选择器视图
- (void)removeDatePickerView:(UITapGestureRecognizer *)tap
{
    CGFloat height = self.mainTableView.frame.size.height;
    self.mainTableView.frame =  CGRectMake(0, 0, kScreen_Width, height);

    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.25;
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [[self.view viewWithTag:99] removeFromSuperview];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _datePicker.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 200);
    [UIView commitAnimations];
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

//- (void)hideKeyBoard:(UIGestureRecognizer *)recognizer
//{
//    [self.mainTableView removeGestureRecognizer:recognizer];
//    [self.mainTableView endEditing:YES];
//}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 提交
- (void)clickCommitButton
{
    NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *startTime = [_consultStartTimeFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *endTime = [_consultEndTimeFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self validatePhone:phone patientId:self.patientModel.patientId selectHealthFiles:self.testRecordArray consultStartTime:startTime andConsultEndTime:endTime]) {
        UIViewController <MYSExpertGroupConfirmNetworkConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConfirmNetworkConsultViewControllerProtocol)];
        self.hidesBottomBarWhenPushed = YES;
        viewController.patientModel = self.patientModel;
        viewController.symptom = self.symptom;
        viewController.situation = self.situation;
        viewController.help = self.help;
        viewController.askModel = self.askModel;
        viewController.phone = phone;
        viewController.recordArray = self.testRecordArray;
        viewController.consultType = @"电话咨询";
        viewController.consultStartTime = startTime;
        viewController.consultEndTime = endTime;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - API methods
// 获取咨询详情
- (void)fetchAsk
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult"];
    NSDictionary *parameters = @{@"doctorid": self.doctorId, @"type": @"1"};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        self.askModel = [[MYSExpertGroupAskModel alloc] initWithDictionary:responseObject error:nil];
        [self.mainTableView reloadData];
        
        NSArray *words = @[@{@"付款:  ": [UIFont systemFontOfSize:14]},
                           @{[NSString stringWithFormat:@"￥%@",self.askModel.price]: [UIFont systemFontOfSize:16]}];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        for (NSDictionary *wordToColorMapping in words) {
            for (NSString *word in wordToColorMapping) {
                UIFont *font = [wordToColorMapping objectForKey:word];
                NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor colorFromHexRGB:KEF8004Color], NSFontAttributeName : font};
                NSAttributedString *subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
                [string appendAttributedString:subString];
            }
        }
        
        self.priceLabel.attributedText = string;
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Validate

// 验证电话和患者
- (BOOL)validatePhone:(NSString *)phone patientId:(NSString *)patientId selectHealthFiles:(NSArray *)selectHealthFiles consultStartTime:(NSString *)consultStartTime andConsultEndTime:(NSString *)consultEndTime
{
    
    if (patientId == nil || [patientId length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择咨询者" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
         NO;
    }
    
    if ([selectHealthFiles[0] isKindOfClass:[NSString class]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择健康档案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (self.symptom.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加当前症状与体征" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (self.situation.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加咨询问题及就医情况" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    if (self.help.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加希望得到医生的何种帮助" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![ValidateTools validateFixedLine:phone]) {
        if (![ValidateTools validateMobile:phone]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机或固定电话号（固定电话格式为区号-号码）" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    if (consultStartTime.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择期望开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    if (consultEndTime.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择期望结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *endDate = [dateFormat dateFromString:consultEndTime];
    NSDate *startDate = [dateFormat dateFromString:consultStartTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600 *24);
    int hours = ((int)time)%(3600 *24)/3600;
    if (days < 1) {
        if (hours <3) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"结束时间和开始时间至少相隔三小时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }}

    return YES;
}
@end
