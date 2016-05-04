//
//  MYSSearchViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSearchViewController.h"
#import "UASearchBar.h"
#import "UIColor+Hex.h"
#import "MYSDoctorSearchViewController.h"
#import "MYSDiseaseSearchViewController.h"
#import "UtilsMacro.h"
#import "MYSHotSearchCell.h"
#import "HttpTool.h"
#import "MYSSearch.h"
#import "MYSSearchSliderViewController.h"

@interface MYSSearchViewController () <UASearchBarDelegate,MYSDoctorSearchViewControllerDelegate,MYSDiseaseSearchViewControllerDelegate>
@property (nonatomic, strong) MYSDoctorSearchViewController *doctorSearchVC;
@property (nonatomic, strong) MYSDiseaseSearchViewController *diseaseSearchVC;
@property (nonatomic, weak) UASearchBar *searchView;
@property (nonatomic, weak) UISegmentedControl *segment;
@property (nonatomic, weak) UIView *doctorView;
@property (nonatomic, weak) UIView *diseaseView;
@property (nonatomic, strong) NSMutableArray *searchHistoryArray;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, weak) UIButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *saveArray;
@property (nonatomic, strong) NSMutableArray *tepSearchHistoryArray;
@property (nonatomic, assign) BOOL searched;
@property (nonatomic, strong) MYSSearchSliderViewController *searchSliderVC;
@end

@implementation MYSSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"搜索中心";
    self.searched = NO;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    
    // 搜索框
    UASearchBar *searchView = [[UASearchBar alloc] initWithFrame:CGRectMake(9, 74, self.view.frame.size.width - 18, 28)];
    [searchView setCancelButtonTitle:@"取消" forState:UIControlStateNormal];
    [searchView setCancelButtonTitleColor:[UIColor colorFromHexRGB:KB3B3B3Color] forState:UIControlStateNormal];
    [searchView setShowsCancelButton:YES];
    searchView.delegate = self;
    searchView.backgroundColor = [UIColor clearColor];
    searchView.placeHolder = @"请输入要搜索的医生或疾病";
    [searchView setSearchIcon:@"home_search"];
    searchView.delegate = (id)self;
    self.searchView = searchView;
    [searchView.textField becomeFirstResponder];
    [self.view addSubview:searchView];
    
    
//    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"医生", @"疾病", nil]];
//    segment.selectedSegmentIndex = 0;
//    self.segment = segment;
//    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
//    segment.tintColor = [UIColor colorFromHexRGB:K00907FColor];
//    //    [segment setBackgroundColor:[UIColor colorFromHexRGB:K00A693Color]];
//    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
//    selectedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:KFFFFFFColor];
//    [segment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
//    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
//    normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    normalAttributes[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:K00907FColor];
//    [segment setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
//    segment.frame = CGRectMake(9, CGRectGetMaxY(searchView.frame) + 15, [UIScreen mainScreen].bounds.size.width - 18, 28);
//    [self.view addSubview:segment];
    
    
    
//    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(segment.frame) - 7) style:UITableViewStyleGrouped];
//    mainTableView.delegate = self;
//    mainTableView.dataSource = self;
//    self.mainTableView = mainTableView;
//    [self.view addSubview:mainTableView];
    
    
//    MYSDoctorSearchViewController *doctorSearchVC = [[MYSDoctorSearchViewController alloc] initWithStyle:UITableViewStylePlain];
//    doctorSearchVC.delegate = self;
//    self.doctorSearchVC = doctorSearchVC;
//    
//    MYSDiseaseSearchViewController *diseaseSearchVC = [[MYSDiseaseSearchViewController alloc] initWithStyle:UITableViewStylePlain];
//    diseaseSearchVC.delegate = self;
//    self.diseaseSearchVC = diseaseSearchVC;
    
    MYSSearchSliderViewController *sliderVC = [[MYSSearchSliderViewController alloc] init];
    self.searchSliderVC = sliderVC;
    self.searchSliderVC.view.hidden = YES;
    sliderVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame) + 5, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.searchView.frame));
    sliderVC.doctorSearchVC.delegate = self;
    sliderVC.diseaseSearchVC.delegate = self;
    [self.view addSubview:sliderVC.view];
    
//    [self readSearchHistory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
//    self.navigationController.navigationBarHidden = YES;
}


- (NSMutableArray *)searchHistoryArray
{
    if (_searchHistoryArray == nil) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
}



- (NSMutableArray *)saveArray
{
    if (_saveArray == nil) {
        _saveArray = [NSMutableArray array];
    }
    return _saveArray;
}


- (NSMutableArray *)tepSearchHistoryArray
{
    if (_tepSearchHistoryArray == nil) {
        _tepSearchHistoryArray = [NSMutableArray array];
    }
    return _tepSearchHistoryArray;
}



#pragma mark tabelView delegate

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return  2;
//    } else {
//        if (self.searchHistoryArray.count > 0) {
//            return self.searchHistoryArray.count;
//        } else {
//            return 1;
//        }
//        
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *hotSearch = @"hotSearch";
//    MYSHotSearchCell *hotSearchCell = [tableView dequeueReusableCellWithIdentifier:hotSearch];
//    
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (hotSearchCell == nil) {
//        hotSearchCell = [[MYSHotSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotSearch];
//    }
//    hotSearchCell.hotSearchArray = [NSArray arrayWithObjects:@"胃癌",@"尿毒症",@"甲状腺",@"周春竹", nil];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    
//    if (indexPath.section == 0) {
//        return  hotSearchCell;
//    } else {
//        if (self.searchHistoryArray.count > 0) {
//             cell.textLabel.text = self.searchHistoryArray[indexPath.row];
//            cell.textLabel.textAlignment = NSTextAlignmentLeft;
//            cell.userInteractionEnabled = YES;
//        } else {
//            cell.textLabel.text = @"无历史记录";
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;
//            cell.userInteractionEnabled = NO;
//        }
//       
//        return cell;
//    }
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
//    
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 150, 30)];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:headerLabel];
//    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    deleteButton.frame = CGRectMake(kScreen_Width - 80, 5, 60, 20);
//    [deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [deleteButton setTitle:@"清除记录" forState:UIControlStateNormal];
//    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [deleteButton setBackgroundColor:[UIColor clearColor]];
//    [deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
//    self.deleteButton = deleteButton;
//    [headerView addSubview:deleteButton];
//
//    if (section == 0) {
//        self.deleteButton.hidden = YES;
//        headerLabel.text = @"热门搜索";
//    } else {
//        if (self.searchHistoryArray.count > 0) {
//            self.deleteButton.hidden = NO;
//        } else {
//            self.deleteButton.hidden = YES;
//        }
//        headerLabel.text = @"历史记录";
//        
//    }
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}

#pragma mark doctorSearchDelegate

- (void)doctorSerachViewDidSelectDoctor:(MYSSearchDoctorModel *)searchDoctorModel{
    UIViewController <MYSExpertGroupDoctorHomeViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSExpertGroupDoctorHomeViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.doctorType = searchDoctorModel.doctorType;
    viewController.doctorId = searchDoctorModel.doctorId;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark diseaseSearchDelegate

- (void)diseaseSerachViewDidSelectDiseaseId:(NSString *)diseaseId
{
    UIViewController <MYSDiseaseDetailsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSDiseaseDetailsViewControllerProtocol)];
    self.hidesBottomBarWhenPushed = YES;
    viewController.diseaseId = diseaseId;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark seamentControl Delegate
- (void)segmentClick:(UISegmentedControl *)segment
{
//    [self.view exchangeSubviewAtIndex:3 withSubviewAtIndex:4];
    
    if (self.searched == YES) {
    if(segment.selectedSegmentIndex == 0) {
//        [self.diseaseView removeFromSuperview];
//        [self.view addSubview:self.diseaseView];
        if(self.searchView.textField.text.length > 0){
        self.diseaseView.hidden = YES;
        self.doctorView.hidden = NO;
        } else {
            self.diseaseView.hidden = YES;
            self.doctorView.hidden = YES;
        }
    } else {
//        [self.doctorView removeFromSuperview];
//        [self.view addSubview:self.diseaseView];
        if(self.searchView.textField.text.length > 0){
            self.diseaseView.hidden = NO;
            self.doctorView.hidden = YES;
        } else {
            self.diseaseView.hidden = YES;
            self.doctorView.hidden = YES;
        }
    }
    } else {
        self.diseaseView.hidden = YES;
        self.doctorView.hidden = YES;
    }
}


#pragma mark searchBar delegate
- (void)searchBar:(UASearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        [self.searchView setCancelButtonTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
        self.searchView.cancelButton.userInteractionEnabled = YES;
//        [self.searchView setCancelButtonTitle:@"确定" forState:UIControlStateNormal];
    } else {
        self.searchView.cancelButton.userInteractionEnabled = NO;
        [self.searchView setCancelButtonTitleColor:[UIColor colorFromHexRGB:KB3B3B3Color] forState:UIControlStateNormal];
//        [self.searchView setCancelButtonTitle:@"取消" forState:UIControlStateNormal];
//        self.diseaseView.hidden = YES;
//        self.doctorView.hidden = YES;
//        self.doctorSearchVC.doctorTotal = @"";
//        self.doctorSearchVC.doctorArray = [[NSMutableArray alloc] init];
//        self.doctorSearchVC.searchText = @"";
//        self.diseaseSearchVC.diseaseArray = [[NSMutableArray alloc] init];
//        self.diseaseSearchVC.diseaseTotal = @"";
//        self.diseaseSearchVC.searchText = @"";
//        self.searched = NO;
        self.searchSliderVC.view.hidden = YES;
    }
}

- (void)searchBarSearchButtonClicked:(UASearchBar *)searchBar
{
    if ([self validateSearch:searchBar.text]) {
        [self searchDoctorOrDiseaseWithSearchText:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UASearchBar *)searchBar
{
//    if([self.searchView.cancelButton.titleLabel.text isEqual:@"取消"]) {
////        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        if ([self validateSearch:searchBar.text]) {
//         [self searchDoctorOrDiseaseWithSearchText:searchBar.text];
////         searchBar.text = @"";
//        }
//    }
        self.searchView.text = @"";
    self.searchSliderVC.view.hidden = YES;
}

- (void) searchDoctorOrDiseaseWithSearchText:(NSString *)searchText
{
    [self.searchView setCancelButtonTitle:@"取消" forState:UIControlStateNormal];
    
    if (self.segment.selectedSegmentIndex == 0 ) {
        self.diseaseView = self.diseaseSearchVC.view;
        self.diseaseView.frame = CGRectMake(0, CGRectGetMaxY(self.segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.segment.frame) - 7);
        [self.view addSubview:self.diseaseView];
        
        self.doctorView = self.doctorSearchVC.view;
        self.doctorView.frame =  CGRectMake(0, CGRectGetMaxY(self.segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.segment.frame) - 7);
        [self.view addSubview:self.doctorView];
    } else {
        self.doctorView = self.doctorSearchVC.view;
        self.doctorView.frame =  CGRectMake(0, CGRectGetMaxY(self.segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.segment.frame) - 7);
        [self.view addSubview:self.doctorView];
        
        self.diseaseView = self.diseaseSearchVC.view;
        self.diseaseView.frame = CGRectMake(0, CGRectGetMaxY(self.segment.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(self.segment.frame) - 7);
        [self.view addSubview:self.diseaseView];
    }
    
    [self search:searchText];
    
    //[self saveSearchHistory:searchText];
}


/**
 *  存储
 *
 *  @param text 新添内容
 */
//- (void)saveSearchHistory:(NSString *)text
//{
//    //    [self.titleArray addObject:text];
//    
//    self.saveArray = [NSMutableArray arrayWithArray:self.searchHistoryArray];
//    self.tepSearchHistoryArray  = [NSMutableArray arrayWithArray:self.searchHistoryArray];
//    if (self.searchHistoryArray.count == 0) {
//        
//        [self.saveArray addObject:text];
//        [self.searchHistoryArray addObject:text];
//        [[NSUserDefaults standardUserDefaults] setObject:self.saveArray forKey:@"history"];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    } else {
//        BOOL isEqual = NO;
//        for (NSString *title in self.searchHistoryArray) {
//            if (![title isEqualToString:text]) {
//                continue;
//            } else {
//                isEqual = YES;
//                break;
//            }
//        }
//        
//        if (isEqual == NO) {
//            [self.saveArray insertObject:text atIndex:0];
//            [self.tepSearchHistoryArray insertObject:text atIndex:0];
//            if (self.saveArray.count > 3) {
//                [self.saveArray removeLastObject];
//                [self.tepSearchHistoryArray removeLastObject];
//            }
//            self.searchHistoryArray = [NSMutableArray arrayWithArray:self.tepSearchHistoryArray];
//            [[NSUserDefaults standardUserDefaults] setObject:self.saveArray forKey:@"history"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//    }
//}


/**
 *  读取存储内容
 */
//- (void)readSearchHistory
//{
//    self.searchHistoryArray =  [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
////    if (self.searchHistoryArray == nil) {
////
////    } else {
////        if ([self.searchHistoryArray count] == 0) {
////            [self.deleteButton setTitle:@"无历史记录" forState:UIControlStateNormal];
////            self.deleteButton.userInteractionEnabled = NO;
////        } else {
////            [self.deleteButton setTitle:@"清除记录" forState:UIControlStateNormal];
////            self.deleteButton.userInteractionEnabled = YES;
////        }
////    }
//    
//}


/**
 *  清除存储
 */
//- (void)delete
//{
//    NSMutableArray *savArray = [NSMutableArray arrayWithArray:self.searchHistoryArray];
//    
//    [savArray removeAllObjects];
//    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"history"];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    self.searchHistoryArray = savArray;
////    if ([self.searchHistoryArray count] == 0) {
////        [self.deleteButton setTitle:@"无历史记录" forState:UIControlStateNormal];
////        self.deleteButton.userInteractionEnabled = NO;
////    } else {
////        [self.deleteButton setTitle:@"清除记录" forState:UIControlStateNormal];
////        self.deleteButton.userInteractionEnabled = YES;
////    }
//    
//    
//    [self.mainTableView reloadData];
//    
//}


- (void)search:(NSString *)keyword
{
    self.searched = YES;
    if(self.segment.selectedSegmentIndex == 0) {
        //        [self.diseaseView removeFromSuperview];
        //        [self.view addSubview:self.diseaseView];
        if(self.searchView.textField.text.length > 0){
            self.diseaseView.hidden = YES;
            self.doctorView.hidden = NO;
        } else {
            self.diseaseView.hidden = YES;
            self.doctorView.hidden = YES;
        }
    } else {
        //        [self.doctorView removeFromSuperview];
        //        [self.view addSubview:self.diseaseView];
        if(self.searchView.textField.text.length > 0){
            self.diseaseView.hidden = NO;
            self.doctorView.hidden = YES;
        } else {
            self.diseaseView.hidden = YES;
            self.doctorView.hidden = YES;
        }
        
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"search/new_search"];
    NSDictionary *parameters = @{@"keywords": keyword};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSSearch *search = [[MYSSearch alloc] initWithDictionary:responseObject error:nil];
        self.searchSliderVC.view.hidden = NO;
        self.searchSliderVC.search = search;
        self.searchSliderVC.keyWord = keyword;
//        self.doctorSearchVC.doctorTotal = search.doctorTotal;
//        self.doctorSearchVC.doctorArray = search.doctorArray;
//        self.doctorSearchVC.searchText = keyword;
//        self.diseaseSearchVC.diseaseArray = search.diseaseArray;
//        self.diseaseSearchVC.diseaseTotal = search.diseaseTotal;
//        self.diseaseSearchVC.searchText = keyword;
//        
//        if ([self.doctorSearchVC.doctorTotal isEqualToString:@"0"] && ![self.diseaseSearchVC.diseaseTotal isEqualToString:@"0"]) {
//            self.segment.selectedSegmentIndex = 1;
//            
//            [self segmentClick:self.segment];
//        } else {
//            self.segment.selectedSegmentIndex = 0;
//            [self segmentClick:self.segment];
//        }
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

#pragma mark - Validate

// 验证搜索内容
- (BOOL)validateSearch:(NSString *)keyword
{
    if ([keyword length] < 1 || [keyword length] > 10) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"搜索内容为1至10个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
