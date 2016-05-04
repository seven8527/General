//
//  MYSExpertGroupViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-12.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupViewController.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSExpertGroupAddConcerneViewController.h"
#import "MYSExpertGroupConcernedViewController.h"
#import "MYSExpertGroupDoctorHomeViewController.h"
#import "HttpTool.h"
#import "MYSExpertGroupDepartment.h"
#import "MYSExpertGroupDepartmentModel.h"
#import "MYSExpertGroupChildDepartmentModel.h"
#import "MYSExpertGroupDoctor.h"
#import "AppDelegate.h"
#import "MYSDoctorHome.h"
#import "MYSExpertGroupDoctorModel.h"

@interface MYSExpertGroupViewController () <MYSExpertGroupConcerneViewDelegate,MYSExpertGroupAddConcerneViewDelegate>
@property (nonatomic, weak) UISegmentedControl *segment;
@property (nonatomic, strong) MYSExpertGroupAddConcerneViewController *addConcerneVC;
@property (nonatomic, strong) MYSExpertGroupConcernedViewController *concernedVC;


//@property (nonatomic, strong) NSMutableArray *doctorArray; // 医生数组
@property (nonatomic, strong) NSMutableArray *attentedDoctorArray; // 已关注的医生数组

@property (nonatomic, strong) NSString *doctorId;
@end

@implementation MYSExpertGroupViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
//    [self findDepartment];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expertGroupClickPicAskButton:) name:@"expertGroupClickPicAskButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expertGroupClickPhoneAskButton:) name:@"expertGroupClickPhoneAskButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expertGroupClickOfflineAskButton:) name:@"expertGroupClickOfflineAskButton" object:nil];
    
    self.title = @"名医汇";
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    
//    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"加关注", @"已关注", nil]];
//    segment.selectedSegmentIndex = 0;
//    self.segment = segment;
//    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
//    segment.tintColor = [UIColor colorFromHexRGB:K00907FColor];
//    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
//    selectedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:KFFFFFFColor];
//    [segment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
//    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
//    normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    normalAttributes[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:K00907FColor];
//    [segment setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
//    segment.frame = CGRectMake(9, 64 + 7, [UIScreen mainScreen].bounds.size.width - 18, 29);
//    [self.view addSubview:segment];
//    
//    [self segmentClick:segment];
//    
//       
//    MYSExpertGroupConcernedViewController *concernedVC = [[MYSExpertGroupConcernedViewController alloc] init];
//    concernedVC.view.frame = CGRectMake(0, CGRectGetMaxY(segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(segment.frame) - 7);
//    [self.view addSubview:concernedVC.view];
//    concernedVC.delegate = self;
//    concernedVC.view.hidden = YES;
//    self.concernedVC = concernedVC;
//    
//    MYSExpertGroupAddConcerneViewController *addConcerneVC = [[MYSExpertGroupAddConcerneViewController alloc] init];
//    addConcerneVC.view.frame = CGRectMake(0, CGRectGetMaxY(segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(segment.frame) - 7);
//    [self.view addSubview:addConcerneVC.view];
//    addConcerneVC.delegate = self;
//    addConcerneVC.view.hidden = NO;
//    self.addConcerneVC = addConcerneVC;
    
        MYSExpertGroupAddConcerneViewController *addConcerneVC = [[MYSExpertGroupAddConcerneViewController alloc] init];
        addConcerneVC.view.frame = CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64);
        [self.view addSubview:addConcerneVC.view];
        addConcerneVC.delegate = self;
        addConcerneVC.view.hidden = NO;
        self.addConcerneVC = addConcerneVC;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
     self.navigationController.navigationBarHidden = NO;
}

//#pragma mark tableViewDelegate
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.departmentArray.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[section];
//    
//    return departmentModel.childDepartmentArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    cell.textLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
//    MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[indexPath.section];
//    MYSExpertGroupChildDepartmentModel *childDepartmentModel  = departmentModel.childDepartmentArray[indexPath.row];
//    cell.textLabel.text = childDepartmentModel.departmentName;
//    cell.textLabel.highlightedTextColor = [UIColor colorFromHexRGB:K00907FColor];
//    
//    return cell;
//}





//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"选择科室%ld",(long)indexPath.row);
//    
//    [self tapHeaderView];
//    
//#warning 选择科室  加载调用不同接口加载数据
//    
//    if(self.segment.selectedSegmentIndex == 0) {
//        NSLog(@"加载加关注列表的所选科室的医生");
//        
//        MYSExpertGroupDepartmentModel *departmentModel = self.departmentArray[indexPath.section];
//        MYSExpertGroupChildDepartmentModel *childDepartmentModel  = departmentModel.childDepartmentArray[indexPath.row];
//        self.headerTitleLable.text = childDepartmentModel.departmentName;
//        NSString *departmentId = childDepartmentModel.departmentID;
//        [self findDoctorByDepartmentId:departmentId];
//    } else {
//        NSLog(@"加载已关注关注列表的所选科室的医生");
//    }
//}


#pragma mark 选择医生 

// 已关注
- (void)expertGroupConcerneView:(UITableView *)expertGroupAddConcerneView didSelectedWith:(id)model
{
    UIViewController <MYSExpertGroupDoctorHomeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDoctorHomeViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorId = [model doctorId];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 加关注
- (void)expertGroupAddConcerneView:(UITableView *)expertGroupAddConcerneView didSelectedWith:(id)model
{
    UIViewController <MYSExpertGroupDoctorHomeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDoctorHomeViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorType = [model doctorType];
    viewController.doctorId = [model doctorId];
    [self.navigationController pushViewController:viewController animated:YES];
}



// 切换关注
- (void)segmentClick:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) { // 加关注
        
        self.concernedVC.view.hidden = YES;
        self.addConcerneVC.view.hidden = NO;
        // 默认没有选择科室时加载的医生
        //[self findDoctorByDepartmentId:@""];
        
    } else { // 已关注
        self.hidesBottomBarWhenPushed = YES;
        if (!ApplicationDelegate.isLogin) { // 未登录
            self.segment.selectedSegmentIndex = 0;
            UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
            loginViewController.title = @"登录";
            loginViewController.source = NSClassFromString(@"MYSExpertGroupViewController");
            loginViewController.aSelector = @selector(reflect);
            loginViewController.instance = self;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navController animated:YES completion:nil];
            
        } else { // 已登录
            //[self findAttentionedDoctorByDepartmentId:@""];
            self.concernedVC.view.hidden = NO;
            self.addConcerneVC.view.hidden = YES;
        }
    }
//    [self.view exchangeSubviewAtIndex:2 withSubviewAtIndex:3];
}

// 登录后，重新调用已关注方法
- (void)reflect
{
    self.segment.selectedSegmentIndex = 1;
    [self findDepartment];
    [self findAttentionedDoctorByDepartmentId:@""];
}



// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
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
//        self.departmentArray = [NSMutableArray arrayWithArray:department.departmentArray];
        self.concernedVC.departmentArray = department.departmentArray;
//        //
//        [self.departmentListView reloadData];
        //        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        //        [hud hide:YES];
    }];
}


#pragma mark 通过科室id查询加关注的医生

//- (void)findDoctorByDepartmentId:(NSString *)departmentId
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在加载";
//    
//    NSString *userId = @"";
//    if (ApplicationDelegate.isLogin) {
//        userId = ApplicationDelegate.userId;
//    } else {
//        userId = @"";
//    }
//    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention/bydepartment"];
//    NSDictionary *parameters = @{@"attention_type": @"4", @"uid": userId, @"pnid": departmentId, @"start":[NSString stringWithFormat:@"%lu",(unsigned long)self.doctorArray.count], @"end": kNumberOfPage};
//    [HttpTool get:URLString params:parameters success:^(id responseObject) {
//        LOG(@"Success: %@", responseObject);
//        MYSExpertGroupDoctor *doctor = [[MYSExpertGroupDoctor alloc] initWithDictionary:responseObject error:nil];
////        self.addConcerneVC.expertGroupDoctor = doctor;
//    
//        [hud hide:YES];
//    } failure:^(NSError *error) {
//        NSLog(@"Error: %@", error);
//        [hud hide:YES];
//    }];
//}

#pragma mark 通过科室id查询已关注的医生

- (void)findAttentionedDoctorByDepartmentId:(NSString *)departmentId
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";

    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention/bydepartment"];
    NSDictionary *parameters = @{@"attention_type": @"1", @"uid": ApplicationDelegate.userId, @"pnid": departmentId, @"start":[NSString stringWithFormat:@"%lu",(unsigned long)self.attentedDoctorArray.count], @"end": kNumberOfPage};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSExpertGroupDoctor *doctor = [[MYSExpertGroupDoctor alloc] initWithDictionary:responseObject error:nil];
        self.concernedVC.expertGroupDoctor = doctor;

        self.addConcerneVC.view.hidden = YES;
        self.concernedVC.view.hidden = NO;
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
    }];
}


#pragma mark 关注医生

//- (void)addAttention:(NSString *)doctorId
//{
//    if (!ApplicationDelegate.isLogin) { // 未登录
//        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
//        loginViewController.title = @"登录";
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//        [self presentViewController:navController animated:YES completion:nil];
//    } else { // 已登录
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"正在加载";
//        
//        NSString *URLString = [kURL stringByAppendingString:@"attention/add"];
//        NSDictionary *parameters = @{@"attention_id": doctorId, @"uid": ApplicationDelegate.userId};
//        [HttpTool get:URLString params:parameters success:^(id responseObject) {
//            LOG(@"Success: %@", responseObject);
//            [hud hide:YES];
//        } failure:^(NSError *error) {
//            NSLog(@"Error: %@", error);
//            [hud hide:YES];
//        }];
//        
//    }
//}

// 网络咨询
- (void)expertGroupClickPicAskButton:(NSNotification *)notification
{
    MYSExpertGroupDoctorModel *doctorModel = notification.object;
    self.doctorId = doctorModel.doctorId;
    
    if (ApplicationDelegate.isLogin) {
        [self reflectAskNetWorkExpert];
    } else {
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        loginViewController.source = NSClassFromString(@"MYSExpertGroupDoctorHomeViewController");
        loginViewController.aSelector = @selector(reflectAskNetWorkExpert);
        loginViewController.instance = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
    
}

- (void)reflectAskNetWorkExpert
{
    UIViewController <MYSExpertGroupNetworkConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupNetworkConsultViewControllerProtocol)];
//    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorId = self.doctorId;
    [self.navigationController pushViewController:viewController animated:YES];
}

// 电话咨询
- (void)expertGroupClickPhoneAskButton:(NSNotification *)notification
{
    MYSExpertGroupDoctorModel *doctorModel = notification.object;
    self.doctorId = doctorModel.doctorId;
    
    if (ApplicationDelegate.isLogin) {
        [self reflectAskPhoneExpert];
    } else {
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        loginViewController.source = NSClassFromString(@"MYSExpertGroupDoctorHomeViewController");
        loginViewController.aSelector = @selector(reflectAskPhoneExpert);
        loginViewController.instance = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
    
}

- (void)reflectAskPhoneExpert
{
    UIViewController <MYSExpertGroupPhoneConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupPhoneConsultViewControllerProtocol)];
//    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorId = self.doctorId;
    [self.navigationController pushViewController:viewController animated:YES];
}

// 面对面咨询
- (void)expertGroupClickOfflineAskButton:(NSNotification *)notification
{
    MYSExpertGroupDoctorModel *doctorModel = notification.object;
    self.doctorId = doctorModel.doctorId;
    
    if (ApplicationDelegate.isLogin) {
        [self reflectAskOfflineExpert];
    } else {
        UIViewController <MYSLoginViewControllerProtocol> *loginViewController = [[JSObjection defaultInjector] getObject:@protocol(MYSLoginViewControllerProtocol)];
        loginViewController.title = @"登录";
        loginViewController.source = NSClassFromString(@"MYSExpertGroupDoctorHomeViewController");
        loginViewController.aSelector = @selector(reflectAskOfflineExpert);
        loginViewController.instance = self;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)reflectAskOfflineExpert
{
    UIViewController <MYSExpertGroupOfflineConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupOfflineConsultViewControllerProtocol)];
//    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorId = self.doctorId;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
