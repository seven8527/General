//
//  TEHomeSearchViewController.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-15.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeSearchViewController.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"

@interface TEHomeSearchViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation TEHomeSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
        // Custom initialization
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreen_Width - 67.0f, 44.0f)];
        searchBar.delegate = self;
        searchBar.placeholder = @"找医生，疾病，科室，医院";
        [searchBar becomeFirstResponder];
        searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchBar.backgroundImage = [[UIImage alloc] init];
        self.searchBar = searchBar;
        
        self.navigationItem.titleView =searchBar;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick:)];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 91)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.3;
    [footerView addSubview:lineView];
    
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(10, 2, 300, 34);
    [deleteButton setTitleColor:[UIColor colorWithHex:0x9e9e9e] forState:UIControlStateNormal];
    [deleteButton setTitle:@"清除记录" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteButton setBackgroundColor:[UIColor whiteColor]];
    [deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deleteButton];
    self.tableView.tableFooterView = footerView;
    
    
    [self readSearchHistory];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDlegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.keyword = self.titleArray[indexPath.row];
    
    [self searchWithText:self.keyword];
    
    [self cancel];
    
}

/**
 *  搜索文本内容
 *
 *  @param text 文本
 */
- (void)searchWithText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(homeSearchViewController:searchWithText:)]) {
        [self.delegate homeSearchViewController:self searchWithText:text];
    }
    
}

/**
 *  返回
 */
- (void)cancel{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

/**
 *  搜索框代理
 *
 *  @param searchBar  搜索框
 *  @param searchText 搜索框内容
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        self.navigationItem.rightBarButtonItem.title = @"搜索";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"取消";
    }
}

/**
 *  rightBarButton 点击
 *
 *  @param barButton 右导航键
 */
- (void)rightButtonClick:(UIBarButtonItem *)barButton
{
    if (self.searchBar.text.length > 0) {
        self.keyword = self.searchBar.text;
        
        [self searchWithText:self.keyword];
        
        [self saveSearchHistory:self.keyword];
        
        [self cancel];
        
    } else {
        [self cancel];
    }
}


/**
 *  点击键盘搜索
 *
 *  @param searchBar 搜索框
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    self.keyword = self.searchBar.text;
    
    [self searchWithText:self.keyword];
    
    [self saveSearchHistory:self.keyword];
    
    [self cancel];
}


/**
 *  存储
 *
 *  @param text 新添内容
 */
- (void)saveSearchHistory:(NSString *)text
{
    //    [self.titleArray addObject:text];
    
    NSMutableArray *saveArray = [NSMutableArray arrayWithArray:self.titleArray];
    if (self.titleArray.count == 0) {
        [saveArray addObject:text];
        
        [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"history"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        BOOL isEqual = NO;
        for (NSString *title in self.titleArray) {
            if (![title isEqualToString:text]) {
                continue;
            } else {
                isEqual = YES;
                break;
            }
        }
        
        if (isEqual == NO) {
            [saveArray addObject:text];
            [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"history"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}


/**
 *  读取存储内容
 */
- (void)readSearchHistory
{
    self.titleArray =  [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    
    if ([self.titleArray count] == 0) {
        self.titleForEmpty = @"当前没有搜索记录";
        self.tableView.tableFooterView = nil;
        [TEUITools hiddenTableExtraCellLine:self.tableView];
    }
    
}


/**
 *  清除存储
 */
- (void)delete
{
    NSMutableArray *savArray = [NSMutableArray arrayWithArray:self.titleArray];
    
    [savArray removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"history"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.titleArray = savArray;
    if ([self.titleArray count] == 0) {
        self.titleForEmpty = @"当前没有搜索记录";
        self.tableView.tableFooterView = nil;
        [TEUITools hiddenTableExtraCellLine:self.tableView];
    }
    
    [self.tableView reloadData];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


@end
