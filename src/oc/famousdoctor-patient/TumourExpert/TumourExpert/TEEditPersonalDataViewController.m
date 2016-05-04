//
//  TEEditPersonalDataViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEEditPersonalDataViewController.h"
#import "TEAppDelegate.h"
#import "TEUserModel.h"
#import "TEResultModel.h"
#import "TEStoreManager.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "TEFoundationCommon.h"
#import "TERegisterCell.h"
#import "TEAreaPickerView.h"
#import "TEValidateTools.h"
#import "TEHttpTools.h"

@interface TEEditPersonalDataViewController ()  <UIPickerViewDelegate>
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *mobilePhone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *trueName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *detailedAddress;
@property (strong, nonatomic) UITextField *userNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *trueNameTextField;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *detailedAddressTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) TEAreaPickerView *areaPicker;
@end

@implementation TEEditPersonalDataViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[TEStoreManager sharedStoreManager] getPersonalDataConfigureArray];
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaPickerValueChange) name:@"changeValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.userNameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.emailTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.trueNameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.detailedAddressTextField];
    
    [super viewDidLoad];
    
    [self loadDataSource];
    
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
}

// UI设置
- (void)configUI
{
    self.title = @"编辑基本资料";
}

// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(commitPersonalData:)];
    
    //初始日期选择控件
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.maximumDate = [NSDate date];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    TEAreaPickerView *areaPicker = [[TEAreaPickerView alloc] initWithWithStyle:TEAreaPickerWithStateAndCityAndDistrict andFrame:CGRectMake(0, 0, kScreen_Width, 216)];
    self.areaPicker.pickerStyle = TEAreaPickerWithStateAndCityAndDistrict;
    self.areaPicker = areaPicker;
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 50;
            break;
        case 1:
            return 30;
            break;
        default:
            return 4;
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *editCellIdentifier = @"editCellIdentifier";
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    TERegisterCell *editCell = [tableView dequeueReusableCellWithIdentifier:editCellIdentifier];
    
    if (!editCell) {
        editCell = [[TERegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:editCellIdentifier];
        editCell.valueTextField.textAlignment = NSTextAlignmentRight;
        editCell.valueTextField.textColor = [UIColor grayColor];
        editCell.valueTextField.font = [UIFont systemFontOfSize:17];
        if (!IOS7_OR_LATER) {
            editCell.valueTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
            editCell.valueTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
        }
        editCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    
    editCell.textLabel.text = [self.dataSource[indexPath.section][indexPath.row] valueForKey:@"title"];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                if (self.userName.length > 0) {
                    cell.textLabel.text = @"用户名";
                    cell.detailTextLabel.text = self.userName;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return  cell;
                } else {
                    editCell.valueTextField.delegate = self;
                    editCell.valueTextField.text = self.userName;
                    editCell.valueTextField.keyboardType = UIKeyboardTypeDefault;
                    _userNameTextField = editCell.valueTextField;
                    return editCell;
                }
                break;
            case 1:
                cell.textLabel.text = @"手机号";
                cell.detailTextLabel.text = self.mobilePhone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return  cell;
                break;
            case 2:
                if (self.email.length > 0) {
                    cell.textLabel.text = @"电子邮箱";
                    cell.detailTextLabel.text = self.email;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return  cell;
                    
                } else {
                    editCell.valueTextField.delegate = self;
                    editCell.valueTextField.text = self.email;
                    editCell.valueTextField.keyboardType = UIKeyboardTypeEmailAddress;
                    _emailTextField = editCell.valueTextField;
                    return editCell;
                }
                
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                editCell.valueTextField.delegate = self;
                editCell.valueTextField.text = self.trueName;
                editCell.valueTextField.keyboardType = UIKeyboardTypeDefault;
                _trueNameTextField = editCell.valueTextField;
                break;
            case 1:
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = self.gender;
                return  cell;
                break;
            case 2:
                cell.textLabel.text = @"出生日期";
                cell.detailTextLabel.text = self.birthday;
                return  cell;
                break;
            case 3:
                editCell.valueTextField.delegate = self;
                editCell.valueTextField.text = self.phone;
                editCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
                _phoneTextField = editCell.valueTextField;
                break;
            case 4:
                cell.textLabel.text = @"省市区";
                if ([self.userModel.province isEqualToString:@"0"]) {
                    self.province = @"";
                }
                if ([self.userModel.city isEqualToString:@"0"]) {
                    self.city = @"";
                }
                if ([self.userModel.region isEqualToString:@"0"]) {
                    self.region = @"";
                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.region];
                return  cell;
                break;
            case 5:
                editCell.valueTextField.delegate = self;
                editCell.valueTextField.text = self.detailedAddress;
                editCell.valueTextField.keyboardType = UIKeyboardTypeDefault;
                _detailedAddressTextField = editCell.valueTextField;
                break;
                
            default:
                break;
        }
    }
    
    return editCell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"账号资料";
    } else {
        return @"个人信息";
    }
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [self actionSheetGender];
        } else if (indexPath.row == 2) {
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
        } else  if (indexPath.row == 4) {
            UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
            areaView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
            areaView.tag = 98;
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.25;
            transition.type = kCATransitionFade;
            [self.view.layer addAnimation:transition forKey:nil];
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCityPickView:)];
            tapGR.numberOfTapsRequired    = 1;
            tapGR.numberOfTouchesRequired = 1;
            [areaView addGestureRecognizer:tapGR];
            [self.view addSubview:areaView];
            
            [_areaPicker showInView:self.view];

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.35];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView commitAnimations];
            
        }
        
    }
}


#pragma mark UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{   if([textField isEqual:self.userNameTextField]) {
    self.userName = textField.text;
}else if ([textField isEqual:self.trueNameTextField]) {
    self.trueName = textField.text;
} else if ([textField isEqual:self.phoneTextField]) {
    self.phone = textField.text;
} else if ([textField isEqual:self.emailTextField]){
    self.email = textField.text;
} else {
    self.detailedAddress = textField.text;
}
}

#pragma mark NSNotification
- (void)textFieldChanged:(NSNotification *)notification
{
    if (notification.object == self.userNameTextField) {
        self.userName = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else if (notification.object == self.trueNameTextField) {
        self.trueName = self.trueNameTextField.text;
    } else if (notification.object == self.phoneTextField) {
        self.phone = self.phoneTextField.text;
    } else if (notification.object == self.emailTextField) {
        self.email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    } else {
        self.detailedAddress = self.detailedAddressTextField.text;
    }
}


- (void)setUserModel:(TEUserModel *)userModel
{
    _userModel = userModel;
    
    self.userName = userModel.userName;
    self.mobilePhone = userModel.mobilephone;
    self.email = userModel.email;
    self.trueName = userModel.trueName;
    self.gender = userModel.gender;
    self.birthday = userModel.birthday;
    self.phone = userModel.phone;
    self.province = userModel.province;
    self.city = userModel.city;
    self.region = userModel.region;
    self.detailedAddress = userModel.detailedAddress;
}


#pragma mark - Bussiness methods

- (void)areaPickerValueChange
{
    NSString *province = nil;
    NSString *city = nil;
    NSString *region = nil;
    if (self.areaPicker.pickerStyle == TEAreaPickerWithStateAndCityAndDistrict) {
        province = _areaPicker.selectedState;
        city = _areaPicker.selectedCity;
        region = _areaPicker.selectedDistrict;
    } else {
        province = _areaPicker.selectedState;
        city = _areaPicker.selectedCity;
    }
    
    self.province = province;
    self.city = city;
    self.region = region;
    
    [self.tableView reloadData];
}

// 性别
- (void)actionSheetGender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles:@"男", @"女", nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 0;
}

- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *birthday = [dateFormat stringFromDate:[datePicker date]];
    self.birthday = birthday;
    [self.tableView reloadData];
}

- (void)removeCityPickView:(UITapGestureRecognizer *)tap
{
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.25;
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [[self.view viewWithTag:98] removeFromSuperview];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _areaPicker.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 216);
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
    _datePicker.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 216);
    [UIView commitAnimations];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.gender = @"男";
    } else if (buttonIndex == 1) {
        self.gender = @"女";
    }
    [self.tableView reloadData];
}

- (void)editPersonalData
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"user_edit"];
    
    NSDictionary *parameters1 = @{@"userid": ApplicationDelegate.userId, @"cookie": ApplicationDelegate.cookie, @"real_name": self.trueName, @"sex": self.gender, @"phone": self.phone, @"birthday": self.birthday,
                                  @"province": self.province, @"city": self.city, @"region": self.region, @"address": self.detailedAddress, @"nick_name": self.userName, @"email": self.email};
    
    NSDictionary *parameters2 = @{@"userid": ApplicationDelegate.userId, @"cookie": ApplicationDelegate.cookie, @"real_name": self.trueName, @"sex": self.gender, @"phone": self.phone, @"birthday": self.birthday,
                                  @"province": self.province, @"city": self.city, @"region": self.region, @"address": self.detailedAddress, @"email": self.email};
    
    NSDictionary *parameters3 = @{@"userid": ApplicationDelegate.userId, @"cookie": ApplicationDelegate.cookie, @"real_name": self.trueName, @"sex": self.gender, @"phone": self.phone, @"birthday": self.birthday,
                                  @"province": self.province, @"city": self.city, @"region": self.region, @"address": self.detailedAddress, @"nick_name": self.userName};
    
    NSDictionary *parameters4 = @{@"userid": ApplicationDelegate.userId, @"cookie": ApplicationDelegate.cookie, @"real_name": self.trueName, @"sex": self.gender, @"phone": self.phone, @"birthday": self.birthday,
                                  @"province": self.province, @"city": self.city, @"region": self.region, @"address": self.detailedAddress};
    
    NSMutableDictionary *parameters;
    
    if ([self.userModel.userName isEqualToString:@""] && [self.userModel.email isEqualToString:@""]) {
        if (self.userName.length > 0 && self.email.length > 0) {
            parameters = [NSMutableDictionary dictionaryWithDictionary:parameters1];
        } else if (self.userName.length > 0 && [self.email isEqualToString:@""]) {
            parameters = [NSMutableDictionary dictionaryWithDictionary:parameters3];
        } else if([self.userName isEqualToString:@""] && self.email.length > 0){
            parameters = [NSMutableDictionary dictionaryWithDictionary:parameters2];
        } else {
            parameters = [NSMutableDictionary dictionaryWithDictionary:parameters4];
        }
    }
    
    if ([self.userModel.userName isEqualToString:@""] && self.userModel.email.length > 0) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:parameters3];
    }
    
    if (self.userModel.userName.length > 0 && [self.userModel.email isEqualToString:@""]) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:parameters2];
    }
    
    if (self.userModel.userName.length > 0 && self.userModel.email.length > 0) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:parameters4];
    }
    
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        self.navigationItem.rightBarButtonItem.enabled = YES;
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        if ([result.state isEqualToString:@"201"]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (([result.state isEqualToString:@"201"])){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        if ([result.state isEqualToString:@"201"]) {
//            [self.navigationController popViewControllerAnimated:YES];
//        } else if (([result.state isEqualToString:@"201"])){
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//        NSLog(@"Error: %@ desc:%@", error, [operation responseString]);
//    }];
}

- (void)commitPersonalData:(UIBarButtonItem *)sender
{
    // 去除空格
    NSString *name = [_trueNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([self validateTrueName:name birthday:self.birthday gender:self.gender province:self.province city:self.city region:self.region userName:self.userName email:self.email phone:self.phone]) {
        [self editPersonalData];
    }
}

// 验证手机和密码
- (BOOL)validateTrueName:(NSString *)trueName birthday:(NSString *)birthday gender:(NSString *)gender province:(NSString *)province city:(NSString *)city region:(NSString *)region userName:(NSString *)userName email:(NSString *)email phone:(NSString *)phone
{
    
    if (userName.length > 0) {
        if (userName.length <2 || userName.length > 20) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名2-20字符范围" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    
    if (email.length > 0) {
        if (![TEValidateTools validateEmail:email]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    
    if (![trueName length] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真实姓名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![TEValidateTools validatechineseAndEngSet:trueName]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真实姓名为中文、英文字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![gender length] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"性别不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![birthday length] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"出生日期不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    if (self.phone.length > 0) {
        if (![TEValidateTools validateFixedLine:self.phone]) {
            if (![TEValidateTools validateMobile:self.phone]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机或固定电话号（固定电话格式为区号-号码）" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return NO;
            }
        }
    }

    NSString *areaStr = [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.region];
    if (! areaStr.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"省市区不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

@end
