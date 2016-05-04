//
//  TETumourViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETumourViewController.h"
#import "TEDisease.h"
#import "TEDiseaseModel.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "pinyin.h"
#import "TEHttpTools.h"

@interface TETumourViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *tumour; // 原始数据
@property (nonatomic, strong) NSMutableArray *sortedTumour; // 排序后的数据
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys; // 索引键
@end

@implementation TETumourViewController

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        _tumour = [NSMutableArray array];
        _sortedTumour = [NSMutableArray array];
        _sectionHeadsKeys = [NSMutableArray array];
    }
    
    return self;
}

- (void) viewDidLoad
{
    
    [self configUI];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tumour removeAllObjects];
            [_sortedTumour removeAllObjects];
            [_sectionHeadsKeys removeAllObjects];
            [self fetchDiseaseCategory];
        });
    };
    
    [reach startNotifier];
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"肿瘤疾病";
}

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionIndexColor = [UIColor colorWithHex:0x00947d];
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return [self.sortedTumour count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sortedTumour objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeadsKeys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionHeadsKeys;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //sortedArrForArrays存放cell值的动态数组,首先将数组中的值赋给一个静态数组
    if ([self.sortedTumour count] > indexPath.section)
    {
        NSArray *arr = [self.sortedTumour objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            // 之后,将数组的元素取出,赋值给数据模型
            TEDiseaseModel *disease = (TEDiseaseModel *) [arr objectAtIndex:indexPath.row];
            // 给cell赋给相应地值,从数据模型处获得
            cell.textLabel.text = disease.name;
        }
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TETumourDetailViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TETumourDetailViewControllerProtocol)];
    //sortedArrForArrays存放cell值的动态数组,首先将数组中的值赋给一个静态数组
    if ([self.sortedTumour count] > indexPath.section)
    {
        NSArray *arr = [self.sortedTumour objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            // 之后,将数组的元素取出,赋值给数据模型
            TEDiseaseModel *disease = (TEDiseaseModel *) [arr objectAtIndex:indexPath.row];
            // 给cell赋给相应地值,从数据模型处获得
            viewController.name = disease.name;
            viewController.diseaseId = disease.diseaseId;
        }
    }
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - API methods

// 获取疾病类别
- (void)fetchDiseaseCategory
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"disclass"];
    [TEHttpTools post:URLString params:nil success:^(id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        TEDisease *disease = [[TEDisease alloc] initWithDictionary:responseObject error:nil];
        [_tumour addObjectsFromArray:disease.diseases];
        
        // 引用getChineseStringArr,并传入参数,最后将值赋给sortedArrForArrays
        _sortedTumour = [self getChineseStringArr:_tumour];
        [self.tableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject: %@", responseObject);
//        TEDisease *disease = [[TEDisease alloc] initWithDictionary:responseObject error:nil];
//        [_tumour addObjectsFromArray:disease.diseases];
//
//        // 引用getChineseStringArr,并传入参数,最后将值赋给sortedArrForArrays
//        _sortedTumour = [self getChineseStringArr:_tumour];
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [hud hide:YES];
//    }];
}

#pragma mark - Bussiness methods

// 固定代码,每次使用只需要将数据模型替换就好,这个方法是获取首字母,将填充给cell的值按照首字母排序
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort
{
    //创建一个临时的变动数组
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    
    for (TEDiseaseModel *disease in arrToSort) {
        if(disease.name == nil) {
            disease.name = @"";
        }
        
        if(![disease.name isEqualToString:@""]) {
            //join(链接) the pinYin (letter字母) 链接到首字母
            NSString *pinYinResult = [NSString string];
            //按照数据模型中row的个数循环
            for(int j = 0;j < disease.name.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([disease.name characterAtIndex:j])] uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            disease.englishName = pinYinResult;
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
    
    for (TEDiseaseModel *disease in chineseStringsArray) {
        NSMutableString *strchar = [NSMutableString stringWithString:disease.englishName];
        NSString *sr = @"";
        if (strchar && [strchar length] > 1) {
            sr = [strchar substringToIndex:1];
        }
        
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

@end
