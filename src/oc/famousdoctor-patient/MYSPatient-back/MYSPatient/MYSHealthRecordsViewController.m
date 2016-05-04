//
//  MYSHealthRecordsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsViewController.h"
#import "MYSHealthRecordsCollectionViewCell.h"
#import "MYSMedicalRecordCollectionHeaderView.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "MYSExpertGroupConsultAddNewUserView.h"
#import "UserIDCard.h"
#import "MYSChoosePhotoSourceView.h"
#import "ValidateTools.h"
#import "AppDelegate.h"
#import "MYSExpertGroupPatient.h"
#import "MYSUpdatePatientIconModel.h"
#import "NSString+URLEncoded.h"

@interface MYSHealthRecordsViewController () <MYSMedicalRecordCollectionHeaderViewDelegate,MYSExpertGroupConsultAddNewUserViewDelegate,MYSChoosePhotoSourceViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, weak) MYSExpertGroupConsultAddNewUserView *addNewUserView;
@property (nonatomic, strong) NSMutableArray *patientArray;
@property (nonatomic, copy) NSString *userIconStr;
@end

@implementation MYSHealthRecordsViewController

static  NSString *healthRecordsCollectionView = @"healthRecordsCollectionViewCell";
static  NSString *medicalRecordCollectionHeaderView = @"medicalRecordCollectionHeaderView";
- (id)init
{
    // 1.流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 2.每个cell的尺寸
    layout.itemSize = CGSizeMake(kScreen_Width - 20, 163);
    // 3.设置cell之间的水平间距
    layout.minimumInteritemSpacing = 0;
    // 4.设置cell之间的垂直间距
    layout.minimumLineSpacing = 10;
    // 5.设置四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 45, 0, 45);
    layout.headerReferenceSize = CGSizeMake(kScreen_Width, 90);
    return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchPatient];
    
    self.title = @"健康档案";
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    
    [self.collectionView registerClass:[MYSMedicalRecordCollectionHeaderView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:medicalRecordCollectionHeaderView];
    
    [self.collectionView registerClass:[MYSHealthRecordsCollectionViewCell class] forCellWithReuseIdentifier:healthRecordsCollectionView];
    
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



- (NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}


- (NSMutableArray *)patientArray
{
    if (_patientArray == nil) {
        _patientArray = [NSMutableArray array];
    }
    return _patientArray;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYSHealthRecordsCollectionViewCell * healthRecordsCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:healthRecordsCollectionView forIndexPath:indexPath];
    if (healthRecordsCollectionViewCell == nil) {
        healthRecordsCollectionViewCell = [[MYSHealthRecordsCollectionViewCell alloc] init];
    }
    healthRecordsCollectionViewCell.healthRecordType = indexPath.row;
    healthRecordsCollectionViewCell.model = nil;
    return healthRecordsCollectionViewCell;
}


- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        MYSMedicalRecordCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:medicalRecordCollectionHeaderView forIndexPath:indexPath];
        headerView.delegate = self;
        headerView.patientArray = self.patientArray;
        headerView.frame = CGRectMake(0, 0, kScreen_Width, 75);
        headerView.addNewRecordView.hidden = YES;
        reusableview = headerView;
    }
    return reusableview;
}

// 查看详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIViewController <MYSHealthRecordsBloodPressureViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSHealthRecordsBloodPressureViewControllerProtocol)];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    } else if(indexPath.row == 1){
        UIViewController <MYSHealthRecordsBloodGlucoseViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSHealthRecordsBloodGlucoseViewControllerProtocol)];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    } else {
        UIViewController <MYSHealthRecordsWeightViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSHealthRecordsWeightViewControllerProtocol)];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

// 用户管理
- (void)medicalRecordCollectionHeaderViewClickUserManager
{
    UIViewController <MYSExpertGroupConsultChooseUserViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultChooseUserViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;

}


// 添加用户
- (void)clickRightBarButton
{
    MYSExpertGroupConsultAddNewUserView *addNewUserView = [MYSExpertGroupConsultAddNewUserView actionSheetWithCommitButtonTitle:@"确定" cameraButtonImage:[UIImage imageNamed:@"zoe_button_photo_"] otherTextFiledPlaceHolderTitles:@"输入姓名",@"身份证", nil];
    addNewUserView.delegate = self;
    self.addNewUserView = addNewUserView;
    [addNewUserView showInView:self.navigationController.view];
}

#warning 选择患者
- (void)medicalRecordCollectionHeaderViewDidSelectPatientWithModel:(id)model
{
    LOG(@"%@",model);
}


#pragma mark MYSExpertGroupConsultAddNewUserViewDelegate

- (void)actionSheet:(MYSExpertGroupConsultAddNewUserView *)actionSheet cameraButtonTouched:(UIButton *)button
{
    //    [self showActionSheet];
    MYSChoosePhotoSourceView *photoSourceView = [MYSChoosePhotoSourceView actionSheetWithCancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil  ];
    photoSourceView.delegate = self;
    photoSourceView.delegate = self;
    [photoSourceView showInView:self.navigationController.view];
    
}

- (void)actionSheet:(MYSExpertGroupConsultAddNewUserView *)actionSheet commitButtonTouchedWithName:(NSString *)name IDCard:(NSString *)IDCard iconStr:(NSString *)iconStr
{
    if ([self validateName:name idCard:IDCard]) {
        
        [actionSheet dismiss];
        
        NSString *gender;
        if ([[UserIDCard obtainSexWith:IDCard] isEqualToString:@"男"]) {
            gender = @"1";
        } else {
            gender = @"0";
        }
        
        NSString *birthday = [UserIDCard obtainBirthdayWith:IDCard];
        
        [self addPatientWithName:name gender:gender birthday:birthday idCard:IDCard];
    }
}

#pragma mark - Validate

// 验证姓名，年龄
- (BOOL)validateName:(NSString *)name idCard:(NSString *)idCard
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
            [self clickRightBarButton];
        } else {
            [self.collectionView reloadData];
        }
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        [hud hide:YES];
    }];
}


// 调用后台添加患者接口
- (void)addPatientWithName:(NSString *)name gender:(NSString *)gender birthday:(NSString *)birthday idCard:(NSString *)idCard
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/addpatient"];
    NSDictionary *parameters = @{@"uid": ApplicationDelegate.userId, @"cookie":ApplicationDelegate.cookie, @"patient_name":name, @"patient_sex":gender, @"patient_birthday": birthday, @"patient_itentity": idCard, @"patient_pic": self.userIconStr};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"state"] integerValue]  == 202) {
            [self fetchPatient];
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


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
