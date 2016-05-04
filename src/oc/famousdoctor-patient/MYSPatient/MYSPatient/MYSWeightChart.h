//
//  MYSWeightChart.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUColor.h"
#import "MYSWeightChartView.h"
#import "UUBarChart.h"

//类型
typedef enum {
    UUChartLineStyle,
    UUChartBarStyle
} UUChartStyle;

@class MYSWeightChart;
@protocol UUChartDataSource <NSObject>

@required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(MYSWeightChart *)chart;

//数值多重数组
- (NSArray *)UUChart_yValueArray:(MYSWeightChart *)chart;

@optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(MYSWeightChart *)chart;

//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(MYSWeightChart *)chart;

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(MYSWeightChart *)chart;

//判断显示横线条
- (BOOL)UUChart:(MYSWeightChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

//判断显示最大最小值
- (BOOL)UUChart:(MYSWeightChart *)chart ShowMaxMinAtIndex:(NSInteger)index;
@end


@interface MYSWeightChart : UIView
//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;

@property (strong, nonatomic) MYSWeightChartView * lineChart;

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;

@end
