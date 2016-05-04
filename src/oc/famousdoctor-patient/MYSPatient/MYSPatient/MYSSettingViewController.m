//
//  MYSSettingViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSettingViewController.h"
#import "MYSSettingCell.h"
#import "MYSStoreManager.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"
#import "AppDelegate.h"

@interface MYSSettingViewController ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIButton *logoutButton;
@end

@implementation MYSSettingViewController

- (void)loadDataSource
{
    self.dataSource = [[MYSStoreManager sharedStoreManager] getSettingConfigureAray];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"设置";
    
    // 设置tableview
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    [self layoutUI];

    
    [self loadDataSource];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:KEB3C00Color] withButton:self.logoutButton];
    [self.logoutButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
    
    UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:KEB3C00Color] withButton:self.logoutButton];
    [self.logoutButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
}

- (void)layoutUI
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 127)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *logoutButton = [UIButton newAutoLayoutView];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:[UIColor colorFromHexRGB:KEB3C00Color]];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:18];
    logoutButton.layer.cornerRadius = 5.0;
    [logoutButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(clickLogoutButton) forControlEvents:UIControlEventTouchUpInside];
    self.logoutButton = logoutButton;
    [footerView addSubview:logoutButton];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        self.didSetupConstraints = YES;
        
        // 反馈内容提示
        [self.logoutButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.logoutButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.logoutButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25];
        [self.logoutButton autoSetDimension:ALDimensionHeight toSize:44];
        
    }
    [super updateViewConstraints];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"setting";
    MYSSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MYSSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    }
    NSDictionary *tempDict = self.dataSource[indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:[tempDict objectForKey:@"icon"]];
    cell.textLabel.text = [tempDict objectForKey:@"title"];
    [cell setisOpen:[tempDict objectForKey:@"isOpen"] withIndex:indexPath.row];
//    cell.separatorInset = UIEdgeInsetsMake(0, 51, 0, 10);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLogoutButton
{
    ApplicationDelegate.userId = nil;
    ApplicationDelegate.isLogin = NO;
    ApplicationDelegate.cookie = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(clickLogoutButton)]) {
        [self.delegate clickLogoutButton];
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
        
        if (tableView == self.tableView) {
            
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
                
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 23, bounds.size.height-lineHeight, bounds.size.width - 38, lineHeight);
                
                lineLayer.backgroundColor = [UIColor colorFromHexRGB:KD1D1D1Color].CGColor;
                
                [layer addSublayer:lineLayer];
                
            }
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            
            [testView.layer insertSublayer:layer atIndex:0];
            
            testView.backgroundColor = UIColor.clearColor;
            
            cell.backgroundView = testView;
            
        }
        
    }
    
}


@end
