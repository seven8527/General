//
//  TEEditConsultDetailsViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEEditConsultDetailsViewController.h"
#import "TEUITools.h"
#import "TEQuestionDescribeCell.h"
#import "TEQuestionDescribe.h"
#import "UIColor+Hex.h"
#import "TEPatientData.h"
#import "TEConsultMultipleChoiceCell.h"
#import "TEAppDelegate.h"
#import "TEPatientDataModel.h"
#import "TEHealthArchiveDataInfoModel.h"
#import "TEHealthArchiveDetail.h"
#import "TEHttpTools.h"

@interface TEEditConsultDetailsViewController () <UITableViewDelegate, UITableViewDataSource, TEChoosePayModeViewControllerDelegate, TEReusableTextViewViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSMutableArray *healthFiles;
@property (nonatomic, copy) NSString *patientName; // 患者
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, copy) NSString *consultState;
@property (nonatomic, copy) NSString *expectStartTime;
@property (nonatomic, copy) NSString *expectEndTime;
@property (nonatomic, strong) NSMutableArray *selectHealthFiles;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *symptom;
@property (nonatomic, copy) NSString *detailDesc;
@property (nonatomic, copy) NSString *help;
@property (nonatomic, copy) NSString *payDate;
@property (nonatomic, copy) NSString *payState;
@property (nonatomic, copy) NSString *payModeName;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *replay;

@property (nonatomic, copy) NSString *selectedHealthFile;
@end

@implementation TEEditConsultDetailsViewController

- (void)viewDidLoad
{
    
    self.title = @"咨询详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataNameDidRevamp:) name:@"dataNameDidRevamp" object:nil];
    
    self.symptom = self.orderDetails.symptom;
    self.detailDesc = self.orderDetails.desDetails;
    self.help = self.orderDetails.help;
    if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
        self.expectStartTime = self.orderDetails.expectStartTime;
        self.expectEndTime = self.orderDetails.expectEndTime;
    }
    
    if (self.TEConfirmConsultType == TEConfirmConsultOffLine) {
        self.expectStartTime = self.orderDetails.expectTime;
    }
    
    if ([self.orderDetails.payStatue isEqualToString:@"0"]) {
        self.payState = @"未付款";
    } else if ([self.orderDetails.payStatue isEqualToString:@"1"]){
        self.payState = @"已付款";
    }
    
    
    self.selectedHealthFile = self.orderDetails.healthFile;
    if ([self.orderDetails.payModeType isEqualToString:@"1"]) {
        self.payModeName = @"支付宝";
    } else if ([self.orderDetails.payModeType isEqualToString:@"2"]) {
        self.payModeName = @"网银";
    } else if ([self.orderDetails.payModeType isEqualToString:@"3"]) {
        self.payModeName = @"网银转账";
    } else if ([self.orderDetails.payModeType isEqualToString:@"4"]) {
        self.payModeName = @"银行汇款";
    } else {
        self.payModeName = @"其他";
    }
    if (self.selectedHealthFile != nil) {
        [self.healthFiles addObject:self.selectedHealthFile];
    }
    
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    };
    
    [reach startNotifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

// UI设置
- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
}

// UI布局
- (void)layoutUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(commitButtonItemClick)];
    
    // Create a UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
    
    
    //初始日期选择控件
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minimumDate = [NSDate date];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (NSMutableArray *)healthFiles
{
    if (_healthFiles == nil) {
        _healthFiles = [NSMutableArray arrayWithObjects:@"健康档案", nil];
    }
    return _healthFiles;
}

- (NSMutableArray *)selectHealthFiles
{
    if (_selectHealthFiles == nil) {
        _selectHealthFiles = [NSMutableArray array];
    }
    return _selectHealthFiles;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        return 3;
    }else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (section == 0) {
            return 6;
        } else if (section == 1) {
            return self.healthFiles.count;
        } else {
            return 4;
        }
        
    } else if(self.TEConfirmConsultType == TEConfirmConsultPhone){
        if (section == 0) {
            return 6;
        } else if (section == 1) {
            return self.healthFiles.count;
        } else if (section == 2) {
            return 3;
        } else {
            return 4;
        }
    } else {
        if (section == 0) {
            return 6;
        } else if (section == 1) {
            return self.healthFiles.count;
        } else if (section == 2) {
            return 1;
        } else {
            return 4;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    static NSString *questionDescribeIdentifier = @"questionDescribeIdentifier";
    static NSString *multipleChoiceIdentifier = @"multipleChoiceCellIdentifier";
    TEConsultMultipleChoiceCell *multipleChoiceCell;
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
    
    TEQuestionDescribeCell *questionDescribeCell = [aTableView dequeueReusableCellWithIdentifier:questionDescribeIdentifier];
    if (!questionDescribeCell) {
        questionDescribeCell = [[TEQuestionDescribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionDescribeIdentifier];
    }
    
    multipleChoiceCell = [aTableView dequeueReusableCellWithIdentifier:multipleChoiceIdentifier];
    if (multipleChoiceCell == nil) {
        multipleChoiceCell = [[TEConsultMultipleChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:multipleChoiceIdentifier];
    }
    
    questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
    questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"咨询者";
                cell.detailTextLabel.text = self.orderDetails.patientName;
                return cell;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"咨询号";
                cell.detailTextLabel.text = self.orderNumber;
                return cell;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"咨询状态";
                NSString *tempConsultState;
                if ([self.orderDetails.orderState isEqualToString:@"0"]) {
                    tempConsultState = @"待审核";;
                } else if ([self.orderDetails.orderState isEqualToString:@"1"]) {
                    tempConsultState = @"已通过";
                } else if ([self.orderDetails.orderState isEqualToString:@"2"]) {
                    tempConsultState = @"等待咨询";
                } else if ([self.orderDetails.orderState isEqualToString:@"3"]) {
                    tempConsultState = @"已完成";
                } else if ([self.orderDetails.orderState isEqualToString:@"4"]) {
                    tempConsultState = @"已取消";
                } else if ([self.orderDetails.orderState isEqualToString:@"5"]) {
                    tempConsultState = @"爽约";
                } else if ([self.orderDetails.orderState isEqualToString:@"7"]) {
                    tempConsultState = @"退款申请中";
                } else if ([self.orderDetails.orderState isEqualToString:@"8"]) {
                    tempConsultState = @"退款已审核";
                } else if ([self.orderDetails.orderState isEqualToString:@"9"]){
                    tempConsultState = @"已退款";
                }
                cell.detailTextLabel.text = tempConsultState;
                return cell;
                
            } else if (indexPath.row == 3) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = nil;
                cell.textLabel.text = @"主要症状和感受";
                return cell;
            } else if (indexPath.row == 4) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"详细描述及以往就医记录";
                cell.detailTextLabel.text = nil;
                return cell;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = nil;
                cell.textLabel.text = @"希望得到医生的何种帮助";
                return cell;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = self.healthFiles[indexPath.row];
                return cell;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = self.healthFiles[indexPath.row];
                return cell;
            }
            
        } else {
            if (indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"付款日期";
                cell.detailTextLabel.text = self.orderDetails.payTime;
                return cell;
            } else if (indexPath.row == 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"付款状态";
                cell.detailTextLabel.text = self.payState;
                return cell;
            } else if (indexPath.row == 2) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"付款方式";
                
                
                cell.detailTextLabel.text = self.payModeName;
                return cell;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"金额";
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@元",self.orderDetails.truePrice];
                return cell;
            }
        }
    } else {
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"咨询者";
                cell.detailTextLabel.text = self.orderDetails.patientName;
                return cell;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"咨询号";
                cell.detailTextLabel.text = self.orderNumber;
                return cell;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"咨询状态";
                NSString *tempConsultState;
                if ([self.orderDetails.orderState isEqualToString:@"0"]) {
                    tempConsultState = @"待审核";;
                } else if ([self.orderDetails.orderState isEqualToString:@"1"]) {
                    tempConsultState = @"已通过";
                } else if ([self.orderDetails.orderState isEqualToString:@"2"]) {
                    tempConsultState = @"等待咨询";
                } else if ([self.orderDetails.orderState isEqualToString:@"3"]) {
                    tempConsultState = @"已完成";
                } else if ([self.orderDetails.orderState isEqualToString:@"4"]) {
                    tempConsultState = @"已取消";
                } else if ([self.orderDetails.orderState isEqualToString:@"5"]) {
                    tempConsultState = @"爽约";
                } else if ([self.orderDetails.orderState isEqualToString:@"7"]) {
                    tempConsultState = @"退款申请中";
                } else if ([self.orderDetails.orderState isEqualToString:@"8"]) {
                    tempConsultState = @"退款已审核";
                } else if ([self.orderDetails.orderState isEqualToString:@"9"]){
                    tempConsultState = @"已退款";
                }
                cell.detailTextLabel.text = tempConsultState;
                return cell;
            } else if (indexPath.row == 3) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = nil;
                cell.textLabel.text = @"主要症状和感受";
                return cell;
            } else if (indexPath.row == 4) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = nil;
                cell.textLabel.text = @"详细描述及以往就医记录";
                return cell;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = nil;
                cell.textLabel.text = @"希望得到医生的何种帮助";
                return cell;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = self.healthFiles[indexPath.row];
                return cell;
            }else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = self.healthFiles[indexPath.row];
                return cell;
            }

        } else if(indexPath.section == 2) {
            if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
                
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                if (indexPath.row == 0) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = @"期望咨询时间";
                    cell.detailTextLabel.text = nil;
                    return cell;
                } else if (indexPath.row == 1) {
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"开始时间";
                    
                    cell.detailTextLabel.text = self.expectStartTime;
                    return cell;
                } else {
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.text = @"结束时间";
                    
                    cell.detailTextLabel.text = self.expectEndTime;
                    return cell;
                }
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.textLabel.text = @"期望预约时间";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = self.expectStartTime;
                return cell;
            }
        } else {
            
            if (indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"付款日期";
                cell.detailTextLabel.text = self.orderDetails.payTime;
                return cell;
            } else if (indexPath.row == 1) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"付款状态";
                cell.detailTextLabel.text = self.payState;
                return cell;
            } else if (indexPath.row == 2) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"付款方式";
                
                cell.detailTextLabel.text = self.payModeName;
                return cell;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"金额";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",self.orderDetails.truePrice];
                return cell;
            }
            
        }
    }
}
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
            return 122;
        } else if (self.TEConfirmConsultType == TEConfirmConsultOffLine) {
            return 44;
        } else {
            TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
            question.prompt = @"名医回复";
            question.question = self.orderDetails.expertAnswer;
            return [TEQuestionDescribeCell rowHeightWitObject:question];
        }
    }
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        
        if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width, 44)];
            titleLable.backgroundColor = [UIColor clearColor];
            titleLable.textColor = [UIColor colorWithHex:0x383838];
            titleLable.text = @"咨询时间";
            titleLable.font = [UIFont boldSystemFontOfSize:14];
            [headView addSubview:titleLable];
            UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(15, 43, kScreen_Width - 30, 0.5)];
            firstLine.backgroundColor = [UIColor grayColor];
            firstLine.alpha = 0.3;
            [headView addSubview:firstLine];
            UILabel *startTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, kScreen_Width, 39)];
            startTimeLable.backgroundColor = [UIColor clearColor];
            startTimeLable.font = [UIFont boldSystemFontOfSize:14];
            startTimeLable.textColor = [UIColor colorWithHex:0x383838];
            startTimeLable.text = @"开始时间";
            [headView addSubview:startTimeLable];
            
            UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(15, 82, kScreen_Width - 30, 0.5)];
            secondLine.backgroundColor = [UIColor grayColor];
            secondLine.alpha = 0.3;
            
            [headView addSubview:secondLine];
            UILabel *endTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 83, kScreen_Width, 39)];
            endTimeLable.backgroundColor = [UIColor clearColor];
            endTimeLable.textColor = [UIColor colorWithHex:0x383838];
            endTimeLable.font = [UIFont boldSystemFontOfSize:14];
            endTimeLable.text = @"开始时间";

            [headView addSubview:endTimeLable];
            
        } else if (self.TEConfirmConsultType == TEConfirmConsultOffLine) {
            UILabel *consultDate = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width, 44)];
            consultDate.textColor = [UIColor colorWithHex:0x383838];
            consultDate.font = [UIFont boldSystemFontOfSize:14];
            consultDate.text = @"咨询时间";

            consultDate.backgroundColor = [UIColor clearColor];
            [headView addSubview:consultDate];
            
        } else {
            static NSString *questionDescribeIdentifier = @"questionDescribeIdentifier";
            TEQuestionDescribeCell *questionDescribeCell;
            if (!questionDescribeCell) {
                questionDescribeCell = [[TEQuestionDescribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionDescribeIdentifier];
            }
            questionDescribeCell.titleLabel.text = @"名医回复";
            questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
            questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
            questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
            questionDescribeCell.questionLabel.text =  self.orderDetails.expertAnswer;
            
            [headView addSubview:questionDescribeCell];
            
        }
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (indexPath.section == 0) {
            return 44;
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 44;
            } else {
                return 39;
            }
        } else {
            return 44;
        }
        
    } else {
        if (indexPath.section == 0) {
            return 44;
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 44;
            } else {
                return 39;
            }
        } else  if (indexPath.section == 2){
            if (indexPath.row == 0) {
                return 44;
            } else {
                return 39;
            }
        } else {
            return 44;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (indexPath.section == 0) {
            if(indexPath.row == 3) {
                UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
                viewController.content = self.symptom;
                viewController.flag = @"major";
                viewController.delegate = self;
                viewController.title = @"主要症状和感受";
                viewController.exampleContent = @"下腹疼痛1个多月，看过一次医生，给开了泻立停药，吃了也不见好5cm瘢痕，愈合良好。发病以来体重减轻5KG，生活可自理，目前未输液。";
                [self.navigationController pushViewController:viewController animated:NO];
            }
            
            if (indexPath.row == 4) {
                UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
                viewController.content = self.detailDesc;
                viewController.flag = @"detail";
                viewController.delegate = self;
                viewController.title = @"详情描述及以往就医记录";
                viewController.exampleContent = @"2年前突然出现腹胀、腹痛，伴恶心、呕吐，呕吐物为咖啡色，口服\"西咪替丁\"效果 不好 ，2014年4月8 日在西安交大一附院，做胃镜检查提示：胃窦部溃疡性病变。发病以来体重减轻5KG，生活可自理，目前未输液。";
                [self.navigationController pushViewController:viewController animated:NO];
            }
            
            if (indexPath.row == 5) {
                UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
                viewController.content = self.help;
                viewController.flag = @"help";
                viewController.delegate = self;
                viewController.title = @"希望得到医生的何种帮助";
                viewController.exampleContent = @"想问问医生，目前我这种状况是否需要继续化疗，大概还需要多少个疗程？还需要做哪些进一步检查吗？";
                [self.navigationController pushViewController:viewController animated:NO];
            }
            
        } else if (indexPath.section == 1) {
            if(indexPath.row != 0){
                self.hidesBottomBarWhenPushed = YES;
                UIViewController <TEPatientDataPreviewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientDataPreviewViewControllerProtocol)];
                viewController.patientId = self.orderDetails.patientID;
                viewController.patientDataId = self.orderDetails.orderNumber;
                [self pushNewViewController:viewController];
            }

            
        } else {
            if (indexPath.row == 2) {
                UIViewController <TEChoosePayModeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEChoosePayModeViewControllerProtocol)];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:NO];
            }
        }
        
    } else {
        if (indexPath.section == 0) {
            if(indexPath.row == 3) {
                UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
                viewController.content = self.symptom;
                viewController.flag = @"major";
                viewController.delegate = self;
                viewController.title = @"主要症状和感受";
                viewController.exampleContent = @"下腹疼痛1个多月，看过一次医生，给开了泻立停药，吃了也不见好5cm瘢痕，愈合良好。发病以来体重减轻5KG，生活可自理，目前未输液。";
                [self.navigationController pushViewController:viewController animated:NO];
            }
            
            if (indexPath.row == 4) {
                UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
                viewController.content = self.detailDesc;
                viewController.flag = @"detail";
                viewController.delegate = self;
                viewController.title = @"详情描述及以往就医记录";
                viewController.exampleContent = @"2年前突然出现腹胀、腹痛，伴恶心、呕吐，呕吐物为咖啡色，口服\"西咪替丁\"效果 不好 ，2014年4月8 日在西安交大一附院，做胃镜检查提示：胃窦部溃疡性病变。发病以来体重减轻5KG，生活可自理，目前未输液。";
                [self.navigationController pushViewController:viewController animated:NO];
            }
            
            if (indexPath.row == 5) {
                UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
                viewController.content = self.help;
                viewController.flag = @"help";
                viewController.delegate = self;
                viewController.title = @"希望得到医生的何种帮助";
                viewController.exampleContent = @"想问问医生，目前我这种状况是否需要继续化疗，大概还需要多少个疗程？还需要做哪些进一步检查吗？";
                [self.navigationController pushViewController:viewController animated:NO];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row != 0) {
                self.hidesBottomBarWhenPushed = YES;
                UIViewController <TEPatientDataPreviewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientDataPreviewViewControllerProtocol)];
                viewController.patientId = self.orderDetails.patientID;
                viewController.patientDataId = self.orderDetails.orderNumber;
                [self pushNewViewController:viewController];
            }

        } else if (indexPath.section == 2) {
            if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
                
                if (indexPath.row == 1) {
                    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
                    dataView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
                    dataView.tag = 99;
                    CATransition *transition = [CATransition animation];
                    transition.delegate = self;
                    transition.duration = 0.25;
                    transition.type = kCATransitionFade;
                    [self.view.layer addAnimation:transition forKey:nil];
                    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePickerView:)];
                    tapGR.numberOfTapsRequired    = 1;
                    tapGR.numberOfTouchesRequired = 1;
                    [dataView addGestureRecognizer:tapGR];
                    [self.view addSubview:dataView];
                    
                    _datePicker.frame = CGRectMake(0, kScreen_Height - 216, kScreen_Width, 216);
                    _datePicker.tag = 1;
                    [self.view addSubview:_datePicker];
                    
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [UIView setAnimationDuration:0.35];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView commitAnimations];
                    
                }
                
                if (indexPath.row == 2) {
                    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
                    dataView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
                    dataView.tag = 99;
                    CATransition *transition = [CATransition animation];
                    transition.delegate = self;
                    transition.duration = 0.25;
                    transition.type = kCATransitionFade;
                    [self.view.layer addAnimation:transition forKey:nil];
                    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePickerView:)];
                    tapGR.numberOfTapsRequired    = 1;
                    tapGR.numberOfTouchesRequired = 1;
                    [dataView addGestureRecognizer:tapGR];
                    [self.view addSubview:dataView];
                    
                    _datePicker.frame = CGRectMake(0, kScreen_Height - 216, kScreen_Width, 216);
                    _datePicker.tag = 2;
                    [self.view addSubview:_datePicker];
                    
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [UIView setAnimationDuration:0.35];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView commitAnimations];
                    
                }
            } else {
                UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
                dataView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
                dataView.tag = 99;
                CATransition *transition = [CATransition animation];
                transition.delegate = self;
                transition.duration = 0.25;
                transition.type = kCATransitionFade;
                [self.view.layer addAnimation:transition forKey:nil];
                UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePickerView:)];
                tapGR.numberOfTapsRequired    = 1;
                tapGR.numberOfTouchesRequired = 1;
                [dataView addGestureRecognizer:tapGR];
                [self.view addSubview:dataView];
                
                _datePicker.frame = CGRectMake(0, kScreen_Height - 216, kScreen_Width, 216);
                _datePicker.tag = 1;
                [self.view addSubview:_datePicker];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView setAnimationDuration:0.35];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView commitAnimations];
                
            }
        } else {
            if (indexPath.row == 2) {
                UIViewController <TEChoosePayModeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEChoosePayModeViewControllerProtocol)];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:NO];
            }
            
        }
    }
}

#pragma mark TEChoosePayModeViewController delegate

- (void)didSelectedPayModeId:(NSInteger)payModeId payModeName:(NSString *)payModeName
{
    self.payModeName = payModeName;
    
    [self.tableView reloadData];
}

#pragma mark - TEReusableTextViewControllerDelegate

- (void)didFinishedTextViewContent:(NSString *)content byFlag:(NSString *)flag
{
    if ([flag isEqualToString:@"major"]) {
        self.symptom = content;

    }  else if ([flag isEqualToString:@"detail"]) {
        self.detailDesc = content;

    }  else if ([flag isEqualToString:@"help"]) {
        self.help = content;

    }
}

#pragma mark 通知
- (void)dataNameDidRevamp:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    
    [self.healthFiles removeLastObject];
    [self.healthFiles addObject:[dict objectForKey:@"dataName"]];
    [self.tableView reloadData];
    
}

- (void)commitButtonItemClick
{
    if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
        if([self validate]){
            [self commitOrder];
        }
    } else {
        [self commitOrder];
    }
    
}
// 验证电话和患者
- (BOOL)validate
{
    if (self.symptom.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加主要症状和感受" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (self.detailDesc.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加详细描述及以往就医记录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    if (self.help.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"希望得到医生的何种帮助" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [dateFormat dateFromString:self.expectEndTime];
    NSDate *startDate = [dateFormat dateFromString:self.expectStartTime];
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

// 移除日期选择器视图
- (void)removeDatePickerView:(UITapGestureRecognizer *)tap
{
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
    _datePicker.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 216);
    [UIView commitAnimations];
}

- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (datePicker.tag == 1) {
        self.expectStartTime = [dateFormat stringFromDate:[datePicker date]];
    }  else {
        self.expectEndTime = [dateFormat stringFromDate:[datePicker date]];
    }

    [self.tableView reloadData];
}


#pragma mark - API methods

// 获取患者资料列表
- (void)fetchPatientData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"health_details"];
    NSDictionary *parameters = @{@"patient_id": self.orderDetails.patientID};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"----%@", responseObject);
        TEHealthArchiveDetail *health = [[TEHealthArchiveDetail alloc] initWithDictionary:responseObject error:nil];
        [self.healthFiles removeAllObjects];
        [self.healthFiles addObject:@"健康档案"];
        [self.healthFiles addObjectsFromArray:health.datas];
        [self.healthFiles addObject:@"新建资料"];
        
        [self.selectHealthFiles removeAllObjects];
        [self.tableView reloadData];
        [hud hide:YES];

    } failure:^(NSError *error) {
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"----%@", responseObject);
//        TEHealthArchiveDetail *health = [[TEHealthArchiveDetail alloc] initWithDictionary:responseObject error:nil];
//        [self.healthFiles removeAllObjects];
//        [self.healthFiles addObject:@"健康档案"];
//        [self.healthFiles addObjectsFromArray:health.datas];
//        [self.healthFiles addObject:@"新建资料"];
//        
//        [self.selectHealthFiles removeAllObjects];
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
//    }];
}


// 提交修改
- (void)commitOrder
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"conorder/edit_order"];
    
    NSString *type ;
    if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
        type = @"1";
    } else if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        type = @"0";
    } else {
        type = @"2";
    }
    
    NSString *payMode;
    
    if ([self.payModeName isEqualToString:@"支付宝"]) {
        payMode = @"1";
    } else if ([self.payModeName isEqualToString:@"网银"]) {
        payMode = @"2";
    } else if ([self.payModeName isEqualToString:@"网银转账"]) {
        payMode = @"3";
    } else if([self.payModeName isEqualToString:@"银行汇款"]) {
        payMode = @"4";
    } else {
        payMode = @"5";
    }
    
    if (self.help.length == 0) {
        self.help = @"";
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        NSDictionary *onlineConsult = @{@"cookie": ApplicationDelegate.cookie,@"billno": self.orderNumber, @"type": type, @"sult": self.symptom, @"description":self.detailDesc, @"question": self.help, @"pay_type": payMode,@"pmid" :self.orderDetails.orderNumber};
        [parameters setDictionary:onlineConsult];
        
    } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
        
        NSDictionary *phoneConsult = @{@"cookie": ApplicationDelegate.cookie,@"billno": self.orderNumber, @"type": type, @"sult": self.symptom, @"description":self.detailDesc, @"question": self.help, @"pay_type": payMode,@"pmid" :self.orderDetails.orderNumber, @"user_tel_time": self.expectStartTime, @"user_tel_time_end": self.expectEndTime};
        [parameters setDictionary:phoneConsult];
        
        
    } else if (self.TEConfirmConsultType == TEConfirmConsultOffLine) {
        NSDictionary *offlineConsult = @{@"cookie": ApplicationDelegate.cookie,@"billno": self.orderNumber, @"type": type, @"sult": self.symptom, @"description":self.detailDesc, @"question": self.help, @"pay_type": payMode,@"pmid" :self.orderDetails.orderNumber ,@"referral_date_user": self.expectStartTime};
        [parameters setDictionary:offlineConsult];
    }
    
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"----%@", responseObject);
        [hud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"----%@", responseObject);
//        [hud hide:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"----------------%@",error);
//        [hud hide:YES];
//    }];
}

@end
