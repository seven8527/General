//
//  MYSDiseasesSearchDiseaseViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseasesSearchDiseaseViewController.h"
#import "UASearchBar.h"
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "MYSSearchDisease.h"


@interface MYSDiseasesSearchDiseaseViewController () <UASearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UASearchBar *searchView;
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *diseaseArray;
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@end

@implementation MYSDiseasesSearchDiseaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 搜索框
    UASearchBar *searchView = [[UASearchBar alloc] initWithFrame:CGRectMake(9, 32, self.view.frame.size.width - 18, 28)];
    [searchView setCancelButtonTitle:@"取消" forState:UIControlStateNormal];
    [searchView setCancelButtonTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    [searchView setShowsCancelButton:YES];
    searchView.delegate = self;
    searchView.backgroundColor = [UIColor clearColor];
    searchView.placeHolder = @"请输入要搜索的疾病";
    [searchView setSearchIcon:@"home_search"];
    searchView.delegate = (id)self;
    self.searchView = searchView;
    [searchView.textField becomeFirstResponder];
    [self.view addSubview:searchView];
    
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchView.frame) + 7, kScreen_Width, kScreen_Height - CGRectGetMaxY(searchView.frame) - 7) style:UITableViewStylePlain];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    self.mainTableView = mainTableView;
    [self.view addSubview:mainTableView];
    
    
    UIImageView *sadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 60) / 2, (kScreen_Height - 160) / 2 -60, 60, 60)];
    sadImageView.image = [UIImage imageNamed:@"search_icon_none_"];
    self.sadImageView = sadImageView;
    sadImageView.hidden = YES;
    [self.view addSubview:sadImageView];
    
    UILabel *sadTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sadImageView.frame) + 10, kScreen_Width, 40)];
    self.sadTextLabel = sadTextLabel;
    sadTextLabel.hidden = YES;
    sadTextLabel.textColor = [UIColor lightGrayColor];
    sadTextLabel.text = @"未搜索到相关信息";
    sadTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sadTextLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (NSMutableArray *)diseaseArray
{
    if (_diseaseArray == nil) {
        _diseaseArray = [NSMutableArray array];
    }
    return _diseaseArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.diseaseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
    cell.textLabel.highlightedTextColor = [UIColor colorFromHexRGB:K00907FColor];
    cell.textLabel.text = [self.diseaseArray[indexPath.row] diseaseName];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController <MYSDiseaseDetailsViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(MYSDiseaseDetailsViewControllerProtocol)];
    viewController.diseaseId = [self.diseaseArray[indexPath.row] diseaseId];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;

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


#pragma mark searchBar delegate
- (void)searchBar:(UASearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        [self.searchView setCancelButtonTitle:@"确定" forState:UIControlStateNormal];
    } else {
        [self.searchView setCancelButtonTitle:@"取消" forState:UIControlStateNormal];
        self.sadTextLabel.hidden = YES;
        self.sadImageView.hidden = YES;
        [self.diseaseArray removeAllObjects];
        [self.mainTableView reloadData];
    }
}


- (void)searchBarSearchButtonClicked:(UASearchBar *)searchBar
{
    if ([self validateSearch:searchBar.text]) {
        [self diseaseSearchWithKey:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UASearchBar *)searchBar
{
    if([self.searchView.cancelButton.titleLabel.text isEqual:@"取消"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if ([self validateSearch:searchBar.text]) {
            [self diseaseSearchWithKey:searchBar.text];
        }
    }
}

#pragma mark  request

- (void)diseaseSearchWithKey:(NSString *)key
{
     [self.searchView setCancelButtonTitle:@"取消" forState:UIControlStateNormal];
    
    [self.diseaseArray removeAllObjects];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"search/new_search"];
    NSDictionary *parameters = @{@"keywords": key, @"type": @"disease", @"start":@"0"};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSSearchDisease *searchDisease = [[MYSSearchDisease alloc] initWithDictionary:responseObject error:nil];
        [self.diseaseArray addObjectsFromArray:searchDisease.diseaseArray];
        if (self.diseaseArray.count == 0) {
            self.sadImageView.hidden = NO;
            self.sadTextLabel.hidden = NO;
        } else {
            self.sadImageView.hidden = YES;
            self.sadTextLabel.hidden = YES;
        }
        [self.mainTableView reloadData];
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
@end
