//
//  MYSDiseasesViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseasesViewController.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "MYSDiseaseModel.h"
#import "MYSDiseases.h"
#import "pinyin.h"
#import "MYSExpertGroupDepartment.h"
#import "MYSExpertGroupDepartmentModel.h"
#import "MYSExpertGroupChildDepartmentModel.h"
#import "MYSDiseasesSearchDiseaseViewController.h"

@interface MYSDiseasesViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UIButton *headerButton;
@property (nonatomic, weak) UILabel *headerTitleLable;
@property (nonatomic, strong) UITableView *departmentListView;
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSMutableArray *groupTipArray;

@property (nonatomic, strong) NSMutableArray *disease; // 原始数据
@property (nonatomic, strong) NSMutableArray *sortedDisease; // 排序后的数据
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys; // 索引键
@end

@implementation MYSDiseasesViewController

- (id)init
{
    if (self = [super init]) {
        _disease = [NSMutableArray array];
        _sortedDisease = [NSMutableArray array];
        _sectionHeadsKeys = [NSMutableArray array];
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.isOpen = NO;
    
    self.title = @"疾病大全";
    
    self.view.backgroundColor = [UIColor colorFromHexRGB:KF6F6F6Color];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(9, 64 + 7, [UIScreen mainScreen].bounds.size.width - 18, 29)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    //    searchBar.tintColor = [UIColor clearColor];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.layer.borderWidth = 1;
    searchBar.layer.borderColor = [UIColor colorFromHexRGB:KEDEDEDColor].CGColor;
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    [self.view addSubview:searchBar];
    
    // 按科室查找展开控件
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame) + 7, kScreen_Width, 44)];
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
    
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), kScreen_Width, kScreen_Height -  CGRectGetMaxY(headerView.frame)) style:UITableViewStylePlain];
    mainTableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    self.mainTableView =mainTableView;
    self.mainTableView.sectionIndexColor = [UIColor colorFromHexRGB:k00947DColor];//section索引的背景色
    [self.view addSubview:mainTableView];
    
    UITableView *departmentListView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), kScreen_Width, 0) style:UITableViewStylePlain];
    departmentListView.separatorColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    departmentListView.delegate = self;
    departmentListView.dataSource = self;
    [self.view addSubview:departmentListView];
    self.departmentListView = departmentListView;
    
    [self findDepartment];
    [self findDiseaseCategory];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:self.departmentListView]) {
        return self.groupTipArray.count;
    } else {
        return [self.sortedDisease count];
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if ([tableView isEqual:self.mainTableView]) {
        return self.sectionHeadsKeys;
        
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.departmentListView]) {
        MYSExpertGroupDepartmentModel *departmentModel = self.groupTipArray[section];
        return departmentModel.childDepartmentArray.count;
    } else {
        return [[self.sortedDisease objectAtIndex:section] count];
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([tableView isEqual:self.departmentListView]) {
//        return @"";
//    } else {
//        return [self.sectionHeadsKeys objectAtIndex:section];
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if ([tableView isEqual:self.departmentListView]) {
        cell.textLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
        cell.textLabel.highlightedTextColor = [UIColor colorFromHexRGB:K00907FColor];
        MYSExpertGroupDepartmentModel *departmentModel = self.groupTipArray[indexPath.section];
        MYSExpertGroupChildDepartmentModel *childDepartmentModel  = departmentModel.childDepartmentArray[indexPath.row];
        cell.textLabel.text = childDepartmentModel.departmentName;
        cell.textLabel.highlightedTextColor = [UIColor colorFromHexRGB:K00907FColor];
    } else {
        if ([self.sortedDisease count] > indexPath.section)
        {
            NSArray *arr = [self.sortedDisease objectAtIndex:indexPath.section];
            if ([arr count] > indexPath.row) {
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
                cell.textLabel.highlightedTextColor = [UIColor colorFromHexRGB:K00907FColor];
                // 之后,将数组的元素取出,赋值给数据模型
                MYSDiseaseModel *disease = (MYSDiseaseModel *) [arr objectAtIndex:indexPath.row];
                // 给cell赋给相应地值,从数据模型处获得
                cell.textLabel.text = disease.name;
            }
        }
        
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.departmentListView]) {
        MYSExpertGroupDepartmentModel *departmentModel = self.groupTipArray[indexPath.section];
        [self tapHeaderView];
        self.headerTitleLable.text = [departmentModel.childDepartmentArray[indexPath.row] departmentName];
        [self findDiseaseCategoryWithDepartment:[departmentModel.childDepartmentArray[indexPath.row] departmentID]];
        [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        UIViewController <MYSDiseaseDetailsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSDiseaseDetailsViewControllerProtocol)];
         NSArray *arr = [self.sortedDisease objectAtIndex:indexPath.section];
        viewController.diseaseId = [arr[indexPath.row] diseaseId];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
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
        MYSExpertGroupDepartmentModel *departmentModel = self.groupTipArray[section];
        sectionLabel.text = departmentModel.superDepartmentName;
        [sectionView addSubview:sectionLabel];
        return sectionView;
    } else {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 26)];
        sectionView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width - 15, 26)];
        sectionLabel.backgroundColor = [UIColor clearColor];
        sectionLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        sectionLabel.font = [UIFont systemFontOfSize:14];
        sectionLabel.text = [self.sectionHeadsKeys objectAtIndex:section];
        [sectionView addSubview:sectionLabel];
        return sectionView;
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
            self.departmentListView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, kScreen_Height - 154);
        }];
    } else {
        //        self.maskView.hidden = YES;
        [self.headerButton setImage:[UIImage imageNamed:@"doctor_button_down_"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.departmentListView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreen_Width, 0);
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.departmentListView]) {
        return 22;
    } else {
        return 26;
    }
}

#pragma  mark UISearchBarDelegete

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    MYSDiseasesSearchDiseaseViewController *searchVC = [[MYSDiseasesSearchDiseaseViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:NO completion:nil];
}

// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Bussiness methods

// 固定代码,每次使用只需要将数据模型替换就好,这个方法是获取首字母,将填充给cell的值按照首字母排序
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort
{
    // 多次调用需清空
    [_sectionHeadsKeys removeAllObjects];
    //创建一个临时的变动数组
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    
    for (MYSDiseaseModel *disease in arrToSort) {
        if(disease.name == nil) {
            disease.name = @"";
        }
        
        if(![disease.name isEqualToString:@""]) {
            // "全部"不加入索引项
            if ([disease.name isEqualToString:@"全部"]) {
                disease.englishName = @"";
            } else {
                //join(链接) the pinYin (letter字母) 链接到首字母
                NSString *pinYinResult = [NSString string];
                //按照数据模型中row的个数循环
                for(int j = 0;j < disease.name.length; j++) {
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([disease.name characterAtIndex:j])] uppercaseString];
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                
                if ([disease.name rangeOfString:@"膀胱"].location != NSNotFound) {
                    pinYinResult = [pinYinResult stringByReplacingOccurrencesOfString:@"BG" withString:@"PG"];
                }
                if ([disease.name rangeOfString:@"Ⅰ"].location != NSNotFound) {
                    pinYinResult = [pinYinResult stringByReplacingOccurrencesOfString:@"`" withString:@"I"];
                }
                
                disease.englishName = pinYinResult;
            }
        } else {
            disease.englishName = @"";
        }
        
        [chineseStringsArray addObject:disease];
    }
    
    //sort(排序) the ChineseStringArr by pinYin(首字母)
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"englishName" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex = NO; //flag to check
    
    NSMutableArray *tempArrForGrouping = nil;
    
    for (MYSDiseaseModel *disease in chineseStringsArray) {
        NSMutableString *strchar = [NSMutableString stringWithString:disease.englishName];
        NSString *sr = @"";
        if (strchar && [strchar length] > 1) {
            sr = [strchar substringToIndex:1];
        }
        // NSString *sr = [strchar substringToIndex:1];
        
        // I'm checking whether the character already in the selection header keys or not  (检查字符是否已经选择头键)
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]]) {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            tempArrForGrouping = [NSMutableArray array];
            checkValueAtIndex = NO;
        }
        
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]]) {
            [tempArrForGrouping addObject:disease];
            if(checkValueAtIndex == NO) {
                [arrayForArrays addObject:tempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
        
    }
    
    return arrayForArrays;
}

#pragma mark - 获取所有疾病列表

// 获取疾病类别
- (void)findDiseaseCategory
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"disclass"];
    [HttpTool post:URLString params:nil success:^(id responseObject) {
        LOG(@"responseObject: %@", responseObject);
        MYSDiseases *disease = [[MYSDiseases alloc] initWithDictionary:responseObject error:nil];
        //        // 加入"全部"，目的在于用户能取消之前的选择
        //        MYSDiseaseModel *all = [[MYSDiseaseModel alloc] init];
        //        all.diseaseId = @"-1";
        //        all.name = @"全部";
        //        all.englishName = @"";
        //        [_disease addObject:all];
        [_disease addObjectsFromArray:disease.diseases];
        
        // 引用getChineseStringArr,并传入参数,最后将值赋给sortedArrForArrays
        _sortedDisease = [self getChineseStringArr:_disease];
        [self.mainTableView reloadData];
        [hud hide:YES];
        
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

#pragma mark 含有疾病的所有科室
- (void)findDepartment
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention/disease-pnid"];
    [HttpTool get:URLString params:[NSDictionary dictionary] success:^(id responseObject) {
        
        
        LOG(@"Success: %@", responseObject);
        MYSExpertGroupDepartment *department = [[MYSExpertGroupDepartment alloc] initWithDictionary:responseObject error:nil];
        self.groupTipArray = [NSMutableArray arrayWithArray:department.departmentArray];
        
        [self.departmentListView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

// 根据科室查找疾病
- (void)findDiseaseCategoryWithDepartment:(NSString *)departmentId
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL stringByAppendingString:@"index.php/user-attention/bypnid"];
    NSDictionary *parameters = @{@"pnid": departmentId};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        [_sortedDisease removeAllObjects];
        [_disease removeAllObjects];
        MYSDiseases *disease = [[MYSDiseases alloc] initWithDictionary:responseObject error:nil];
        //        // 加入"全部"，目的在于用户能取消之前的选择
        //        MYSDiseaseModel *all = [[MYSDiseaseModel alloc] init];
        //        all.diseaseId = @"-1";
        //        all.name = @"全部";
        //        all.englishName = @"";
        //        [_disease addObject:all];
        
        
        [_disease addObjectsFromArray:disease.diseases];
        
        // 引用getChineseStringArr,并传入参数,最后将值赋给sortedArrForArrays
        _sortedDisease = [self getChineseStringArr:_disease];
        [self.mainTableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];

}

@end
