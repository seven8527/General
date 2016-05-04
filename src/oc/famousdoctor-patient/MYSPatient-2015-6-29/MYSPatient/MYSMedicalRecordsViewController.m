//
//  MYSMedicalRecordsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMedicalRecordsViewController.h"
#import "MYSMedicalRecordCollectionViewCell.h"
#import "MYSMedicalRecordCollectionHeaderView.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "MYSExpertGroupPatient.h"
#import "MYSSignTool.h"
//#import "MYSPersonalRecords.h"
#import <MJRefresh/MJRefresh.h>
#import "MYSExpertGroupPatientRecords.h"


@interface MYSMedicalRecordsViewController () <UICollectionViewDelegate,UICollectionViewDataSource,MYSMedicalRecordCollectionHeaderViewDelegate>
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *patientArray;
@property (nonatomic, weak) MYSMedicalRecordCollectionHeaderView *headerView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, strong) NSMutableArray *totalRecords;
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@property (nonatomic, assign) BOOL fisrtLoad;
@end

@implementation MYSMedicalRecordsViewController
static  NSString *medicalRecordCollection = @"medicalRecordCollectionCell";
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
    layout.minimumLineSpacing = 0;
    // 5.设置四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 45, 0, 45);
    layout.headerReferenceSize = CGSizeMake(kScreen_Width, 90);
    return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 更换用户
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeUser:) name:@"exchangeUser" object:nil];
    
    // 添加患者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNewPatient:) name:@"expertGroupAddNewPatient" object:nil];
    
    // 添加记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewPatientRecord) name:@"addnewPatientRecord" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalEditMedicalRecord) name:@"updatePersonalEditMedicalRecord" object:nil];

    self.fisrtLoad = YES;
    
    UIImageView *sadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 60) / 2, (kScreen_Height - 160) / 2 -60, 60, 60)];
    sadImageView.image = [UIImage imageNamed:@"search_icon_none_"];
    self.sadImageView = sadImageView;
    self.sadImageView.hidden = YES;
    [self.view addSubview:sadImageView];
    
    
    UILabel *sadTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sadImageView.frame) + 10, kScreen_Width, 40)];
    self.sadTextLabel = sadTextLabel;
    sadTextLabel.textColor = [UIColor lightGrayColor];
    sadTextLabel.text = @"无就诊记录";
    sadTextLabel.textAlignment = NSTextAlignmentCenter;
    sadTextLabel.hidden = YES;
    [self.view addSubview:sadTextLabel];
  
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[MYSMedicalRecordCollectionHeaderView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:medicalRecordCollectionHeaderView];
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.collectionView addGestureRecognizer:upSwipe];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.collectionView addGestureRecognizer:downSwipe];
    
    [self.collectionView registerClass:[MYSMedicalRecordCollectionViewCell class] forCellWithReuseIdentifier:medicalRecordCollection];
   
    self.currentPage = 1;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.fisrtLoad == YES) {
        [self fetchPatient];
        [self addFooter];
        self.fisrtLoad = NO;
    }
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.collectionView addFooterWithCallback:^{
        if (self.dataSource.count < self.totalPage) {
            self.currentPage ++;
            [vc featchDataSourceWith:self.patientModel];
            [vc.collectionView footerEndRefreshing];
        } else {
            vc.collectionView.footerRefreshingText = @"已加载全部数据";
            [vc.collectionView footerEndRefreshing];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 更换账号
- (void)exchangeUser:(NSNotification *)notification
{
    self.currentPage = 1;
    [self fetchPatient];
    [self addFooter];
}

// 添加患者
- (void)addNewPatient:(NSNotification *)notification
{
    self.currentPage = 1;
    [self fetchPatient];
    [self addFooter];

}

// 添加完成就诊记录  刷新最新
- (void)addNewPatientRecord
{
    self.currentPage = 1;
//    [self fetchPatient];
    [self.totalRecords removeAllObjects];
    // 获取患者资料列表
    [self featchDataSourceWith:self.patientModel];
}

// 编辑就诊记录 跟新就诊记录
- (void)updatePersonalEditMedicalRecord
{
    self.currentPage = 1;
    //    [self fetchPatient];
    [self.totalRecords removeAllObjects];
    // 获取患者资料列表
    [self featchDataSourceWith:self.patientModel];
}
- (NSMutableArray *)patientArray
{
    if (_patientArray == nil) {
        _patientArray = [NSMutableArray array];
    }
    return _patientArray;
}

- (NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (NSMutableArray *)totalRecords
{
    if (_totalRecords == nil) {
        _totalRecords = [NSMutableArray array];
    }
    return _totalRecords;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalRecords.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYSMedicalRecordCollectionViewCell * medicalRecordCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:medicalRecordCollection forIndexPath:indexPath];
    if (medicalRecordCollectionCell == nil) {
        medicalRecordCollectionCell = [[MYSMedicalRecordCollectionViewCell alloc] init];
    }
    medicalRecordCollectionCell.model = self.totalRecords[indexPath.row];
    return medicalRecordCollectionCell;
}


- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        MYSMedicalRecordCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:medicalRecordCollectionHeaderView forIndexPath:indexPath];
        self.headerView = headerView;
        headerView.delegate = self;
        reusableview = headerView;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *userInfo = @{@"patientRecord": self.totalRecords[indexPath.item] , @"patientModel": self.patientModel};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"personalMedicalRecordSelect" object:nil userInfo:userInfo];
}


// 新增记录
- (void)medicalRecordCollectionHeaderViewClickAddNewRecord
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"personalMedicalRecordAddNewRecord" object:self.patientModel userInfo:nil];
}

// 用户管理
- (void)medicalRecordCollectionHeaderViewClickUserManager
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"personalMedicalRecordUserManager" object:nil userInfo:nil];
}

// 选中患者
- (void)medicalRecordCollectionHeaderViewDidSelectPatientWithModel:(id)model
{
    if(model) {
        self.currentPage = 1;
        self.patientModel = model;
        [self.totalRecords removeAllObjects];
        [self featchDataSourceWith:model];
    } else {
        self.sadImageView.hidden = NO;
        self.sadTextLabel.hidden = NO;
    }
}


#pragma mark - API methods

// 获取患者列表
- (void)fetchPatient
{
    LOG(@"window---------%@",self.view.window);
    
    LOG(@"view------%@",self.view);
//    UIView *view = self.view.window;
//    if (!view) {
//        view = self.view;
//    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    [self.patientArray removeAllObjects];
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/patient"];
    NSDictionary *parameters = @{@"userid": ApplicationDelegate.userId};
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        MYSExpertGroupPatient *patient = [[MYSExpertGroupPatient alloc] initWithDictionary:responseObject error:nil];
        [self.patientArray addObjectsFromArray:patient.patients];
        self.headerView.patientArray = self.patientArray;
        if(self.patientArray.count == 0) {
            [self.totalRecords removeAllObjects];
            [self.collectionView reloadData];
        }
        [hud hide:YES];
    } failure:^(NSError *error) {
        [hud hide:YES];
    }];
}

// 获取患者资料列表
- (void)featchDataSourceWith:(id)model
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"consult/record_list"];
    NSDictionary *parameters = @{@"patient_id": [model patientId], @"start": [NSString stringWithFormat:@"%lu",(unsigned long)self.totalRecords.count], @"end": @"5"};
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        LOG(@"%@",responseObject);
        MYSExpertGroupPatientRecords *patientRecords = [[MYSExpertGroupPatientRecords alloc] initWithDictionary:responseObject error:nil];
//        [self.textArray removeAllObjects];
        [self.totalRecords addObjectsFromArray:patientRecords.records];
        if (self.totalRecords.count > 0) {
            self.sadImageView.hidden = YES;
            self.sadTextLabel.hidden = YES;
        } else {
            self.sadTextLabel.hidden = NO;
            self.sadImageView.hidden = NO;
        }

//        self.total = [patientRecords.total intValue];
//        for(MYSExpertGroupPatientRecordDataModel *record in patientRecords.records)
//        {
//            LOG(@"%@",record);
//            NSMutableArray *sectionArray = [NSMutableArray array];
//            if (record.jianyandan.length > 0) {
//                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                [sectionDict setValue:@"检验单" forKey:@"title"];
//                NSArray *picArray = [record.jianyandan componentsSeparatedByString:@","];
//                [sectionDict setValue:picArray forKey:@"picArray"];
//                [sectionArray addObject:sectionDict];
//            }
//            if (record.binglidan.length > 0) {
//                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                [sectionDict setValue:@"病例资料与检验报告单" forKey:@"title"];
//                NSArray *picArray = [record.binglidan componentsSeparatedByString:@","];
//                [sectionDict setValue:picArray forKey:@"picArray"];
//                [sectionArray addObject:sectionDict];
//            }
//            if (record.other.length > 0) {
//                NSDictionary *sectionDict = [NSMutableDictionary dictionary];
//                [sectionDict setValue:@"其他" forKey:@"title"];
//                NSArray *picArray = [record.other componentsSeparatedByString:@","];
//                [sectionDict setValue:picArray forKey:@"picArray"];
//                [sectionArray addObject:sectionDict];
//            }
//            [self.contentArray addObject:sectionArray];
//        }
//        
//        [self.textArray addObjectsFromArray:self.contentArray];
//        for (int i = 0; i < self.textArray.count; i++) {
//            [self.textArray replaceObjectAtIndex:i withObject:@[]];
//        }
        [self.collectionView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
//        LOG(@"%@",error);
        [hud hide:YES];
    }];
}


//- (void)featchDataSourceWith:(id)model
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在加载";
//    
//    NSDictionary *parameters = @{@"ownerId": [model patientId], @"page": [NSString stringWithFormat:@"%d",self.currentPage], @"sortorder": @"desc", @"rows": @"5"};
//    NSString *sign =  [MYSSignTool healthPlatformSignWith:parameters];
//    NSString *URLString = [NSString stringWithFormat:@"%@%@?appId=%@&sign=%@",KURL_HEALTHPLATFORM,@"/medical/querylistmobilefour",@"APP08",sign];
//    [HttpTool get:URLString params:parameters success:^(id responseObject) {
//        NSLog(@"%@", [responseObject objectForKey:@"output"]);
//        MYSPersonalRecords *records = [[MYSPersonalRecords alloc] initWithDictionary:[responseObject objectForKey:@"output"] error:nil];
//        self.totalPage = [[[responseObject objectForKey:@"output"] objectForKey:@"total"] intValue];
//        [self.totalRecords addObjectsFromArray:records.patientRecords];
//        if (self.totalRecords.count > 0) {
//            self.centerLabel.hidden = YES;
//        } else {
//            self.centerLabel.hidden = NO;
//        }
//        [self.collectionView reloadData];
//        [hud hide:YES];
//    } failure:^(NSError *error) {
//        LOG(@"%@",error);
//        [hud hide:YES];
//    }];
//}



float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    LOG(@"开始拖动");
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (lastContentOffset > scrollView.contentOffset.y) {
        LOG(@"12向下滚动");
        if(self.collectionView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    } else {
        LOG(@"12向上滚动");
        if(self.collectionView.contentOffset.y > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        LOG(@"向上滚动");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
    }else{
        LOG(@"向下滚动");
        if(self.collectionView.contentOffset.y > 0) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
        }
    }
}


- (void)upSwipe
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollUp" object:nil];
}


- (void)downSwipe
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollDown" object:nil];
}
@end
