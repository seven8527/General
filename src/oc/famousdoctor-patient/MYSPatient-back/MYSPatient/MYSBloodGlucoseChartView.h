//
//  MYSBloodGlucoseChartView.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-25.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUColor.h"

#define chartMargin     10
#define xLabelMargin    15
#define yLabelMargin    15
#define UULabelHeight    10
#define UUYLabelwidth     30
#define UUTagLabelwidth     80


@interface MYSBloodGlucoseChartView : UIView

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine;
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray;

-(void)strokeChart;

@end
