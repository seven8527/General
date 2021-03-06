//
//  TESeekAreaViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESeekAreaViewController.h"
#import "TEArea.h"
#import "TEAreaModel.h"
#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "pinyin.h"
#import "TEHttpTools.h"

@interface TESeekAreaViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *area; // 原始数据
@property (nonatomic, strong) NSMutableArray *sortedArea; // 排序后的数据
@property (nonatomic, strong) NSMutableArray *sectionHeadsKeys; // 索引键
@end

@implementation TESeekAreaViewController

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        _area = [NSMutableArray array];
        _sortedArea = [NSMutableArray array];
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
            [_area removeAllObjects];
            [_sortedArea removeAllObjects];
            [_sectionHeadsKeys removeAllObjects];
            [self fetchArea];
        });
    };
    
    [reach startNotifier];
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    self.title = @"地区";
}

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    //    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 88, kScreen_Width, self.view.bounds.size.height - 108) style:UITableViewStylePlain];
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
    return [self.sortedArea count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sortedArea objectAtIndex:section] count];
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
    if ([self.sortedArea count] > indexPath.section)
    {
        NSArray *arr = [self.sortedArea objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            // 之后,将数组的元素取出,赋值给数据模型
            TEAreaModel *area = (TEAreaModel *) [arr objectAtIndex:indexPath.row];
            // 给cell赋给相应地值,从数据模型处获得
            cell.textLabel.text = area.provinceName;
        }
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TEAreaModel *area = self.sortedArea[indexPath.section][indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectedAreaId:areaName:)]) {
        [self.delegate didSelectedAreaId:area.provinceId areaName:area.provinceName];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API methods

// 获取地区列表
- (void)fetchArea
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"wap_city"];
    [TEHttpTools post:URLString params:nil success:^(id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        TEArea *diqu = [[TEArea alloc] initWithDictionary:responseObject error:nil];
        // 加入"全部"，目的在于用户能取消之前的选择
        TEAreaModel *all = [[TEAreaModel alloc] init];
        all.hid = @"";
        all.province = @"";
        all.city = @"";
        all.provinceId = @"-1";
        all.provinceName = @"全部";
        all.englishName = @"";
        [_area addObject:all];
        [_area addObjectsFromArray:diqu.areas];
        
        // 引用getChineseStringArr,并传入参数,最后将值赋给sortedArrForArrays
        _sortedArea = [self getChineseStringArr:_area];
        
        
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
//        TEArea *diqu = [[TEArea alloc] initWithDictionary:responseObject error:nil];
//        // 加入"全部"，目的在于用户能取消之前的选择
//        TEAreaModel *all = [[TEAreaModel alloc] init];
//        all.hid = @"";
//        all.province = @"";
//        all.city = @"";
//        all.provinceId = @"-1";
//        all.provinceName = @"全部";
//        all.englishName = @"";
//        [_area addObject:all];
//        [_area addObjectsFromArray:diqu.areas];
//        
//        // 引用getChineseStringArr,并传入参数,最后将值赋给sortedArrForArrays
//        _sortedArea = [self getChineseStringArr:_area];
//        
//        
//        [self.tableView reloadData];
//
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
    
    for (TEAreaModel *area in arrToSort) {
        if(area.provinceName == nil) {
            area.provinceName = @"";
        }
        
        
        if(![area.provinceName isEqualToString:@""]) {
            // "全部"不加入索引项
            if ([area.provinceName isEqualToString:@"全部"]) {
                area.englishName = @"";
            } else {
                //join(链接) the pinYin (letter字母) 链接到首字母
                NSString *pinYinResult = [NSString string];
                //按照数据模型中row的个数循环
                for(int j = 0;j < area.provinceName.length; j++) {
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([area.provinceName characterAtIndex:j])] uppercaseString];
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                area.englishName = pinYinResult;
            }
            
        } else {
            area.englishName = @"";
        }
        
        [chineseStringsArray addObject:area];
    }
    
    //sort(排序) the ChineseStringArr by pinYin(首字母)
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"englishName" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex = NO; //flag to check
    
    NSMutableArray *tempArrForGrouping = nil;
    
    for (TEAreaModel *area in chineseStringsArray) {
        NSMutableString *strchar = [NSMutableString stringWithString:area.englishName];
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
            [tempArrForGrouping addObject:area];
            if(checkValueAtIndex == NO) {
                [arrayForArrays addObject:tempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
        
    }
    
    return arrayForArrays;
}

@end
