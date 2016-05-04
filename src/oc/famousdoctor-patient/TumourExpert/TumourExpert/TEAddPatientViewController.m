//
//  TEAddPatientViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAddPatientViewController.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "TEAppDelegate.h"
#import "TEResultAddPatientModel.h"
#import "TEValidateTools.h"
#import "TEStoreManager.h"
#import "TERegisterCell.h"
#import "TEHealthArchivesUserModel.h"
#import "TEHttpTools.h"

@interface TEAddPatientViewController ()
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idCardTextField;
@property (nonatomic, strong) UITextField *heightTextField;
@property (nonatomic, strong) UITextField *weightTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) TEHealthArchivesUserModel *healthArchivesUser;
@end

@implementation TEAddPatientViewController

#pragma mark - DataSource

- (void)loadDataSource
{
    self.dataSource = [[TEStoreManager sharedStoreManager] getHealthUserConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
        self.healthArchivesUser = [[TEHealthArchivesUserModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新建咨询者";

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(21, 20, 277, 51);
    if(ApplicationDelegate.addPatientProtal == TEAddPatientPotalConsult) {
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
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
    }
    
    if (!editCell) {
        editCell = [[TERegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:editCellIdentifier];
        editCell.valueTextField.textAlignment = NSTextAlignmentRight;
        editCell.valueTextField.textColor = [UIColor grayColor];
        editCell.valueTextField.font = [UIFont systemFontOfSize:17];
        editCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    editCell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
    
    
    switch (indexPath.row) {
        case 0:
            editCell.valueTextField.delegate = self;
            editCell.valueTextField.text = self.healthArchivesUser.name;
            _nameTextField = editCell.valueTextField;
            _nameTextField.tag = 0;
            
            if (!IOS7_OR_LATER) {
                editCell.valueTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
                editCell.valueTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
            }
            break;
        case 1:
            editCell.valueTextField.delegate = self;
            editCell.valueTextField.text = self.healthArchivesUser.idCard;
            _idCardTextField = editCell.valueTextField;
            _idCardTextField.tag = 1;
            
            if (!IOS7_OR_LATER) {
                editCell.valueTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
                editCell.valueTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
            }
            break;
        case 2:
            cell.detailTextLabel.text = self.healthArchivesUser.gender;
            cell.textLabel.text = @"性别";
            return  cell;
            break;
        case 3:
            cell.detailTextLabel.text = self.healthArchivesUser.birthday;
            cell.textLabel.text = @"出生日期";
            return  cell;
            break;
        case 4:
        {
            CGRect frame = CGRectMake(0, 0, 24, 21);
            if (!IOS7_OR_LATER) {
                frame = CGRectMake(0, 0, 34, 21);
            }
            
            UILabel *heightLabel = [[UILabel alloc] initWithFrame:frame];
            heightLabel.font = [UIFont systemFontOfSize:17];
            heightLabel.text = @"cm";
            heightLabel.textColor = [UIColor grayColor];
            heightLabel.backgroundColor = [UIColor clearColor];
            
            editCell.valueTextField.delegate = self;
            editCell.valueTextField.text = self.healthArchivesUser.height;
            editCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
            editCell.valueTextField.rightView = heightLabel;
            editCell.valueTextField.rightViewMode = UITextFieldViewModeAlways;
            _heightTextField = editCell.valueTextField;
            _heightTextField.tag = 2;
            break;
        }
        case 5:
        {
            CGRect frame = CGRectMake(0, 0, 24, 21);
            if (!IOS7_OR_LATER) {
                frame = CGRectMake(0, 0, 34, 21);
            }
            
            UILabel *weightLabel = [[UILabel alloc] initWithFrame:frame];
            weightLabel.font = [UIFont systemFontOfSize:17];
            weightLabel.text = @"kg";
            weightLabel.textColor = [UIColor grayColor];
            weightLabel.backgroundColor = [UIColor clearColor];
            
            editCell.valueTextField.delegate = self;
            editCell.valueTextField.text = self.healthArchivesUser.weight;
            editCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
            editCell.valueTextField.rightView = weightLabel;
            editCell.valueTextField.rightViewMode = UITextFieldViewModeAlways;
            _weightTextField = editCell.valueTextField;
            _weightTextField.tag = 3;
            break;
        }
        default:
            break;
    }
    
    return editCell;
}

#pragma mark - UITableView Delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyboard];
  
    if (indexPath.row == 2) {
        [self actionSheetGender];
    } else if (indexPath.row == 3) {
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

// 性别
- (void)actionSheetGender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles:@"男", @"女", nil];
    [actionSheet showInView:self.view];
}

- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *birthday = [dateFormat stringFromDate:[datePicker date]];
    self.healthArchivesUser.birthday = birthday;
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


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.healthArchivesUser.gender = @"男";
    } else if (buttonIndex == 1) {
        self.healthArchivesUser.gender = @"女";
    }
    [self.tableView reloadData];
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
        self.healthArchivesUser.name = textField.text;
    } else if (textField.tag == 1) {
        self.healthArchivesUser.idCard = textField.text;
    } else if (textField.tag == 2) {
        self.healthArchivesUser.height = textField.text;
    } else if (textField.tag == 3) {
        self.healthArchivesUser.weight = textField.text;
    }
}


#pragma mark - Bussiness methods

// 添加咨询者并跳转到下一步
- (void)nextStep
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *name = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *idCard = [_idCardTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *height = [_heightTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *weight = [_weightTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateName:name idCard:idCard gender:self.healthArchivesUser.gender birthday:self.healthArchivesUser.birthday height:height weight:weight]) {
        NSString *gender = @"";
        if ([self.healthArchivesUser.gender isEqualToString:@"男"]) {
            gender = @"1";
        } else if ([self.healthArchivesUser.gender isEqualToString:@"女"]) {
            gender = @"0";
        }
        [self addPatientWithName:name gender:gender birthday:self.healthArchivesUser.birthday idCard:idCard height:height weight:weight];
    }
}


#pragma mark - API methods

// 调用后台添加患者接口
- (void)addPatientWithName:(NSString *)name gender:(NSString *)gender birthday:(NSString *)birthday idCard:(NSString *)idCard height:(NSString *)height weight:(NSString *)weight
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/addpatient"];
    NSDictionary *parameters = @{@"uid": ApplicationDelegate.userId, @"cookie":ApplicationDelegate.cookie, @"patient_name":name, @"patient_sex":gender, @"patient_birthday": birthday, @"patient_itentity": idCard,
                                 @"patient_height": height, @"patient_weight": weight};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEResultAddPatientModel *result = [[TEResultAddPatientModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"202"]) {
            if (ApplicationDelegate.addPatientProtal == TEAddPatientPotalConsult) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIViewController <TEPatientBasicDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientBasicDataViewControllerProtocol)];
                viewController.patientId = result.patientId;
                [self.navigationController pushViewController:viewController animated:YES];
            }
        } else if ([state isEqualToString:@"-406"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证号码已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
        ;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        TEResultAddPatientModel *result = [[TEResultAddPatientModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"202"]) {
//            if (ApplicationDelegate.addPatientProtal == TEAddPatientPotalConsult) {
//                [self.navigationController popViewControllerAnimated:YES];
//            } else {
//            UIViewController <TEPatientBasicDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPatientBasicDataViewControllerProtocol)];
//            viewController.patientId = result.patientId;
//            [self.navigationController pushViewController:viewController animated:YES];
//            }
//        } else if ([state isEqualToString:@"-406"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证号码已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

#pragma mark - Keyboard

// 隐藏键盘
- (void)hideKeyboard
{
    [self.nameTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
    [self.heightTextField resignFirstResponder];
    [self.weightTextField resignFirstResponder];
}

#pragma mark - Validate

// 验证姓名，年龄
- (BOOL)validateName:(NSString *)name idCard:(NSString *)idCard gender:(NSString *)gender birthday:(NSString *)birthday height:(NSString *)height weight:(NSString *)weight
{
    NSLog(@"name:%@, idCard:%@, gender:%@, birthday:%@, height:%@, weight:%@", name, idCard, gender, birthday, height, weight);
    
    if ([name length] < 2 || [name length] > 20) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![TEValidateTools validatechineseAndEngSet:name]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名为中文、英文字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![TEValidateTools validate18PaperId:idCard]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的身份证号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([gender length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择性别" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([birthday length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择出生日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    birthday = [birthday stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (![[idCard substringWithRange:NSMakeRange(6, 8)] isEqualToString:birthday]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"出生日期和身份证不符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }


    if (![TEValidateTools validatePositiveNumber:height]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的身高" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([height intValue] < 20 || [height intValue] > 500) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的身高" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }

    if (![TEValidateTools validatePositiveNumber:weight]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的体重" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([weight intValue] < 10 || [weight intValue] > 500) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的体重" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }

    return YES;
}

@end
