//
//  MYSExpertGroupConcernedViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-12.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConcernedViewController.h"
#import "MYSDirectorGroupCell.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSExpertGroupDoctorModel.h"
#import "MYSExpertGroupDepartmentModel.h"
#import "HttpTool.h"
#import "MYSExpertGroupDepartment.h"
#import "AppDelegate.h"
#import "MJRefresh.h"

@interface MYSExpertGroupConcernedViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, strong) UITableView *departmentListView; // 科室视图
@property (nonatomic, weak) UITableView *mainTableView; // 医生视图
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIButton *headerButton;
@property (nonatomic, weak) UILabel *headerTitleLable;
@property (nonatomic, strong) NSMutableArray *doctorArray; // 医生数组
@property (nonatomic, strong) NSString *departmentId; // 部门id
@property (nonatomic, strong) NSString *doctorTotal; // 医生总数
@end

@implementation MYSExpertGroupConcernedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.isOpen = NO;
    
    if (ApplicationDelegate.isLogin) {
        [self findDepartment];
        self.departmentId = @"";
        [self findAttentionedDoctorByDepartmentId:self.departmentId scrollPositonTop:NO];
    }
    
    // 按科室查找展开控件
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
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
    [headerView addSubview:headerButton];
    
    
    UILabel *headerTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,CGRectGetMinX(headerButton.frame) - 15, 44)];
    headerTitleLable.font = [UIFont systemFontOfSize:14];
    headerTitleLable.textColor = [UIColor colorFromHexRGB:K747474Color];
    headerTitleLable.text = @"按科室查找";
    self.headerTitleLable = headerTitleLable;
    [headerView addSubview:headerTitleLable];
    [self.view addSubview:headerView];
    
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    maskView.backgroundColor = [UIColor lightGrayColor];
    maskView.alpha = 0.2;
    self.maskView = maskView;
    self.maskView.hidden = YES;
    [self.view addSubview:maskView];
    
    // 医生列表
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, kScreen_Height - 151) style:UITableViewStylePlain];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    self.mainTableView = mainTableView;
    [self.view addSubview:mainTableView];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 科室列表
    UITableView *departmentListView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, 0) style:UITableViewStylePlain];
    departmentListView.separatorColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    departmentListView.delegate = self;
    departmentListView.dataSource = self;
    [self.view addSubview:departmentListView];
    self.departmentListView = departmentListView;
    
    // 加载更多
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.mainTableView addFooterWithCallback:^{
        if (vc.doctorArray.count < [vc.doctorTotal intValue]) {
            [vc findAttentionedDoctorByDepartmentId:self.departmentId scrollPositonTop:NO];
            [vc.mainTableView footerEndRefreshing];
        } else {
            vc.mainTableView.footerRefreshingText = @"已加载全部数据";
            [vc.mainTableView footerEndRefreshing];
        }
    }];
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

- (void)setDepartmentArray:(NSMutableArray *)departmentArray
{
    [self.departmentArray removeAllObjects];
    
    _departmentArray = departmentArray;
    
    [self.departmentListView reloadData];
}

- (void)setExpertGroupDoctor:(MYSExpertGroupDoctor *)expertGroupDoctor
{
    _expertGroupDoctor = expertGroupDoctor;

    [self.doctorArray removeAllObjects];
    
    [self.doctorArray addObjectsFromArray:expertGroupDoctor.doctorArray];
    
    [self.mainTableView reloadData];
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
        return [[self.departmentArray[section] childDepartmentArray] count];
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
        MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[indexPath.section];
        MYSExpertGroupChildDepartmentModel *childDepartmentModel  = departmentModel.childDepartmentArray[indexPath.row];
        cell.textLabel.text = childDepartmentModel.departmentName;
        cell.textLabel.highlightedTextColor = [UIColor colorFromHexRGB:K00907FColor];
        
        return cell;
    } else {
        static NSString *expertGroupConcerne = @"expertGroupConcerne";
        MYSDirectorGroupCell *expertGroupConcerneCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConcerne];
        if (expertGroupConcerneCell == nil) {
            expertGroupConcerneCell = [[MYSDirectorGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expertGroupConcerne];
        }
        expertGroupConcerneCell.concerneLabel.hidden = YES;
        expertGroupConcerneCell.concerneButton.hidden = YES;
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
        MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[indexPath.section];
        MYSExpertGroupChildDepartmentModel *childDepartmentModel  = departmentModel.childDepartmentArray[indexPath.row];
        self.headerTitleLable.text = childDepartmentModel.departmentName;
        [self findAttentionedDoctorByDepartmentId:childDepartmentModel.departmentID scrollPositonTop:YES];
    } else {
        if ([self.delegate respondsToSelector:@selector(expertGroupConcerneView:didSelectedWith:)]) {
            [self.delegate expertGroupConcerneView:tableView didSelectedWith:self.doctorArray[indexPath.row]];
        }
    }
    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.departmentListView]) {
        return NO;
    } else {
        return YES;
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
        MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[section];
        sectionLabel.text = departmentModel.superDepartmentName;
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

/*改变删除按钮的title*/
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return @"取消\n关注";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.departmentListView]) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.expertGroupDoctor.doctorArray removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
    }
}

// 打开科室选择
- (void)tapHeaderView
{
    self.isOpen = !self.isOpen;
    
    if (self.isOpen) {
        //        self.maskView.hidden = NO;
        [self.headerButton setImage:[UIImage imageNamed:@"doctor_button_up_"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.departmentListView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, kScreen_Height - 151);
        }];
    } else {
        //        self.maskView.hidden = YES;
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
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
//        hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention"];
    NSDictionary *parameters = @{@"attention_type": @"1", @"uid": ApplicationDelegate.userId};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSExpertGroupDepartment *department = [[MYSExpertGroupDepartment alloc] initWithDictionary:responseObject error:nil];
        self.departmentArray = [NSMutableArray arrayWithArray:department.departmentArray];
        //
        [self.departmentListView reloadData];
        //        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        //        [hud hide:YES];
    }];
}

#pragma mark 通过科室id查询已关注的医生

- (void)findAttentionedDoctorByDepartmentId:(NSString *)departmentId scrollPositonTop:(BOOL)isScrollPositionTop
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention/bydepartment"];
    NSDictionary *parameters = @{@"attention_type": @"1", @"uid": ApplicationDelegate.userId, @"pnid": departmentId, @"start":[NSString stringWithFormat:@"%lu",(unsigned long)self.doctorArray.count], @"end": kNumberOfPage};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSExpertGroupDoctor *doctor = [[MYSExpertGroupDoctor alloc] initWithDictionary:responseObject error:nil];
        [self.doctorArray addObjectsFromArray:doctor.doctorArray];
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

@end
