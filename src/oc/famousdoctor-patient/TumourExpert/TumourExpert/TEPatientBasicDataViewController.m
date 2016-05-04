//
//  TEPatientBasicDataViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientBasicDataViewController.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "TEAppDelegate.h"
#import "TEPatientBasicDataModel.h"
#import "TEResultBasicDataModel.h"
#import "TEPatientBasicDataCell.h"
#import "TEStoreManager.h"
#import "TERegisterCell.h"
#import "TEHealthArchivesBasicDataModel.h"
#import "TEResultModel.h"
#import "TEResultEditPatientDataModel.h"
#import "TEHttpTools.h"

@interface TEPatientBasicDataViewController ()
@property (nonatomic, strong) UITextField *dataNameTextField;
@property (nonatomic, strong) UITextField *hospitalTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *keshiTextField;
@property (nonatomic, strong) UITextField *zhenduanTextField;

@property (nonatomic, strong) TEHealthArchivesBasicDataModel *healthArchivesBasicData;

@property (nonatomic, strong) NSString *pmid; // 资料Id

@end

@implementation TEPatientBasicDataViewController

#pragma mark - DataSource

- (void)loadDataSource
{
    self.dataSource = [[TEStoreManager sharedStoreManager] getHealthDiseaseConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
        self.healthArchivesBasicData = [[TEHealthArchivesBasicDataModel alloc] init];
        self.pmid = @"";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"填写健康档案";
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(21, 20, 277, 51);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
    self.tableView.tableFooterView = footerView;
    
    //初始日期选择控件
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.maximumDate = [NSDate date];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self loadDataSource];
}


#pragma mark - UITableView DataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *editCellIdentifier = @"editCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    TERegisterCell *editCell = [tableView dequeueReusableCellWithIdentifier:editCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (!editCell) {
        editCell = [[TERegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:editCellIdentifier];
        editCell.valueTextField.textAlignment = NSTextAlignmentRight;
        editCell.valueTextField.textColor = [UIColor grayColor];
        editCell.valueTextField.font = [UIFont systemFontOfSize:17];
        editCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!IOS7_OR_LATER) {
            editCell.valueTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
            editCell.valueTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
        }
    }
    
    cell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
    editCell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
    
    switch (indexPath.row) {
        case 0:
            editCell.valueTextField.delegate = self;
            editCell.valueTextField.text = self.healthArchivesBasicData.dataName;
            _dataNameTextField = editCell.valueTextField;
            _dataNameTextField.tag = 0;
            return  editCell;
            break;
        case 1:
            editCell.valueTextField.delegate = self;
            editCell.valueTextField.text = self.healthArchivesBasicData.hospital;
            _hospitalTextField = editCell.valueTextField;
            _hospitalTextField.tag = 1;
            return  editCell;
            break;
        case 2:
            cell.detailTextLabel.text = self.healthArchivesBasicData.date;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 3:
            editCell.valueTextField.delegate = self;
            editCell.valueTextField.text = self.healthArchivesBasicData.keshi;
            _keshiTextField = editCell.valueTextField;
            _keshiTextField.tag = 2;
            return  editCell;
            break;
        case 4:
            editCell.valueTextField.delegate = self;
            editCell.valueTextField.text = self.healthArchivesBasicData.zhenduan;
            _zhenduanTextField = editCell.valueTextField;
            _zhenduanTextField.tag = 3;
            return  editCell;
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyboard];
    
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
        [self.view addSubview:_datePicker];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.35];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView commitAnimations];
    }
}

#pragma mark - Bussiness methods

- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *birthday = [dateFormat stringFromDate:[datePicker date]];
    self.healthArchivesBasicData.date = birthday;
    [self.tableView reloadData];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        self.healthArchivesBasicData.dataName = textField.text;
    } else if (textField.tag == 1) {
        self.healthArchivesBasicData.hospital = textField.text;
    } else if (textField.tag == 2) {
        self.healthArchivesBasicData.keshi = textField.text;
    } else if (textField.tag == 3) {
        self.healthArchivesBasicData.zhenduan = textField.text;
    }
}


#pragma mark - Bussiness methods

// 添加咨询者并跳转到下一步
- (void)nextStep
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *dataName = [_dataNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *hospital = [_hospitalTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *keshi = [_keshiTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *zhenduan = [_zhenduanTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([self validateDataName:dataName hospital:hospital date:self.healthArchivesBasicData.date keshi:keshi zhenduan:zhenduan]) {
        if (self.pmid && [self.pmid length] > 0) {
            [self editPatientDataWithPatientDataId:self.pmid dataName:dataName hospital:hospital date:self.healthArchivesBasicData.date keshi:keshi zhenduan:zhenduan];
        } else {
            [self addPatientDataWithPatientId:self.patientId dataName:dataName hospital:hospital date:self.healthArchivesBasicData.date keshi:keshi zhenduan:zhenduan];
        }
    }
}


#pragma mark - API methods

// 调用后台添加健康档案接口
- (void)addPatientDataWithPatientId:(NSString *)patientId dataName:(NSString *)dataName hospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/upload_means"];
    NSDictionary *parameters = @{@"patient_id": patientId, @"cookie":ApplicationDelegate.cookie, @"pmid_title":dataName, @"c2": hospital, @"c1": date,
                                 @"c3": keshi, @"c13": zhenduan};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEResultBasicDataModel *result = [[TEResultBasicDataModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"201"]) {
            UIViewController <TEPatientMedicalDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientMedicalDataViewControllerProtocol)];
            viewController.patientId = self.patientId;
            viewController.patientDataId = result.pmid;
            self.pmid = result.pmid;
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if ([state isEqualToString:@"-201"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"填写失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        TEResultBasicDataModel *result = [[TEResultBasicDataModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"201"]) {
//            UIViewController <TEPatientMedicalDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientMedicalDataViewControllerProtocol)];
//            viewController.patientId = self.patientId;
//            viewController.patientDataId = result.pmid;
//            self.pmid = result.pmid;
//            [self.navigationController pushViewController:viewController animated:YES];
//            
//        } else if ([state isEqualToString:@"-201"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"填写失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

- (void)editPatientDataWithPatientDataId:(NSString *)patientDataId dataName:(NSString *)dataName hospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/pmid_edit"];
    NSDictionary *parameters = @{@"pmid": patientDataId, @"cookie":ApplicationDelegate.cookie, @"pmid_title":dataName, @"c2": hospital, @"c1": date,
                                 @"c3": keshi, @"c13": zhenduan};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEResultEditPatientDataModel *result = [[TEResultEditPatientDataModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"202"]) {
            UIViewController <TEPatientMedicalDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientMedicalDataViewControllerProtocol)];
            viewController.patientId = self.patientId;
            viewController.patientDataId = self.pmid;
            [self.navigationController pushViewController:viewController animated:YES];
        } else if ([state isEqualToString:@"-202"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:result.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        TEResultEditPatientDataModel *result = [[TEResultEditPatientDataModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"202"]) {
//            UIViewController <TEPatientMedicalDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientMedicalDataViewControllerProtocol)];
//            viewController.patientId = self.patientId;
//            viewController.patientDataId = self.pmid;
//            [self.navigationController pushViewController:viewController animated:YES];
//        } else if ([state isEqualToString:@"-202"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:result.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - Keyboard


- (void)hideKeyboard
{
    [self.dataNameTextField resignFirstResponder];
    [self.hospitalTextField resignFirstResponder];
    [self.keshiTextField resignFirstResponder];
    [self.zhenduanTextField resignFirstResponder];
}

#pragma mark - Validate

// 验证姓名，年龄
- (BOOL)validateDataName:(NSString *)dataName hospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    NSLog(@"name:%@, hospital:%@, date:%@, keshi:%@, zhenduan:%@", dataName, hospital, date, keshi, zhenduan);
    
    if ([dataName length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入就诊记录名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    
    if ([hospital length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入医院" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([date length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择就诊日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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

@end
