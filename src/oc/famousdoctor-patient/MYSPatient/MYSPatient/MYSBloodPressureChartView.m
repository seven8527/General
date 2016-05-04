//
//  MYSBloodPressureChartView.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBloodPressureChartView.h"
#import "UUColor.h"
#import "UUChartLabel.h"
#import "UIColor+Hex.h"

@interface MYSBloodPressureChartView ()
@property (nonatomic, strong) NSMutableArray *firstBloodArray;
@property (nonatomic, strong) NSMutableArray *secondBloodArray;
@property (nonatomic, strong) NSArray *highBloodArray;
@property (nonatomic, strong) NSArray *lowBloodArray;
@property (nonatomic, assign) int firstLine;
@property (nonatomic, assign) int secondLine;
@end

@implementation MYSBloodPressureChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

- (NSMutableArray *)firstBloodArray
{
    if (_firstBloodArray == nil) {
        _firstBloodArray = [NSMutableArray array];
    }
    return _firstBloodArray;
}


- (NSMutableArray *)secondBloodArray
{
    if (_secondBloodArray == nil) {
        _secondBloodArray = [NSMutableArray array];
    }
    return _secondBloodArray;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
    self.firstLine = 0;
    
    self.secondLine = 0;
    
    [self.firstBloodArray addObjectsFromArray:yValues[0]];
    [self.secondBloodArray addObjectsFromArray:yValues[1]];
    
    self.highBloodArray  = [self judgeHighWithHighBlood:yValues[0] andLowBlood:yValues[1]];
    self.lowBloodArray = [self judgeLowWithHighBlood:yValues[0] andLowBlood:yValues[1]];
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 200;
    NSInteger min = 0;
    
//    for (NSArray * ary in yLabels) {
//        for (NSString *valueString in ary) {
//            NSInteger value = [valueString integerValue];
//            if (value > max) {
//                max = value;
//            }
//            if (value < min) {
//                min = value;
//            }
//        }
//    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    float level = (_yValueMax-_yValueMin) /4.0;
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /4.0;
    
    for (int i=0; i<5; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
        label.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        label.text = [NSString stringWithFormat:@"%d",(int)(level * i+_yValueMin)];
        [self addSubview:label];
    }
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        [self addSubview:view];
    }
    
    //画横线
    for (int i=0; i<5; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
    
   
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    CGFloat num = 0;
    if (xLabels.count>=20) {
        num=31.0;
    }else if (xLabels.count<=1){
        num=1.0;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = (self.frame.size.width - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = labelText;
        [self addSubview:label];
    }
    
//    //画竖线
//    for (int i=0; i<xLabels.count+1; i++) {
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,UULabelHeight)];
//        [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-2*UULabelHeight)];
//        [path closePath];
//        shapeLayer.path = path.CGPath;
//        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
//        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
//        shapeLayer.lineWidth = 1;
//        [self.layer addSublayer:shapeLayer];
//    }
    
    //画竖线
    for (int i=0; i<xLabels.count+1; i++) {
        if(i == [self.yValues[0]count]) {
            
            UILabel *lastPointTipView = [[UILabel alloc] initWithFrame:CGRectMake(UUYLabelwidth+i*_xLabelWidth - 110, -UULabelHeight * 3, 120, 25)];
            lastPointTipView.backgroundColor = [UIColor yellowColor];
            [self.superview addSubview:lastPointTipView];
            
            NSArray *secondWordsFont = @[@{@"02/04 08:00": [UIFont fontWithName:@"Helvetica Light" size:12]},
                                         @{@" 126/80": [UIFont fontWithName:@"Helvetica Light" size:12]},];
            UIColor *glucoseColor;
            if (i == [[self.highBloodArray lastObject] intValue]) {
                glucoseColor = [UIColor colorFromHexRGB:KEB3C00Color];
            } else if (i == [[self.lowBloodArray lastObject] intValue]) {
                glucoseColor = [UIColor colorFromHexRGB:KEF8004Color];
            } else {
                glucoseColor = [UIColor colorFromHexRGB:K9D76AAColor];
            }
            NSArray *secondWordsColor = @[@{@"02/04 08:00": [UIColor colorFromHexRGB:K747474Color]},
                                          @{@" 126/80": glucoseColor},];
            NSMutableAttributedString *secondValueStr = [[NSMutableAttributedString alloc] init];
            for (int i = 0; i < 2; i ++) {
                NSString *text = [secondWordsFont[i] allKeys][0];
                NSDictionary *attributes = @{NSForegroundColorAttributeName : [secondWordsColor[i] objectForKey:text], NSFontAttributeName : [secondWordsFont[i] objectForKey:text]};
                NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
                [secondValueStr appendAttributedString:subString];
            }
            lastPointTipView.attributedText = secondValueStr;
            
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,UULabelHeight)];
            [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-2*UULabelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }

}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
}
- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}
- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
        
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];
        
        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
                
                //                [progressline stroke];
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [UUGreen CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
//    view.layer.borderWidth = 2;

//    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUGreen.CGColor;
//    
//    if (isHollow) {
    LOG(@"%f",value);
//        if (index == 0) {
//            if (point.y <= 62) {
//                view.backgroundColor = [UIColor redColor];
//            } else if (point.y >= 110) {
//                view.backgroundColor = [UIColor orangeColor];
//            }else {
//                view.backgroundColor = [UIColor greenColor];
//            }
//        } else {
//            if (point.y <= 111) {
//                view.backgroundColor = [UIColor redColor];
//            } else if (point.y >= 140) {
//                view.backgroundColor = [UIColor orangeColor];
//            } else {
//                view.backgroundColor = [UIColor greenColor];
//            }
//        }
    

    view.backgroundColor = [UIColor greenColor];
    if (index == 0) {
        view.backgroundColor = [UIColor greenColor];
        for (NSString *integer in self.highBloodArray) {
            if ([integer intValue] == self.firstLine) {
                view.backgroundColor = [UIColor redColor];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
                label.font = [UIFont systemFontOfSize:10];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = view.backgroundColor;
                label.text = [NSString stringWithFormat:@"%d",(int)value];
                [self addSubview:label];

            }
        }
        
        for (NSString *integer in self.lowBloodArray) {
            if ([integer intValue] == self.firstLine) {
                view.backgroundColor = [UIColor orangeColor];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
                label.font = [UIFont systemFontOfSize:10];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = view.backgroundColor;
                label.text = [NSString stringWithFormat:@"%d",(int)value];
                [self addSubview:label];

            }
        }

        self.firstLine ++;
    } else {
        view.backgroundColor = [UIColor greenColor];
        
        for (NSString *integer in self.highBloodArray) {
            if ([integer intValue] == self.secondLine) {
                view.backgroundColor = [UIColor redColor];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
                label.font = [UIFont systemFontOfSize:10];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = view.backgroundColor;
                label.text = [NSString stringWithFormat:@"%d",(int)value];
                [self addSubview:label];

            }
        }
        
        for (NSString *integer in self.lowBloodArray) {
            if ([integer intValue] == self.secondLine) {
                view.backgroundColor = [UIColor orangeColor];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
                label.font = [UIFont systemFontOfSize:10];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = view.backgroundColor;
                label.text = [NSString stringWithFormat:@"%d",(int)value];
                [self addSubview:label];

            }
        }
        self.secondLine ++;
    }
    
    [self addSubview:view];
}

// 高压数组
- (NSArray *)judgeHighWithHighBlood:(NSArray *)highBlood andLowBlood:(NSArray *)lowBlood
{
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (int i = 0; i < highBlood.count; i++) {
        if ([highBlood[i] integerValue] >=140 && [lowBlood[i] integerValue] >= 90) {
//            [indexArray addObject:[NSString stringWithFormat:@"%d",i]];
            [indexArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return indexArray;
}

// 低压数组
- (NSArray *)judgeLowWithHighBlood:(NSArray *)highBlood andLowBlood:(NSArray *)lowBlood
{
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (int i = 0; i < highBlood.count; i++) {
        if ([highBlood[i] integerValue] <=90 && [lowBlood[i] integerValue] <= 60) {
            [indexArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return indexArray;
}


@end
