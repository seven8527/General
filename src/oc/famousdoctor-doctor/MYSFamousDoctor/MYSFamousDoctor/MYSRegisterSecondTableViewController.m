//
//  MYSRegisterSecondTableViewController.m
//  MYSFamousDoctor
//
//  Created by yanwb on 15/4/8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSRegisterSecondTableViewController.h"
#import "MYSRegisterTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIImage+Corner.h"
#import "MYSFoundationCommon.h"
#import "MYSRegisterThirdTableViewController.h"
#import "MYSRegisterPhoneTableViewCell.h"

@interface MYSRegisterSecondTableViewController () <UITextFieldDelegate>
{
    MYSRegisterThirdTableViewController *registerThirdVC;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, weak) UITextField *nameField;
@property (nonatomic, weak) UITextField *hospitolField;
@property (nonatomic, weak) UITextField *departmentField;
@property (nonatomic, weak) UITextField *phoneField;
@property (nonatomic, weak) UITextField *quhaoField;
@property (nonatomic, weak) UITextField *telephoneField;
@property (nonatomic, weak) UITextField *fenjiField;
@end

@implementation MYSRegisterSecondTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"完善资料";
    
    self.mainTableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    [self layoutBottonView];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.tableView addGestureRecognizer:gesture];
}

- (void)tapClick
{
    [self hiddenKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

// 底部布局
- (void)layoutBottonView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 200)];
    footerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    UITextView *tipTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, kScreen_Width-30, 40)];
    tipTextView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    tipTextView.userInteractionEnabled = NO;
    tipTextView.text = @"如：010-6666666-666 请准确填写您所在医院的固定电话，我们将核实是否本人注册。电话不会被公开";
    tipTextView.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    tipTextView.font = [UIFont systemFontOfSize:12];
    [footerView addSubview:tipTextView];
    
    // 注册
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tipTextView.frame) + 41, kScreen_Width - 30, 44)];;
    [registerButton setTitle:@"下一步" forState:UIControlStateNormal];
    registerButton.layer.cornerRadius = 5.0;
    [registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:registerButton];
    [registerButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:registerButton];
    [registerButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
    
    //    self.registerButton = registerButton;
    [footerView addSubview:registerButton];
    
    self.tableView.tableFooterView = footerView;
    
}

#pragma mark
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *registerIdentifier = @"register";
    MYSRegisterTableViewCell *registerCell = [tableView dequeueReusableCellWithIdentifier:registerIdentifier];
    if (registerCell == nil) {
        registerCell = [[MYSRegisterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerIdentifier];
    }
    
    if(indexPath.row == 0) {
        registerCell.accessoryType = UITableViewCellAccessoryNone;
        registerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        registerCell.valueTextField.userInteractionEnabled = YES;
        registerCell.infoLabel.text = @"真实姓名";
        registerCell.valueTextField.placeholder = @"请输入真实姓名";
        self.nameField = registerCell.valueTextField;
        self.nameField.returnKeyType = UIReturnKeyNext;
        self.nameField.delegate = self;
    } else if (indexPath.row == 1) {
        registerCell.accessoryType = UITableViewCellAccessoryNone;
        registerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        registerCell.valueTextField.userInteractionEnabled = YES;
        registerCell.infoLabel.text = @"所在医院";
        registerCell.valueTextField.placeholder = @"请输入您所在的医院";
        self.hospitolField = registerCell.valueTextField;
        self.hospitolField.returnKeyType = UIReturnKeyNext;
        self.hospitolField.delegate = self;
    } else if (indexPath.row == 2) {
        registerCell.accessoryType = UITableViewCellAccessoryNone;
        registerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        registerCell.valueTextField.userInteractionEnabled = YES;
        registerCell.infoLabel.text = @"所在科室";
        registerCell.valueTextField.placeholder = @"请选择您所在医院的科室";
        self.departmentField = registerCell.valueTextField;
        self.departmentField.returnKeyType = UIReturnKeyNext;
        self.departmentField.delegate = self;
    } else if (indexPath.row == 3) {
        registerCell.accessoryType = UITableViewCellAccessoryNone;
        registerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        registerCell.valueTextField.userInteractionEnabled = YES;
        registerCell.infoLabel.text = @"手机号";
        registerCell.valueTextField.placeholder = @"请输入手机号";
        self.phoneField = registerCell.valueTextField;
        self.phoneField.returnKeyType = UIReturnKeyNext;
        self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneField.delegate = self;
    } else if (indexPath.row == 4) {
        MYSRegisterPhoneTableViewCell *phoneCell = [[MYSRegisterPhoneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"value"];
        phoneCell.accessoryType = UITableViewCellAccessoryNone;
        phoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        phoneCell.infoLabel.text = @"核实电话";
        self.quhaoField = phoneCell.quhaoTextField;
        self.telephoneField = phoneCell.dianhuaTextField;
        self.fenjiField = phoneCell.fenjiTextField;
        self.quhaoField.delegate = self;
        self.telephoneField.delegate = self;
        self.fenjiField.delegate = self;
        return phoneCell;
    }
    
    // Configure the cell...
    
    return registerCell;
}

#pragma mark
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_nameField]) {
        [_hospitolField becomeFirstResponder];
    } else if ([textField isEqual:_hospitolField]) {
        [_departmentField becomeFirstResponder];
    } else if ([textField isEqual:_departmentField]) {
        [_phoneField becomeFirstResponder];
    } else if([textField isEqual:_phoneField]) {
        [_quhaoField becomeFirstResponder];
    } else if([textField isEqual:_quhaoField]){
        [_telephoneField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboard];
}

#pragma mark
#pragma mark 按钮点击事件
/**
 *  下一步按钮点击事件
 */
- (void)clickRegisterButton
{
    [self hiddenKeyboard];
    
    if ([self checkInputValue])
    {
        NSString *tel = _telephoneField.text;
        if (![@"" isEqualToString:_quhaoField.text])
        {
            tel = [NSString stringWithFormat:@"%@-%@", _quhaoField.text, tel];
        }
        if (![@"" isEqualToString:_fenjiField.text])
        {
            tel = [NSString stringWithFormat:@"%@-%@", tel, _fenjiField.text];
        }
        if (!registerThirdVC)
        {
            registerThirdVC = [[MYSRegisterThirdTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        }        
        [registerThirdVC sendValue:_nameField.text
                          hospitol:_hospitolField.text
                        department:_departmentField.text
                             phone:_phoneField.text
                         telephone:tel];
        [self.navigationController pushViewController:registerThirdVC animated:YES];
    }
}

/**
 *  返回按钮点击事件
 */
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  check输入项
 *
 *  @return result
 */
- (BOOL)checkInputValue
{
    if ([@"" isEqualToString:_nameField.text])
    {
        [_nameField becomeFirstResponder];
        [self showAlert:@"请输入真实姓名"];
        return NO;
    }
    
    if ([@"" isEqualToString:_hospitolField.text])
    {
        [_hospitolField becomeFirstResponder];
        [self showAlert:@"请输入您所在的医院"];
        return NO;
    }
    
    if ([@"" isEqualToString:_departmentField.text])
    {
        [_departmentField becomeFirstResponder];
        [self showAlert:@"请输入您所在医院的科室"];
        return NO;
    }
    
    if ([@"" isEqualToString:_phoneField.text])
    {
        [_phoneField becomeFirstResponder];
        [self showAlert:@"请输入手机号"];
        return NO;
    }
    
    if (![MYSUtils checkCellPhoneNum:_phoneField.text])
    {
        [_phoneField becomeFirstResponder];
        [self showAlert:@"请输入正确的手机号"];
        return NO;
    }
    
    
    if ([@"" isEqualToString:_quhaoField.text])
    {
        [_quhaoField becomeFirstResponder];
        [self showAlert:@"请输入区号"];
        return NO;
    }
    if ([@"" isEqualToString:_telephoneField.text])
    {
        [_telephoneField becomeFirstResponder];
        [self showAlert:@"请输入您所在医院的固话"];
        return NO;
    }
    
    NSString *tel = _telephoneField.text;
    if (![@"" isEqualToString:_quhaoField.text])
    {
        tel = [NSString stringWithFormat:@"%@-%@", _quhaoField.text, tel];
    }
    if (![@"" isEqualToString:_fenjiField.text])
    {
        tel = [NSString stringWithFormat:@"%@-%@", tel, _fenjiField.text];
    }
    
    NSLog(@"%@", tel);
    
    if (![MYSUtils checkPhoneNum:tel])
    {
        [_telephoneField becomeFirstResponder];
        [self showAlert:@"请输入正确的固话"];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_quhaoField])
    {
        if (![@"" isEqualToString:string])
        {
            if (textField.text.length == 4)
            {
                return NO;
            }
        }
    }
    
    if ([textField isEqual:_telephoneField])
    {
        if (![@"" isEqualToString:string])
        {
            if (textField.text.length == 8)
            {
                return NO;
            }
        }
    }
    
    if ([textField isEqual:_fenjiField])
    {
        if (![@"" isEqualToString:string])
        {
            if (textField.text.length == 4)
            {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)hiddenKeyboard
{
    if ([_nameField isFirstResponder])
    {
        [_nameField resignFirstResponder];
    }
    if ([_hospitolField isFirstResponder])
    {
        [_hospitolField resignFirstResponder];
    }
    if ([_departmentField isFirstResponder])
    {
        [_departmentField resignFirstResponder];
    }
    if ([_phoneField isFirstResponder])
    {
        [_phoneField resignFirstResponder];
    }
    if ([_quhaoField isFirstResponder])
    {
        [_quhaoField resignFirstResponder];
    }
    if ([_telephoneField isFirstResponder])
    {
        [_telephoneField resignFirstResponder];
    }
    if ([_fenjiField isFirstResponder])
    {
        [_fenjiField resignFirstResponder];
    }
}

@end
