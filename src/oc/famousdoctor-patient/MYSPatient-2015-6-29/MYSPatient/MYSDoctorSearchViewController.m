//
//  MYSDoctorSearchViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDoctorSearchViewController.h"
#import "MYSDirectorGroupCell.h"
#import "MYSSearchDoctorModel.h"
#import "UIColor+Hex.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "MYSSearchDoctor.h"

@interface MYSDoctorSearchViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UIImageView *sadImageView;
@property (nonatomic, weak) UILabel *sadTextLabel;
@property (nonatomic, assign) int currentDoctorPage;
@end

@implementation MYSDoctorSearchViewController

//- (NSMutableArray *)doctorArray
//{
//    if (_doctorArray == nil) {
//        _doctorArray = [NSMutableArray array];
//    }
//    return _doctorArray;
//}



- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        
        self.view.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        UIImageView *sadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 60) / 2, (kScreen_Height - 160) / 2 -60, 60, 60)];
        sadImageView.image = [UIImage imageNamed:@"search_icon_none_"];
        self.sadImageView = sadImageView;
        self.sadImageView.hidden = YES;
        [self.view addSubview:sadImageView];
        
        
        UILabel *sadTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sadImageView.frame) + 10, kScreen_Width, 40)];
        self.sadTextLabel = sadTextLabel;
        sadTextLabel.textColor = [UIColor lightGrayColor];
        sadTextLabel.text = @"未搜索到相关信息";
        sadTextLabel.textAlignment = NSTextAlignmentCenter;
        sadTextLabel.hidden = YES;
        [self.view addSubview:sadTextLabel];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __unsafe_unretained typeof(self) vc = self;
    
    [vc.tableView addFooterWithCallback:^{
        if (vc.doctorArray.count < [vc.doctorTotal intValue]) {
            [vc doctorSearch];
            [vc.tableView footerEndRefreshing];
        } else {
            vc.tableView.footerRefreshingText = @"已加载全部数据";
            [vc.tableView footerEndRefreshing];
        }
    }];

}

-(void)setDoctorArray:(NSMutableArray *)doctorArray
{
    _doctorArray = doctorArray;
    if (doctorArray.count == 0) {
        self.sadImageView.hidden = NO;
        self.sadTextLabel.hidden = NO;
    } else {
        self.sadImageView.hidden = YES;
        self.sadTextLabel.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark tabelView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.doctorArray count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    
//    cell.textLabel.text = @"A额外确认日期为FA";
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *expertGroupConcerne = @"expertGroupConcerne";
    MYSDirectorGroupCell *expertGroupConcerneCell = [tableView dequeueReusableCellWithIdentifier:expertGroupConcerne];
    if (expertGroupConcerneCell == nil) {
        expertGroupConcerneCell = [[MYSDirectorGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:expertGroupConcerne];
    }
    expertGroupConcerneCell.concerneLabel.hidden = YES;
    expertGroupConcerneCell.concerneButton.hidden = YES;
    expertGroupConcerneCell.doctorModel = (MYSSearchDoctorModel *)self.doctorArray[indexPath.row];
    
    return expertGroupConcerneCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(doctorSerachViewDidSelectDoctor:)]) {
        [self.delegate doctorSerachViewDidSelectDoctor:(MYSSearchDoctorModel *)self.doctorArray[indexPath.row]];
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

- (void)doctorSearch
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"search/new_search"];
    NSDictionary *parameters = @{@"keywords": self.searchText, @"type": @"doctor", @"start":[NSString stringWithFormat:@"%lu",(unsigned long)self.doctorArray.count]};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSSearchDoctor *searchDoctor = [[MYSSearchDoctor alloc] initWithDictionary:responseObject error:nil];
        [self.doctorArray addObjectsFromArray:searchDoctor.doctorArray];
        [self.tableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}

@end
