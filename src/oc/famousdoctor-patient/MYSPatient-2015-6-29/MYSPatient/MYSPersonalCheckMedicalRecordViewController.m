//
//  MYSPersonalCheckMedicalRecordViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalCheckMedicalRecordViewController.h"
#import "UIColor+Hex.h"
#import "MYSExpertGroupAddNewRecordPatientCell.h"
#import "MYSPersonalMedicalRecordPatientInfoCell.h"
#import "MYSMedicalDataCell.h"
#import "HttpTool.h"
#import "MYSSignTool.h"
#import "MYSPersonalPatientBasicDataModel.h"
//#import "MYSPatientRecordModel.h"
#import "AppDelegate.h"
#import "MYSPersonalPatientRecordDataModel.h"

@interface MYSPersonalCheckMedicalRecordViewController ()
@property (nonatomic, strong) NSArray *sectionTwoTipArray;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSMutableArray *jianyandanArray; // 检验单
@property (nonatomic, strong) NSMutableArray *baogaodanArray; // 报告单
@property (nonatomic, strong) NSMutableArray *qitaArray; // 其他
//@property (nonatomic, strong) MYSPersonalPatientBasicDataModel *basicData;
//@property (nonatomic, strong)  MYSPatientRecordModel *patientRecordModel;
@property (nonatomic, strong)  MYSPersonalPatientRecordDataModel *patientRecordModel;
@property (nonatomic, weak) UIButton *rightButton;
@end

@implementation MYSPersonalCheckMedicalRecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查看就诊记录";
    
//    self.tableView.scrollEnabled = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
   
    
    [self featchDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (NSArray *)sectionTwoTipArray
{
    if (_sectionTwoTipArray == nil) {
        _sectionTwoTipArray = [NSArray arrayWithObjects:@"检验单",@"病例资料与检验报告单",@"其他资料", nil];
    }
    return _sectionTwoTipArray;
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

- (NSMutableArray *)qitaArray
{
    if (_qitaArray == nil) {
        _qitaArray = [NSMutableArray array];
    }
    return _qitaArray;
}


- (void)setMedicalId:(NSString *)medicalId
{
    _medicalId = medicalId;
}

- (void)setPatientModel:(MYSExpertGroupPatientModel *)patientModel
{
    _patientModel = patientModel;
    
}

- (void)setOrderNumber:(NSString *)orderNumber
{
    _orderNumber = orderNumber;
    if (!orderNumber) {
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
        [rightButton addTarget:self action:@selector(clickRightBarBurron) forControlEvents:UIControlEventTouchUpInside];
        rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateHighlighted];
        self.rightButton = rightButton;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
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
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYSExpertGroupAddNewRecordPatientCell *addNewRecordPatientCell = [[MYSExpertGroupAddNewRecordPatientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    addNewRecordPatientCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    MYSPersonalMedicalRecordPatientInfoCell *personalMedicalRecordPatientInfoCell = [[MYSPersonalMedicalRecordPatientInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    personalMedicalRecordPatientInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MYSMedicalDataCell *medicalDataCell = [[MYSMedicalDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    medicalDataCell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            addNewRecordPatientCell.model = self.patientModel;
            return  addNewRecordPatientCell;
        } else {
            personalMedicalRecordPatientInfoCell.patientRecordModel = self.patientRecordModel;
            return personalMedicalRecordPatientInfoCell;
        }
    } else {
        medicalDataCell.itemLabel.text = self.sectionTwoTipArray[indexPath.row];
        if (indexPath.row == 0) {
            medicalDataCell.picArray = self.jianyandanArray;
            return medicalDataCell;
        } else if (indexPath.row == 1) {
            medicalDataCell.picArray = self.baogaodanArray;
            return medicalDataCell;
        } else {
            medicalDataCell.picArray = self.qitaArray;
            return medicalDataCell;
        }
        
    }
        return addNewRecordPatientCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
    return 65;
    } else {
        return 110;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if(section == 1) {
//        return 1;
//    } else {
//        return 0.1;
//    }
//}

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


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sectionHeadrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
//    sectionHeadrView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
//    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
//    topLine.alpha = 0.8;
//    topLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
//    [sectionHeadrView addSubview:topLine];
//    
////    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
////    bottomLine.alpha = 0.8;
////    bottomLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
////    [sectionHeadrView addSubview:bottomLine];
////    sectionHeadrView.frame = CGRectZero;
////    if (section == 0) {
////        topLine.hidden = YES;
////    } else {
////        topLine.hidden = NO;
////    }
//    return sectionHeadrView;
//
//}

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
            if (indexPath.section == 0) {
                if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    
                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                    
                } else if (indexPath.row == 0) {
                    
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                    
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                    
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                    
                    addLine = YES;
                }
                
            } else {
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
                    addLine = YES;
                    
                } else {
                    
                    CGPathAddRect(pathRef, nil, bounds);
                    
                    addLine = YES;
                    
                }
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



// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 编辑就诊记录
- (void)clickRightBarBurron
{
    UIViewController <MYSPersonalEditMedicalRecordViewControllerPrototol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSPersonalEditMedicalRecordViewControllerPrototol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.recordID = self.medicalId;
    viewController.patientRecordModel = self.patientRecordModel;
    viewController.patientModel = self.patientModel;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - API methods

//- (void)featchDataSource
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在加载";
//    
//    NSDictionary *parameters = @{@"medicalId": self.medicalId};
//    NSString *sign =  [MYSSignTool healthPlatformSignWith:parameters];
//    NSString *URLString = [NSString stringWithFormat:@"%@%@?appId=%@&sign=%@",KURL_HEALTHPLATFORM,@"/medical/querymobile",@"APP08",sign];
//    [HttpTool get:URLString params:parameters success:^(id responseObject) {
//        NSLog(@"%@", [responseObject objectForKey:@"output"]);
//        MYSPatientRecordModel *patientRecordModel = [[MYSPatientRecordModel alloc] initWithDictionary:[responseObject objectForKey:@"output"] error:nil];
//        self.patientRecordModel = patientRecordModel;
//            for (NSString *content in patientRecordModel.attList) {
//                NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *err;
//                NSArray *contentArray = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                        options:NSJSONReadingMutableContainers
//                                                                          error:&err];
//                if (contentArray.count > 0) {
//                    if([[contentArray[0] objectForKey:@"fileType"] intValue]== 2) {
//                        NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                        [sectionDict setValue:@"检验单" forKey:@"title"];
//                        for (int i = 0; i< contentArray.count; i++) {
//                            [self.jianyandanArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                        }
//                    }else if ([[contentArray[0] objectForKey:@"fileType"] intValue]== 1) {
//                        NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                        [sectionDict setValue:@"病例资料与检验报告单" forKey:@"title"];
//                        for (int i = 0; i< contentArray.count; i++) {
//                            [self.baogaodanArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                        }
//                    } else if ([[contentArray[0] objectForKey:@"fileType"] intValue]== 8) {
//                        NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                        [sectionDict setValue:@"其他资料" forKey:@"title"];
//                        for (int i = 0; i< contentArray.count; i++) {
//                            [self.qitaArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                        }
//                    }
//                }
//            }
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(NSError *error) {
//        LOG(@"%@",error);
//        [hud hide:YES];
//    }];
//}
// 获取就诊记录资料
- (void)featchDataSource
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.yOffset = 50;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/showmeans"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId, @"patient_id": self.patientModel.patientId, @"pmid": self.medicalId};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        MYSPersonalPatientRecordDataModel *patientRecordModel = [[MYSPersonalPatientRecordDataModel alloc] initWithDictionary:responseObject error:nil];
        self.patientRecordModel = patientRecordModel;
        LOG(@"%@",patientRecordModel);
        self.jianyandanArray = [self picURLArrayWithType:patientRecordModel.jianyandan];
        self.baogaodanArray = [self picURLArrayWithType:patientRecordModel.binglidan];
        self.qitaArray = [self picURLArrayWithType:patientRecordModel.other];
        [self.tableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        ;
    }];
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
@end
