//
//  MYSHealthRecordsBloodGlucoseChartViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-25.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsBloodGlucoseChartViewController.h"
#import "MYSBloodGlucoseChart.h"
#import "MYSBloodGlucoseChartView.h"
#import "UIColor+Hex.h"
#import "MYSHealthRecordsBloodGlucoseChooseTimeStateView.h"
#import "MYSHealthRecordsExchangeButton.h"

@interface MYSHealthRecordsBloodGlucoseChartViewController () <UUChartDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) MYSBloodGlucoseChart *sevenChartView;
@property (nonatomic, strong) MYSBloodGlucoseChart *monthChartView;
@property (nonatomic, weak) UIScrollView *mainScrollView;
@end

@implementation MYSHealthRecordsBloodGlucoseChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    mainScrollView.contentSize = CGSizeMake(kScreen_Width * 2, kScreen_Height);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    self.mainScrollView = mainScrollView;
    [self.view addSubview:mainScrollView];
    
    
    // 周状态
    MYSHealthRecordsBloodGlucoseChooseTimeStateView *sevenTimeState = [MYSHealthRecordsBloodGlucoseChooseTimeStateView healthRecordsBloodGlucoseChooseTimeStateViewStateWithImage:@"" andTitleArray:[NSArray arrayWithObjects:@"空腹",@"餐后1h",@"餐后2h", nil] andFrame:CGRectMake(0, 10, kScreen_Width, 60)];
    [mainScrollView addSubview:sevenTimeState];
    
    // 星期表
    MYSBloodGlucoseChart *sevenChartView = [[MYSBloodGlucoseChart alloc] initwithUUChartDataFrame:CGRectMake(10, 80, [UIScreen mainScreen].bounds.size.width-20, 200) withSource:self withStyle:UUChartLineStyle];
    self.sevenChartView = sevenChartView;
    [sevenChartView showInView:mainScrollView];
    
    UIView *sevenView = [self bottomViewWithTimeArray:[NSArray arrayWithObjects:@"01/06\n08:10",@"01/06\n08:10",@"01/06\n08:10",@"01/06\n08:10",@"01/06\n08:10",@"01/06\n08:10",@"01/06\n08:10", nil] andX:40];
    [mainScrollView addSubview:sevenView];
    
    // 月状态
    MYSHealthRecordsBloodGlucoseChooseTimeStateView *monthTimeState = [MYSHealthRecordsBloodGlucoseChooseTimeStateView healthRecordsBloodGlucoseChooseTimeStateViewStateWithImage:@"" andTitleArray:[NSArray arrayWithObjects:@"空腹",@"餐后1h",@"餐后2h", nil] andFrame:CGRectMake(kScreen_Width, 10, kScreen_Width, 60)];
    [mainScrollView addSubview:monthTimeState];
    
    
    // 月表
    MYSBloodGlucoseChart *monthChartView = [[MYSBloodGlucoseChart alloc] initwithUUChartDataFrame:CGRectMake(kScreen_Width + 10, 80, [UIScreen mainScreen].bounds.size.width-20, 200) withSource:self withStyle:UUChartLineStyle];
    self.monthChartView = monthChartView;
    [monthChartView showInView:mainScrollView];
    
    UIView *monthView = [self bottomViewWithTimeArray:[NSArray arrayWithObjects:@"01/06\n08:10",@"ad\nfs",@"fgghh",@"fgghh",@"afds", nil] andX:kScreen_Width + 40];
    [mainScrollView addSubview:monthView];
    
    
    MYSHealthRecordsExchangeButton *sevenLeftButton = [[MYSHealthRecordsExchangeButton alloc] initWithFrame:CGRectMake((kScreen_Width- 100)/3, CGRectGetMaxY(sevenView.frame), 50, 50)];
    [sevenLeftButton setTitle:@"近7次" forState:UIControlStateNormal];
    [sevenLeftButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    sevenLeftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    sevenLeftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sevenLeftButton setImage:[UIImage imageNamed:@"record_low_"] forState:UIControlStateNormal];
    [mainScrollView addSubview:sevenLeftButton];
    
    MYSHealthRecordsExchangeButton *sevenRightButton = [[MYSHealthRecordsExchangeButton alloc] initWithFrame:CGRectMake((kScreen_Width- 100)/3 * 2 + 50, CGRectGetMaxY(sevenView.frame), 50, 50)];
    [sevenRightButton addTarget:self action:@selector(exchangeToRightView) forControlEvents:UIControlEventTouchUpInside];
    [sevenRightButton setTitle:@"近30次" forState:UIControlStateNormal];
    [sevenRightButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
    sevenRightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    sevenRightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sevenRightButton setImage:[UIImage imageNamed:@"record_low_"] forState:UIControlStateNormal];
    [mainScrollView addSubview:sevenRightButton];
    
    MYSHealthRecordsExchangeButton *monthLeftButton = [[MYSHealthRecordsExchangeButton alloc] initWithFrame:CGRectMake((kScreen_Width- 100)/3 + kScreen_Width, CGRectGetMaxY(sevenView.frame), 50, 50)];
    [monthLeftButton addTarget:self action:@selector(exchangeToLeftView) forControlEvents:UIControlEventTouchUpInside];
    [monthLeftButton setTitle:@"近7次" forState:UIControlStateNormal];
    [monthLeftButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
    monthLeftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    monthLeftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [monthLeftButton setImage:[UIImage imageNamed:@"record_low_"] forState:UIControlStateNormal];
    [mainScrollView addSubview:monthLeftButton];
    
    MYSHealthRecordsExchangeButton *monthRightButton = [[MYSHealthRecordsExchangeButton alloc] initWithFrame:CGRectMake((kScreen_Width- 100)/3 * 2 + 50 + kScreen_Width, CGRectGetMaxY(sevenView.frame), 50, 50)];
    [monthRightButton setTitle:@"近30次" forState:UIControlStateNormal];
    [monthRightButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
    monthRightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    monthRightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [monthRightButton setImage:[UIImage imageNamed:@"record_low_"] forState:UIControlStateNormal];
    
    [mainScrollView addSubview:monthRightButton];
    
}
// 生成底部控件
- (UIView *)bottomViewWithTimeArray:(NSArray *)timeArray andX:(CGFloat)x
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(self.sevenChartView.frame), kScreen_Width - 20, 100)];
    
    for (int i = 0; i < timeArray.count; i ++) {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake((bottomView.frame.size.width - 40 * 7)/8 * i + 40 * i, 0, 50, 50)];
        textView.text = timeArray[i];
        textView.userInteractionEnabled = NO;
        textView.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        textView.font = [UIFont fontWithName:@"Helvetica Light" size:10];
        [bottomView addSubview:textView];
    }
    
    UITextField *highBloodField = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, kScreen_Width/6, 12)];
    highBloodField.font = [UIFont systemFontOfSize:12];
    highBloodField.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    UIView *highLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    highLeftView.backgroundColor = [UIColor redColor];
    highBloodField.leftViewMode = UITextFieldViewModeAlways;
    highBloodField.leftView = highLeftView;
    highBloodField.textAlignment = NSTextAlignmentRight;
    highBloodField.text =  @"血糖高";
    [bottomView addSubview:highBloodField];
    
    
    UITextField *lowBloodField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(highBloodField.frame) + 40, 60, kScreen_Width/6, 12)];
    lowBloodField.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    lowBloodField.font = [UIFont systemFontOfSize:12];
    UIView *lowLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    lowLeftView.backgroundColor = [UIColor orangeColor];
    lowBloodField.leftViewMode = UITextFieldViewModeAlways;
    lowBloodField.leftView = lowLeftView;
    lowBloodField.textAlignment = NSTextAlignmentRight;
    lowBloodField.text =  @"血糖低";
    [bottomView addSubview:lowBloodField];
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lowBloodField.frame) + 20, 60, kScreen_Width/3, 13)];
    unitLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.text = @"单位：mmol/L";

    unitLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:unitLabel];
    
    return bottomView;
}


// 右滚
- (void)exchangeToRightView
{
    [self.mainScrollView scrollRectToVisible:CGRectMake(kScreen_Width, 0, kScreen_Width, kScreen_Height) animated:YES];
}

// 左滚
- (void)exchangeToLeftView
{
    [self.mainScrollView scrollRectToVisible:CGRectMake(0, 0, kScreen_Width, kScreen_Height) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@""];
        [xTitles addObject:str];
    }
    return xTitles;
}


#pragma mark - @required


//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(MYSBloodGlucoseChart *)chart
{
    if([chart isEqual:self.sevenChartView]) {
        return [self getXTitles:7];
    } else {
        return [self getXTitles:31];
    }
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(MYSBloodGlucoseChart *)chart
{
    NSArray *ary1 = @[@"1.4",@"8",@"5.2",@"3.9",@"4.3",@"2.5",@"3.3"];

    NSArray *ary3 = @[@"1.3",@"2.2",@"8.2",@"5.5",@"5.2",@"1.0",@"4.6",@"3.6",@"1.1",@"4.0",@"2.5",@"4.5",@"5.2",@"5.0",@"4.0",@"3.6",@"1.2"];
    
    if ([chart isEqual:self.sevenChartView]) {
        return @[ary1];
    } else {
        return @[ary3];
    }
    
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(MYSBloodGlucoseChart *)chart
{
    return @[[UIColor colorFromHexRGB:K9D76AAColor],UUGreen,UUGreen];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(MYSBloodGlucoseChart *)chart
{
        return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(MYSBloodGlucoseChart *)chart
{
    return CGRangeZero;
    
}

//判断显示横线条
- (BOOL)UUChart:(MYSBloodGlucoseChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(MYSBloodGlucoseChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return YES;
}

@end
