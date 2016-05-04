//
//  MYSPersonalEditMedicalRecordViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalEditMedicalRecordViewController.h"
#import "UIColor+Hex.h"
#import "MYSExpertGroupAddNewRecordPatientCell.h"
#import "MYSExpertGroupAddNewRecordTextFiledCell.h"
#import "MYSExpertGroupAddNewRecordVisitingTimeCell.h"
#import "MYSAddMedicalDataCell.h"
#import "ZYQAssetPickerController.h"
#import "UUDatePicker.h"
#import "NSMutableURLRequest+Upload.h"
#import "HttpTool.h"
#import "MYSSignTool.h"
#import "AppDelegate.h"
#import "NSString+URLEncoded.h"
#import "MYSUploadImageResultModel.h"

@interface MYSPersonalEditMedicalRecordViewController () <UITableViewDataSource,UITableViewDelegate,MYSAddMedicalDataCellDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UUDatePicker *datePicker;
@property (nonatomic, strong) UITextField *consultTimeFiled; // 就诊时间
@property (nonatomic, strong) UITextField *hospitalTextField; // 就诊医院
@property (nonatomic, strong) UITextField *keshiTextField; // 就诊科室
@property (nonatomic, strong) UITextField *zhenduanTextField; // 诊断
@property (nonatomic, strong) NSArray *sectionTwoTipArray;
@property (nonatomic, copy) NSString *name; // 就诊记录名称
@property (nonatomic, copy) NSString *hospital;  // 就诊医院
@property (nonatomic, copy) NSString *patientRecordDate; // 就诊日期
@property (nonatomic, copy) NSString *department; // 就诊科室
@property (nonatomic, copy) NSString *diagnosis; // 初步诊断
@property (nonatomic, strong) NSMutableArray *jianyandanArray; // 检验单
@property (nonatomic, strong) NSMutableArray *baogaodanArray; // 报告单
@property (nonatomic, strong) NSMutableArray *otherArray; // 其他
@property (nonatomic, strong) NSMutableArray *jianyandanIDArray; // 检验单
@property (nonatomic, strong) NSMutableArray *baogaodanIDArray; // 报告单
@property (nonatomic, strong) NSMutableArray *qitaIDArray; // 其他
@property (nonatomic, copy) NSString *selectedType;
@end

@implementation MYSPersonalEditMedicalRecordViewController

- (instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑就诊记录";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [rightButton addTarget:self action:@selector(clickRightBarBurron) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (NSMutableArray *)jianyandanArray
{
    if (_jianyandanArray == nil) {
        _jianyandanArray = [NSMutableArray array];
    }
    return _jianyandanArray;
}

- (NSMutableArray *)baogaodanArray
{
    if (_baogaodanArray == nil) {
        _baogaodanArray = [NSMutableArray array];
    }
    return _baogaodanArray;
}


- (NSMutableArray *)otherArray
{
    if (_otherArray == nil) {
        _otherArray = [NSMutableArray array];
    }
    return _otherArray;
}


- (NSMutableArray *)jianyandanIDArray
{
    if (_jianyandanIDArray == nil) {
        _jianyandanIDArray = [NSMutableArray array];
    }
    return _jianyandanIDArray;
}

- (NSMutableArray *)baogaodanIDArray
{
    if (_baogaodanIDArray == nil) {
        _baogaodanIDArray = [NSMutableArray array];
    }
    return _baogaodanIDArray;
}


- (NSMutableArray *)qitaIDArray
{
    if (_qitaIDArray == nil) {
        _qitaIDArray = [NSMutableArray array];
    }
    return _qitaIDArray;
}

- (NSArray *)sectionTwoTipArray
{
    if (_sectionTwoTipArray == nil) {
        _sectionTwoTipArray = [NSArray arrayWithObjects:@"检验单",@"病例资料与检验报告单",@"其他资料", nil];
    }
    return _sectionTwoTipArray;
}


- (void)setPatientRecordModel:(MYSExpertGroupPatientRecordDataModel *)patientRecordModel
{
    _patientRecordModel = patientRecordModel;
    
    self.hospital = patientRecordModel.hospital;
    self.patientRecordDate = patientRecordModel.vistingTime;
    self.department = patientRecordModel.department;
    self.diagnosis = patientRecordModel.diagnosis;
    self.jianyandanArray = [self picURLArrayWithType:patientRecordModel.jianyandan];
    
    self.baogaodanArray = [self picURLArrayWithType:patientRecordModel.binglidan];
    
    self.otherArray = [self picURLArrayWithType:patientRecordModel.other];

//    for (NSString *content in patientRecordModel.attList) {
//        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSArray *contentArray = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                options:NSJSONReadingMutableContainers
//                                                                  error:&err];
//        if (contentArray.count > 0) {
//            if([[contentArray[0] objectForKey:@"fileType"] intValue]== 2) {
//                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                [sectionDict setValue:@"检验单" forKey:@"title"];
//                for (int i = 0; i< contentArray.count; i++) {
//                    [self.jianyandanArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                    [self.jianyandanIDArray addObject:[contentArray[i] objectForKey:@"fileId"]];
//                }
//            }else if ([[contentArray[0] objectForKey:@"fileType"] intValue]== 1) {
//                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                [sectionDict setValue:@"病例资料与检验报告单" forKey:@"title"];
//                for (int i = 0; i< contentArray.count; i++) {
//                    [self.baogaodanArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                    [self.baogaodanIDArray addObject:[contentArray[i] objectForKey:@"fileId"]];
//                }
//            } else if ([[contentArray[0] objectForKey:@"fileType"] intValue]== 8) {
//                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                [sectionDict setValue:@"其他资料" forKey:@"title"];
//                for (int i = 0; i< contentArray.count; i++) {
//                    [self.otherArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                    [self.baogaodanIDArray addObject:[contentArray[i] objectForKey:@"fileId"]];
//                }
//            }
//        }
//    }

    [self.tableView reloadData];

}

- (void)setPatientModel:(MYSExpertGroupPatientModel *)patientModel
{
    _patientModel = patientModel;
}

#pragma mark tableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSExpertGroupAddNewRecordPatientCell *addNewRecordPatientCell = [[MYSExpertGroupAddNewRecordPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    addNewRecordPatientCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    static NSString *addNewRecordTextField = @"addNewRecordTextField";
    
    MYSExpertGroupAddNewRecordTextFiledCell *addNewRecordTextFieldCell = [tableView dequeueReusableCellWithIdentifier:addNewRecordTextField];
    if (addNewRecordTextFieldCell == nil) {
        addNewRecordTextFieldCell = [[MYSExpertGroupAddNewRecordTextFiledCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addNewRecordTextField];
    }
    addNewRecordTextFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MYSExpertGroupAddNewRecordVisitingTimeCell *addNewRecordVisitingTimeCell = [[MYSExpertGroupAddNewRecordVisitingTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            addNewRecordPatientCell.model = self.patientModel;
            return  addNewRecordPatientCell;
        } else if(indexPath.row == 1){
            addNewRecordVisitingTimeCell.valueTextField.enabled = NO;
            addNewRecordVisitingTimeCell.infoLabel.text = @"就诊时间";
            addNewRecordVisitingTimeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            addNewRecordVisitingTimeCell.valueTextField.clearButtonMode = UITextFieldViewModeNever;
            addNewRecordVisitingTimeCell.valueTextField.placeholder = @"未选择";
            addNewRecordVisitingTimeCell.valueTextField.text = self.patientRecordDate;
            _consultTimeFiled = addNewRecordVisitingTimeCell.valueTextField;
            return addNewRecordVisitingTimeCell;
        } else if(indexPath.row == 2){
            addNewRecordTextFieldCell.valueTextField.enabled = YES;
            addNewRecordTextFieldCell.infoLabel.text = @"就诊医院";
            addNewRecordTextFieldCell.valueTextField.placeholder = @"未填写";
            addNewRecordTextFieldCell.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            addNewRecordTextFieldCell.accessoryType = UITableViewCellAccessoryNone;
            _hospitalTextField = addNewRecordTextFieldCell.valueTextField;
            _hospitalTextField.delegate = self;
            addNewRecordTextFieldCell.valueTextField.text = self.hospital;
            return addNewRecordTextFieldCell;
        } else if(indexPath.row == 3){
            addNewRecordTextFieldCell.valueTextField.enabled = YES;
            addNewRecordTextFieldCell.infoLabel.text = @"就诊科室";
            addNewRecordTextFieldCell.valueTextField.placeholder = @"未填写";
            addNewRecordTextFieldCell.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            addNewRecordTextFieldCell.accessoryType = UITableViewCellAccessoryNone;
            _keshiTextField = addNewRecordTextFieldCell.valueTextField;
            _keshiTextField.delegate = self;
            addNewRecordTextFieldCell.valueTextField.text = self.department;
            return addNewRecordTextFieldCell;
        } else{
            addNewRecordTextFieldCell.valueTextField.enabled = YES;
            addNewRecordTextFieldCell.infoLabel.text = @"诊断";
            addNewRecordTextFieldCell.valueTextField.placeholder = @"未填写";
            addNewRecordTextFieldCell.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            addNewRecordTextFieldCell.accessoryType = UITableViewCellAccessoryNone;
            addNewRecordTextFieldCell.valueTextField.text = self.diagnosis;
            _zhenduanTextField = addNewRecordTextFieldCell.valueTextField;
            _zhenduanTextField.delegate = self;
            return addNewRecordTextFieldCell;
        }


    } else {
        MYSAddMedicalDataCell *addMedicalDataCell = [[MYSAddMedicalDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        addMedicalDataCell.delegate = self;
        addMedicalDataCell.selectionStyle = UITableViewCellSelectionStyleNone;
        addMedicalDataCell.selected = NO;
        addMedicalDataCell.itemLabel.text = self.sectionTwoTipArray[indexPath.row];
        addMedicalDataCell.isImage = NO;
        if (indexPath.row == 0) {
            addMedicalDataCell.picArray = self.jianyandanArray;
        } else if (indexPath.row == 1) {
            addMedicalDataCell.picArray = self.baogaodanArray;
        } else {
            addMedicalDataCell.picArray = self.otherArray;
        }
        addMedicalDataCell.type = self.sectionTwoTipArray[indexPath.row];
        return addMedicalDataCell;
    }
    return addNewRecordPatientCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 65;
        } else {
            return 44;
        }
    } else {
        return 110;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
//                    addLine = YES;
                    
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
                
                if (indexPath.section == 1) {
                    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                    }else {
                        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 15, bounds.size.height-lineHeight, bounds.size.width - 15, lineHeight);
                    }
                } else {
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 15, bounds.size.height-lineHeight, bounds.size.width - 15, lineHeight);
                }
                
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self.tableView endEditing:YES];
        [self setupDataPicker];
    }
}



#pragma mark uitextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


// 日期选择器
- (void)setupDataPicker
{
    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    dataView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    dataView.tag = 99;
    [self.view addSubview:dataView];
    NSDate *now = [NSDate date];
    UUDatePicker *datePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, kScreen_Height, kScreen_Width, 200) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        _consultTimeFiled.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }];
    self.datePicker = datePicker;
    datePicker.maxLimitDate =now;
    datePicker.ScrollToDate = now;
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.25;
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePickerView:)];
    tapGR.numberOfTapsRequired    = 1;
    tapGR.numberOfTouchesRequired = 1;
    [dataView addGestureRecognizer:tapGR];
    
    _datePicker.frame = CGRectMake(0, kScreen_Height - 160, kScreen_Width, 160);
    _datePicker.tag = 1;
    [self.tableView.superview addSubview:_datePicker];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
    
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
    _datePicker.frame = CGRectMake(0, kScreen_Height, kScreen_Width, 200);
    [UIView commitAnimations];
    
    [self.datePicker removeFromSuperview];
}


# pragma mark MYSAddMedicalDataCell Delegate

- (void)picWillAddWithType:(NSString *)type withCurrentCount:(NSInteger)currentCount
{
    NSLog(@"第%@类%ld",type,(long)currentCount);
    
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
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        if ([self.selectedType isEqualToString:self.sectionTwoTipArray[0]]) {
            [self uploadPhoto:tempImg withFileType:@"c4"];
        } else if ([self.selectedType isEqualToString:self.sectionTwoTipArray[1]]) {
            [self uploadPhoto:tempImg withFileType:@"c5"];
        } else {
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

// 完成
- (void)clickRightBarBurron
{
    self.patientRecordDate = [_consultTimeFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.hospital = [_hospitalTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.department = [_keshiTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.diagnosis = [_zhenduanTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    LOG(@"%@",_hospitalTextField.text);
    if ([self validateHospital:self.hospital date:self.patientRecordDate keshi:self.department zhenduan:self.diagnosis]) {
        [self updatePatientRecord];
    }
}
#pragma mark - Validate

// 验证姓名，年龄
- (BOOL)validateHospital:(NSString *)hospital date:(NSString *)date keshi:(NSString *)keshi zhenduan:(NSString *)zhenduan
{
    
    if ([date length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择就诊日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    
    if ([hospital length] < 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入医院" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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




//#pragma mark api 上传图片
//
//
//-(NSString *)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params dicImages:(NSMutableDictionary *) dicImages{
//    NSString * res;
//    
//    
//    //分界线的标识符
//    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
//    //根据url初始化request
//    //NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//    
//    NSData *tempData = [TWITTERFON_FORM_BOUNDARY dataUsingEncoding:NSUTF8StringEncoding];
//    
//    LOG(@"//////////////////%@",tempData);
//    
//    NSURL *url = [NSURL URLWithString:strUrl];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    //分界线 --AaB03x
//    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//    //结束符 AaB03x--
//    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//    //要上传的图片
//    UIImage *image;//=[params objectForKey:@"pic"];
//    //得到图片的data
//    //NSData* data = UIImagePNGRepresentation(image);
//    //http body的字符串
//    NSMutableString *body=[[NSMutableString alloc]init];
//    //参数的集合的所有key的集合
//    NSArray *keys= [params allKeys];
//    
//    //遍历keys
//    for(int i=0;i<[keys count];i++) {
//        //得到当前key
//        NSString *key=[keys objectAtIndex:i];
//        //如果key不是pic，说明value是字符类型，比如name：Boris
//        //if(![key isEqualToString:@"pic"]) {
//        //添加分界线，换行
//        [body appendFormat:@"%@\r\n",MPboundary];
//        //添加字段名称，换2行
//        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//        //[body appendString:@"Content-Transfer-Encoding: 8bit"];
//        //添加字段的值
//        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
//        //}
//    }
//    ////添加分界线，换行
//    //[body appendFormat:@"%@\r\n",MPboundary];
//    
//    //声明myRequestData，用来放入http body
//    NSMutableData *myRequestData=[NSMutableData data];
//    //将body字符串转化为UTF8格式的二进制
//    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //循环加入上传图片
//    keys = [dicImages allKeys];
//    for(int i = 0; i< [keys count] ; i++){
//        //要上传的图片
//        image = [dicImages objectForKey:[keys objectAtIndex:i ]];
//        //得到图片的data
//        NSData* data =  UIImageJPEGRepresentation(image, 0.0);
//        NSMutableString *imgbody = [[NSMutableString alloc] init];
//        //此处循环添加图片文件
//        //添加图片信息字段
//        //声明pic字段，文件名为boris.png
//        //[body appendFormat:[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"File\"; filename=\"%@\"\r\n", [keys objectAtIndex:i]]];
//        
//        ////添加分界线，换行
//        [imgbody appendFormat:@"%@\r\n",MPboundary];
//        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"File%d\"; filename=\"%@.jpg\"\r\n", i, [keys objectAtIndex:i]];
//        //声明上传文件的格式
//        [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
//        
//        NSLog(@"上传的图片：%d  %@", i, [keys objectAtIndex:i]);
//        
//        //将body字符串转化为UTF8格式的二进制
//        //[myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
//        //将image的data加入
//        [myRequestData appendData:data];
//        [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
//    //加入结束符--AaB03x--
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    LOG(@"%@",myRequestData);
//    
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//    //设置HTTPHeader
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    //[request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
//    //[request setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
//    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
//    //设置http body
//    [request setHTTPBody:myRequestData];
//    //http method
//    [request setHTTPMethod:@"POST"];
//    
//    //建立连接，设置代理
//    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    //设置接受response的data
//    NSData *mResponseData;
//    NSError *err = nil;
//    mResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
//    
//    if(mResponseData == nil){
//        NSLog(@"err code : %@", [err localizedDescription]);
//    }
//    res = [[NSString alloc] initWithData:mResponseData encoding:NSUTF8StringEncoding];
//    /*
//     if (conn) {
//     mResponseData = [NSMutableData data];
//     mResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
//     
//     if(mResponseData == nil){
//     NSLog(@"err code : %@", [err localizedDescription]);
//     }
//     res = [[NSString alloc] initWithData:mResponseData encoding:NSUTF8StringEncoding];
//     }else{
//     res = [[NSString alloc] init];
//     }*/
//    NSLog(@"服务器返回：%@", res);
//    return res;
//}
#pragma mark - API methods

//// 上传病例资料
//- (void)addPatientRecordWithFileType:(NSString *)fileType andFileData:(NSData *)fileData andFileName:(NSString *)fileName
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在上传";
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSDictionary *parameters = @{@"fileType": fileType};
//    NSString *URLString = [KURL_HEALTHPLATFORM stringByAppendingString:@"/fileUpload/uploadPic"];
//    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:fileData name:@"filedata" fileName:fileName mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [hud hide:YES];
//        NSLog(@"Success: %@", [responseObject objectForKey:@"msg"]);
//        NSLog(@"Success: %@", responseObject);
//        if ([fileType isEqualToString:@"2"]) {
//            if([[responseObject objectForKey:@"output"] objectForKey:@"fileId"]){
//                [self.jianyandanIDArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"fileId"]];
//                [self.jianyandanArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"filePath"]];
//            }
//        } else if ([fileType isEqualToString:@"1"]) {
//            if ([[responseObject objectForKey:@"output"] objectForKey:@"fileId"]) {
//                [self.baogaodanIDArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"fileId"]];
//                [self.baogaodanArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"filePath"]];
//            }
//        } else {
//            if ([[responseObject objectForKey:@"output"] objectForKey:@"fileId"]) {
//                [self.qitaIDArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"fileId"]];
//                [self.otherArray addObject:[[responseObject objectForKey:@"output"] objectForKey:@"filePath"]];
//            }
//        }
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        hud.labelText = @"上传失败";
//        [hud hide:YES afterDelay:1];
//        NSLog(@"desc: %@\n  Error: %@", [operation responseString], error);
//    }];
//}
//
//
//// 更新患者就诊记录
//- (void)updatePatientRecord
//{
//    NSMutableString *fileIds = (NSMutableString *)[self.jianyandanIDArray componentsJoinedByString:@","];
//    
//    if (self.baogaodanIDArray.count > 0) {
//        [fileIds appendFormat:@",%@",[self.baogaodanIDArray componentsJoinedByString:@","]];
//    }
//    if (self.qitaIDArray.count > 0) {
//        [fileIds appendFormat:@",%@",[self.qitaIDArray componentsJoinedByString:@","]];
//    }
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在加载";
//    
//    NSDictionary *parameters = @{@"medicalId": self.patientRecordModel.patientRecordID, @"ownerId": self.patientModel.patientId, @"medicalDate": self.patientRecordDate, @"medicalOrg" : self.hospital, @"department": self.department, @"diagnosis": self.diagnosis, @"fileIds": fileIds};
//    NSString *sign =  [MYSSignTool healthPlatformSignWith:parameters];
//    //     NSString *URLString = [KURL_HEALTHPLATFORM stringByAppendingString:@"/medical/add"];
//    NSString *URLString = [NSString stringWithFormat:@"%@%@?appId=%@&sign=%@",KURL_HEALTHPLATFORM,@"/medical/update",@"APP08",sign];
//    [HttpTool post:URLString params:parameters success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//        [hud hide:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    } failure:^(NSError *error) {
//        [hud hide:YES];
//    }];
//}


// 上传图片
- (void)uploadPhoto:(UIImage *)image withFileType:(NSString *)dataType
{
    LOG(@"----%@ cookie:%@", ApplicationDelegate.userId, ApplicationDelegate.cookie);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    
    NSString *URLString = [NSString stringWithFormat:@"%@means/stream2Image?userid=%@&file_type=%@&pmid=%@&image=%@&cookie=%@", kURL_ROOT, ApplicationDelegate.userId, @".jpg",self.recordID, dataType, [ApplicationDelegate.cookie URLEncodedString]];
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
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([dataType isEqualToString:@"c5"]) {
                [self.baogaodanArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                
            } else if ([dataType isEqualToString:@"c7"]) {
                [self.otherArray addObject:model.newurl];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
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
// 删除服务器图片
- (void)deleteImageFromServerWithType:(NSString *)type deleteInteger:(NSInteger)integer
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在删除";
    NSString *imageUrl ;
    NSString *picType;
    if ([type isEqualToString:self.sectionTwoTipArray[0]]) {
        imageUrl = [self.jianyandanArray objectAtIndex:integer];
        picType = @"c4";
    } else if ( [type isEqualToString:self.sectionTwoTipArray[1]]) {
        imageUrl = [self.baogaodanArray objectAtIndex:integer];
        picType = @"c5";
    } else if ([type isEqualToString:self.sectionTwoTipArray[2]]){
        imageUrl = [self.otherArray objectAtIndex:integer];
        picType = @"c7";
    }
    
    // 判断是否是缩略图  删除需传原图路径
    if ([imageUrl rangeOfString:@"_150X150"].location != NSNotFound) {
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_150X150" withString:@""];
    }
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/delimg"];
    LOG(@"cookie:%@", ApplicationDelegate.cookie);
    NSDictionary *parameters = @{@"pmid": self.recordID, @"image":picType, @"del_image": imageUrl, @"cookie": ApplicationDelegate.cookie};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@",responseObject);
        //        TEResultDeleteImageModel *model = [[TEResultDeleteImageModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = [[responseObject objectForKey:@"state"] stringValue];
        if ([state isEqualToString:@"201"]) {
            if ([picType isEqualToString:@"c4"]) {
                [self.jianyandanArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ( [picType isEqualToString:@"c5"]) {
                [self.baogaodanArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([picType isEqualToString:@"c7"]){
                [self.otherArray removeObjectAtIndex:integer];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        hud.labelText = @"删除失败";
        [hud hide:YES afterDelay:1];
        LOG(@"%@",error);
    }];
}


// 更新患者就诊记录
- (void)updatePatientRecord
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/pmid_edit"];
    NSDictionary *parameters = @{@"pmid": self.recordID, @"cookie": [ApplicationDelegate.cookie URLEncodedString], @"pmid_title": self.patientRecordModel.recordTitle, @"c2": self.hospital, @"c1": self.patientRecordDate, @"c3": self.department, @"c13": self.diagnosis};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {

        LOG(@"%@",responseObject);
        [hud hide:YES];
        if ([[responseObject objectForKey:@"state"] isEqualToString:@"202"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePersonalEditMedicalRecord" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更新就诊记录失败,请重试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            [alertView show];
        }
        
    } failure:^(NSError *error) {
        ;
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self updatePatientRecord];
    }
}

@end
