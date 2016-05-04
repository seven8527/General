//
//  TERegisterViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TERegisterViewController.h"
#import "TEAppDelegate.h"
#import "UIColor+Hex.h"
#import "TEValidateTools.h"
#import "TEResultModel.h"
#import "TEResultRegisterModel.h"
#import "TEUITools.h"
#import "TELoginCell.h"
#import "TEHttpTools.h"

@interface TERegisterViewController ()

@property (nonatomic, strong) UITextField *mobilephoneTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property BOOL isAgreementSelected; // 是否勾选同意
@property (nonatomic, strong) UIButton *checkboxButton;
@end

@implementation TERegisterViewController

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
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
    self.title = @"注册";
    self.isAgreementSelected = YES;
}

// UI布局
- (void)layoutUI
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 127)];
    self.tableView.tableFooterView = footerView;
    
    // 服务条款
    _checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkboxButton.frame = CGRectMake(26, 25, 13, 13);
    [_checkboxButton setImage:[UIImage imageNamed:@"agreement_gray.png"] forState:UIControlStateNormal];
    [_checkboxButton setImage:[UIImage imageNamed:@"agreement_green.png"] forState:UIControlStateSelected];
    _checkboxButton.selected = YES;
    [footerView addSubview:_checkboxButton];
    
    // 添加手势
    UIView *gestureView = [[UIView alloc] initWithFrame:CGRectMake(10, 25, kScreen_Width, 50)];
    [footerView addSubview:gestureView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isCheckboxSelected)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [gestureView addGestureRecognizer:tapGestureRecognizer];
    
    UILabel *agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 20, 80, 21)];
    agreementLabel.text = @"阅读并同意";
    agreementLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
    agreementLabel.backgroundColor = [UIColor clearColor];
    agreementLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:agreementLabel];
    
    UIButton *agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementButton.frame = CGRectMake(104, 20, 140, 21);
    [agreementButton setTitle:@"《名医生注册协议》" forState:UIControlStateNormal];
    [agreementButton setTitleColor:[UIColor colorWithHex:0x00947d] forState:UIControlStateNormal];
    [agreementButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [agreementButton addTarget:self action:@selector(checkAgreement) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:agreementButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(21, 61, 277, 51);
    [confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
}

#pragma mark - UITableView DataSource


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    TELoginCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TELoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_telephone.png"];
        cell.valueTextField.delegate = self;
        cell.valueTextField.placeholder = @"请输入11位手机号码";
        _mobilephoneTextField = cell.valueTextField;
    } else if (indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_lock.png"];
        cell.valueTextField.delegate = self;
        cell.valueTextField.placeholder = @"请输入6-20位密码";
        cell.valueTextField.secureTextEntry = YES;
        _passwordTextField = cell.valueTextField;
    }
    
    return cell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Bussiness methods

// 勾选服务条款
- (void)isCheckboxSelected
{
    self.checkboxButton.selected = !self.checkboxButton.selected;
    self.isAgreementSelected = !self.isAgreementSelected;
}

// 查看服务协议
- (void)checkAgreement
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEAgreementViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEAgreementViewControllerProtocol)];
    [self.navigationController pushViewController:viewController animated:YES];
}


// 点击下一步
- (void)nextStep
{
    // 去除空格
    NSString *mobile = [_mobilephoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([self validateMobilePhone:mobile password:password]) {
        if (self.isAgreementSelected ) {
            [self verifyMobilephone:mobile password:password];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择遵守协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}

// 验证手机和密码
- (BOOL)validateMobilePhone:(NSString *)mobilePhone password:(NSString *)password
{
    if ([mobilePhone length] != 11) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    if ([password length] < 6 || [password length] > 20) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![TEValidateTools validateMobile:mobilePhone]) {
        return NO;
    }
    return  YES;
}

/**
 *  验证手机号是否能注册
 *
 *  @param account  手机号
 *
 *  @return YES:手机号能注册  NO:手机号不能注册
 */
- (void)verifyMobilephone:(NSString *)mobile password:(NSString *)password
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"wap_verify"];
    NSDictionary *parameters = @{@"user_data": mobile, @"verify_type": @"mobile"};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"404"]) {
            self.hidesBottomBarWhenPushed = YES;
            UIViewController <TERegisterConfirmViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TERegisterConfirmViewControllerProtocol)];
            viewController.mobile = mobile;
            viewController.password = password;
            [self.navigationController pushViewController:viewController animated:YES];
        } else if ([state isEqualToString:@"-1"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-403"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入黑名单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if ([state isEqualToString:@"-503"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户已经锁定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

    } failure:^(NSError *error) {
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//        TEResultModel *result = [[TEResultModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"404"]) {
//            self.hidesBottomBarWhenPushed = YES;
//            UIViewController <TERegisterConfirmViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TERegisterConfirmViewControllerProtocol)];
//            viewController.mobile = mobile;
//            viewController.password = password;
//            [self.navigationController pushViewController:viewController animated:YES];
//        } else if ([state isEqualToString:@"-1"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else if ([state isEqualToString:@"-403"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加入黑名单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        } else if ([state isEqualToString:@"-503"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户已经锁定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

@end
