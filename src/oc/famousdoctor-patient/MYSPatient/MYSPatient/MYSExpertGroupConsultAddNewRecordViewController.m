//
//  MYSExpertGroupConsultAddNewRecordViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultAddNewRecordViewController.h"
#import "UIColor+Hex.h"
#import "MYSExpertGroupAddNewRecordPatientCell.h"
#import "MYSExpertGroupAddNewRecordTextFiledCell.h"
#import "MYSExpertGroupAddNewRecordVisitingTimeCell.h"
#import "UIImage+Corner.h"
#import "MYSFoundationCommon.h"
#import "UUDatePicker.h"
#import "MYSStoreManager.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "MYSExpertGroupConsultAddPatientRecordResult.h"
#import "MYSExpertGroupConsultEditPatientRecordResult.h"



#define lineTopMargin 20
#define topButtonWidth 21
#define topSubViewMargin 6.5
#define longLineWidth (kScreen_Width - topButtonWidth * 2 - topSubViewMargin * 4)/2

@interface MYSExpertGroupConsultAddNewRecordViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UUDatePicker *datePicker;
@property (nonatomic, strong) UITextField *consultTimeFiled; // 就诊时间
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, weak) UITextField *hospitalTextField;
@property (nonatomic, weak) UITextField *keshiTextField;
@property (nonatomic, weak) UITextField *zhenduanTextField;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *hospital;
@property (nonatomic, copy) NSString *keshi;
@property (nonatomic, copy) NSString *zhenduan;
@property (nonatomic, strong) NSString *pmid; // 资料Id
@end

@implementation MYSExpertGroupConsultAddNewRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pmid = @"";
    
    self.title = @"新增就诊记录";
    
    [self loadDataSource];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    [self layoutTableViewHeaderView];
    
    [self layoutTableViewFooterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.tabBarController.tabBar.hidden = YES;
}


- (void)loadDataSource
{
    self.dataSource = [[MYSStoreManager sharedStoreManager] getAddNewRecordConfigureAray];
}

- (void)setPatientModel:(MYSExpertGroupPatientModel *)patientModel
{
    _patientModel = patientModel;
}

#pragma  mark LayoutUI

// 设置tableview的头部
- (void) layoutTableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 63)];
    headerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, lineTopMargin, longLineWidth/2, 3)];
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
    
    UIView *firstLongLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstButton.frame) + topSubViewMargin, lineTopMargin, longLineWidth , 3)];
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
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondButton.frame) + topSubViewMargin, lineTopMargin, longLineWidth/2, 3)];
    rightLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:rightLine];
    
    
    UILabel *fillInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/2, 12)];
    fillInfoLabel.textAlignment = NSTextAlignmentCenter;
    fillInfoLabel.text = @"基本就医资料";
    fillInfoLabel.font = [UIFont systemFontOfSize:12];
    fillInfoLabel.textColor = [UIColor colorFromHexRGB:K00907FColor];
    [headerView addSubview:fillInfoLabel];
    
    UILabel *confirmInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fillInfoLabel.frame), CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/2, 12)];
    confirmInfoLabel.font = [UIFont systemFontOfSize:12];
    confirmInfoLabel.textAlignment = NSTextAlignmentCenter;
    confirmInfoLabel.text = @"完善就医资料";
    confirmInfoLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:confirmInfoLabel];
}


- (void)layoutTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    footerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, kScreen_Width - 30, 44)];
    commitButton.layer.cornerRadius = 5.0;
    commitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [commitButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [commitButton setTitle:@"下一步" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:commitButton];
    [commitButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:commitButton];
    [commitButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
    [footerView addSubview:commitButton];
}

#pragma mark tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSExpertGroupAddNewRecordPatientCell *addNewRecordPatientCell = [[MYSExpertGroupAddNewRecordPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
       addNewRecordPatientCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    static NSString *addNewRecordTextField = @"addNewRecordTextField";
    
    MYSExpertGroupAddNewRecordTextFiledCell *addNewRecordTextFieldCell = [tableView dequeueReusableCellWithIdentifier:addNewRecordTextField];
    if (addNewRecordTextFieldCell == nil) {
        addNewRecordTextFieldCell = [[MYSExpertGroupAddNewRecordTextFiledCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addNewRecordTextField];
    }
       addNewRecordTextFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MYSExpertGroupAddNewRecordVisitingTimeCell *addNewRecordVisitingTimeCell = [[MYSExpertGroupAddNewRecordVisitingTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row == 0) {
        addNewRecordPatientCell.model = self.patientModel;
        return  addNewRecordPatientCell;
    } else if(indexPath.row == 1){
        addNewRecordVisitingTimeCell.valueTextField.enabled = NO;
        addNewRecordVisitingTimeCell.infoLabel.text =[self.dataSource[0][indexPath.row - 1] objectForKey:@"title"];
        addNewRecordVisitingTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        addNewRecordVisitingTimeCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
        addNewRecordVisitingTimeCell.valueTextField.placeholder = @"未选择";
        _consultTimeFiled = addNewRecordVisitingTimeCell.valueTextField;
        return addNewRecordVisitingTimeCell;
    } else {
        addNewRecordTextFieldCell.valueTextField.enabled = YES;
        addNewRecordTextFieldCell.infoLabel.text = [self.dataSource[0][indexPath.row - 1] objectForKey:@"title"];
        addNewRecordTextFieldCell.valueTextField.placeholder = @"未填写";
        addNewRecordTextFieldCell.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        addNewRecordTextFieldCell.accessoryType = UITableViewCellAccessoryNone;
        if(indexPath.row == 2) {
            _hospitalTextField = addNewRecordTextFieldCell.valueTextField;
            _hospitalTextField.delegate = self;
        } else if (indexPath.row == 3) {
            _keshiTextField = addNewRecordTextFieldCell.valueTextField;
            _keshiTextField.delegate = self;
        } else {
            _zhenduanTextField = addNewRecordTextFieldCell.valueTextField;
            _zhenduanTextField.delegate =self;
        }
        return addNewRecordTextFieldCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 65;
    } else {
        return 44;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [self featchCurrentTimeWithIndex:indexPath.row];
        [self setupDataPicker];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([textField isEqual:_hospitalTextField]) {
        [_keshiTextField becomeFirstResponder];
    } else if ([textField isEqual:_keshiTextField]) {
        [_zhenduanTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
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
            
            layer.path = pathRef;
            
            CFRelease(pathRef);
            
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            
            
            if (addLine == YES) {
                
                CALayer *lineLayer = [[CALayer alloc] init];
                
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                
                
                if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                }else {
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


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    LOG(@"hahahhahahh");
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
    _consultTimeFiled.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)y,(long)m,(long)d];
}


// 日期选择器
- (void)setupDataPicker
{
    [_hospitalTextField resignFirstResponder];
    [_keshiTextField resignFirstResponder];
    [_zhenduanTextField resignFirstResponder];
    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    dataView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    dataView.tag = 99;
    [self.view addSubview:dataView];
    NSDate *now = [NSDate date];
    UUDatePicker *datePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, kScreen_Height, kScreen_Width, 200) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        _consultTimeFiled.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }];
    self.datePicker = datePicker;
    datePicker.maxLimitDate =now;
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
    
    [_datePicker removeFromSuperview];
}

#pragma mark UITextFieldDelegate


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextStep
{
    self.time = [_consultTimeFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.hospital = [_hospitalTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.keshi = [_keshiTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.zhenduan = [_zhenduanTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([self validateHospital:self.hospital date:self.time keshi:self.keshi zhenduan:self.zhenduan]) {
        if (self.pmid && [self.pmid length] > 0) {
            [self editPatientDataWithPatientDataId:self.pmid dataName:self.zhenduan hospital:self.hospital date:self.time keshi:self.keshi zhenduan:self.zhenduan];
        } else {
            [self addPatientDataWithPatientId:self.patientModel.patientId dataName:self.zhenduan hospital:self.hospital date:self.time keshi:self.keshi zhenduan:self.zhenduan];
        }
    }
}


#pragma mark - Validate

// 验证姓名，年龄
- (BOOL)validateHospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    
    if ([date length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择就诊日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    
    if ([hospital length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入医院" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    
    if ([keshi length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入就诊科室" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    
    if ([zhenduan length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入初步诊断" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}



#pragma mark - API methods

// 调用后台添加健康档案接口
- (void)addPatientDataWithPatientId:(NSString *)patientId dataName:(NSString *)dataName hospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在提交";

    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/upload_means"];
    NSDictionary *parameters = @{@"patient_id": patientId, @"cookie":ApplicationDelegate.cookie, @"pmid_title":dataName, @"c2": hospital, @"c1": date,
                                 @"c3": keshi, @"c13": zhenduan};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        
        MYSExpertGroupConsultAddPatientRecordResult *result = [[MYSExpertGroupConsultAddPatientRecordResult alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"201"]) {
            UIViewController <MYSExpertGroupConsultAddNewRecordDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultAddNewRecordDataViewControllerProtocol)];
            self.hidesBottomBarWhenPushed = YES;
            viewController.patientModel = self.patientModel;
            viewController.patientDataId = result.pmid;
            self.pmid = result.pmid;
            [self.navigationController pushViewController:viewController animated:YES];
        } else if ([state isEqualToString:@"-201"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"填写失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        hud.hidden = YES;
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        hud.hidden = YES;
    }];
}


// 编辑就诊记录
- (void)editPatientDataWithPatientDataId:(NSString *)patientDataId dataName:(NSString *)dataName hospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/pmid_edit"];
    NSDictionary *parameters = @{@"pmid": patientDataId, @"cookie":ApplicationDelegate.cookie, @"pmid_title":dataName, @"c2": hospital, @"c1": date,
                                 @"c3": keshi, @"c13": zhenduan};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        
        MYSExpertGroupConsultEditPatientRecordResult *result = [[MYSExpertGroupConsultEditPatientRecordResult alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"202"]) {
            UIViewController <MYSExpertGroupConsultAddNewRecordDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultAddNewRecordDataViewControllerProtocol)];
            self.hidesBottomBarWhenPushed = YES;
            viewController.patientModel = self.patientModel;
            viewController.patientDataId = self.pmid;
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if ([state isEqualToString:@"-202"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:result.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
    }];
}


@end
