//
//  MYSExpertGroupConsultAddNewRecordDataViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultAddNewRecordDataViewController.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "MYSExpertGroupConsultMedicalRecordsHeaderView.h"
#import "MYSAddMedicalDataCell.h"
#import "UIImage+Corner.h"
#import "MYSFoundationCommon.h"
#import "ZYQAssetPickerController.h"
#import "HttpTool.h"
#import "AppDelegate.h"
//#import "MYSSignTool.h"
#import "MYSExpertGroupConsultChooseMedicalRecordsViewController.h"
#import "NSString+URLEncoded.h"
#import "MYSUploadImageResultModel.h"
#import "MYSPatientConsultRecordDataModel.h"
#import "MYSPersonalViewController.h"



#define lineTopMargin 20
#define topButtonWidth 21
#define topSubViewMargin 6.5
#define longLineWidth (kScreen_Width - topButtonWidth * 2 - topSubViewMargin * 4)/2

@interface MYSExpertGroupConsultAddNewRecordDataViewController () <UITableViewDataSource,UITableViewDelegate,MYSAddMedicalDataCellDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSMutableArray *jianyandanArray;
@property (nonatomic, strong) NSMutableArray *bingliArray;
@property (nonatomic, strong) NSMutableArray *otherArray;
@property (nonatomic, copy) NSString *selectedType;
//@property (nonatomic, strong) NSMutableArray *jianyandanIDArray;
//@property (nonatomic, strong) NSMutableArray *bingliIDArray;
//@property (nonatomic, strong) NSMutableArray *otherIDArray;
@property (nonatomic, copy) NSString *isContainHttp; // 域名是否包含http
@end

@implementation MYSExpertGroupConsultAddNewRecordDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增就诊记录";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    [self layoutTableViewHeaderView];
    
    [self layoutTableViewFooterView];
    
    [self setupDataSource];
    
    [self fetchPatientMedicalData];
}
- (void) setupDataSource
{
//    for (int i = 0; i < 3; i ++) {
        NSArray *contentArray =  [NSArray arrayWithObjects:@"检验单",@"病例资料与检验报告单",@"其他资料", nil];
    self.contentArray = contentArray;
//        [self.contentArray addObject:sectionArray];
//    }
//    [self.textArray addObjectsFromArray:self.contentArray];
}

- (NSArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (NSMutableArray *)jianyandanArray
{
    if (_jianyandanArray == nil) {
        _jianyandanArray = [NSMutableArray array];
    }
    return _jianyandanArray;
}

- (NSMutableArray *)bingliArray
{
    if (_bingliArray == nil) {
        _bingliArray = [NSMutableArray array];
    }
    return _bingliArray;
}


- (NSMutableArray *)otherArray
{
    if (_otherArray == nil) {
        _otherArray = [NSMutableArray array];
    }
    return _otherArray;
}


//- (NSMutableArray *)jianyandanIDArray
//{
//    if (_jianyandanIDArray == nil) {
//        _jianyandanIDArray = [NSMutableArray array];
//    }
//    return _jianyandanIDArray;
//}
//
//- (NSMutableArray *)bingliIDArray
//{
//    if (_bingliIDArray == nil) {
//        _bingliIDArray = [NSMutableArray array];
//    }
//    return _bingliIDArray;
//}
//
//
//- (NSMutableArray *)otherIDArray
//{
//    if (_otherIDArray == nil) {
//        _otherIDArray = [NSMutableArray array];
//    }
//    return _otherIDArray;
//}

#pragma  mark LayoutUI

// 设置tableview的头部
- (void) layoutTableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 63)];
    headerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, lineTopMargin, longLineWidth/2, 3)];
    leftLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:leftLine];
    
    UIButton *firstButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLine.frame) + topSubViewMargin, 10, topButtonWidth, topButtonWidth)];
    firstButton.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    firstButton.layer.cornerRadius = 10.5;
    firstButton.clipsToBounds = YES;
    firstButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [firstButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [firstButton setTitle:@"1" forState:UIControlStateNormal];
    [headerView addSubview:firstButton];
    
    UIView *firstLongLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstButton.frame) + topSubViewMargin, lineTopMargin, longLineWidth , 3)];
    firstLongLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:firstLongLine];
    
    UIButton *secondButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstLongLine.frame) + topSubViewMargin, 10, topButtonWidth, topButtonWidth)];
    secondButton.backgroundColor = [UIColor colorFromHexRGB:K00907FColor];;
    secondButton.layer.cornerRadius = 10.5;
    secondButton.clipsToBounds = YES;
    secondButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [secondButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [secondButton setTitle:@"2" forState:UIControlStateNormal];
    [headerView addSubview:secondButton];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(secondButton.frame) + topSubViewMargin, lineTopMargin, longLineWidth/2, 3)];
    rightLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:rightLine];
    
    
    UILabel *fillInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/2, 12)];
    fillInfoLabel.textAlignment = NSTextAlignmentCenter;
    fillInfoLabel.text = @"基本就医资料";
    fillInfoLabel.font = [UIFont systemFontOfSize:12];
    fillInfoLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:fillInfoLabel];
    
    UILabel *confirmInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fillInfoLabel.frame), CGRectGetMaxY(firstButton.frame) + 10, kScreen_Width/2, 12)];
    confirmInfoLabel.font = [UIFont systemFontOfSize:12];
    confirmInfoLabel.textAlignment = NSTextAlignmentCenter;
    confirmInfoLabel.text = @"完善就医资料";
    confirmInfoLabel.textColor = [UIColor colorFromHexRGB:K00907FColor];
    [headerView addSubview:confirmInfoLabel];
}


- (void)layoutTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    footerView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, kScreen_Width - 30, 44)];
    commitButton.layer.cornerRadius = 5.0;
    commitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [commitButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [commitButton setTitle:@"确认添加" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(addPatientRecord) forControlEvents:UIControlEventTouchUpInside];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:commitButton];
    [commitButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:commitButton];
    [commitButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
    [footerView addSubview:commitButton];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSAddMedicalDataCell *addMedicalDataCell = [[MYSAddMedicalDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    addMedicalDataCell.delegate = self;
    addMedicalDataCell.selectionStyle = UITableViewCellSelectionStyleNone;
    addMedicalDataCell.selected = NO;
    addMedicalDataCell.itemLabel.text = self.contentArray[indexPath.row];
    if (indexPath.row == 0) {
         addMedicalDataCell.picArray = self.jianyandanArray;
    } else if (indexPath.row == 1) {
        addMedicalDataCell.picArray = self.bingliArray;
    } else {
        addMedicalDataCell.picArray = self.otherArray;
    }
    addMedicalDataCell.type = self.contentArray[indexPath.row];
    addMedicalDataCell.isImage = NO;
    return addMedicalDataCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

# pragma mark MYSAddMedicalDataCell Delegate

- (void)picWillAddWithType:(NSString *)type withCurrentCount:(NSInteger)currentCount
{
    LOG(@"第%@类%ld",type,(long)currentCount);
    
    self.selectedType = type;
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    if (15 - currentCount > 5) {
        picker.maximumNumberOfSelection = 5;
    } else {
         picker.maximumNumberOfSelection = 15 - currentCount;
    }

    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];

}


- (void)picWillDeleteWithType:(NSString *)type andInteger:(NSInteger)integer
{
    [self deleteImageFromServerWithType:type deleteInteger:integer];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
//    [src.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        src.contentSize=CGSizeMake(assets.count*src.frame.size.width, src.frame.size.height);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            pageControl.numberOfPages=assets.count;
//        });
//        
//        for (int i=0; i<assets.count; i++) {
//            ALAsset *asset=assets[i];
//            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*src.frame.size.width, 0, src.frame.size.width, src.frame.size.height)];
//            imgview.contentMode=UIViewContentModeScaleAspectFill;
//            imgview.clipsToBounds=YES;
//            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [imgview setImage:tempImg];
//                [src addSubview:imgview];
//            });
//        }
//    });
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t  queue= dispatch_queue_create("wendingding", NULL);
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//        NSString *name = asset.defaultRepresentation.filename;
//        NSDictionary *picDict = @{@"name":name, @"image":tempImg};
        if ([self.selectedType isEqualToString:self.contentArray[0]]) {
//            [self.jianyandanArray addObject:picDict];
//            dispatch_sync(queue, ^{
//             [self addPatientRecordWithFileType:@"2" andFileData: UIImageJPEGRepresentation([picDict objectForKey:@"image"], 0.7) andFileName:[picDict objectForKey:@"name"]];
//            });
            [self uploadPhoto:tempImg withFileType:@"c4"];
        } else if ([self.selectedType isEqualToString:self.contentArray[1]]) {
//            [self.bingliArray addObject:picDict];
            //            dispatch_sync(queue, ^{
//            [self addPatientRecordWithFileType:@"1" andFileData: UIImageJPEGRepresentation([picDict objectForKey:@"image"], 0.7) andFileName:[picDict objectForKey:@"name"]];
            //            });
            [self uploadPhoto:tempImg withFileType:@"c5"];
        } else {
//            [self.otherArray addObject:picDict];
            //            dispatch_sync(queue, ^{
//            [self addPatientRecordWithFileType:@"8" andFileData: UIImageJPEGRepresentation([picDict objectForKey:@"image"], 0.7) andFileName:[picDict objectForKey:@"name"]];
            //            });
            [self uploadPhoto:tempImg withFileType:@"c7"];
        }
        [self.tableView reloadData];
    }
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark - API methods

// 获取患者病历资料
- (void)fetchPatientMedicalData
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/patientmeans"];
    NSDictionary *parameters = @{@"pmid": self.patientDataId};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"---%@", responseObject);
        
        MYSPatientConsultRecordDataModel *basicData = [[MYSPatientConsultRecordDataModel alloc] initWithDictionary:responseObject error:nil];
        
        self.isContainHttp = basicData.isContainHttp;
        
        self.jianyandanArray = [self picURLArrayWithType:basicData.jianyandan];
        
        self.bingliArray = [self picURLArrayWithType:basicData.baogaodan];
        
        self.otherArray = [self picURLArrayWithType:basicData.qita];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
    }];
}
//// 上传病例资料
//- (void)addPatientRecordWithFileType:(NSString *)fileType andFileData:(NSData *)fileData andFileName:(NSString *)fileName
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在上传";
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//   NSDictionary *parameters = @{@"fileType": fileType};
//    NSString *URLString = [KURL_HEALTHPLATFORM stringByAppendingString:@"/fileUpload/uploadPic"];
//    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:fileData name:@"filedata" fileName:fileName mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [hud hide:YES];
//        NSLog(@"Success: %@", [responseObject objectForKey:@"msg"]);
//        NSLog(@"Success: %@", responseObject);
//        if ([fileType isEqualToString:@"2"]) {
//            if([[responseObject objectForKey:@"output"] objectForKey:@"fileId"]){
//            [self.jianyandanIDArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"fileId"]];
//            }
//        } else if ([fileType isEqualToString:@"1"]) {
//            if ([[responseObject objectForKey:@"output"] objectForKey:@"fileId"]) {
//                [self.bingliIDArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"fileId"]];
//            }
//        } else {
//            if ([[responseObject objectForKey:@"output"] objectForKey:@"fileId"]) {
//             [self.otherIDArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"fileId"]];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        hud.labelText = @"上传失败";
//        [hud hide:YES afterDelay:1];
//        NSLog(@"desc: %@\n  Error: %@", [operation responseString], error);
//    }];
//}

// 上传图片
- (void)uploadPhoto:(UIImage *)image withFileType:(NSString *)dataType
{
    LOG(@"----%@ cookie:%@", ApplicationDelegate.userId, ApplicationDelegate.cookie);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    
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
        LOG(@"%@", responseObject);
        
        MYSUploadImageResultModel *model = [[MYSUploadImageResultModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.state isEqualToString:@"201"]) {
            if ([dataType isEqualToString:@"c4"]) {
                [self.jianyandanArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([dataType isEqualToString:@"c5"]) {
                [self.bingliArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            } else if ([dataType isEqualToString:@"c7"]) {
                [self.otherArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.labelText = @"上传失败";
        [hud hide:YES afterDelay:1];
        LOG(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}




//// 添加患者就诊记录
//- (void)addPatientRecord
//{
//    NSMutableString *fileIds = (NSMutableString *)[self.jianyandanIDArray componentsJoinedByString:@","];
//    
//    if (self.bingliIDArray.count > 0) {
//        [fileIds appendFormat:@",%@",[self.bingliIDArray componentsJoinedByString:@","]];
//    }
//    if (self.otherIDArray.count > 0) {
//         [fileIds appendFormat:@",%@",[self.otherIDArray componentsJoinedByString:@","]];
//    }
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在加载";
//   
//    NSDictionary *parameters = @{@"ownerId": self.patientModel.patientId, @"medicalDate": self.time, @"medicalOrg" : self.hospital, @"department": self.keshi, @"diagnosis": self.zhenduan, @"fileIds": fileIds};
//    NSString *sign =  [MYSSignTool healthPlatformSignWith:parameters];
////     NSString *URLString = [KURL_HEALTHPLATFORM stringByAppendingString:@"/medical/add"];
//    NSString *URLString = [NSString stringWithFormat:@"%@%@?appId=%@&sign=%@",KURL_HEALTHPLATFORM,@"/medical/add",@"APP08",sign];
//    [HttpTool post:URLString params:parameters success:^(id responseObject) {
//            NSLog(@"%@", [responseObject objectForKey:@"msg"]);
//            [hud hide:YES];
//        for(UIViewController *controller in self.navigationController.childViewControllers) {
//            if ([controller isKindOfClass:[MYSExpertGroupConsultChooseMedicalRecordsViewController class]]) {
//                [self.navigationController popToViewController:controller animated:YES];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"addnewPatientRecord" object:nil];
//            }
//        }
//        
//        } failure:^(NSError *error) {
//            [hud hide:YES];
//        }];
//}
// 删除服务器图片
- (void)deleteImageFromServerWithType:(NSString *)type deleteInteger:(NSInteger)integer
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在删除";
    NSString *imageUrl ;
    NSString *picType;
    if ([type isEqualToString:self.contentArray[0]]) {
        imageUrl = [self.jianyandanArray objectAtIndex:integer];
        picType = @"c4";
    } else if ( [type isEqualToString:self.contentArray[1]]) {
        imageUrl = [self.bingliArray objectAtIndex:integer];
        picType = @"c5";
    } else if ([type isEqualToString:self.contentArray[2]]){
        imageUrl = [self.otherArray objectAtIndex:integer];
        picType = @"c7";
    }
    
    // 判断是否是缩略图  删除需传原图路径
    if ([imageUrl rangeOfString:@"_150X150"].location != NSNotFound) {
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_150X150" withString:@""];
    }
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/delimg"];
    LOG(@"cookie:%@", ApplicationDelegate.cookie);
    NSDictionary *parameters = @{@"pmid": self.patientDataId, @"image":picType, @"del_image": imageUrl, @"cookie": ApplicationDelegate.cookie};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@",responseObject);
//        TEResultDeleteImageModel *model = [[TEResultDeleteImageModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        if ([state isEqualToString:@"201"]) {
            if ([picType isEqualToString:@"c4"]) {
                [self.jianyandanArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ( [picType isEqualToString:@"c5"]) {
                [self.bingliArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([picType isEqualToString:@"c7"]){
                [self.otherArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        hud.labelText = @"删除失败";
        [hud hide:YES afterDelay:1];
        NSLog(@"%@",error);
    }];
}



// 添加患者就诊记录
- (void)addPatientRecord
{
    for(UIViewController *controller in self.navigationController.childViewControllers) {
            if ([controller isKindOfClass:[MYSExpertGroupConsultChooseMedicalRecordsViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addnewPatientRecord" object:nil];
            }
        if ([controller isKindOfClass:[MYSPersonalViewController  class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addnewPatientRecord" object:nil];
        }
}
}
@end
