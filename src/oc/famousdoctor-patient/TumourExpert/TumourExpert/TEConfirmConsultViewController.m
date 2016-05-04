//
//  TEConfirmConsultViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConfirmConsultViewController.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEAskModel.h"
#import "TEQuestionDescribeCell.h"
#import "TEQuestionDescribe.h"

#import "SDWebImage/UIImageView+WebCache.h"
#import "TERegisterCell.h"
#import "TEPatientData.h"
#import "TEAppDelegate.h"
#import "TEPatientDataModel.h"
#import "TEHealthArchiveDetail.h"
#import "TEHealthArchiveDataInfoModel.h"
#import "TEOrderModel.h"

#import "TEHttpTools.h"

@interface TEConfirmConsultViewController ()
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) TEAskModel *askModel;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, copy) NSString *patientDataId; // 患者资料Id
@property (nonatomic, copy) NSString *patientDataName; // 患者资料
@property (nonatomic, copy) NSString *payModeName;
@property (nonatomic, strong) TEOrderModel *orderModel;
@property (nonatomic, copy) NSString *consultType;
@end

@implementation TEConfirmConsultViewController

- (void)viewDidLoad
{
    
    self.title = @"确定咨询";
    
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
    
    self.orderModel = [[TEOrderModel alloc] init];
}

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    // 画线
    UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    UIImage *image = [UIImage imageNamed:@"line_d1d1d1.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    separatorLine.image = image;
    [view addSubview:separatorLine];
    // 按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(21, 20, 277, 51);
    [submitButton setTitle:@"确定咨询" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitButton];
    self.tableView.tableFooterView = view;
}
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        return 4;
    } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
        return 5;
    } else {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (section == 0) {
            return 1;
        } else if(section == 1) {
            return 6;
        } else if (section == 2) {
            return self.selectHealthFiles.count + 1;
        } else {
            return 2;
        }
    } else if (self.TEConfirmConsultType ==TEConfirmConsultPhone){
        if (section == 0) {
            return 1;
        } else if(section == 1) {
            return 6;
        } else if (section == 2) {
            return self.selectHealthFiles.count + 1;
        } else if (section == 3) {
            return 3;
        } else {
            return 2;
        }
    } else {
        if (section == 0) {
            return 1;
        } else if(section == 1) {
            return 6;
        } else if (section == 2) {
            return self.selectHealthFiles.count + 1;
        } else if (section == 3) {
            return 1;
        } else {
            return 2;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *editCellIdentifier = @"editCellIdentifier";
    static NSString *CellIdentifier = @"CellIdentifier";
    static NSString *questionDescribeIdentifier = @"questionDescribeIdentifier";
    UITableViewCell *cell;
    TEQuestionDescribeCell *questionDescribeCell;
    TERegisterCell *editCell;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (indexPath.section == 0) {
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.textLabel.text = @"名医";
            cell.detailTextLabel.text = self.expertName;
            return cell;
        } else if (indexPath.section == 1) {
            editCell = [aTableView dequeueReusableCellWithIdentifier:editCellIdentifier];
            if (!editCell) {
                editCell = [[TERegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:editCellIdentifier];
            }
            questionDescribeCell = [aTableView dequeueReusableCellWithIdentifier:questionDescribeIdentifier];
            if (!questionDescribeCell) {
                questionDescribeCell = [[TEQuestionDescribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionDescribeIdentifier];
            }
            questionDescribeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = @"咨询者";
                cell.detailTextLabel.text = self.patientName;
                
                
            } else if (indexPath.row == 1) {
                NSString *title = nil;
                // 文字描述
                if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
                    self.consultType = @"电话咨询";
                    title = @"电话咨询";
                } else if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
                    self.consultType = @"网络咨询";
                    title = @"网络咨询";
                } else {
                    self.consultType = @"面对面咨询";
                    title = @"面对面咨询";
                }

                cell.textLabel.text = @"咨询类型";
                cell.detailTextLabel.text = title;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
                
            } else if (indexPath.row == 2) {
                questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
                questionDescribeCell.titleLabel.text = @"主要症状和感受";
                questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
                questionDescribeCell.questionLabel.text =  self.symptom;
                return questionDescribeCell;
            } else if (indexPath.row == 3) {
                questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
                questionDescribeCell.titleLabel.text =  @"详细描述及以往就医记录";
                questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
                questionDescribeCell.questionLabel.text =  self.detailDesc;
                return questionDescribeCell;
            } else if (indexPath.row == 4){
                questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
                questionDescribeCell.titleLabel.text =  @"希望得到医生的何种帮助";
                questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
                questionDescribeCell.questionLabel.text =  self.help;
                return questionDescribeCell;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = @"联系方式";
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.detailTextLabel.text = self.phone;
                return cell;
            }
            return cell;
            
        } else if (indexPath.section == 2) {
            cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = @"健康档案";
                return cell;
            } else {
                TEPatientDataModel *patient = self.selectHealthFiles[indexPath.row - 1];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = patient.patientDataName;
                return cell;
            }
        } else {
            cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            
            if (indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"咨询费用";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",self.price];
                return cell;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"付款方式";
                cell.detailTextLabel.text = self.payModeName;
            }
            return cell;
        }
        
    } else {
        
        if (indexPath.section == 0) {
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.textLabel.text = @"名医";
            cell.detailTextLabel.text = self.expertName;
            return cell;
        } else if (indexPath.section == 1) {
            editCell = [aTableView dequeueReusableCellWithIdentifier:editCellIdentifier];
            if (!editCell) {
                editCell = [[TERegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:editCellIdentifier];
            }
            questionDescribeCell = [aTableView dequeueReusableCellWithIdentifier:questionDescribeIdentifier];
            if (!questionDescribeCell) {
                questionDescribeCell = [[TEQuestionDescribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionDescribeIdentifier];
            }
            questionDescribeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = @"咨询者";
                cell.detailTextLabel.text = self.patientName;
                
                
            } else if (indexPath.row == 1) {
                NSString *title = nil;
                // 文字描述
                if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
                    self.consultType = @"电话咨询";
                    title = @"电话咨询";
                } else if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
                    self.consultType = @"网络咨询";
                    title = @"网络咨询";
                } else {
                    self.consultType = @"面对面咨询";
                    title = @"面对面咨询";
                }

                cell.textLabel.text = @"咨询类型";
                cell.detailTextLabel.text = title;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;

            } else if (indexPath.row == 2) {
                questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
                questionDescribeCell.titleLabel.text = @"主要症状和感受";
                questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
                questionDescribeCell.questionLabel.text =  self.symptom;
                return questionDescribeCell;
            } else if (indexPath.row == 3) {
                questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
                questionDescribeCell.titleLabel.text =  @"详细描述及以往就医记录";
                questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
                questionDescribeCell.questionLabel.text =  self.detailDesc;
                return questionDescribeCell;
            } else if (indexPath.row == 4){
                questionDescribeCell.accessoryType = UITableViewCellAccessoryNone;
                questionDescribeCell.titleLabel.text =  @"希望得到医生的何种帮助";
                questionDescribeCell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.questionLabel.font = [UIFont boldSystemFontOfSize:14];
                questionDescribeCell.titleLabel.textColor = [UIColor colorWithHex:0x383838];
                questionDescribeCell.questionLabel.text =  self.help;
                return questionDescribeCell;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = @"联系方式";
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.detailTextLabel.text = self.phone;
                return cell;
            }
            return cell;
            
        } else if (indexPath.section == 2) {
            cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = @"健康档案";
                return cell;
            } else {
                TEPatientDataModel *patient = self.selectHealthFiles[indexPath.row - 1];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
                cell.textLabel.text = patient.patientDataName;
                return cell;
            }
        } else if(indexPath.section == 3) {
            cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
               
                if (indexPath.row == 0) {
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                    cell.textLabel.text = @"期望咨询时间";
                    cell.detailTextLabel.text = nil;
                    return cell;
                } else if (indexPath.row == 1) {
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                    cell.textLabel.text = @"开始时间";
                    cell.detailTextLabel.text = self.startTime;
                    return cell;
                } else {
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                    cell.textLabel.text = @"结束时间";
                    cell.detailTextLabel.text = self.endTime;
                    return cell;
                }
            } else {
                cell.userInteractionEnabled = NO;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.textLabel.text = @"期望预约时间";
                cell.detailTextLabel.text = self.startTime;
                return cell;

            }
        } else {
            cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            
            if (indexPath.row == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"咨询费用";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",self.price];
                return cell;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"付款方式";
                cell.detailTextLabel.text = self.payModeName;
            }
            return cell;
        }
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
        if (indexPath.section == 3) {
            if (indexPath.row == 1) {
                UIViewController <TEChoosePayModeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEChoosePayModeViewControllerProtocol)];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:NO];
            }
        }
    } else {
        if (indexPath.section == 4) {
            if (indexPath.row == 1) {
                UIViewController <TEChoosePayModeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEChoosePayModeViewControllerProtocol)];
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:NO];
            }
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
            question.prompt = @"咨询问题";
            question.question = self.symptom;
            return [TEQuestionDescribeCell rowHeightWitObject:question];
        } else if (indexPath.row == 3) {
            TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
            question.prompt = @"咨询问题";
            question.question = self.detailDesc;
            return [TEQuestionDescribeCell rowHeightWitObject:question];
        }
        else if (indexPath.row == 4) {
            TEQuestionDescribe *question = [[TEQuestionDescribe alloc] init];
            question.prompt = @"咨询问题";
            question.question =self.help;
            return [TEQuestionDescribeCell rowHeightWitObject:question];
        }
        else
            return 44;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 44;
        } else {
            return 39;
        }
    } else {
        if (self.TEConfirmConsultType == TEConfirmConsultOffLine) {
            return 44;
        } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
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


#pragma mark - TEChoosePatientDataViewControllerDelegate

- (void)didSelectedPatientDataId:(NSString *)patientDataId patientDataName:(NSString *)patientDataName
{
    if (![patientDataId isEqualToString:self.patientDataId]) {
        self.patientDataId = patientDataId;
        self.patientDataName = patientDataName;
        [self.tableView reloadData];
    }
}


#pragma mark UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.phoneTextField]) {
        self.phone = textField.text;
    }
}


#pragma mark - Bussiness methods

// 查看电话咨询协议
- (void)checkPhoneAgreement:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEAgreementViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEAgreementViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 提交订单
- (void)submitOrder:(id)sender
{
    if ([self validatePayMode:self.payModeName]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在提交";

        
        NSString *URLString = [kURL_ROOT stringByAppendingString:@"conorder/order"];
        NSString *type;
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
        
        TEHealthArchiveDataInfoModel *patientData = self.selectHealthFiles[0];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        if (self.TEConfirmConsultType == TEConfirmConsultOnline) {
            NSDictionary *onlineConsult = @{@"cookie": ApplicationDelegate.cookie,@"uid": ApplicationDelegate.userId, @"type": type, @"doctor_id": self.doctorId, @"pay_type":payMode, @"price": self.price, @"proid": self.proid, @"medical_id": patientData.patientDataId, @"sult": self.symptom, @"description": self.detailDesc, @"question": self.help, @"patientid": patientData.patientId, @"phone": self.phone};
            [parameters setDictionary:onlineConsult];
            
        } else if (self.TEConfirmConsultType == TEConfirmConsultPhone) {
            
            NSDictionary *phoneConsult = @{@"cookie": ApplicationDelegate.cookie,@"uid": ApplicationDelegate.userId, @"type": type, @"doctor_id": self.doctorId, @"pay_type":payMode, @"price": self.price, @"proid": self.proid, @"medical_id": patientData.patientDataId, @"sult": self.symptom, @"description": self.detailDesc, @"question": self.help, @"patientid": patientData.patientId, @"phone": self.phone, @"time_begin": self.startTime, @"time_end": self.endTime};
            [parameters setDictionary:phoneConsult];
            
            
        } else if (self.TEConfirmConsultType == TEConfirmConsultOffLine) {
            NSDictionary *offlineConsult = @{@"cookie": ApplicationDelegate.cookie,@"uid": ApplicationDelegate.userId, @"type": type, @"doctor_id": self.doctorId, @"pay_type":payMode, @"price": self.price, @"proid": self.proid, @"medical_id": patientData.patientDataId, @"sult": self.symptom, @"description": self.detailDesc, @"question": self.help, @"patientid": patientData.patientId, @"phone": self.phone,@"referral_date": self.startTime };
            [parameters setDictionary:offlineConsult];
        }
            
        [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
            NSLog(@"----%@", responseObject);
            
            NSString *orderNumber = [responseObject objectForKey:@"billno"];
            self.orderModel.orderId = orderNumber;
            self.orderModel.orderPrice = self.price;
            self.orderModel.expertName = self.expertName;
            self.orderModel.expertTitle = self.consultType;
            self.orderModel.orderType = [payMode intValue];
            [hud hide:YES];
            UIViewController <TEOrderSuccessViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEOrderSuccessViewControllerProtocol)];
            viewController.orderModel = self.orderModel;
            viewController.patientId = self.patientId;
            viewController.patientName = self.patientName;
            viewController.TEConfirmConsultType = self.TEConfirmConsultType;
            viewController.orderId = orderNumber;
            viewController.payType = payMode;
            [self.navigationController pushViewController:viewController animated:YES];

        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [hud hide:YES];
        }];
            
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"----%@", responseObject);
//            
//            NSString *orderNumber = [responseObject objectForKey:@"billno"];
//            self.orderModel.orderId = orderNumber;
//            self.orderModel.orderPrice = self.price;
//            self.orderModel.expertName = self.expertName;
//            self.orderModel.expertTitle = self.consultType;
//            self.orderModel.orderType = [payMode intValue];
//            [hud hide:YES];
//            UIViewController <TEOrderSuccessViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEOrderSuccessViewControllerProtocol)];
//            viewController.orderModel = self.orderModel;
//            viewController.patientId = self.patientId;
//            viewController.patientName = self.patientName;
//            viewController.TEConfirmConsultType = self.TEConfirmConsultType;
//            viewController.orderId = orderNumber;
//            viewController.payType = payMode;
//            [self.navigationController pushViewController:viewController animated:YES];
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"%@",error);
//            [hud hide:YES];
//        }];
    }
}


#pragma mark - Validate

// 验证电话和患者
- (BOOL)validatePayMode:(NSString *)payMode
{
    if (self.payModeName.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }

    return YES;
}


@end
