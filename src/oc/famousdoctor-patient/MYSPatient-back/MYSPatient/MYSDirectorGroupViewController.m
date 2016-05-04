//
//  MYSDirectorGroupViewController.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-18.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDirectorGroupViewController.h"
#import "MYSDirectorGroupCell.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSExpertGroupDepartmentModel.h"
#import "HttpTool.h"
#import "MYSExpertGroupDepartment.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "MYSExpertGroupDoctor.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"

@interface MYSDirectorGroupViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UIButton *consultButton; // 免费咨询
@property (nonatomic, weak) UITableView *departmentListView; // 科室视图
@property (nonatomic, weak) UITableView *mainTableView; // 医生视图
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIButton *headerButton;
@property (nonatomic, weak) UILabel *headerTitleLable;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSMutableArray *departmentArray; // 科室数组
@property (nonatomic, strong) NSMutableArray *doctorArray; // 医生数组
@property (nonatomic, strong) NSString *departmentId; // 部门id
@property (nonatomic, strong) NSString *doctorTotal; // 医生总数

@end

@implementation MYSDirectorGroupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"主任医师团";
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // 免费咨询
    UIButton *consultButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 64+14, kScreen_Width-30, 44)];
    [consultButton setTitle:@"免费咨询" forState:UIControlStateNormal];
    consultButton.layer.cornerRadius = 5.0;
    consultButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [consultButton addTarget:self action:@selector(clickConsultButton) forControlEvents:UIControlEventTouchUpInside];
    [consultButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:consultButton];
    [consultButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:consultButton];
    [consultButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:highlightImage.size radius:5] forState:UIControlStateHighlighted];
    [self.view addSubview:consultButton];
    self.consultButton = consultButton;
    self.consultButton.hidden = YES;
    
    self.isOpen = NO;
    
    // 按科室查找展开控件
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 72, kScreen_Width, 44)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addGestureRecognizer:tap];
    
    // 顶部线
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    topLineView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    [headerView addSubview:topLineView];
    
    // 底部线
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreen_Width, 1)];
    bottomLineView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    [headerView addSubview:bottomLineView];
    
    // 提示打开
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 27, 16, 12, 8)];
    [headerButton setImage:[UIImage imageNamed:@"doctor_button_down_"] forState:UIControlStateNormal];
    headerButton.userInteractionEnabled = NO;
    self.headerButton = headerButton;
    self.headerView = headerView;
    self.headerView.hidden = YES;
    [headerView addSubview:headerButton];
    
    
    UILabel *headerTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetMinX(headerButton.frame) - 15, 44)];
    headerTitleLable.font = [UIFont systemFontOfSize:14];
    headerTitleLable.textColor = [UIColor colorFromHexRGB:K747474Color];
    headerTitleLable.text = @"按科室查找";
    [headerView addSubview:headerTitleLable];
    self.headerTitleLable = headerTitleLable;
    [self.view addSubview:headerView];
    
    // 医生列表
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, kScreen_Height - 180) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
    self.mainTableView.hidden = YES;
    
    // 科室列表
    UITableView *departmentListView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, 0) style:UITableViewStylePlain];
    departmentListView.separatorColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    departmentListView.delegate = self;
    departmentListView.dataSource = self;
    [self.view addSubview:departmentListView];
    self.departmentListView = departmentListView;
    
    [self findDepartment];
    
    self.departmentId = @"";
    [self findDoctorByDepartmentId:self.departmentId scrollPositonTop:NO];
    
    
    // 加载更多
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.mainTableView addFooterWithCallback:^{
        if (vc.doctorArray.count < [vc.doctorTotal intValue]) {
            [vc findDoctorByDepartmentId:vc.departmentId scrollPositonTop:NO];
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
}

- (NSMutableArray *)doctorArray
{
    if (_doctorArray == nil) {
        _doctorArray = [NSMutableArray array];
    }
    return  _doctorArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.departmentListView]) {
        return self.departmentArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.departmentListView]) {
        if(section == 0) {
            return 1;
        } else {
            return [[self.departmentArray[section] childDepartmentArray] count];
        }
        
    } else {
        return self.doctorArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.departmentListView]) {
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
        if(indexPath.section == 0) {
            cell.textLabel.text = @"全部科室";
        } else {
            MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[indexPath.section];
            MYSExpertGroupChildDepartmentModel *childDepartmentModel  = departmentModel.childDepartmentArray[indexPath.row];
            cell.textLabel.text = childDepartmentModel.departmentName;
        }
        cell.textLabel.highlightedTextColor = [UIColor colorFromHexRGB:K00907FColor];
        return cell;
    } else {
        static NSString *expertGroupConcerne = @"expertGroupConcerne";
        MYSDirectorGroupCell *expertGroupConcerneCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConcerne];
        if (expertGroupConcerneCell == nil) {
            expertGroupConcerneCell = [[MYSDirectorGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expertGroupConcerne];
        }
        MYSExpertGroupDoctorModel *expertGroupDoctorModel = self.doctorArray[indexPath.row];
        expertGroupConcerneCell.expertGroupDoctorModel = expertGroupDoctorModel;
        
        return expertGroupConcerneCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.departmentListView]) {
        [self tapHeaderView];
        [self.doctorArray removeAllObjects];
        self.doctorTotal = @"0";
        if (indexPath.section == 0) {
            [self findDoctorByDepartmentId:@"" scrollPositonTop:YES];
            self.departmentId = @"";
            self.headerTitleLable.text = @"全部科室";
        } else {
            MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[indexPath.section];
            MYSExpertGroupChildDepartmentModel *childDepartmentModel  = departmentModel.childDepartmentArray[indexPath.row];
            self.headerTitleLable.text = childDepartmentModel.departmentName;
            self.departmentId = childDepartmentModel.departmentID;
            [self findDoctorByDepartmentId:self.departmentId scrollPositonTop:YES];
        }
    } else {
        UIViewController <MYSExpertGroupDoctorHomeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDoctorHomeViewControllerProtocol)];
//        self.hidesBottomBarWhenPushed = YES;
        MYSExpertGroupDoctorModel *expertGroupDoctorModel = self.doctorArray[indexPath.row];
        viewController.doctorType = expertGroupDoctorModel.doctorType;
        viewController.doctorId = expertGroupDoctorModel.doctorId;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.departmentListView]) {
        return 44;
    } else {
        return 88;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.departmentListView]) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 22)];
        sectionView.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width - 15, 22)];
        sectionLabel.backgroundColor = [UIColor clearColor];
        sectionLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        sectionLabel.font = [UIFont systemFontOfSize:12];
        if (section == 0) {
            sectionLabel.text = @"全部科室";
        } else {
            MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[section];
            sectionLabel.text = departmentModel.superDepartmentName;
        }
        [sectionView addSubview:sectionLabel];
        return sectionView;
    } else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.departmentListView]) {
        return 22;
    } else {
        return 0.1;
    }
    
}

// 打开科室选择
- (void)tapHeaderView
{
    self.isOpen = !self.isOpen;
    
    if (self.isOpen) {
        [self.headerButton setImage:[UIImage imageNamed:@"doctor_button_up_"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.departmentListView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, kScreen_Height - 180);
        }];
    } else {
        [self.headerButton setImage:[UIImage imageNamed:@"doctor_button_down_"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.departmentListView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, 0);
        }];
    }
}

/**
 *  设置cell的圆角
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
                
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                
                lineLayer.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor].CGColor;
                
                [layer addSublayer:lineLayer];
                
            }
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            
            [testView.layer insertSublayer:layer atIndex:0];
            
            testView.backgroundColor = UIColor.clearColor;
            
            cell.backgroundView = testView;
            
        }
        
    }
    
}

#pragma mark 含有医生的所有科室

- (void)findDepartment
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention"];
    NSDictionary *parameters = @{@"attention_type": @"4",@"doctor_type": @"1"};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSExpertGroupDepartment *department = [[MYSExpertGroupDepartment alloc] initWithDictionary:responseObject error:nil];
        self.departmentArray = [NSMutableArray arrayWithArray:department.departmentArray];
        [self.departmentArray insertObject:@"全部科室" atIndex:0];
        [self.departmentListView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

#pragma mark 通过科室id查询医生

- (void)findDoctorByDepartmentId:(NSString *)departmentId scrollPositonTop:(BOOL)isScrollPositionTop
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *userId = @"";
    if (ApplicationDelegate.isLogin) {
        userId = ApplicationDelegate.userId;
    } else {
        userId = @"";
    }
    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention/bydepartment"];
    NSDictionary *parameters = @{@"attention_type": @"4", @"pnid": departmentId, @"start":[NSString stringWithFormat:@"%lu",(unsigned long)self.doctorArray.count], @"end": kNumberOfPage, @"doctor_type": @"1"};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSExpertGroupDoctor *doctor = [[MYSExpertGroupDoctor alloc] initWithDictionary:responseObject error:nil];
        self.doctorTotal = doctor.doctorTotal;
        [self.doctorArray addObjectsFromArray:doctor.doctorArray];
        self.consultButton.hidden = NO;
        self.headerView.hidden = NO;
        self.mainTableView.hidden = NO;
        [self.mainTableView reloadData];
        if (isScrollPositionTop) { // 切换科室内容需要重新定位到顶部
            [self.mainTableView setContentOffset:CGPointMake(0,0) animated:NO];
        }
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

- (void)clickConsultButton
{
    UIViewController <MYSDirectorGroupFreeConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSDirectorGroupFreeConsultViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
