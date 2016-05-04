//
//  TEOfflineConsultViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOfflineConsultViewController.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEAskModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TESeekExpertCell.h"
#import "TEConsultMultipleChoiceCell.h"
#import "TEPatientData.h"
#import "TEAppDelegate.h"
#import "TERegisterCell.h"
#import "TEHealthArchiveDetail.h"
#import "TEHealthArchiveDataInfoModel.h"
#import "TEValidateTools.h"
#import "UIImageView+NetLoading.h"
#import "TEHttpTools.h"


@interface TEOfflineConsultViewController () <TEReusableTextViewViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *phone; // 电话
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, strong) NSString *patientName; // 患者
@property (nonatomic, strong) NSString *patientDataId; // 患者资料Id
@property (nonatomic, strong) NSString *patientDataName; // 患者资料
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *symptom;
@property (nonatomic, strong) NSString *detailDesc;
@property (nonatomic, strong) NSString *help;

@property (nonatomic, strong) TEAskModel *askModel;
@property BOOL isAgreementSelected;

@property (nonatomic, strong) NSMutableArray *healthFiles;
@property (nonatomic, strong) NSMutableArray *selectHealthFiles;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, strong) UITextField *phoneTextField;
@end

@implementation TEOfflineConsultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPatientData) name:@"addPatientData" object:nil];
    // 查看通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consultMultipleLableClick:) name:@"consultMultiple" object:nil];
    [self configUI];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchAsk];
        });
    };
    
    [reach startNotifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)healthFiles
{
    if (_healthFiles == nil) {
        _healthFiles = [NSMutableArray arrayWithObjects:@"健康档案",@"新建资料", nil];
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

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.patientName = @"请选择咨询者";
    self.patientDataName = @"请选择健康档案";
    
    
    //初始日期选择控件
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minimumDate = [NSDate date];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
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
    [submitButton setTitle:@"下一步" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitButton];
    self.tableView.tableFooterView = view;
}
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        return 6;
    } else if (section == 2) {
        return self.healthFiles.count;
    } else  {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *editCellIdentifier = @"editCellIdentifier";
    static NSString *CellIdentifier = @"CellIdentifier";
    static NSString *multipleChoiceIdentifier = @"multipleChoiceCellIdentifier";
    
    UITableViewCell *cell;
    TESeekExpertCell *expertCell;
    TEConsultMultipleChoiceCell *multipleChoiceCell;
    TERegisterCell *editCell;
    if (indexPath.section == 0) {
        if (!expertCell) {
            expertCell = [[TESeekExpertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            expertCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        expertCell.doctorLabel.text = _askModel.expertName;
        expertCell.titleLabel.text = _askModel.expertTitle;
        expertCell.hospitalLabel.text = _askModel.hospitalName;
         [expertCell.iconImageView accordingToNetLoadImagewithUrlstr:_askModel.expertIcon and:@"logo.png"];
        return expertCell;
    } else if (indexPath.section == 1) {
        cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        editCell = [aTableView dequeueReusableCellWithIdentifier:editCellIdentifier];
        if (!editCell) {
            editCell = [[TERegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:editCellIdentifier];
        }
        if (indexPath.row == 0) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.textLabel.text = @"咨询者";
            cell.detailTextLabel.text = self.patientName;
            
            
        } else if (indexPath.row == 1) {

            cell.textLabel.text = @"咨询类型";
            cell.detailTextLabel.text = self.title;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        } else if (indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.detailTextLabel.text = nil;
            cell.textLabel.text = @"主要症状和感受";
            return cell;
        } else if (indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.detailTextLabel.text = nil;
            cell.textLabel.text = @"详细描述及以往就医记录";
        } else if (indexPath.row == 4){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.detailTextLabel.text = nil;
            cell.textLabel.text = @"希望得到医生的何种帮助";
        } else {
            editCell.valueTextField.delegate = self;
            editCell.selectionStyle = UITableViewCellSelectionStyleNone;
            editCell.accessoryType = UITableViewCellAccessoryNone;
            editCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            editCell.valueTextField.font = [UIFont boldSystemFontOfSize:14];
            editCell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            editCell.textLabel.text = @"联系方式";
            editCell.valueTextField.textAlignment = NSTextAlignmentRight;
            editCell.valueTextField.text = self.phone;
            self.phoneTextField = editCell.valueTextField;
            return editCell;
        }
        return cell;
        
    } else if (indexPath.section == 2) {
        cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        multipleChoiceCell = [aTableView dequeueReusableCellWithIdentifier:multipleChoiceIdentifier];
        if (multipleChoiceCell == nil) {
            multipleChoiceCell = [[TEConsultMultipleChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:multipleChoiceIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            cell.detailTextLabel.text = nil;
            cell.textLabel.text = self.healthFiles[indexPath.row];
            return cell;
            
        } else if (indexPath.row == (self.healthFiles.count - 1)) {
            multipleChoiceCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            multipleChoiceCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            multipleChoiceCell.textLabel.textColor = [UIColor colorWithHex:0x00947d];
            multipleChoiceCell.textLabel.text = self.healthFiles[indexPath.row];
            multipleChoiceCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            multipleChoiceCell.mSelected = NO;
            multipleChoiceCell.showSelectedIndicator = NO;
            multipleChoiceCell.showAccessLable = NO;
            return multipleChoiceCell;
        } else {
            TEHealthArchiveDataInfoModel *healthArchiveDataInfo = self.healthFiles[indexPath.row];
            if ([healthArchiveDataInfo.selcted isEqualToString:@"1"]) {
                multipleChoiceCell.mSelected = YES;
            } else {
                multipleChoiceCell.mSelected = NO;
            }
            multipleChoiceCell.showSelectedIndicator = YES;
            multipleChoiceCell.showAccessLable = YES;
            multipleChoiceCell.contentModel = healthArchiveDataInfo;
            multipleChoiceCell.accessoryType = UITableViewCellAccessoryNone;
            multipleChoiceCell.textLabel.text = healthArchiveDataInfo.patientDataName;
            multipleChoiceCell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            multipleChoiceCell.textLabel.textColor = [UIColor colorWithHex:0x383838];
            
            return multipleChoiceCell;
        }
        
        //        return cell;
    } else {
        cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.textColor = [UIColor colorWithHex:0x383838];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.text = @"期望预约时间";
        cell.detailTextLabel.text = self.startTime;
        return cell;
    }
}

#pragma mark - UITableView Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == self.healthFiles.count - 1) {
            return NO;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIViewController <TEChoosePatientViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEChoosePatientViewControllerProtocol)];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:NO];
        }
        if(indexPath.row == 2) {
            UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
            viewController.flag = @"major";
            viewController.delegate = self;
            viewController.content = self.symptom;
            viewController.title = @"主要症状和感受";
            viewController.exampleContent = @"下腹疼痛1个多月，看过一次医生，给开了泻立停药，吃了也不见好5cm瘢痕，愈合良好。发病以来体重减轻5KG，生活可自理，目前未输液。";
            
            [self.navigationController pushViewController:viewController animated:NO];
        }
        
        if (indexPath.row == 3) {
            UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
            viewController.flag = @"detail";
            viewController.delegate = self;
            viewController.content = self.detailDesc;
            viewController.title = @"详情描述及以往就医记录";
            viewController.exampleContent = @"2年前突然出现腹胀、腹痛，伴恶心、呕吐，呕吐物为咖啡色，口服\"西咪替丁\"效果 不好 ，2014年4月8 日在西安交大一附院，做胃镜检查提示：胃窦部溃疡性病变。发病以来体重减轻5KG，生活可自理，目前未输液。";
            
            [self.navigationController pushViewController:viewController animated:NO];
        }
        
        if (indexPath.row == 4) {
            UIViewController <TEReusableTextViewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEReusableTextViewViewControllerProtocol)];
            viewController.flag = @"help";
            viewController.delegate = self;
            viewController.content = self.help;
            viewController.title = @"希望得到医生的何种帮助";
            viewController.exampleContent = @"想问问医生，目前我这种状况是否需要继续化疗，大概还需要多少个疗程？还需要做哪些进一步检查吗？";
            
            [self.navigationController pushViewController:viewController animated:NO];
        }

    } else if (indexPath.section == 2) {
        if (indexPath.row != 0 && indexPath.row != (self.healthFiles.count -1)) {
            if (self.selectHealthFiles.count == 0) {
                TEHealthArchiveDataInfoModel *healthArchiveDataInfo = self.healthFiles[indexPath.row];
                healthArchiveDataInfo.selcted = @"1";
                [self.selectHealthFiles addObject:healthArchiveDataInfo];
                
            } else  {
                [self.healthFiles removeObjectAtIndex:0];
                [self.healthFiles removeLastObject];
                for (TEHealthArchiveDataInfoModel *healthArchiveData in self.healthFiles) {
                    healthArchiveData.selcted = @"0";
                    [self.selectHealthFiles removeAllObjects];
                }
                [self.healthFiles insertObject:@"健康档案" atIndex:0];
                [self.healthFiles addObject:@"新建资料"];
                
                TEHealthArchiveDataInfoModel *healthArchiveDataInfo = self.healthFiles[indexPath.row];
                [self.selectHealthFiles addObject:healthArchiveDataInfo];
                healthArchiveDataInfo.selcted = @"1";
            }
            
            TEConsultMultipleChoiceCell *cell = (TEConsultMultipleChoiceCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell changeMSelectedState];
            
            [self.tableView reloadData];
        }
        
        if (indexPath.row == (self.healthFiles.count - 1 )) {
            if (self.patientId == nil || [self.patientId length] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择咨询者" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            } else {
                ApplicationDelegate.patientDataProtal = TEPatientDataPortalConsult;
                self.hidesBottomBarWhenPushed = YES;
                UIViewController <TEPatientBasicDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientBasicDataViewControllerProtocol)];
                viewController.patientId = self.patientId;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            
        }
        
    } else if (indexPath.section == 3) {

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

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    } else if (indexPath.section == 1) {
        return 44;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 44;
        } else {
            return 39;
        }
    } else {
        return 44;
    }
}


#pragma mark - TEReusableTextViewControllerDelegate

- (void)didFinishedTextViewContent:(NSString *)content byFlag:(NSString *)flag
{
    if ([flag isEqualToString:@"major"]) {
        self.symptom = content;
        [self.tableView reloadData];
    }  else if ([flag isEqualToString:@"detail"]) {
        self.detailDesc = content;
        [self.tableView reloadData];
    }  else if ([flag isEqualToString:@"help"]) {
        self.help = content;
        [self.tableView reloadData];
    }
}



#pragma mark - TEChoosePatientViewControllerDelegate

- (void)didSelectedPatientId:(NSString *)patientId patientName:(NSString *)patientName
{
    if (![patientId isEqualToString:self.patientId]) {
        self.patientId = patientId;
        self.patientName = patientName;
        self.patientDataId = @"";
        self.patientDataName = @"";
        
        [self fetchPatientData];
    }
}
#pragma mark - API methods

// 获取患者资料列表
- (void)fetchPatientData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"health_details"];
    NSDictionary *parameters = @{@"patient_id": self.patientId};
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


// 提交订单
- (void)submitOrder:(id)sender
{
    if ([self validatePhone:self.phone patientId:self.patientId patientDataId:self.patientDataId selectHealthFiles:self.selectHealthFiles]) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TEConfirmConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConfirmConsultViewControllerProtocol)];

        viewController.patientId = self.patientId;
        viewController.expertName = self.askModel.expertName;
        viewController.startTime = self.startTime;
        viewController.endTime = self.endTime;
        viewController.phone = self.phone;
        viewController.patientName = self.patientName;
        viewController.TEConfirmConsultType = TEConfirmConsultOffLine;
        viewController.selectHealthFiles = self.selectHealthFiles;
        viewController.price = self.askModel.price;
        viewController.symptom = self.symptom;
        viewController.help = self.help;
        viewController.detailDesc = self.detailDesc;
        viewController.doctorId = self.expertId;
        viewController.proid = self.askModel.productId;

        [self.navigationController pushViewController:viewController animated:YES];
    }
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
        self.startTime = [dateFormat stringFromDate:[datePicker date]];
    }  else {
        self.endTime = [dateFormat stringFromDate:[datePicker date]];
    }

    [self.tableView reloadData];
}

- (void)addPatientData
{
    [self fetchPatientData];
}


// cell查看
- (void)consultMultipleLableClick:(NSNotification *)notification
{
    TEHealthArchiveDataInfoModel *healthArchiveDataInfo = (TEHealthArchiveDataInfoModel *)[notification.userInfo objectForKey:@"consultMultiple"];
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEPatientDataPreviewViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientDataPreviewViewControllerProtocol)];
    viewController.patientId = healthArchiveDataInfo.patientId;
    viewController.patientDataId = healthArchiveDataInfo.patientDataId;
    [self pushNewViewController:viewController];
}
#pragma mark - API methods

// 获取咨询详情
- (void)fetchAsk
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult"];
    NSDictionary *parameters = @{@"doctorid": self.expertId, @"type": @"2"};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        _askModel = [[TEAskModel alloc] initWithDictionary:responseObject error:nil];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        _askModel = [[TEAskModel alloc] initWithDictionary:responseObject error:nil];
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}


#pragma mark - Validate

// 验证电话和患者
- (BOOL)validatePhone:(NSString *)phone patientId:(NSString *)patientId patientDataId:(NSString *)patientDataId selectHealthFiles:(NSArray *)selectHealthFiles
{

    if (patientId == nil || [patientId length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择咨询者" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
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
    if (![TEValidateTools validateFixedLine:phone]) {
        if (![TEValidateTools validateMobile:phone]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机或固定电话号（固定电话格式为区号-号码）" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }

    if (patientDataId == nil || [patientId length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择健康档案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (selectHealthFiles.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择健康档案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (self.startTime == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择期望预约时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    return YES;
}

@end
