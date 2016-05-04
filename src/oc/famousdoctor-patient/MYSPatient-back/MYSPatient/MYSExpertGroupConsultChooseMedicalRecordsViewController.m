//
//  MYSExpertGroupConsultChooseMedicalRecordsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultChooseMedicalRecordsViewController.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "MYSExpertGroupConsultMedicalRecordsHeaderView.h"
#import "MYSMedicalDataCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MYSSignTool.h"
#import "HttpTool.h"
//#import "MYSPatientRecords.h"
//#import "MYSPatientRecordModel.h"
#import <MJRefresh/MJRefresh.h>
#import "MYSExpertGroupPatientRecords.h"
#import "MYSExpertGroupPatientRecordDataModel.h"

@interface MYSExpertGroupConsultChooseMedicalRecordsViewController () <UITableViewDataSource,UITableViewDelegate,MYSExpertGroupConsultMedicalRecordsHeaderViewDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSMutableArray *selectedRecordArray;
//@property (nonatomic, strong) MYSPatientRecords *records;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int total;
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@property (nonatomic, strong) NSMutableArray *totalRecords;
@end

@implementation MYSExpertGroupConsultChooseMedicalRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择就诊记录";
    
    self.currentPage = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewPatientRecord) name:@"addnewPatientRecord" object:nil];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_button_addrecord_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickRightBarButton)];
    rightBarButton.tintColor = [UIColor colorFromHexRGB:K00907FColor];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    
//    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreen_Width, kScreen_Height - 65 ) style:UITableViewStyleGrouped];
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreen_Width, kScreen_Height - 15 ) style:UITableViewStyleGrouped];
    if (iPhone4) {
         mainTableView.frame = CGRectMake(0, 15, kScreen_Width,480 + 30);
    }
   
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView = mainTableView;
    [self.view addSubview:mainTableView];
    
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreen_Width, 1)];
//    topView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
//    [mainTableView addSubview:topView];
//    
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainTableView.frame.size.height - 1, kScreen_Width, 1)];
//    bottomView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
//    [mainTableView addSubview:bottomView];
//    [self layoutBottomView];
    
    UIImageView *sadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 60) / 2, kScreen_Height  / 2 -60, 60, 60)];
    sadImageView.image = [UIImage imageNamed:@"search_icon_none_"];
    self.sadImageView = sadImageView;
    sadImageView.hidden = YES;
    [self.view addSubview:sadImageView];
    
    UILabel *sadTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sadImageView.frame) + 10, kScreen_Width, 40)];
    self.sadTextLabel = sadTextLabel;
    sadTextLabel.hidden = YES;
    sadTextLabel.textColor = [UIColor lightGrayColor];
    sadTextLabel.text = @"没有就诊记录,请添加";
    sadTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sadTextLabel];
    [self fetchPatientData];
    
    [self addFooter];
    
}


- (NSArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (NSMutableArray *)textArray
{
    if (_textArray == nil) {
        _textArray = [NSMutableArray array];
    }
    return _textArray;
}


- (NSMutableArray *)selectedRecordArray
{
    if (_selectedRecordArray == nil) {
        _selectedRecordArray = [NSMutableArray array];
    }
    return _selectedRecordArray;
}


- (NSMutableArray *)totalRecords
{
    if (_totalRecords == nil) {
        _totalRecords = [NSMutableArray array];
    }
    return _totalRecords;
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.mainTableView addFooterWithCallback:^{
        if (self.contentArray.count < self.total) {
            self.currentPage ++;
            [vc fetchPatientData];
            [vc.mainTableView footerEndRefreshing];
        } else {
            vc.mainTableView.footerRefreshingText = @"已加载全部数据";
            [vc.mainTableView footerEndRefreshing];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置底部控件
- (void)layoutBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 50, kScreen_Width, 50)];
    bottomView.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    [bottomView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [bottomView.layer setBorderWidth:0.5];
    [self.view addSubview:bottomView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    iconImageView.layer.cornerRadius = 15;
    iconImageView.clipsToBounds = YES;
    [bottomView addSubview:iconImageView];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 84 -10, 7.5, 84, 35)];
    [commitButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    commitButton.layer.cornerRadius = 5;
    [commitButton.layer setBorderWidth:1];
    [commitButton.layer setBorderColor:[UIColor colorFromHexRGB:K00907FColor].CGColor];
    [commitButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    [bottomView addSubview:commitButton];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:12];
    CGSize priceSize = [MYSFoundationCommon sizeWithText:priceLabel.text withFont:priceLabel.font];
    priceLabel.frame = CGRectMake(CGRectGetMinX(commitButton.frame) - 15 - priceSize.width, (50 - priceSize.height) / 2, priceSize.width, priceSize.height);
    [bottomView addSubview:priceLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 8,19, CGRectGetMinX(priceLabel.frame) - CGRectGetMaxX(iconImageView.frame) - 8, 12)];
    nameLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:nameLabel];
}

- (void)setPatientModel:(MYSExpertGroupPatientModel *)patientModel
{
    _patientModel = patientModel;
}

#pragma mark UITabelviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if([[self.textArray objectAtIndex:section] isEqualToArray:@[]])
   {
       return 0;
   } else {
       return [self.textArray[section] count];
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MYSMedicalDataCell *medicalDataCell = [[MYSMedicalDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    medicalDataCell.itemLabel.text = [[self.textArray[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
    medicalDataCell.picArray =[[self.textArray[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"picArray"];
    return medicalDataCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MYSExpertGroupConsultMedicalRecordsHeaderView *headerView = [[MYSExpertGroupConsultMedicalRecordsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 85)];
    headerView.patientRecordModel = self.totalRecords[section];
    headerView.delegate = self;
    headerView.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expend:)];
    [headerView addGestureRecognizer:tap];
    if (section == 0) {
        headerView.topLine.frame = CGRectMake(0, 0, kScreen_Width, 1);
        headerView.bottomLine.hidden = YES;
    } else if (section == self.textArray.count - 1){
        headerView.topLine.frame = CGRectMake(15, 0, kScreen_Width - 15, 1);
        if ([[self.textArray objectAtIndex:section] isEqualToArray:@[]]) {
             headerView.bottomLine.hidden = NO;
        } else {
             headerView.bottomLine.hidden = YES;
        }
       
    } else {
        headerView.topLine.frame = CGRectMake(15, 0, kScreen_Width - 15, 1);
        headerView.bottomLine.hidden = YES;
    }
    if ([[self.textArray objectAtIndex:section] isEqualToArray:@[]]) {
        headerView.indicatorView.image = [UIImage imageNamed:@"doctor_button_down_"];
    } else {
         headerView.indicatorView.image = [UIImage imageNamed:@"doctor_button_up_"];
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


//- (void)medicalDataCell:(MYSMedicalDataCell *)medicalDataCell showImageWithIndex:(NSInteger *)index andSection:(NSInteger *)section
//{
////    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.picArray.count];
////    for (int i = 0; i<self.picArray.count; i++) {
////        // 替换为中等尺寸图片
////        MJPhoto *photo = [[MJPhoto alloc] init];
////        photo.url = [NSURL URLWithString:self.picArray[i]];
//////        photo.srcImageView = [self.imageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].imageView; // 来源于哪个UIImageView
////        [photos addObject:photo];
////    }
////    
////    
////    // 2.显示相册
////    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
////    browser.hiddenPhotoLoadingView = NO;
////    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
////    browser.photos = photos; // 设置所有的图片
////    [browser show];
//
//}

- (void)expend:(UIGestureRecognizer *)gestureReconginzer
{
    MYSExpertGroupConsultMedicalRecordsHeaderView *tapView = (MYSExpertGroupConsultMedicalRecordsHeaderView *)gestureReconginzer.view;
    NSInteger tapInteger = tapView.tag;
    NSLog(@"%p,%p",self.textArray,self.contentArray);
    
    if([[self.textArray objectAtIndex:tapInteger] isEqualToArray:@[]])
    {
        [self.textArray replaceObjectAtIndex:tapInteger withObject:[self.contentArray objectAtIndex:tapInteger]];
    }else
    {
        [self.textArray replaceObjectAtIndex:tapInteger withObject:@[]];
    }
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:tapInteger] withRowAnimation:UITableViewRowAnimationFade];
}

//- (void)expertGroupConsultMedicalRecordDidSelectWithIndex:(NSInteger)index
//{
//    NSLog(@"%ld",(long)index);
//    [self.selectedRecordArray addObject:self.contentArray[index]];
//}
//
//- (void)expertGroupConsultMedicalRecordDidDeselectWithIndex:(NSInteger)index
//{
//     NSLog(@"%ld",(long)index);
//    
//    [self.selectedRecordArray removeObject:self.contentArray[index]];
//}

// 选择就诊记录的代理方法  获得选择的索引值
- (void)expertGroupConsultMedicalRecordDidSelectWithIndex:(NSInteger)index
{
    if([self.delegate respondsToSelector:@selector(expertGroupConsultChooseMedicalRecordsDidSelectedMedicalRecordModel:)]) {
        [self.delegate expertGroupConsultChooseMedicalRecordsDidSelectedMedicalRecordModel:self.totalRecords[index]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 取消选择的就诊记录  获得取消选择的索引值 为多选时使用
- (void)expertGroupConsultMedicalRecordDidDeselectWithIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    
    [self.selectedRecordArray removeObject:self.contentArray[index]];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加记录
- (void)clickRightBarButton
{
    UIViewController <MYSExpertGroupConsultAddNewRecordViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupConsultAddNewRecordViewControllerProtocol)];
    viewController.patientModel = self.patientModel;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.hidesBottomBarWhenPushed = YES;
}

// 添加完成就诊记录  刷新最新
- (void)addNewPatientRecord
{
    [self.textArray removeAllObjects];
    [self.contentArray removeAllObjects];
    [self fetchPatientData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - API methods
// 获取患者资料列表
- (void)fetchPatientData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/record_list"];
    NSDictionary *parameters = @{@"patient_id": self.patientModel.patientId, @"start": [NSString stringWithFormat:@"%lu",(unsigned long)self.contentArray.count], @"end": @"5"};
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@",responseObject);
        MYSExpertGroupPatientRecords *patientRecords = [[MYSExpertGroupPatientRecords alloc] initWithDictionary:responseObject error:nil];
        [self.textArray removeAllObjects];
        [self.totalRecords addObjectsFromArray:patientRecords.records];
        if (self.totalRecords.count == 0) {
            self.sadImageView.hidden = NO;
            self.sadTextLabel.hidden = NO;
        } else {
            self.sadTextLabel.hidden = YES;
            self.sadImageView.hidden = YES;
        }
        self.total = [patientRecords.total intValue];
        for(MYSExpertGroupPatientRecordDataModel *record in patientRecords.records)
        {
            LOG(@"%@",record);
              NSMutableArray *sectionArray = [NSMutableArray array];
            if (record.jianyandan.length > 0) {
                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
                [sectionDict setValue:@"检验单" forKey:@"title"];
                NSArray *picArray = [record.jianyandan componentsSeparatedByString:@","];
                [sectionDict setValue:picArray forKey:@"picArray"];
                [sectionArray addObject:sectionDict];
            }
            if (record.binglidan.length > 0) {
                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
                [sectionDict setValue:@"病例资料与检验报告单" forKey:@"title"];
                NSArray *picArray = [record.binglidan componentsSeparatedByString:@","];
                [sectionDict setValue:picArray forKey:@"picArray"];
                [sectionArray addObject:sectionDict];
            }
            if (record.other.length > 0) {
                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
                [sectionDict setValue:@"其他" forKey:@"title"];
                NSArray *picArray = [record.other componentsSeparatedByString:@","];
                [sectionDict setValue:picArray forKey:@"picArray"];
                [sectionArray addObject:sectionDict];
            }
            [self.contentArray addObject:sectionArray];
        }
        
        [self.textArray addObjectsFromArray:self.contentArray];
        for (int i = 0; i < self.textArray.count; i++) {
            [self.textArray replaceObjectAtIndex:i withObject:@[]];
        }
        [self.mainTableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"%@",error);
        [hud hide:YES];
    }];
}

//- (void)featchDataSource
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在加载";
//    
//    NSDictionary *parameters = @{@"ownerId": self.patientModel.patientId, @"page": [NSString stringWithFormat:@"%d",self.currentPage], @"sortorder": @"desc", @"rows": @"2"};
//    NSString *sign =  [MYSSignTool healthPlatformSignWith:parameters];
//    NSString *URLString = [NSString stringWithFormat:@"%@%@?appId=%@&sign=%@",KURL_HEALTHPLATFORM,@"/medical/querylistmobile",@"APP08",sign];
//    [HttpTool get:URLString params:parameters success:^(id responseObject) {
//        NSLog(@"%@", [responseObject objectForKey:@"output"]);
//        MYSPatientRecords *records = [[MYSPatientRecords alloc] initWithDictionary:[responseObject objectForKey:@"output"] error:nil];
//        self.totalPage = [[[responseObject objectForKey:@"output"] objectForKey:@"total"] intValue];
//        //        self.records = records;
//        [self.totalRecords addObjectsFromArray:records.patientRecords];
//        
//        [self.textArray removeAllObjects];
//        for (int i = 0; i < records.patientRecords.count; i ++) {
//            MYSPatientRecordModel *patientRecordModel = records.patientRecords[i];
//            //            [self featchdesWithMedicalId:patientRecordModel.patientRecordID];
//            NSMutableArray *sectionArray = [NSMutableArray array];
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
//                        NSMutableArray *picArray = [NSMutableArray array];
//                        for (int i = 0; i< contentArray.count; i++) {
//                            [picArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                        }
//                        [sectionDict setValue:picArray forKey:@"picArray"];
//                        [sectionArray addObject:sectionDict];
//                    }else if ([[contentArray[0] objectForKey:@"fileType"] intValue]== 1) {
//                        NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                        [sectionDict setValue:@"病例资料与检验报告单" forKey:@"title"];
//                        NSMutableArray *picArray = [NSMutableArray array];
//                        for (int i = 0; i< contentArray.count; i++) {
//                            [picArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                        }
//                        [sectionDict setValue:picArray forKey:@"picArray"];
//                        [sectionArray addObject:sectionDict];
//                    } else if ([[contentArray[0] objectForKey:@"fileType"] intValue]== 8) {
//                        NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                        [sectionDict setValue:@"其他资料" forKey:@"title"];
//                        NSMutableArray *picArray = [NSMutableArray array];
//                        for (int i = 0; i< contentArray.count; i++) {
//                            [picArray addObject:[contentArray[i] objectForKey:@"filePath"]];
//                        }
//                        [sectionDict setValue:picArray forKey:@"picArray"];
//                        [sectionArray addObject:sectionDict];
//                    }
//                }
//            }
//            [self.contentArray addObject:sectionArray];
//        }
//        [self.textArray addObjectsFromArray:self.contentArray];
//        for (int i = 0; i < self.textArray.count; i++) {
//            [self.textArray replaceObjectAtIndex:i withObject:@[]];
//        }
//        [self.mainTableView reloadData];
//        [hud hide:YES];
//    } failure:^(NSError *error) {
//        LOG(@"%@",error);
//        [hud hide:YES];
//    }];
//}

//- (void)featchdesWithMedicalId:(NSString *)medicalId
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在加载";
//    
//    NSDictionary *parameters = @{@"businessId": medicalId};
//    NSString *sign =  [MYSSignTool healthPlatformSignWith:parameters];
//    NSString *URLString = [NSString stringWithFormat:@"%@%@?appId=%@&sign=%@",KURL_HEALTHPLATFORM,@"/fileUpload/select",@"APP08",sign];
//    [HttpTool get:URLString params:parameters success:^(id responseObject) {
//        NSLog(@"%@", [responseObject objectForKey:@"output"]);
////        MYSPatientRecords *records = [[MYSPatientRecords alloc] initWithDictionary:[responseObject objectForKey:@"output"] error:nil];
////        self.records = records;
////        [self.contentArray removeAllObjects];
////        [self.textArray removeAllObjects];
////        for (int i = 0; i < records.patientRecords.count; i ++) {
////            MYSPatientRecordModel *patientRecordModel = records.patientRecords[i];
////            NSMutableArray *sectionArray = [NSMutableArray array];
////            for (MYSPatientRecordDataModel *patientRecordDataModel in patientRecordModel.attList) {
////                if ([patientRecordDataModel.fileType isEqualToString:@"2"]) {
////                    [sectionArray addObject:@"检验单"];
////                }else if ([patientRecordDataModel.fileType isEqualToString:@"1"]) {
////                    [sectionArray addObject:@"病例资料与检验报告单"];
////                } else if ([patientRecordDataModel.fileType isEqualToString:@"8"]) {
////                    [sectionArray addObject:@"其他资料"];
////                }
////            }
////            [self.contentArray addObject:sectionArray];
////        }
////        [self.textArray addObjectsFromArray:self.contentArray];
////        for (int i = 0; i < self.textArray.count; i++) {
////            [self.textArray replaceObjectAtIndex:i withObject:@[]];
////        }
////        [self.mainTableView reloadData];
//        [hud hide:YES];
//    } failure:^(NSError *error) {
//        LOG(@"%@",error);
//        [hud hide:YES];
//    }];
//}

//- (void)featchdesWithMedicalId:(NSString *)medicalId
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在加载";
//    
//    
//    NSDictionary *parameters = @{@"businessId": medicalId};
//    NSString *sign =  [MYSSignTool healthPlatformSignWith:parameters];
//    NSString *URLString = [NSString stringWithFormat:@"%@%@?appId=%@&sign=%@",KURL_HEALTHPLATFORM,@"/fileUpload/attlistpager",@"APP08",sign];
//    [HttpTool get:URLString params:parameters success:^(id responseObject) {
//        NSLog(@"%@", [responseObject objectForKey:@"output"]);
//        //        MYSPatientRecords *records = [[MYSPatientRecords alloc] initWithDictionary:[responseObject objectForKey:@"output"] error:nil];
//        //        self.records = records;
//        //        [self.contentArray removeAllObjects];
//        //        [self.textArray removeAllObjects];
//        //        for (int i = 0; i < records.patientRecords.count; i ++) {
//        //            MYSPatientRecordModel *patientRecordModel = records.patientRecords[i];
//        //            NSMutableArray *sectionArray = [NSMutableArray array];
//        //            for (MYSPatientRecordDataModel *patientRecordDataModel in patientRecordModel.attList) {
//        //                if ([patientRecordDataModel.fileType isEqualToString:@"2"]) {
//        //                    [sectionArray addObject:@"检验单"];
//        //                }else if ([patientRecordDataModel.fileType isEqualToString:@"1"]) {
//        //                    [sectionArray addObject:@"病例资料与检验报告单"];
//        //                } else if ([patientRecordDataModel.fileType isEqualToString:@"8"]) {
//        //                    [sectionArray addObject:@"其他资料"];
//        //                }
//        //            }
//        //            [self.contentArray addObject:sectionArray];
//        //        }
//        //        [self.textArray addObjectsFromArray:self.contentArray];
//        //        for (int i = 0; i < self.textArray.count; i++) {
//        //            [self.textArray replaceObjectAtIndex:i withObject:@[]];
//        //        }
//        //        [self.mainTableView reloadData];
//        [hud hide:YES];
//    } failure:^(NSError *error) {
//        LOG(@"%@",error);
//        [hud hide:YES];
//    }];
//}

@end
