//
//  TEExpertViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertViewController.h"
#import "TEExpertCell.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "TEExpert.h"
#import "TEOrder.h"
#import "TEAppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SVPullToRefresh.h"
#import "TEStoreManager.h"
#import "TEAreaPickerView.h"



@interface TEExpertViewController () <TESeekDiseaseViewControllerDelegate, TESeekHospitalViewControllerDelegate>
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, copy) NSString *keyword;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *placeHolderSource;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *diseaseId;
@property (nonatomic, copy) NSString *diseaseName;
@property (nonatomic, copy) NSString *hospitalId;
@property (nonatomic, copy) NSString *hospitalName;
@property (nonatomic, assign) NSInteger currentPage; // 当前是第几页
@property (nonatomic, assign) NSInteger totalPage; // 总页数
@property (nonatomic, assign) NSInteger number; // 每页显示几条记录

@end

@implementation TEExpertViewController

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {

        _number = 20;
        _currentPage = 0;
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)loadDataSource {
    self.dataSource = [[TEStoreManager sharedStoreManager] getSearchDoctorConfigureArray] ;
}

- (NSArray *)placeHolderSource
{
    if (_placeHolderSource == nil) {
        _placeHolderSource = [NSArray arrayWithObjects:@"请选择省市",@"请选择疾病",@"请选择医院", nil];
    }
    return _placeHolderSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDataSource];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    };
    
    [reach startNotifier];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
#pragma mark - UI

// UI布局
- (void)layoutUI
{

    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Create a search bar
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreen_Width, 44.0f)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreen_Width, 44.0f)];
    searchBar.delegate = self;
    searchBar.placeholder = @"找医生，疾病，科室，医院";
    searchBar.tintColor = [UIColor lightGrayColor];
    UIBarButtonItem *colextBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(colect)];
    colextBarButton.tintColor = [UIColor blackColor];
    UIBarButtonItem *springBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //给工具条添加按钮和相应方法
    NSArray *bArray = [NSArray arrayWithObjects:springBarButton, colextBarButton, nil];
    UIToolbar *keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];//创建工具条对象
    keyboardToolBar.items = bArray;
    searchBar.inputAccessoryView =keyboardToolBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.backgroundImage = [self createImageWithColor:[UIColor colorWithHex:0xe5f4f2]]; // 去掉搜索的边框
    self.searchBar = searchBar;
    [headerView addSubview:searchBar];
    self.tableView.tableHeaderView = headerView;
    
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(21, 20, 277, 51);
    [searchButton setTitle:@"搜    索" forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:searchButton];
    self.tableView.tableFooterView = footerView;
    

}

#pragma mark - Bussiness methods

// 去掉搜索的边框
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.dataSource[indexPath.section][indexPath.row] valueForKey:@"title"];
    switch (indexPath.row) {
        case 0:
            if (self.areaName == nil) {
                cell.detailTextLabel.text = self.placeHolderSource[indexPath.row];
            } else {
                cell.detailTextLabel.text = self.areaName;
            }
            
            break;
        case 1:
            if (self.diseaseName == nil) {
                cell.detailTextLabel.text = self.placeHolderSource[indexPath.row];
            } else {
                cell.detailTextLabel.text = self.diseaseName;
            }
            
            break;
            
        case 2:
            if (self.hospitalName == nil) {
                cell.detailTextLabel.text = self.placeHolderSource[indexPath.row];
            } else {
                cell.detailTextLabel.text = self.hospitalName;
            }
            
            break;
            
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TESeekAreaViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TESeekAreaViewControllerProtocol)];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    } else if (indexPath.row == 1) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TESeekDiseaseViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TESeekDiseaseViewControllerProtocol)];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TESeekHospitalViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TESeekHospitalViewControllerProtocol)];
        viewController.delegate = self;
        if (self.areaName && ![self.areaName isEqualToString:@"全部"]) {
            viewController.province = self.areaName;
        } else {
            viewController.province = @"";
        }
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}







- (void)searchButtonClick
{
    [self.searchBar resignFirstResponder];
    
    NSString *searchKeyword = @"";
    NSString *searchType = @"all";
    NSString *searchId = @"";
    
    BOOL isKeyword = NO;
    BOOL isArea = NO;
    BOOL isDisease = NO;
    BOOL isHospital = NO;
    
    if (self.searchBar.text && ![self.searchBar.text isEqualToString:@""]) {
        searchKeyword = self.searchBar.text;
        isKeyword = YES;
    }
    
    if (self.areaName && ![self.areaName isEqualToString:@"全部"] && ![self.areaName isEqualToString:@"请选择省市"]) {
        searchKeyword = [searchKeyword stringByAppendingFormat:@" %@", self.areaName];
        isArea = YES;
    }
    if (self.diseaseName && ![self.diseaseName isEqualToString:@"全部"] && ![self.diseaseName isEqualToString:@"请选择疾病"]) {
        searchKeyword = [searchKeyword stringByAppendingFormat:@" %@", self.diseaseName];
        isDisease = YES;
    }
    
    if (self.hospitalName && ![self.hospitalName isEqualToString:@"全部"] && ![self.hospitalName isEqualToString:@"请选择医院"]) {
        searchKeyword = [searchKeyword stringByAppendingFormat:@" %@", self.hospitalName];
        isHospital = YES;
    }
    
    
    if (isDisease == YES && isKeyword == NO && isArea == NO && isHospital == NO) {
        searchType = @"disease";
        if (self.diseaseId) {
            searchId = self.diseaseId;
        }
        
    } else if (isHospital == YES && isKeyword == NO && isDisease == NO) {
        searchType = @"hospital";
        if (self.hospitalId) {
            searchId = self.hospitalId;
        }
    }
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TESearchResultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TESearchResultViewControllerProtocol)];
    viewController.title = @"搜索结果";
    viewController.keyword = searchKeyword;
    viewController.searchType = searchType;
    viewController.searchId = searchId;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

// 完成退出键盘
- (void)colect
{
    [self.searchBar resignFirstResponder];
}

#pragma mark TESeekAreaViewControllerDelegate

- (void)didSelectedAreaId:(NSString *)areaId areaName:(NSString *)areaName
{
    if (![self.areaName isEqualToString:areaName]) {
        self.hospitalId = @"";
        self.hospitalName = @"请选择医院";
    }
    
    self.areaId = areaId;
    self.areaName = areaName;
    [self.tableView reloadData];
}

#pragma mark SeekTumourView Delegate

- (void)didSelectedDiseaseId:(NSString *)diseaseId diseaseName:(NSString *)diseaseName
{
    self.diseaseId = diseaseId;
    self.diseaseName = diseaseName;
    [self.tableView reloadData];
}


#pragma mark TESeekHospitalViewControllerDelegate

- (void)didSelectedHospitalId:(NSString *)hospitalId hospitalName:(NSString *)hospitalName
{
    self.hospitalId = hospitalId;
    self.hospitalName = hospitalName;
    [self.tableView reloadData];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSString *searchKeyword = @"";
    if (self.searchBar.text && ![self.searchBar.text isEqualToString:@""]) {
        searchKeyword = searchBar.text;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TESearchResultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TESearchResultViewControllerProtocol)];
    viewController.title = @"搜索结果";
    viewController.keyword = searchKeyword;
    viewController.searchType = @"all";
    viewController.searchId = @"";
    
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



@end