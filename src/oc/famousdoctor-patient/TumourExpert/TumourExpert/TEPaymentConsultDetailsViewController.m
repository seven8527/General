//
//  TEPaymentConsultDetailsViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPaymentConsultDetailsViewController.h"
#import "TEUITools.h"
#import "TEQuestionDescribeCell.h"
#import "TEQuestionDescribe.h"
#import "UIColor+Hex.h"
#import "TEOrderViewController.h"
#import "TEOrderDetailsModel.h"
#import "TEOrderDetails.h"
#import "TEHomeViewController.h"
#import "TEExpertViewController.h"
#import "TEOrderModel.h"
#import "TEAppDelegate.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "TEHttpTools.h"

@interface TEPaymentConsultDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *consultState;
@property (nonatomic, copy) NSString *symptom;
@property (nonatomic, copy) NSString *detailDesc;
@property (nonatomic, copy) NSString *help;
@property (nonatomic, copy) NSMutableArray *selectHealthFiles;
@property (nonatomic, copy) NSString *expectStartTime;
@property (nonatomic, copy) NSString *expectEndTime;
@property (nonatomic, copy) NSString *payDate;
@property (nonatomic, copy) NSString *payState;
@property (nonatomic, copy) NSString *payModeName;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *replay;
@property (nonatomic, strong) TEOrderDetailsModel *orderDetails;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (nonatomic, strong)TEOrderModel *orderModel;
@property (nonatomic, copy) NSString *consultType;

@end

@implementation TEPaymentConsultDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"咨询详情";
    
    self.orderModel = [[TEOrderModel alloc] init];
    
    [self configUI];
    
    [self layoutUI];
    
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchPatientData];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editButtonItemClick)];
    
    // Create a UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor clearColor];
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)selectHealthFiles
{
    if(_selectHealthFiles == nil) {
        _selectHealthFiles = [NSMutableArray arrayWithObject:@"健康档案"];
    }
    return  _selectHealthFiles;
}
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        return 3;
    }else if(self.TEConfirmConsultType == TEConfirmConsultPhone){
        return 4;
    } else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (section == 0) {
            return 6;
        } else if (section == 1) {
            return self.selectHealthFiles.count;
        } else {
            return 4;
        }
        
    } else if(self.TEConfirmConsultType == TEConfirmConsultPhone){
        if (section == 0) {
            return 6;
        } else if (section == 1) {
            return self.selectHealthFiles.count;
        } else if (section == 2) {
            return 3;
        } else {
            return 4;
        }
    } else {
        if (section == 0) {
            return 6;
        } else if (section == 1) {
            return self.selectHealthFiles.count;
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
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
    
    TEQuestionDescribeCell *questionDescribeCell = [aTableView dequeueReusableCellWithIdentifier:questionDescribeIdentifier];
    if (!questionDescribeCell) {
        questionDescribeCell = [[TEQuestionDescribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionDescribeIdentifier];
        questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
        questionDescribeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
    questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
    
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"咨询者";
                cell.detailTextLabel.text = self.patientName;
                return cell;
                
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"咨询号";
                cell.detailTextLabel.text = self.orderNumber;
                return cell;
                
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"咨询状态";
                NSString *tempConsultState;
                if ([self.consultState isEqualToString:@"0"]) {
                    tempConsultState = @"待审核";;
                } else if ([self.consultState isEqualToString:@"1"]) {
                    tempConsultState = @"已通过";
                } else if ([self.consultState isEqualToString:@"2"]) {
                    tempConsultState = @"等待咨询";
                } else if ([self.consultState isEqualToString:@"3"]) {
                    tempConsultState = @"已完成";
                } else if ([self.consultState isEqualToString:@"4"]) {
                    tempConsultState = @"已取消";
                } else if ([self.consultState isEqualToString:@"5"]) {
                    tempConsultState = @"爽约";
                } else if ([self.consultState isEqualToString:@"7"]) {
                    tempConsultState = @"退款申请中";
                } else if ([self.consultState isEqualToString:@"8"]) {
                    tempConsultState = @"退款已审核";
                } else if([self.consultState isEqualToString:@"9"]){
                    tempConsultState = @"已退款";
                }
                cell.detailTextLabel.text = tempConsultState;
                return cell;
                
            } else if (indexPath.row == 3) {
                questionDescribeCell.titleLabel.text = @"主要症状和感受";
                questionDescribeCell.questionLabel.text =  self.symptom;
                return questionDescribeCell;
            } else if (indexPath.row == 4) {
                questionDescribeCell.titleLabel.text =  @"详细描述及以往就医记录";
                questionDescribeCell.questionLabel.text =  self.detailDesc;
                return questionDescribeCell;
            } else {
                questionDescribeCell.titleLabel.text =  @"希望得到医生的何种帮助";
                questionDescribeCell.questionLabel.text =  self.help;
                return questionDescribeCell;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"健康档案";
                cell.detailTextLabel.text = nil;
                return cell;
            } else {
                NSString *patient = self.selectHealthFiles[indexPath.row];
                cell.textLabel.text = patient;
                cell.detailTextLabel.text = nil;
                return cell;
            }
        } else {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"付款日期";
                cell.detailTextLabel.text = self.payDate;
                return cell;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"付款状态";
                cell.detailTextLabel.text = self.payState;
                return cell;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"付款方式";
                cell.detailTextLabel.text = self.payModeName;
                return cell;
            } else {
                cell.textLabel.text = @"金额";
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@元",self.money];
                return cell;
            }
            
        }
        
    } else  if(self.TEConfirmConsultType == TEConfirmConsultPhone){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"咨询者";
                cell.detailTextLabel.text = self.patientName;
                return cell;
                
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"咨询号";
                cell.detailTextLabel.text = self.orderNumber;
                return cell;
                
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"咨询状态";
                NSString *tempConsultState;
                if ([self.consultState isEqualToString:@"0"]) {
                    tempConsultState = @"待审核";;
                } else if ([self.consultState isEqualToString:@"1"]) {
                    tempConsultState = @"已通过";
                } else if ([self.consultState isEqualToString:@"2"]) {
                    tempConsultState = @"等待咨询";
                } else if ([self.consultState isEqualToString:@"3"]) {
                    tempConsultState = @"已完成";
                } else if ([self.consultState isEqualToString:@"4"]) {
                    tempConsultState = @"已取消";
                } else if ([self.consultState isEqualToString:@"5"]) {
                    tempConsultState = @"爽约";
                } else if ([self.consultState isEqualToString:@"7"]) {
                    tempConsultState = @"退款申请中";
                } else if ([self.consultState isEqualToString:@"8"]) {
                    tempConsultState = @"退款已审核";
                } else if ([self.consultState isEqualToString:@"9"]){
                    tempConsultState = @"已退款";
                }
                cell.detailTextLabel.text = tempConsultState;
                return cell;
                
            } else if (indexPath.row == 3) {
                questionDescribeCell.titleLabel.text = @"主要症状和感受";
                questionDescribeCell.questionLabel.text =  self.symptom;
                return questionDescribeCell;
            } else if (indexPath.row == 4) {
                questionDescribeCell.titleLabel.text =  @"详细描述及以往就医记录";
                questionDescribeCell.questionLabel.text =  self.detailDesc;
                return questionDescribeCell;
            } else {
                questionDescribeCell.titleLabel.text =  @"希望得到医生的何种帮助";
                questionDescribeCell.questionLabel.text =  self.help;
                return questionDescribeCell;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"健康档案";
                cell.detailTextLabel.text = nil;
                return cell;
            } else {
                NSString *patient = self.selectHealthFiles[indexPath.row];
                cell.textLabel.text = patient;
                cell.detailTextLabel.text = nil;
                return cell;
            }
        } else if(indexPath.section == 2) {
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            if (indexPath.row == 0) {
                cell.userInteractionEnabled = NO;
                cell.textLabel.text = @"期望咨询时间";
                cell.detailTextLabel.text = nil;
                return cell;
            } else if (indexPath.row == 1) {
                cell.userInteractionEnabled = NO;
                cell.textLabel.text = @"开始时间";
                cell.detailTextLabel.text = self.expectStartTime;
                return cell;
            } else {
                cell.userInteractionEnabled = NO;
                cell.textLabel.text = @"结束时间";
                cell.detailTextLabel.text = self.expectEndTime;
                return cell;
            }
        } else {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"付款日期";
                cell.detailTextLabel.text = self.payDate;
                return cell;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"付款状态";
                cell.detailTextLabel.text = self.payState;
                return cell;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"付款方式";
                cell.detailTextLabel.text = self.payModeName;
                return cell;
            } else {
                cell.textLabel.text = @"金额";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",self.money];
                return cell;
            }
            
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"咨询者";
                cell.detailTextLabel.text = self.patientName;
                return cell;
                
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"咨询号";
                cell.detailTextLabel.text = self.orderNumber;
                return cell;
                
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"咨询状态";
                NSString *tempConsultState;
                if ([self.consultState isEqualToString:@"0"]) {
                    tempConsultState = @"待审核";;
                } else if ([self.consultState isEqualToString:@"1"]) {
                    tempConsultState = @"已通过";
                } else if ([self.consultState isEqualToString:@"2"]) {
                    tempConsultState = @"等待咨询";
                } else if ([self.consultState isEqualToString:@"3"]) {
                    tempConsultState = @"已完成";
                } else if ([self.consultState isEqualToString:@"4"]) {
                    tempConsultState = @"已取消";
                } else if ([self.consultState isEqualToString:@"5"]) {
                    tempConsultState = @"爽约";
                } else if ([self.consultState isEqualToString:@"7"]) {
                    tempConsultState = @"退款申请中";
                } else if ([self.consultState isEqualToString:@"8"]) {
                    tempConsultState = @"退款已审核";
                } else if ([self.consultState isEqualToString:@"9"]){
                    tempConsultState = @"已退款";
                }
                cell.detailTextLabel.text = tempConsultState;
                return cell;
                
            } else if (indexPath.row == 3) {
                questionDescribeCell.titleLabel.text = @"主要症状和感受";
                questionDescribeCell.questionLabel.text =  self.symptom;
                return questionDescribeCell;
            } else if (indexPath.row == 4) {
                questionDescribeCell.titleLabel.text =  @"详细描述及以往就医记录";
                questionDescribeCell.questionLabel.text =  self.detailDesc;
                return questionDescribeCell;
            } else {
                questionDescribeCell.titleLabel.text =  @"希望得到医生的何种帮助";
                questionDescribeCell.questionLabel.text =  self.help;
                return questionDescribeCell;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"健康档案";
                cell.detailTextLabel.text = nil;
                return cell;
            } else {
                NSString *patient = self.selectHealthFiles[indexPath.row];
                cell.detailTextLabel.text = nil;
                cell.textLabel.text = patient;
                return cell;
            }
        } else if(indexPath.section == 2) {
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.userInteractionEnabled = NO;
                cell.textLabel.text = @"期望预约时间";
                cell.detailTextLabel.text = self.expectStartTime;
                return cell;
        } else {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"付款日期";
                cell.detailTextLabel.text = self.payDate;
                return cell;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"付款状态";
                cell.detailTextLabel.text = self.payState;
                return cell;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"付款方式";
                cell.detailTextLabel.text = self.payModeName;
                return cell;
            } else {
                cell.textLabel.text = @"金额";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",self.money];
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
            question.question = self.replay;
            return [TEQuestionDescribeCell rowHeightWitObject:question];
        }
    }
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (section == 2) {
            return 80;
        } else {
            return 0;
        }
    } else {
        if (section == 3) {
            return 80;
        } else {
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (section == 2) {
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            loginButton.frame = CGRectMake(21, 20, 277, 51);
            [loginButton setTitle:@"去付款" forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
            [loginButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:loginButton];
        }
    } else {
        if (section == 3) {
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            loginButton.frame = CGRectMake(21, 20, 277, 51);
            [loginButton setTitle:@"去付款" forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
            [loginButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:loginButton];
        }
    }
    return footerView;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
//    headView.backgroundColor = [UIColor whiteColor];
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
            endTimeLable.text = @"结束时间";
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
            TEQuestionDescribeCell *questionDescribeCell ;
            if (!questionDescribeCell) {
                questionDescribeCell = [[TEQuestionDescribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionDescribeIdentifier];
            }
            questionDescribeCell.titleLabel.text = @"名医回复";
            questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
            questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
            questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
            questionDescribeCell.questionLabel.text =  self.replay;
            [headView addSubview:questionDescribeCell];
            
        }
         return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
                question.prompt = @"咨询问题";
                question.question = self.symptom;
                return [TEQuestionDescribeCell rowHeightWitObject:question];
            } else if (indexPath.row == 4) {
                TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
                question.prompt = @"咨询问题";
                question.question = self.detailDesc;
                return [TEQuestionDescribeCell rowHeightWitObject:question];
            } else if (indexPath.row == 5) {
                TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
                question.prompt = @"咨询问题";
                question.question =self.help;
                return [TEQuestionDescribeCell rowHeightWitObject:question];
            } else
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
            if (indexPath.row == 3) {
                TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
                question.prompt = @"咨询问题";
                question.question = self.symptom;
                return [TEQuestionDescribeCell rowHeightWitObject:question];
            } else if (indexPath.row == 4) {
                TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
                question.prompt = @"咨询问题";
                question.question = self.detailDesc;
                return [TEQuestionDescribeCell rowHeightWitObject:question];
            } else if (indexPath.row == 5) {
                TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
                question.prompt = @"咨询问题";
                question.question =self.help;
                return [TEQuestionDescribeCell rowHeightWitObject:question];
            } else
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

#pragma mark TEChoosePayModeViewController delegate

- (void)didSelectedPayModeId:(NSInteger)payModeId payModeName:(NSString *)payModeName
{
    self.payModeName = payModeName;
    
    [self.tableView reloadData];
}

#pragma  mark business

- (void)editButtonItemClick
{
    UIViewController <TEEditConsultDetailsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEEditConsultDetailsViewControllerProtocol)];
    viewController.TEConfirmConsultType = self.TEConfirmConsultType;
    viewController.orderDetails = self.orderDetails;
    viewController.orderNumber = self.orderNumber;
    [self.navigationController pushViewController:viewController animated:YES];

}

// 点击支付
- (void)pay:(id)sender
{
    if ([self.payModeName isEqualToString:@"支付宝"]) {
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
         */
        NSString *appScheme = @"SINOTumourExpert";
        NSString *orderInfo = [self getOrderInfo:self.orderModel];
        NSString *signedStr = [self doRsa:orderInfo];
        
        NSLog(@"signedStr:%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderInfo, signedStr, @"RSA"];
        
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
        ApplicationDelegate.orderId = self.orderNumber;
        ApplicationDelegate.payType = self.orderDetails.payModeType;
        ApplicationDelegate.TEConfirmConsultType = self.TEConfirmConsultType;
        ApplicationDelegate.payProtal = 1;
    } else {
        UIViewController <TEPayInfoViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayInfoViewControllerProtocol)];
        viewController.payStatue = self.orderDetails.payStatue;
        viewController.payTime = self.orderDetails.payTime;
        viewController.payPrice = self.orderDetails.truePrice;
        viewController.payModeName = self.payModeName;
        [self.navigationController pushViewController:viewController animated:YES];

    }
    
}

-(NSString*)getOrderInfo:(TEOrderModel *)orderModel
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = orderModel.orderId; //订单ID
    NSLog(@"trade orderId:%@", orderModel.orderId);
	order.productName = orderModel.expertName; //商品标题
	order.productDescription = orderModel.expertTitle; //商品描述
	order.amount = orderModel.orderPrice; //商品价格
    order.notifyURL = [kURL stringByAppendingString:@"apliay/notify.php"]; //回调URL
    
    self.orderId = orderModel.orderId;
	
	return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                
                NSLog(@"验证签名成功");
                
                //验证签名成功，交易结果无篡改
                //[self finishedPay];
                
                UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
                UIViewController <TEPaySuccessViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPaySuccessViewControllerProtocol)];
                viewController.TEConfirmConsultType = self.TEConfirmConsultType;
                viewController.hidesBottomBarWhenPushed = YES;
                [navController pushViewController:viewController animated:NO];
                
                for (UIViewController *ctrl in navController.viewControllers) {
                    if ([ctrl isMemberOfClass:[TEHomeViewController class]]) {
                        [self.tabBarController.navigationController popToViewController:ctrl animated:YES];
                    } else if ([ctrl isMemberOfClass:[TEExpertViewController class]]) {
                        [self.tabBarController.navigationController popToViewController:ctrl animated:YES];
                    } 
                }
                
			}
        }
        else
        {
            //交易失败
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <TEPayFailureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayFailureViewControllerProtocol)];
            [self.navigationController pushViewController:viewController animated:YES];
            NSLog(@"交易失败");
        }
    }
    else
    {
        //失败
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEPayFailureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPayFailureViewControllerProtocol)];
        [self.navigationController pushViewController:viewController animated:YES];
        
        NSLog(@"失败");
    }
    
}

- (void)finishedPay
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"paysuccess"];
    NSDictionary *parameters = @{@"billno": self.orderId, @"cookie": ApplicationDelegate.cookie, @"pay_type": [NSString stringWithFormat:@"%d", self.TEConfirmConsultType]};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        ;
    } failure:^(NSError *error) {
        ;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - API methods

// 获取患者订单详情
- (void)fetchPatientData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"conorder/view_order"];
    NSString *consultType = [NSString stringWithFormat:@"%d",self.TEConfirmConsultType];
    NSDictionary *parameters = @{@"billno": self.orderNumber, @"type": consultType};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"----%@", responseObject);
        if (self.selectHealthFiles.count ==2) {
            [self.selectHealthFiles removeLastObject];
        }
        TEOrderDetails *patient = [[TEOrderDetails alloc] initWithDictionary:responseObject error:nil];
        TEOrderDetailsModel *orderDetails = patient.orderDetails;
        self.orderDetails = orderDetails;
        
        
        if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
            self.replay = orderDetails.expertAnswer;
            self.consultType = @"网络咨询";
        } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
            self.expectStartTime = orderDetails.expectStartTime;
            self.expectEndTime = orderDetails.expectEndTime;
            self.startTime = orderDetails.actualStartTime;
            self.endTime = orderDetails.actualEndTime;
            self.consultType = @"电话咨询";
        } else {
            self.expectStartTime = orderDetails.expectTime;
            self.startTime = orderDetails.actualTime;
            self.consultType = @"面对面咨询";
        }
        self.patientName = orderDetails.patientName;
        self.patientId = orderDetails.patientID;
        self.consultState = orderDetails.orderState;
        self.symptom = orderDetails.symptom;
        self.detailDesc = orderDetails.desDetails;
        self.help = orderDetails.help;
        if (orderDetails.healthFile != nil) {
            [self.selectHealthFiles addObject:orderDetails.healthFile];
        }
        
        self.payDate = orderDetails.payTime;
        if ([orderDetails.payStatue isEqualToString:@"0"]) {
            self.payState = @"未付款";
        } else if ([orderDetails.payStatue isEqualToString:@"1"]){
            self.payState = @"已付款";
        }
        
        if ([orderDetails.payModeType isEqualToString:@"1"]) {
            self.payModeName = @"支付宝";
        } else if ([orderDetails.payModeType isEqualToString:@"2"]) {
            self.payModeName = @"网银";
        } else if ([orderDetails.payModeType isEqualToString:@"3"]) {
            self.payModeName = @"网银转账";
        } else if ([orderDetails.payModeType isEqualToString:@"4"]) {
            self.payModeName = @"银行汇款";
        } else {
            self.payModeName = @"其他";
        }
        self.money = orderDetails.truePrice;
        
        
        //        self.orderModel.orderId = orderDetails.orderId;
        self.orderModel.orderId = self.orderNumber;
        self.orderModel.orderPrice = orderDetails.truePrice;
        self.orderModel.expertName = orderDetails.expertName;
        self.orderModel.expertTitle = self.consultType;
        [self.tableView reloadData];
        [hud hide:YES];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [hud hide:YES];
    }];
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"----%@", responseObject);
//        if (self.selectHealthFiles.count ==2) {
//            [self.selectHealthFiles removeLastObject];
//        }
//        TEOrderDetails *patient = [[TEOrderDetails alloc] initWithDictionary:responseObject error:nil];
//        TEOrderDetailsModel *orderDetails = patient.orderDetails;
//        self.orderDetails = orderDetails;
//
//        
//        if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
//            self.replay = orderDetails.expertAnswer;
//            self.consultType = @"网络咨询";
//        } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
//            self.expectStartTime = orderDetails.expectStartTime;
//            self.expectEndTime = orderDetails.expectEndTime;
//            self.startTime = orderDetails.actualStartTime;
//            self.endTime = orderDetails.actualEndTime;
//            self.consultType = @"电话咨询";
//        } else {
//            self.expectStartTime = orderDetails.expectTime;
//            self.startTime = orderDetails.actualTime;
//            self.consultType = @"面对面咨询";
//        }
//        self.patientName = orderDetails.patientName;
//        self.patientId = orderDetails.patientID;
//        self.consultState = orderDetails.orderState;
//        self.symptom = orderDetails.symptom;
//        self.detailDesc = orderDetails.desDetails;
//        self.help = orderDetails.help;
//        if (orderDetails.healthFile != nil) {
//             [self.selectHealthFiles addObject:orderDetails.healthFile];
//        }
//       
//        self.payDate = orderDetails.payTime;
//        if ([orderDetails.payStatue isEqualToString:@"0"]) {
//            self.payState = @"未付款";
//        } else if ([orderDetails.payStatue isEqualToString:@"1"]){
//            self.payState = @"已付款";
//        }
//        
//        if ([orderDetails.payModeType isEqualToString:@"1"]) {
//            self.payModeName = @"支付宝";
//        } else if ([orderDetails.payModeType isEqualToString:@"2"]) {
//            self.payModeName = @"网银";
//        } else if ([orderDetails.payModeType isEqualToString:@"3"]) {
//            self.payModeName = @"网银转账";
//        } else if ([orderDetails.payModeType isEqualToString:@"4"]) {
//            self.payModeName = @"银行汇款";
//        } else {
//            self.payModeName = @"其他";
//        }
//        self.money = orderDetails.truePrice;
//        
//        
////        self.orderModel.orderId = orderDetails.orderId;
//        self.orderModel.orderId = self.orderNumber;
//        self.orderModel.orderPrice = orderDetails.truePrice;
//        self.orderModel.expertName = orderDetails.expertName;
//        self.orderModel.expertTitle = self.consultType;
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        [hud hide:YES];
//    }];
}


@end
