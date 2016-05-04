//
//  MYSExpertGroupConsultChooseUserViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultChooseUserViewController.h"
#import "MYSExpertGroupConsultChooseUserCell.h"
#import "UIColor+Hex.h"
#import "MYSExpertGroupConsultAddNewUserView.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "MYSExpertGroupPatient.h"
#import "NSString+URLEncoded.h"
#import "ValidateTools.h"
#import "UserIDCard.h"
#import "MYSUpdatePatientIconModel.h"
#import "MYSChoosePhotoSourceView.h"


@interface MYSExpertGroupConsultChooseUserViewController () <UITableViewDataSource,UITableViewDelegate,MYSExpertGroupConsultAddNewUserViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MYSChoosePhotoSourceViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, weak) MYSExpertGroupConsultAddNewUserView *addNewUserView;
@property (nonatomic, strong) NSMutableArray *patientArray;
@property (nonatomic, copy) NSString *userIconStr;
@property (nonatomic, weak) UILabel *centerLabel; // 当没有记录的时候显示
@end

@implementation MYSExpertGroupConsultChooseUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userIconStr = @"";
    
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardShow:)
                                                 name: UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardHide:)
                                                 name: UIKeyboardWillHideNotification object:nil];
    
    self.title = @"选择用户";
    
  
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_button_adduser_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickRightBarButton)];
    rightBarButton.tintColor = [UIColor colorFromHexRGB:K00907FColor];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView = mainTableView;
    [self.view addSubview:mainTableView];
    
    
    // 无用户时的提示
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreen_Height/3, kScreen_Width, 100)];
    self.centerLabel = centerLabel;
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.text = @"无患者";
    centerLabel.hidden = YES;
    [self.mainTableView addSubview:centerLabel];
    
    [self fetchPatient];

    // Do any additional setup after loading the view.
}
-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIKeyboardDidShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)patientArray
{
    if (_patientArray == nil) {
        _patientArray = [NSMutableArray array];
    }
    return _patientArray;
}

#pragma mark tableviewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.patientArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *expertGroupConsultChooseUser = @"expertGroupConsultChooseUser";
    MYSExpertGroupConsultChooseUserCell *expertGroupConsultChooseUserCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConsultChooseUser];
    if (expertGroupConsultChooseUserCell == nil) {
        expertGroupConsultChooseUserCell = [[MYSExpertGroupConsultChooseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expertGroupConsultChooseUser];
    }
    expertGroupConsultChooseUserCell.separatorInset = UIEdgeInsetsMake(0, 51, 0, 0);
    expertGroupConsultChooseUserCell.patientModel = self.patientArray[indexPath.row];
    return expertGroupConsultChooseUserCell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   MYSExpertGroupConsultChooseUserCell *selectedCell = (MYSExpertGroupConsultChooseUserCell *)[tableView cellForRowAtIndexPath:indexPath];
    selectedCell.checkButton.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(expertGroupConsultChooseUserViewControllerDidSelected:)]) {
        [self.delegate expertGroupConsultChooseUserViewControllerDidSelected:self.patientArray[indexPath.row]];
    }
    
    if ([self.delegate respondsToSelector:@selector(expertGroupConsultChooseUserViewControllerDidSelectedIndex:)]) {
        [self.delegate expertGroupConsultChooseUserViewControllerDidSelectedIndex:indexPath.row];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
//    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame) - 1, kScreen_Width, 1)];
//    linView.alpha = 0.5;
//    linView.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
//    [headerView addSubview:linView];
//    return headerView;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 15;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    linView.alpha = 0.5;
    linView.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:linView];
    return headerView;
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
        
        if (tableView == self.mainTableView) {
            
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
                
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 51, bounds.size.height-lineHeight, bounds.size.width - 51, lineHeight);
                
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

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加用户
- (void)clickRightBarButton
{
    MYSExpertGroupConsultAddNewUserView *addNewUserView = [MYSExpertGroupConsultAddNewUserView actionSheetWithCommitButtonTitle:@"确定" cameraButtonImage:[UIImage imageNamed:@"zoe_button_photo_"] otherTextFiledPlaceHolderTitles:@"输入姓名",@"输入身份证", @"身高(cm/厘米)", @"体重(kg/千克)", nil];
    addNewUserView.delegate = self;
    self.addNewUserView = addNewUserView;
    [addNewUserView showInView:self.navigationController.view];
    
    //添加下滑手势
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    swipeDown.delegate = self;
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [addNewUserView addGestureRecognizer:swipeDown];

}

- (void)swipeDown
{
    [self.addNewUserView keyBoardDismiss];
}

//自定义键盘打开时触发的事件
-(void) keyboardShow: (NSNotification *)notif
{

    [UIView animateWithDuration:[[notif.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue]animations:^{
        LOG(@"%f",[[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height);
        CGFloat height = self.addNewUserView.frame.size.height;
        self.addNewUserView.frame =  CGRectMake(0, - [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height, kScreen_Width, height);
    }];
}

//自定义键盘关闭时触发的事件
-(void) keyboardHide: (NSNotification *)notif {
    [UIView animateWithDuration:[[notif.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue]animations:^{
        CGFloat height = self.addNewUserView.frame.size.height;
        self.addNewUserView.frame =  CGRectMake(0, 0, kScreen_Width, height);
    }];

}

#pragma mark MYSExpertGroupConsultAddNewUserViewDelegate

- (void)actionSheet:(MYSExpertGroupConsultAddNewUserView *)actionSheet cameraButtonTouched:(UIButton *)button
{
    [actionSheet keyBoardDismiss];
    MYSChoosePhotoSourceView *photoSourceView = [MYSChoosePhotoSourceView actionSheetWithCancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil  ];
    photoSourceView.delegate = self;
    photoSourceView.delegate = self;
    [photoSourceView showInView:self.navigationController.view];
    
}

- (void)actionSheet:(MYSExpertGroupConsultAddNewUserView *)actionSheet commitButtonTouchedWithName:(NSString *)name IDCard:(NSString *)IDCard height:(NSString *)height weight:(NSString *)weight iconStr:(NSString *)iconStr
{
    if ([self validateName:name idCard:IDCard height:height weight:weight]) {
        
        [actionSheet dismiss];
        
        NSString *gender;
        if ([[UserIDCard obtainSexWith:IDCard] isEqualToString:@"男"]) {
            gender = @"1";
        } else {
            gender = @"0";
        }
        
        NSString *birthday = [UserIDCard obtainBirthdayWith:IDCard];
        
        [self addPatientWithName:name gender:gender birthday:birthday idCard:IDCard height:height weight:weight];
    }
}

#pragma mark - Validate

// 验证姓名,年龄,身高,体重
- (BOOL)validateName:(NSString *)name idCard:(NSString *)idCard height:(NSString *)height weight:(NSString *)weight
{
    
    if ([name length] < 2 || [name length] > 20) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名长度不符合要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![ValidateTools validatechineseAndEngSet:name]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名为中文、英文字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![ValidateTools validate18PaperId:idCard]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的身份证号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if (![ValidateTools validatePositiveNumber:height]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的身高" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    
    if (![ValidateTools validatePositiveNumber:weight]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入合适的体重" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

#pragma mark MYSChoosePhotoSourceViewDelegate

- (void)actionSheet:(MYSChoosePhotoSourceView *)actionSheet titleButtonClick:(UIButton *)button
{
    if (button.tag == 0) {
        [self showPickerCameraView];
    } else {
        [self showImagePicker];
    }
    
}


//#pragma mark - UIAcitonSheetDelegate
//// 增加图像
//- (void)showActionSheet
//{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"拍照", @"相册", nil];
//    actionSheet.tag = 1;
//    [actionSheet showInView:self.view];
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag == 1) {
//        if (buttonIndex == 0) {
//            [self showPickerCameraView];
//        } else if (buttonIndex == 1) {
//            [self showImagePicker];
//        }
//    }
//}

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
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
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
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
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

#pragma mark - API methods

// 获取患者列表
- (void)fetchPatient
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    [self.patientArray removeAllObjects];
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/patient"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        MYSExpertGroupPatient *patient = [[MYSExpertGroupPatient alloc] initWithDictionary:responseObject error:nil];
        [self.patientArray addObjectsFromArray:patient.patients];
        if(self.patientArray.count == 0) {
            self.centerLabel.hidden = NO;
        } else {
            self.centerLabel.hidden = YES;
            [self.mainTableView reloadData];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        [hud hide:YES];
    }];
}


// 调用后台添加患者接口
- (void)addPatientWithName:(NSString *)name gender:(NSString *)gender birthday:(NSString *)birthday idCard:(NSString *)idCard height:(NSString *)height weight:(NSString *)weight
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/addpatient"];
    NSDictionary *parameters = @{@"uid": ApplicationDelegate.userId, @"cookie":ApplicationDelegate.cookie, @"patient_name":name, @"patient_sex":gender, @"patient_birthday": birthday, @"patient_itentity": idCard, @"patient_pic": self.userIconStr, @"patient_height":height, @"patient_weight": weight};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"state"] integerValue]  == 202) {
            [self fetchPatient];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"expertGroupAddNewPatient" object:nil];
            hud.labelText = @"添加成功";
        } else if ([[responseObject objectForKey:@"state"] integerValue]  == -201) {
            hud.labelText = @"添加失败";
        } else if ([[responseObject objectForKey:@"state"] integerValue]  == -406) {
            hud.labelText = @"身份证号已存在";
        }
        [hud hide:YES afterDelay:1.0];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
    
}


// 上传图片
- (void)uploadPhoto:(UIImage *)image
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.addNewUserView animated:YES];
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
            [self.addNewUserView.picButton setImage:image forState:UIControlStateNormal];
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

@end
