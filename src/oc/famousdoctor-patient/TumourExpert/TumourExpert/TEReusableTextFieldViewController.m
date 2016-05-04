//
//  TEReusableTextFieldViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEReusableTextFieldViewController.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "TEValidateTools.h"

@interface TEReusableTextFieldViewController ()
@property (nonatomic, strong) UITextField *contentTextField;
@end

@implementation TEReusableTextFieldViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutUI];
}


#pragma mark - UI

// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveContent)];
    
    // 输入内容
    _contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
    _contentTextField.borderStyle = UITextBorderStyleRoundedRect;
    _contentTextField.delegate = self;
    _contentTextField.font = [UIFont systemFontOfSize:13];
    _contentTextField.textColor = [UIColor colorWithHex:0x9e9e9e];
    _contentTextField.text = self.content;
    if (self.keyboardType) {
        _contentTextField.keyboardType = self.keyboardType;
    }
    NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0x9e9e9e], NSFontAttributeName : [UIFont systemFontOfSize:13]};
    _contentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:placeholderAttributes];
    [self.view addSubview:_contentTextField];
    
    // 添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Bussiness methods

// 密码修改
- (void)saveContent
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *content = [_contentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateContent:content]) {
        [self.delegate didFinishedTextFieldContent:content byFlag:self.flag];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Keyboard

// 隐藏键盘
- (void)hideKeyboard
{
    [self.contentTextField resignFirstResponder];
}

#pragma mark - Validate

// 验证内容
- (BOOL)validateContent:(NSString *)content
{
    if ([content length] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([self.flag isEqualToString:@"name"]) {
        if ([content length] > 100) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名超过规定的字数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    
    if ([self.flag isEqualToString:@"phone"]) {
         if (![TEValidateTools validateMobile:content]) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的电话号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
             [alertView show];
             return NO;
         }
    }
    
    if ([self.flag isEqualToString:@"age"]) {
        if (![TEValidateTools validatePositiveNumber:content]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的年龄" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
        
        if ([content intValue] < 1 || [content intValue] > 199) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的年龄" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    
    if ([self.flag isEqualToString:@"height"]) {
        if (![TEValidateTools validatePositiveNumber:content]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的身高" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
        
        if ([content intValue] < 20 || [content intValue] > 500) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的身高" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    
    if ([self.flag isEqualToString:@"weight"]) {
        if (![TEValidateTools validatePositiveNumber:content]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的体重" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
        
        if ([content intValue] < 10 || [content intValue] > 500) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的体重" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    
    if ([self.flag isEqualToString:@"hospital"]) {
        if ([content length] > 100) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最近一次就诊医院超过规定的字数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    
    if ([self.flag isEqualToString:@"keshi"]) {
        if ([content length] > 50) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"科室超过规定的字数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }

    return YES;
}

@end
