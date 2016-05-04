//
//  TEPatientMedicalDataViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientMedicalDataViewController.h"
#import "TEMedicalCell.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEAppDelegate.h"
#import "TEPatientDataViewController.h"
#import "TEPatientViewController.h"
#import <MBProgressHUD.h>
#import "UIImageView+AFNetworking.h"
#import "TEResultUploadImageModel.h"
#import "TEResultDeleteImageModel.h"
#import "NSString+URLEncoded.h"
#import "TETextConsultViewController.h"
#import "TEPhoneConsultViewController.h"
#import "TEOfflineConsultViewController.h"
#import "TEPatientBasicDataModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import "TEHttpTools.h"

#define  PIC_WIDTH 70
#define  PIC_HEIGHT 70
#define  INSETS 8

@interface TEPatientMedicalDataViewController () <TEMedicalCellDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *medicals;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) NSMutableArray *jianyandanArray; //检验单
@property (nonatomic, strong) NSMutableArray *baogaodanArray; //报告单
@property (nonatomic, strong) NSMutableArray *qitaArray; // 其他
@property (nonatomic, copy) NSString *isContainHttp; // 域名是否包含http
@property (nonatomic, assign) NSInteger cellFlag;

@end

@implementation TEPatientMedicalDataViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configDataSource];
    
    [self configUI];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchPatientMedicalData];
        });
    };
    
    [reach startNotifier];
}

- (void)configDataSource
{
    self.medicals = @[@"检验单", @"病历资料与检查报告单", @"其他资料"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

- (NSMutableArray *)jianyandanArray
{
    if (_jianyandanArray == nil) {
        _jianyandanArray = [NSMutableArray array];
    }
    return  _jianyandanArray;
}



- (NSMutableArray *)baogaodanArray
{
    if (_baogaodanArray == nil) {
        _baogaodanArray = [NSMutableArray array];
    }
    return  _baogaodanArray;
}

- (NSMutableArray *)qitaArray
{
    if (_qitaArray == nil) {
        _qitaArray = [NSMutableArray array];
    }
    return  _qitaArray;
}
#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"填写健康档案";
}

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    [TEUITools hiddenTableExtraCellLine:tableView];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(21, 20, 277, 51);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(commitPatientData) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextButton];
    self.tableView.tableFooterView = view;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.medicals count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TEMedicalCell *cell = [[TEMedicalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.itemLabel.text = [self.medicals objectAtIndex:indexPath.row];
    objc_setAssociatedObject(cell.plusButton, "row", [NSString stringWithFormat:@"%d", indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.plusButton  addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    cell.isContainHttp = self.isContainHttp;
    if (indexPath.row == 0) {
        cell.picArray = self.jianyandanArray;
        cell.type = @"c4";
        return cell;
    } else if (indexPath.row == 1) {
        cell.picArray = self.baogaodanArray;
        cell.type = @"c5";
        return cell;
    } else if (indexPath.row == 2) {
        cell.picArray = self.qitaArray;
        cell.type = @"c7";
        return cell;
    }
    return nil;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - UIAcitonSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self showPickerCameraView];
        } else if (buttonIndex == 1) {
            [self showImagePicker];
        }
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
        [picker dismissViewControllerAnimated:YES completion:nil];
        image = nil;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Bussiness methods
- (NSMutableArray *)picURLArrayWithType:(NSString *)type
{
    NSMutableArray *tempArray = [NSMutableArray array];
    if (type && ![type isEqualToString:@""]) {
        NSArray *arr = [type componentsSeparatedByString:@","];
        for (NSString *url in arr) {
            if (url.length > 0) {
                NSString *imageUrl = url;
                [tempArray addObject:imageUrl];
            }
        }
    }
    return tempArray;
}

- (void)commitPatientData
{
    for (UIViewController *ctrl in self.navigationController.viewControllers) {
        if ([ctrl isMemberOfClass:[TEPatientViewController class]]) {
            [self.navigationController popToViewController:ctrl animated:YES];
        } else if ([ctrl isMemberOfClass:[TETextConsultViewController  class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addPatientData" object:nil];
            [self.navigationController popToViewController:ctrl animated:YES];
        } else if ([ctrl isMemberOfClass:[TEPhoneConsultViewController  class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addPatientData" object:nil];
            [self.navigationController popToViewController:ctrl animated:YES];
        } else if ([ctrl isMemberOfClass:[TEOfflineConsultViewController  class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addPatientData" object:nil];
            [self.navigationController popToViewController:ctrl animated:YES];
        }
    }
}

// 增加图像
- (void)showActionSheet:(id)sender
{
    NSString *row = objc_getAssociatedObject(sender, "row");
    _cellFlag = [row intValue];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传图片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"相册", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

// Fill every view pixel with no black borders, resize and crop if needed
- (UIImage *)image:(UIImage *)image fillSize:(CGSize)viewsize
{
	CGSize size = image.size;
    
	CGFloat scalex = viewsize.width / size.width;
	CGFloat scaley = viewsize.height / size.height;
	CGFloat scale = MAX(scalex, scaley);
    
	UIGraphicsBeginImageContext(viewsize);
    
	CGFloat width = size.width * scale;
	CGFloat height = size.height * scale;
    
	float dwidth = ((viewsize.width - width) / 2.0f);
	float dheight = ((viewsize.height - height) / 2.0f);
    
	CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
	[image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
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
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        NSString *msg = @"没有相机";
        [self showAlertView:msg];
    }
}

- (void)showAlertView:(NSString *)hintsString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:hintsString
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
}

// 上传图片
- (void)uploadPhoto:(UIImage *)image
{
    NSLog(@"----%@ cookie:%@", ApplicationDelegate.userId, ApplicationDelegate.cookie);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    
    NSString *dataType;
    
    if (_cellFlag == 0) {
        dataType = @"c4";
    } else if (_cellFlag == 1) {
        dataType = @"c5";
    } else if (_cellFlag == 2) {
        dataType = @"c7";
    }

    NSString *URLString = [NSString stringWithFormat:@"%@means/stream2Image?userid=%@&file_type=%@&pmid=%@&image=%@&cookie=%@", kURL_ROOT, ApplicationDelegate.userId, @".jpg",self.patientDataId, dataType, [ApplicationDelegate.cookie URLEncodedString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    
    [request setValue:@"application/octet-stream" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:imageData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        TEResultUploadImageModel *model = [[TEResultUploadImageModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.state isEqualToString:@"201"]) {
            if ([dataType isEqualToString:@"c4"]) {
                [self.jianyandanArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([dataType isEqualToString:@"c5"]) {
                [self.baogaodanArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            } else if ([dataType isEqualToString:@"c7"]) {
                [self.qitaArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = @"上传失败";
        [hud hide:YES afterDelay:1];
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}


#pragma mark - API methods

// 获取患者病历资料
- (void)fetchPatientMedicalData
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/patientmeans"];
    NSDictionary *parameters = @{@"pmid": self.patientDataId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"---%@", responseObject);
        
        TEPatientBasicDataModel *basicData = [[TEPatientBasicDataModel alloc] initWithDictionary:responseObject error:nil];
        
        self.isContainHttp = basicData.isContainHttp;
        
        self.jianyandanArray = [self picURLArrayWithType:basicData.jianyandan];
        
        self.baogaodanArray = [self picURLArrayWithType:basicData.baogaodan];
        
        self.qitaArray = [self picURLArrayWithType:basicData.qita];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"---%@", responseObject);
//        
//        TEPatientBasicDataModel *basicData = [[TEPatientBasicDataModel alloc] initWithDictionary:responseObject error:nil];
//        
//        self.isContainHttp = basicData.isContainHttp;
//        
//        self.jianyandanArray = [self picURLArrayWithType:basicData.jianyandan];
//        
//        self.baogaodanArray = [self picURLArrayWithType:basicData.baogaodan];
//        
//        self.qitaArray = [self picURLArrayWithType:basicData.qita];
//        
//        [self.tableView reloadData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
}



- (void)picWillDeleteWithType:(NSString *)type andInteger:(NSInteger)integer
{
    [self deleteImageFromServerWithType:type deleteInteger:integer];
}

// 删除服务器图片
- (void)deleteImageFromServerWithType:(NSString *)type deleteInteger:(NSInteger)integer
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在删除";
    NSString *imageUrl ;
    if ([type isEqualToString:@"c4"]) {
        imageUrl = [self.jianyandanArray objectAtIndex:integer];
    } else if ( [type isEqualToString:@"c5"]) {
        imageUrl = [self.baogaodanArray objectAtIndex:integer];
    } else if ([type isEqualToString:@"c7"]){
        imageUrl = [self.qitaArray objectAtIndex:integer];
    }
    
    // 判断是否是缩略图  删除需传原图路径
    if ([imageUrl rangeOfString:@"_150X150"].location != NSNotFound) {
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_150X150" withString:@""];
    }
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/delimg"];
    NSLog(@"cookie:%@", ApplicationDelegate.cookie);
    NSDictionary *parameters = @{@"pmid": self.patientDataId, @"image":type, @"del_image": imageUrl, @"cookie": ApplicationDelegate.cookie};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        TEResultDeleteImageModel *model = [[TEResultDeleteImageModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = model.state;
        if ([state isEqualToString:@"201"]) {
            if ([type isEqualToString:@"c4"]) {
                [self.jianyandanArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ( [type isEqualToString:@"c5"]) {
                [self.baogaodanArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([type isEqualToString:@"c7"]){
                [self.qitaArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        hud.labelText = @"删除失败";
        [hud hide:YES afterDelay:1];
        NSLog(@"%@",error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        TEResultDeleteImageModel *model = [[TEResultDeleteImageModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = model.state;
//        if ([state isEqualToString:@"201"]) {
//            if ([type isEqualToString:@"c4"]) {
//                [self.jianyandanArray removeObjectAtIndex:integer];
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            } else if ( [type isEqualToString:@"c5"]) {
//                [self.baogaodanArray removeObjectAtIndex:integer];
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            } else if ([type isEqualToString:@"c7"]){
//                [self.qitaArray removeObjectAtIndex:integer];
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            }
//        }
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        hud.labelText = @"删除失败";
//        [hud hide:YES afterDelay:1];
//        NSLog(@"%@",error);
//    }];
}

@end
