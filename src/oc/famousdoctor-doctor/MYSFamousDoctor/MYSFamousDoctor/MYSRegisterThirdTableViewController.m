//
//  MYSRegisterThirdTableViewController.m
//  MYSFamousDoctor
//
//  Created by yanwb on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSRegisterThirdTableViewController.h"
#import "MYSRegisterPicTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIImage+Corner.h"
#import "MYSFoundationCommon.h"
#import "MYSChoosePhotoSourceView.h"
#import "MYSExaminingViewController.h"

@interface MYSRegisterThirdTableViewController () <MYSRegisterPicTableViewCellDelegate,MYSChoosePhotoSourceViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *headImage;
    UIImageView *certificateImage;
}

@end

@implementation MYSRegisterThirdTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"完善资料";
    
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    [self layoutBottonView];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
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

- (void)sendValue:(NSString *)name hospitol:(NSString *)hospitol department:(NSString *)department phone:(NSString *)phone telephone:(NSString *)telephone
{
    mName = name;
    mHospitol = hospitol;
    mDepartment = department;
    mPhone = phone;
    mTelephone = telephone;
}

// 底部布局
- (void)layoutBottonView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 250)];
    footerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 20, kScreen_Width - 72, 13)];
    tipLabel.text = @"示例";
    tipLabel.textColor = [UIColor lightGrayColor];
    [footerView addSubview:tipLabel];
    
    
    UIImageView *leftImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(tipLabel.frame) + 18, 90, 65)];
    leftImageView.image = [UIImage imageNamed:@"doctor_card"];
    [footerView addSubview:leftImageView];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(leftImageView.frame) + 18, CGRectGetWidth(leftImageView.frame), 20)];
    leftLabel.text = @"执业医师证书";
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.textColor = [UIColor colorFromHexRGB:K919191Color];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:leftLabel];
    
    
    UIImageView *rightImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 36 - 90, CGRectGetMaxY(tipLabel.frame) + 18, 90, 65)];
    rightImageView.image = [UIImage imageNamed:@"job_card"];
    [footerView addSubview:rightImageView];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightImageView.frame), CGRectGetMaxY(rightImageView.frame) + 18, CGRectGetWidth(rightImageView.frame), 20)];
    rightLabel.text = @"医院工作证";
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.textColor = [UIColor colorFromHexRGB:K919191Color];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:rightLabel];
    
    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame), CGRectGetMidX(leftImageView.frame), kScreen_Width - CGRectGetWidth(leftImageView.frame) * 2 -72, 10)];
    middleLabel.text = @"或";
    middleLabel.font = [UIFont systemFontOfSize:12];
    middleLabel.textColor = [UIColor colorFromHexRGB:K919191Color];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:middleLabel];
    
    // 注册
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(leftLabel.frame) + 30, kScreen_Width - 30, 44)];;
    [registerButton setTitle:@"下一步" forState:UIControlStateNormal];
    registerButton.layer.cornerRadius = 5.0;
    [registerButton addTarget:self action:@selector(sendInfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * registerPic = @"registerPic";
    
    MYSRegisterPicTableViewCell *registerPicCell = [tableView dequeueReusableCellWithIdentifier:registerPic];
    if (registerPicCell == nil)
    {
        registerPicCell = [[MYSRegisterPicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerPic];
    }
    registerPicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    registerPicCell.delegate = self;
    if(indexPath.row == 0)
    {
        registerPicCell.index = 0;
        registerPicCell.titleLable.text = @"上传您的头像";
        registerPicCell.tipTitleView.text = @"请上传清晰免冠正面头像。职业且富有亲和力的形象更容易获得患者信赖";
        headImage = registerPicCell.picImageView;
    } else {
        registerPicCell.titleLable.text = @"上传您的职称证明图片";
        registerPicCell.tipTitleView.text = @"请上传执业医师证或者医院工作证";
        registerPicCell.index = 1;
        certificateImage = registerPicCell.picImageView;
    }
    
    return registerPicCell;
}

- (void)registerPicTabelViewCellDidClickPicButtonWithIndex:(NSInteger)index
{
    selectImageIndex = index;
    MYSChoosePhotoSourceView *photoSourceView = [MYSChoosePhotoSourceView actionSheetWithCancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil  ];
    photoSourceView.delegate = self;
    photoSourceView.delegate = self;
    [photoSourceView showInView:self.navigationController.view];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 上传资料信息点击事件
- (void)sendInfoBtnClick
{
    NSLog(@"adsadsasa");
    if ([self checkImageURL])
    {
        [self sendAddinfoRequest];
    }
}

- (BOOL)checkImageURL
{
    if (!headImageURL || [@"" isEqualToString:headImageURL])
    {
        [self showAlertView:@"请上传您的头像"];
        return NO;
    }
    
    if (!certificateImageURL || [@"" isEqualToString:certificateImageURL])
    {
        [self showAlertView:@"请上传您的职称证明图片"];
        return NO;
    }
    return YES;
}

#pragma mark MYSChoosePhotoSourceViewDelegate

- (void)actionSheet:(MYSChoosePhotoSourceView *)actionSheet titleButtonClick:(UIButton *)button
{
    if (button.tag == 0)
    {
        [self showPickerCameraView];
    } else {
        [self showImagePicker];
    }
    
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        NSString *msg = @"没有相册";
        [self showAlertView:msg];
    }
}

//相机
- (void)showPickerCameraView
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
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

// 上传图片
- (void)uploadPhoto:(UIImage *)image
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    NSString *URLString = [NSString stringWithFormat:@"%@upload_image?userid=%@&cookie=%@", kURL_ROOT, userInfo.userId, userInfo.cookie];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    [request setValue:@"application/octet-stream" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:imageData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        LOG(@"%@", responseObject);
        NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        if ([@"-1001" isEqualToString:state])
        {
            [self showAlertView:@"非法操作"];
        } else if ([@"-10" isEqualToString:state]) {
            [self showAlertView:@"用户信息不正确"];
        } else if ([@"-201" isEqualToString:state]) {
            [self showAlertView:@"图片上传失败"];
        } else if ([@"201" isEqualToString:state]) {
            if (0 == selectImageIndex)
            {
                headImageURL = [responseObject objectForKey:@"newurl"];
                headImage.image = image;
            } else {
                certificateImageURL = [responseObject objectForKey:@"img_url"];
                certificateImage.image = image;
            }
        } else {
            [self showAlertView:@"上传失败"];
        }
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LOG(@"Error: %@", error);
        hud.labelText = @"上传失败";
        [hud hide:YES afterDelay:1];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

/**
 *  发送完善资料请求
 */
- (void)sendAddinfoRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MyWindow animated:YES];
    hud.labelText = @"正在加载";
    
    MYSUserInfoManager *userInfo = [MYSUserInfoManager shareInstance];
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"register/addinfo"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:userInfo.cookie forKey:@"cookie"];
    [parameters setValue:userInfo.userId forKey:@"uid"];
    [parameters setValue:mName forKey:@"doctor_name"];
    [parameters setValue:mHospitol forKey:@"hospital_name"];
    [parameters setValue:mDepartment forKey:@"departname"];
    [parameters setValue:mPhone forKey:@"doctor_mobile"];
    [parameters setValue:mTelephone forKey:@"phone"];
    [parameters setValue:headImageURL forKey:@"pic"];
    [parameters setValue:certificateImageURL forKey:@"authentication_occupation"];

    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSString *state = [responseObject objectForKey:@"state"];
        
        if ([@"202" isEqualToString:state])
        {
            MYSExaminingViewController *examing = [[MYSExaminingViewController alloc] init];
            [self.navigationController pushViewController:examing animated:YES];
        } else {
            [self showAlertView:@"完善信息上传失败"];
        }
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        [self showAlertView:@"请求失败"];
    }];
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

@end
