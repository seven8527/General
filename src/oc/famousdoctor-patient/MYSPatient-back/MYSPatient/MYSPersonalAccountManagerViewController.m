//
//  MYSPersonalAccountManagerViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalAccountManagerViewController.h"
#import "UIColor+Hex.h"
#import "MYSExpertGroupConsultSelectUserCell.h"
#import "UIImage+Corner.h"
#import "MYSFoundationCommon.h"
#import "MYSExpertGroupAddNewRecordTextFiledCell.h"
#import "MYSChoosePhotoSourceView.h"
#import "AppDelegate.h"
#import "NSString+URLEncoded.h"
#import "MYSUpdatePatientIconModel.h"
#import "MYSPersonalChangePhoneNumberViewController.h"
#import "HttpTool.h"
#import "MYSResultModel.h"
#import <UIImageView+WebCache.h>
#import "ValidateTools.h"

@interface MYSPersonalAccountManagerViewController () <MYSChoosePhotoSourceViewDelegate, MYSPersonalChangePhoneNumberViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) UITextField *userNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (nonatomic, copy) NSString *userIconStr;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *mobile;
@end

@implementation MYSPersonalAccountManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账号管理";
    
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [rightButton addTarget:self action:@selector(clickRightBarBurron) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorFromHexRGB:K747474Color] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.userIconStr = self.userModel.pic;
    self.userName = self.userModel.userName;
    self.email = self.userModel.email;
    self.mobile = self.userModel.mobilephone;
//    NSURL *url = [NSURL URLWithString: self.userIconStr];
//    self.iconImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.userNameTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.emailTextField];
    
    [self layoutTableViewFooterView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// tableview footView设置
- (void)layoutTableViewFooterView
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    topLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    topLine.alpha = 0.5;
    [footerView addSubview:topLine];
    
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, kScreen_Width - 20, 13)];
    tipLabel.text = @"我们承若:对您的个人信息严格保密！";
    tipLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:tipLabel];
    
    // 保存账号
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tipLabel.frame) + 30, kScreen_Width - 30, 44)];
    [saveButton setTitle:@"保存账号" forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = 5.0;
    saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [footerView addSubview:saveButton];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:saveButton];
    [saveButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:saveButton];
    [saveButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
    
    
    
    footerView.frame = CGRectMake(0, 0, kScreen_Width, CGRectGetMaxY(saveButton.frame));
    self.tableView.tableFooterView = footerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark tableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 咨询用户
    static NSString *expertGroupConsultSelectUser = @"expertGroupConsultSelectUser";
    MYSExpertGroupConsultSelectUserCell *expertGroupConsultSelectUserCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConsultSelectUser];
    if (expertGroupConsultSelectUserCell == nil) {
        expertGroupConsultSelectUserCell = [[MYSExpertGroupConsultSelectUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:expertGroupConsultSelectUser];
    }
    expertGroupConsultSelectUserCell.nameLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    expertGroupConsultSelectUserCell.nameLabel.font = [UIFont systemFontOfSize:14];
    expertGroupConsultSelectUserCell.textLabel.textColor = [UIColor colorFromHexRGB:K484848Color];
    expertGroupConsultSelectUserCell.textLabel.font = [UIFont systemFontOfSize:16];
    expertGroupConsultSelectUserCell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    // textFieldCell
    static NSString *addNewRecordTextField = @"addNewRecordTextField";
    MYSExpertGroupAddNewRecordTextFiledCell *addNewRecordTextFieldCell = [tableView dequeueReusableCellWithIdentifier:addNewRecordTextField];
    if (addNewRecordTextFieldCell == nil) {
        addNewRecordTextFieldCell = [[MYSExpertGroupAddNewRecordTextFiledCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addNewRecordTextField];
    }
    addNewRecordTextFieldCell.valueTextField.textColor = [UIColor colorFromHexRGB:K747474Color];
    addNewRecordTextFieldCell.valueTextField.font = [UIFont systemFontOfSize:14];
    addNewRecordTextFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // UITableViewCell
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.section == 0) {
        if (indexPath.row == 0) {
            expertGroupConsultSelectUserCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            expertGroupConsultSelectUserCell.isHadNameLabel = NO;
//            expertGroupConsultSelectUserCell.model = nil;
//            expertGroupConsultSelectUserCell.iconImageView.image = self.iconImage;
            expertGroupConsultSelectUserCell.patientPic =  self.iconImage;
            //[expertGroupConsultSelectUserCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userIconStr] placeholderImage:[UIImage imageNamed:@"favicon_man"]];
            expertGroupConsultSelectUserCell.textLabel.text = @"头像";
            expertGroupConsultSelectUserCell.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
            return expertGroupConsultSelectUserCell;
        } else {
            addNewRecordTextFieldCell.valueTextField.enabled = YES;
            addNewRecordTextFieldCell.infoLabel.text = @"用户名";
            addNewRecordTextFieldCell.valueTextField.placeholder = @"未填写";
            addNewRecordTextFieldCell.valueTextField.text = self.userName;
            addNewRecordTextFieldCell.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            addNewRecordTextFieldCell.valueTextField.delegate = self;
            addNewRecordTextFieldCell.accessoryType = UITableViewCellAccessoryNone;
            self.userNameTextField = addNewRecordTextFieldCell.valueTextField;
            return addNewRecordTextFieldCell;
        }
    } else {
        if (indexPath.row == 0) {
            addNewRecordTextFieldCell.valueTextField.enabled = YES;
            addNewRecordTextFieldCell.infoLabel.text = @"电子邮箱";
            addNewRecordTextFieldCell.valueTextField.placeholder = @"未填写";
            addNewRecordTextFieldCell.valueTextField.text = self.email;
            addNewRecordTextFieldCell.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            addNewRecordTextFieldCell.valueTextField.delegate = self;
            addNewRecordTextFieldCell.accessoryType = UITableViewCellAccessoryNone;
            self.emailTextField = addNewRecordTextFieldCell.valueTextField;
            return addNewRecordTextFieldCell;
        } else {
            cell.textLabel.text = @"手机号码";
            cell.detailTextLabel.text = self.mobile;
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MYSChoosePhotoSourceView *photoSourceView = [MYSChoosePhotoSourceView actionSheetWithCancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil  ];
            photoSourceView.delegate = self;
            [photoSourceView showInView:self.navigationController.view];
        }
    } else {
        if (indexPath.row == 1) {
            UIViewController <MYSPersonalChangePhoneNumberViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalChangePhoneNumberViewControllerProtocol)];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeadrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    sectionHeadrView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
    topLine.alpha = 0.8;
    topLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [sectionHeadrView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 14.5, kScreen_Width, 0.5)];
    bottomLine.alpha = 0.8;
    bottomLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [sectionHeadrView addSubview:bottomLine];
    sectionHeadrView.frame = CGRectZero;
    if (section == 0) {
        topLine.hidden = YES;
    } else {
        topLine.hidden = NO;
    }
    return sectionHeadrView;
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
                
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 15, bounds.size.height-lineHeight, bounds.size.width - 15, lineHeight);
                
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

#pragma mark MYSChoosePhotoSourceViewDelegate


- (void)actionSheet:(MYSChoosePhotoSourceView *)actionSheet titleButtonClick:(UIButton *)button;
{
    if (button.tag == 0) {
        
        [self showPickerCameraView];
    } else {
        [self showImagePicker];
    }
}

#pragma mark MYSPersonalChangePhoneNumberViewControllerDelegate

- (void)changePhoneNumberViewControllerDidSelected:(NSString *)phoneNumber
{
    self.mobile = phoneNumber;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = [[UIImage alloc] init];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        if (picker.allowsEditing == YES) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        [self uploadPhoto:image];
    }
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:^{ }];
        
        image = nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
}

//相册
- (void)showImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        NSString *msg = @"没有相册";
        [self showAlertView:msg];
    }
}

//相机
- (void)showPickerCameraView
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init] ;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        NSString *msg = @"没有相机";
        [self showAlertView:msg];
    }
}

// 提示语
- (void)showAlertView:(NSString *)hintsString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:hintsString
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:self.userNameTextField]) {
        self.userName = textField.text;
    } else if ([textField isEqual:self.emailTextField]){
        self.email = textField.text;
    }
}

#pragma mark NSNotification
- (void)textFieldChanged:(NSNotification *)notification
{
    if (notification.object == self.userNameTextField) {
        self.userName = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else if (notification.object == self.emailTextField) {
        self.email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    }
}

// 修改密码
- (void)clickRightBarBurron
{
    UIViewController <MYSPersonalChangePasswordViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalChangePasswordViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

// 上传图片
- (void)uploadPhoto:(UIImage *)image
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    NSString *URLString = [NSString stringWithFormat:@"%@upload_photo?userid=%@&file_type=%@&cookie=%@", kURL_ROOT, ApplicationDelegate.userId, @".jpg",[ApplicationDelegate.cookie URLEncodedString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    
    [request setValue:@"application/octet-stream" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:imageData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        LOG(@"%@", responseObject);
        MYSUpdatePatientIconModel *updateModel = [[MYSUpdatePatientIconModel alloc] initWithDictionary:responseObject error:nil];
        if ([updateModel.state isEqualToString:@"201"]) {
            self.userIconStr = updateModel.imageUrl;
            self.iconImage = image;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            if ([self.delegate respondsToSelector:@selector(personalAccountManagerChangeInfo)]) {
                [self.delegate personalAccountManagerChangeInfo];
            }
        } else {
            hud.labelText = @"上传失败";
        }
        [hud hide:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"Error: %@", error);
        hud.labelText = @"上传失败";
        [hud hide:YES afterDelay:1];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
}

// 保存账号
- (void)saveAccount
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    if (self.userIconStr == nil) {
        self.userIconStr = @"";
    }

    NSString *URLString = [kURL_ROOT stringByAppendingString:@"user_edit/update_user_info"];
    NSDictionary *parameters = @{@"uid": ApplicationDelegate.userId, @"my_pic": self.userIconStr, @"nick_name": self.userName, @"email":self.email, @"mobile":self.mobile};
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSResultModel *result = [[MYSResultModel alloc] initWithDictionary:responseObject error:nil];
        if ([result.state isEqualToString:@"201"]) {
            if ([self.delegate respondsToSelector:@selector(personalAccountManagerChangeInfo)]) {
                [self.delegate personalAccountManagerChangeInfo];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else if (([result.state isEqualToString:@"-1"])){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if (([result.state isEqualToString:@"-16"])){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else if (([result.state isEqualToString:@"-2"])){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }

        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@, error desc:%@", error, [error description]);
        [hud hide:YES];
    }];

}

- (void)clickSaveButton
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *userNameStr = [_userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *emailStr = [_emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([self validateUserName:userNameStr email:emailStr phone:self.mobile]) {
        [self saveAccount];
    }
}

// 验证用户名、邮箱和手机
- (BOOL)validateUserName:(NSString *)userName email:(NSString *)email phone:(NSString *)phone
{
    if (userName.length > 0) {
        if (userName.length < 2 || userName.length > 20) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名2-20字符范围" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    
    if (email.length > 0) {
        if (![ValidateTools validateEmail:email]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    }
    

    if (phone.length > 0) {
        if (![ValidateTools validateMobile:phone]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

// 隐藏键盘
- (void)hideKeyboard
{
    [self.userNameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

@end
