//
//  MYSBloodGlucoseChart.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-25.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUColor.h"
#import "MYSBloodGlucoseChartView.h"
#import "UUBarChart.h"
//类型
typedef enum {
    UUChartLineStyle,
    UUChartBarStyle
} UUChartStyle;

@class MYSBloodGlucoseChart;
@protocol UUChartDataSource <NSObject>

@required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(MYSBloodGlucoseChart *)chart;

//数值多重数组
- (NSArray *)UUChart_yValueArray:(MYSBloodGlucoseChart *)chart;

@optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(MYSBloodGlucoseChart *)chart;

//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(MYSBloodGlucoseChart *)chart;

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(MYSBloodGlucoseChart *)chart;

//判断显示横线条
- (BOOL)UUChart:(MYSBloodGlucoseChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

//判断显示最大最小值
- (BOOL)UUChart:(MYSBloodGlucoseChart *)chart ShowMaxMinAtIndex:(NSInteger)index;
@end

@interface MYSBloodGlucoseChart : UIView
//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;
@end
