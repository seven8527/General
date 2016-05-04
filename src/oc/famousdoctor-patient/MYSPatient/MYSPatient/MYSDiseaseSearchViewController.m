//
//  MYSDiseaseSearchViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseaseSearchViewController.h"
#import "MYSSearchDiseaseModel.h"
#import "UIColor+Hex.h"
#import "MJRefresh.h"
#import "MYSSearchDisease.h"
#import "HttpTool.h"

@interface MYSDiseaseSearchViewController ()
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@end

@implementation MYSDiseaseSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        
        self.view.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
    
    return self;
}

- (void)setDiseaseArray:(NSMutableArray *)diseaseArray
{
    _diseaseArray = diseaseArray;
    
    if (diseaseArray.count == 0) {
        self.sadImageView.hidden = NO;
        self.sadTextLabel.hidden = NO;
    } else {
        self.sadImageView.hidden = YES;
        self.sadTextLabel.hidden = YES;
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.tableView addFooterWithCallback:^{
        if (vc.diseaseArray.count < [vc.diseaseTotal intValue]) {
            [vc diseaseSearch];
            [vc.tableView footerEndRefreshing];
        } else {
            vc.tableView.footerRefreshingText = @"已加载全部数据";
            [vc.tableView footerEndRefreshing];
        }
    }];
    
}

#pragma mark tabelView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.diseaseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [self.diseaseArray[indexPath.row] diseaseName];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(diseaseSerachViewDidSelectDiseaseId:)]) {
        [self.delegate diseaseSerachViewDidSelectDiseaseId:[self.diseaseArray[indexPath.row] diseaseId]];
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


#pragma mark  request

- (void)diseaseSearch
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"search/new_search"];
    NSDictionary *parameters = @{@"keywords": self.searchText, @"type": @"disease", @"start":[NSString stringWithFormat:@"%lu",(unsigned long)self.diseaseArray.count]};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSSearchDisease *searchDisease = [[MYSSearchDisease alloc] initWithDictionary:responseObject error:nil];
        [self.diseaseArray addObjectsFromArray:searchDisease.diseaseArray];
        [self.tableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}
@end
