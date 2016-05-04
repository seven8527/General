//
//  TEPatientDataPreviewViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientDataPreviewViewController.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEAppDelegate.h"
#import "TEPatientBasicDataModel.h"
#import "TEMedicalPreviewCell.h"
#import "UIImageView+AFNetworking.h"
#import "TEMedicalCell.h"
#import "TERegisterCell.h"
#import "NSString+URLEncoded.h"
#import "TEResultUploadImageModel.h"
#import "TEResultDeleteImageModel.h"
#import "TEResultEditPatientDataModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import "TEHttpTools.h"


#define  PIC_WIDTH 70
#define  PIC_HEIGHT 70
#define  INSETS 8
#define deleImageWH 25 // 删除按钮的宽高
#define kAdeleImage @"close.png" // 删除按钮图片

@interface TEPatientDataPreviewViewController () <TEMedicalCellDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *basicInfo;
@property (nonatomic, strong) NSArray *basicValue;

@property (nonatomic, copy) NSString *name; // 就诊记录名称
@property (nonatomic, copy) NSString *hospital;  // 就诊医院
@property (nonatomic, copy) NSString *date; // 就诊日期
@property (nonatomic, copy) NSString *keshi; // 就诊科室
@property (nonatomic, copy) NSString *zhenduan; // 初步诊断
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *isContainHttp; // 域名是否包含http
@property (nonatomic, strong) NSMutableArray *jianyandanArray; // 检验单
@property (nonatomic, strong) NSMutableArray *baogaodanArray; // 报告单
@property (nonatomic, strong) NSMutableArray *qitaArray; // 其他
//@property (nonatomic, weak) UIButton *plusButton;
@property (nonatomic, weak) UITextField *nameTextField;
@property (nonatomic, weak) UITextField *hospitalTextField;
@property (nonatomic, weak) UITextField *keshiTextField;
@property (nonatomic, weak) UITextField *zhenduanTextField;

@property (nonatomic, assign) NSInteger cellFlag;

@end

@implementation TEPatientDataPreviewViewController

#pragma mark - UIViewController lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

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
            [self fetchPatientData];
        });
    };
    
    reach.unreachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Failmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"似乎已断开与互联网的连接";
            [HUD hide:YES afterDelay:2];
        });
    };
    
    [reach startNotifier];
    
}

- (void)configDataSource
{
    _basicInfo = @[@[@"就诊记录名称", @"就医医院", @"就诊日期", @"就诊科室", @"初步诊断"], @[@"检验单", @"病历资料与检查报告单", @"其他资料"]];
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
    self.title = @"就诊记录详情";
}

// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(editPatientData:)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    // Create a UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    [TEUITools hiddenTableExtraCellLine:tableView];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    
    //初始日期选择控件
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    self.datePicker = datePicker;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return [self.basicInfo count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.basicInfo objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
       TEMedicalCell *medicalCell =  [[TEMedicalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        medicalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    medicalCell.delegate = self;
    
    static NSString * editCellIdentifier = @"editCellIdentifier";
    TERegisterCell *editCell = [aTableView dequeueReusableCellWithIdentifier:editCellIdentifier];
    
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
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [[self.basicInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        editCell.textLabel.text = [[self.basicInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0) {
            //cell.detailTextLabel.text = self.name;
            editCell.valueTextField.text = self.name;
            self.nameTextField = editCell.valueTextField;
            return editCell;
        } else if (indexPath.row == 1) {
            editCell.valueTextField.text = self.hospital;
            self.hospitalTextField = editCell.valueTextField;
            return editCell;
        } else if (indexPath.row == 2) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.detailTextLabel.text = self.date;
            return cell;
        } else if (indexPath.row == 3) {
            editCell.valueTextField.text = self.keshi;
            self.keshiTextField = editCell.valueTextField;
            return editCell;
        } else if (indexPath.row == 4) {
            editCell.valueTextField.text = self.zhenduan;
            self.zhenduanTextField = editCell.valueTextField;
            return editCell;
        }
        return cell;
    } else if (indexPath.section == 1) {
        medicalCell.itemLabel.text = [[self.basicInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        objc_setAssociatedObject(medicalCell.plusButton, "row", [NSString stringWithFormat:@"%d", indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [medicalCell.plusButton  addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        medicalCell.isContainHttp = self.isContainHttp;
        if (indexPath.row == 0) {
            medicalCell.picArray = self.jianyandanArray;
            medicalCell.type = @"c4";
            return medicalCell;
        } else if (indexPath.row == 1) {
            medicalCell.picArray = self.baogaodanArray;
            medicalCell.type = @"c5";
            return medicalCell;
        } else if (indexPath.row == 2) {
            medicalCell.picArray = self.qitaArray;
            medicalCell.type = @"c7";
            return medicalCell;
        }
       
    }
    return nil;
}



#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 140;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
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

        }
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
#pragma mark - Keyboard


- (void)hideKeyboard
{
    [self.nameTextField resignFirstResponder];
    [self.hospitalTextField resignFirstResponder];
    [self.keshiTextField resignFirstResponder];
    [self.zhenduanTextField resignFirstResponder];
}

#pragma mark - Validate

// 验证姓名，年龄
- (BOOL)validateDataName:(NSString *)dataName hospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    NSLog(@"name:%@, hospital:%@, date:%@, keshi:%@, zhenduan:%@", dataName, hospital, date, keshi, zhenduan);
    
    if ([dataName length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入就诊记录名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    
    if ([hospital length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入医院" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([date length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择就诊日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    if ([keshi length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入就诊科室" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    
    if ([zhenduan length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入初步诊断" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}


- (void)editPatientData:(id)sender
{
    [self hideKeyboard];
    
    // 去除空格
    NSString *dataName = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *hospital = [_hospitalTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *keshi = [_keshiTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *zhenduan = [_zhenduanTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([self validateDataName:dataName hospital:hospital date:self.date keshi:keshi zhenduan:zhenduan]) {
        [self editPatientDataWithPatientDataId:self.patientDataId dataName:dataName hospital:hospital date:self.date keshi:keshi zhenduan:zhenduan];
    }
}


#pragma mark - API methods

// 调用后台添加健康档案接口
- (void)editPatientDataWithPatientDataId:(NSString *)patientDataId dataName:(NSString *)dataName hospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/pmid_edit"];
    NSDictionary *parameters = @{@"pmid": patientDataId, @"cookie":ApplicationDelegate.cookie, @"pmid_title":dataName, @"c2": hospital, @"c1": date,
                                 @"c3": keshi, @"c13": zhenduan};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        self.navigationItem.rightBarButtonItem.enabled = YES;
        TEResultEditPatientDataModel *result = [[TEResultEditPatientDataModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = result.state;
        if ([state isEqualToString:@"202"]) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:dataName forKey:@"dataName"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dataNameDidRevamp" object:nil userInfo:dict];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:result.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([state isEqualToString:@"-202"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:result.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//        TEResultEditPatientDataModel *result = [[TEResultEditPatientDataModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = result.state;
//        if ([state isEqualToString:@"202"]) {
//            NSDictionary *dict = [NSDictionary dictionaryWithObject:dataName forKey:@"dataName"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"dataNameDidRevamp" object:nil userInfo:dict];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:result.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//            
//            [self.navigationController popViewControllerAnimated:YES];
//        } else if ([state isEqualToString:@"-202"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:result.msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }];
}


// 时间选择器
- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = sender;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *birthday = [dateFormat stringFromDate:[datePicker date]];
    self.date = birthday;
    [self.tableView reloadData];
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

#pragma mark UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        self.name = textField.text;
    } else if ([textField isEqual:self.hospitalTextField]) {
        self.hospital = textField.text;
    } else if ([textField isEqual:self.keshiTextField]) {
        self.keshi = textField.text;
    } else if ([textField isEqual:self.zhenduanTextField]) {
        self.zhenduan = textField.text;
    }
}


#pragma mark - API methods


// 获取订单资料
- (void)fetchPatientData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/showmeans"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId, @"patient_id": self.patientId, @"pmid": self.patientDataId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"----%@", responseObject);
        
        TEPatientBasicDataModel *basicData = [[TEPatientBasicDataModel alloc] initWithDictionary:responseObject error:nil];
        self.name = basicData.name;
        self.hospital = basicData.hospital;
        self.date = basicData.date;
        self.keshi = basicData.keshi;
        self.zhenduan = basicData.zhenduan;
        self.isContainHttp = basicData.isContainHttp;
        self.jianyandanArray = [self picURLArrayWithType:basicData.jianyandan];
        
        self.baogaodanArray = [self picURLArrayWithType:basicData.baogaodan];
        
        self.qitaArray = [self picURLArrayWithType:basicData.qita];
        
        [self.tableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        ;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"----%@", responseObject);
//        
//        TEPatientBasicDataModel *basicData = [[TEPatientBasicDataModel alloc] initWithDictionary:responseObject error:nil];
//        self.name = basicData.name;
//        self.hospital = basicData.hospital;
//        self.date = basicData.date;
//        self.keshi = basicData.keshi;
//        self.zhenduan = basicData.zhenduan;
//        self.isContainHttp = basicData.isContainHttp;
//        self.jianyandanArray = [self picURLArrayWithType:basicData.jianyandan];
//        
//        self.baogaodanArray = [self picURLArrayWithType:basicData.baogaodan];
//        
//        self.qitaArray = [self picURLArrayWithType:basicData.qita];
//        
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[operation responseStringEncoding]);
//    }];
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

// 上传图片
- (void)uploadPhoto:(UIImage *)image
{
    NSLog(@"----%@ cookie:%@", ApplicationDelegate.userId, ApplicationDelegate.cookie);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *dataType;
    
    if (_cellFlag == 0) {
        dataType = @"c4";
    } else if (_cellFlag == 1) {
        dataType = @"c5";
    } else if (_cellFlag == 2) {
        dataType = @"c7";
    }
    NSLog(@"dddd %s  %d", __func__, _cellFlag);
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
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([dataType isEqualToString:@"c5"]) {
                [self.baogaodanArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];

            } else if ([dataType isEqualToString:@"c7"]) {
                [self.qitaArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        [hud hide:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        hud.labelText = @"上传失败";
        [hud hide:YES afterDelay:1];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - API methods

- (void)picWillDeleteWithType:(NSString *)type andInteger:(NSInteger)integer
{
    [self deleteImageFromServerWithType:type deleteInteger:integer];
}

// 删除服务器图片
- (void)deleteImageFromServerWithType:(NSString *)type deleteInteger:(NSInteger)integer
{
    NSString *imageUrl ;
    if ([type isEqualToString:@"c4"]) {
        imageUrl = [self.jianyandanArray objectAtIndex:integer];
    } else if ( [type isEqualToString:@"c5"]) {
        imageUrl = [self.baogaodanArray objectAtIndex:integer];
    } else if ([type isEqualToString:@"c7"]){
        imageUrl = [self.qitaArray objectAtIndex:integer];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在删除";
    
    // 判断是否是缩略图  删除需传原图路径
    if ([imageUrl rangeOfString:@"_150X150"].location != NSNotFound) {
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_150X150" withString:@""];
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/delimg"];

    NSDictionary *parameters = @{@"pmid": self.patientDataId, @"image":type, @"del_image": imageUrl, @"cookie": ApplicationDelegate.cookie};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TEResultDeleteImageModel *model = [[TEResultDeleteImageModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = model.state;
        if ([state isEqualToString:@"201"]) {
            if ([type isEqualToString:@"c4"]) {
                [self.jianyandanArray removeObjectAtIndex:integer];
                 [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ( [type isEqualToString:@"c5"]) {
                [self.baogaodanArray removeObjectAtIndex:integer];
                 [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([type isEqualToString:@"c7"]){
               [self.qitaArray removeObjectAtIndex:integer];
                 [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        [hud hide:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        hud.labelText = @"删除失败";
        [hud hide:YES afterDelay:1];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}


@end
