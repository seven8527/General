//
//  MYSHealthRecordsCollectionViewCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//




#import "MYSHealthRecordsCollectionViewCell.h"
#import "UIColor+Hex.h"

#define  TypeBloodPressureColor [UIColor colorFromHexRGB:K69AE42Color]
#define  TypeBloodGlucoseColor  [UIColor colorFromHexRGB:K9D76AAColor]
#define  TypeWeightColor    [UIColor colorFromHexRGB:K398CCCColor]

@interface MYSHealthRecordsCollectionViewCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *typeImageView; // 类型图片
@property (nonatomic, weak) UILabel *typeLabel; // 类型名称
@property (nonatomic, weak) UILabel *centerLabel; // 中间暂无数据及体重控件
@property (nonatomic, weak) UILabel *firstValueLabel; // 血压 血糖值
@property (nonatomic, weak) UILabel *firstTipLabel; // 血压 血糖提示
@property (nonatomic, weak) UILabel *secondValueLabel; // 心率  状态值
@property (nonatomic, weak) UILabel *secondTipLabel; // 心率  状态 提示
@property (nonatomic, weak) UILabel *stateLabel; // 正常
@property (nonatomic, weak) UIImageView *timeImageView; // 时间图标
@property (nonatomic, weak) UILabel *timeLabel; // 时间
@end

@implementation MYSHealthRecordsCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        self.backgroundColor = [UIColor yellowColor];
        
        UIImageView *backView = [[UIImageView alloc] initWithFrame:self.bounds];
        backView.image = [[UIImage imageNamed:@"record_bg_"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 10, 1, 10) resizingMode:UIImageResizingModeStretch];
        [self addSubview:backView];
        self.didSetupConstraints = NO;
        
        UIImageView *typeImageView = [UIImageView newAutoLayoutView];
        [self addSubview:typeImageView];
        self.typeImageView = typeImageView;
        
        UILabel *typeLabel = [UILabel newAutoLayoutView];
        typeLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        typeLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:typeLabel];
        self.typeLabel = typeLabel;
        
        
        UILabel *centerLabel = [UILabel newAutoLayoutView];
        centerLabel.hidden = YES;
        centerLabel.text = @"暂无数据";
        centerLabel.textAlignment = NSTextAlignmentCenter;
        centerLabel.textColor = [UIColor redColor];
        centerLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:centerLabel];
        self.centerLabel = centerLabel;
        
        UILabel *firstValueLabel = [UILabel newAutoLayoutView];
        [self addSubview:firstValueLabel];
        self.firstValueLabel = firstValueLabel;
        
        
        UILabel *firstTipLabel = [UILabel newAutoLayoutView];
        firstTipLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        firstTipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:firstTipLabel];
        self.firstTipLabel = firstTipLabel;
        
        UILabel *secondValueLabel = [UILabel newAutoLayoutView];
        [self addSubview:secondValueLabel];
        self.secondValueLabel = secondValueLabel;
        
        UILabel *secondTipLabel = [UILabel newAutoLayoutView];
        secondTipLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        secondTipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:secondTipLabel];
        self.secondTipLabel = secondTipLabel;
        
        UILabel *stateLabel = [UILabel newAutoLayoutView];
        [self addSubview:stateLabel];
        self.stateLabel = stateLabel;
        
        UIImageView *timeImageView = [UIImageView newAutoLayoutView];
        timeImageView.image = [UIImage imageNamed:@"doctor_icon_time_"];
        [self addSubview:timeImageView];
        self.timeImageView = timeImageView;
        
        
        UILabel *timeLabel = [UILabel newAutoLayoutView];
        timeLabel.text = @"12/11 16:30";
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        
    }
    
    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.typeImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.typeImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        [self.typeImageView autoSetDimensionsToSize:CGSizeMake(28, 28)];
        
        [self.typeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.typeImageView withOffset:10];
        [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [self.typeLabel autoSetDimensionsToSize:CGSizeMake(100, 28)];
        
        [self.firstValueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.firstValueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeImageView withOffset:17];
        [self.firstValueLabel autoSetDimensionsToSize:CGSizeMake(self.frame.size.width / 2, 23)];
        
        
        [self.firstTipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.firstTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.firstValueLabel withOffset:10];
        [self.firstTipLabel autoSetDimensionsToSize:CGSizeMake(self.frame.size.width / 2, 15)];
        
        [self.secondValueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.secondValueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeImageView withOffset:17];
        [self.secondValueLabel autoSetDimensionsToSize:CGSizeMake(self.frame.size.width / 2, 23)];
        
        
        [self.secondTipLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.secondTipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.firstValueLabel withOffset:10];
        [self.secondTipLabel autoSetDimensionsToSize:CGSizeMake(self.frame.size.width / 2, 15)];
        
        
        [self.stateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.stateLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
        [self.stateLabel autoSetDimensionsToSize:CGSizeMake(60, 20)];
        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
        [self.timeLabel autoSetDimensionsToSize:CGSizeMake(80, 20)];
        
        [self.timeImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
        [self.timeImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:-5];
        [self.timeImageView autoSetDimensionsToSize:CGSizeMake(10, 10)];
        
        
        [self.centerLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:70];
        [self.centerLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.centerLabel autoSetDimensionsToSize:CGSizeMake(kScreen_Width-20, 20)];
        
        self.didSetupConstraints = YES;
    }
}

- (void)setHealthRecordType:(NSInteger)healthRecordType
{
    _healthRecordType = healthRecordType;
}

- (void)setModel:(id)model
{
    _model = model;
    if(self.healthRecordType == 0) {
        
        self.typeImageView.image = [UIImage imageNamed:@"record_icon1_"];
        
        self.typeLabel.text = @"血压";
        
        
        // 定义血压 血糖 体重值的文字属性
        UIColor *firstFrontTextColor;
        
        
#warning 根据类型 设置属性
        
        firstFrontTextColor = TypeBloodPressureColor;
        UIColor *firstBackTextColor = [UIColor colorFromHexRGB:K747474Color];
        UIFont *firstFrontTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
        UIFont *FirstBackTextFont = [UIFont fontWithName:@"Helvetica Light" size:12];
        
        NSArray *firstWordsFont = @[@{@"120/80": firstFrontTextFont},
                                    @{@"mmHg": FirstBackTextFont},];
        
        NSArray *firstWordsColor = @[@{@"120/80": firstFrontTextColor},
                                     @{@"mmHg": firstBackTextColor},];
        NSMutableAttributedString *firstValueStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < 2; i ++) {
            
            NSString *text = [firstWordsFont[i] allKeys][0];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [firstWordsColor[i] objectForKey:text], NSFontAttributeName : [firstWordsFont[i] objectForKey:text]};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
            [firstValueStr appendAttributedString:subString];
        }
        self.firstValueLabel.attributedText = firstValueStr;
        
        
        // 定义血压 血糖 体重值的文字属性
        UIColor *seconfFrontTextColor;
        UIColor *secondBackTextColor;
        UIFont *secondFrontTextFont;
        UIFont *secondBackTextFont;
        
#warning 判断心率和状态 设置属性
        seconfFrontTextColor = TypeBloodPressureColor;
        secondBackTextColor = [UIColor colorFromHexRGB:K747474Color];
        secondFrontTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
        secondBackTextFont = [UIFont systemFontOfSize:12];
        
        NSArray *secondWordsFont = @[@{@"60": secondFrontTextFont},
                                     @{@"次/分钟": secondBackTextFont},];
        
        NSArray *secondWordsColor = @[@{@"60": seconfFrontTextColor},
                                      @{@"次/分钟": secondBackTextColor},];
        NSMutableAttributedString *secondValueStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < 2; i ++) {
            NSString *text = [secondWordsFont[i] allKeys][0];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [secondWordsColor[i] objectForKey:text], NSFontAttributeName : [secondWordsFont[i] objectForKey:text]};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
            [secondValueStr appendAttributedString:subString];
        }
        self.secondValueLabel.attributedText = secondValueStr;
        
        self.centerLabel.hidden = YES;
        self.firstTipLabel.text = @"血压";
        
        self.secondTipLabel.text = @"心率";
        
        self.stateLabel.textColor = TypeBloodPressureColor;
        
        self.stateLabel.text = @"正常";
    } else if (self.healthRecordType == 1) {
        self.typeImageView.image = [UIImage imageNamed:@"record_icon2_"];
        
        self.typeLabel.text = @"血糖";
        
        
        // 定义血压 血糖 体重值的文字属性
        UIColor *firstFrontTextColor;
        
        
#warning 根据类型 设置属性
        
        firstFrontTextColor = TypeBloodGlucoseColor;
        UIColor *firstBackTextColor = [UIColor colorFromHexRGB:K747474Color];
        UIFont *firstFrontTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
        UIFont *FirstBackTextFont = [UIFont fontWithName:@"Helvetica Light" size:12];
        
        NSArray *firstWordsFont = @[@{@"5.0": firstFrontTextFont},
                                    @{@"mmol/L": FirstBackTextFont},];
        
        NSArray *firstWordsColor = @[@{@"5.0": firstFrontTextColor},
                                     @{@"mmol/L": firstBackTextColor},];
        NSMutableAttributedString *firstValueStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < 2; i ++) {
            
            NSString *text = [firstWordsFont[i] allKeys][0];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [firstWordsColor[i] objectForKey:text], NSFontAttributeName : [firstWordsFont[i] objectForKey:text]};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
            [firstValueStr appendAttributedString:subString];
        }
        self.firstValueLabel.attributedText = firstValueStr;
        
        
        // 定义血压 血糖 体重值的文字属性
        UIColor *seconfFrontTextColor;
        UIColor *secondBackTextColor;
        UIFont *secondFrontTextFont;
        UIFont *secondBackTextFont;
        
#warning 判断心率和状态 设置属性
        seconfFrontTextColor = [UIColor colorFromHexRGB:K747474Color];
        secondBackTextColor = TypeBloodGlucoseColor;
        secondFrontTextFont = [UIFont systemFontOfSize:12];
        secondBackTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
        
        NSArray *secondWordsFont = @[@{@"餐后": secondFrontTextFont},
                                     @{@"1h": secondBackTextFont},];
        
        NSArray *secondWordsColor = @[@{@"餐后": seconfFrontTextColor},
                                      @{@"1h": secondBackTextColor},];
        NSMutableAttributedString *secondValueStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < 2; i ++) {
            NSString *text = [secondWordsFont[i] allKeys][0];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [secondWordsColor[i] objectForKey:text], NSFontAttributeName : [secondWordsFont[i] objectForKey:text]};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
            [secondValueStr appendAttributedString:subString];
        }
        self.secondValueLabel.attributedText = secondValueStr;
        self.centerLabel.hidden = YES;
        
        self.firstTipLabel.text = @"血糖";
        
        self.secondTipLabel.text = @"状态";
        
        self.stateLabel.textColor = TypeBloodGlucoseColor;
        
        self.stateLabel.text = @"正常";

    } else {
        self.typeImageView.image = [UIImage imageNamed:@"record_icon1_"];
        
        self.typeLabel.text = @"体重";
        
        
//        // 定义血压 血糖 体重值的文字属性
//        UIColor *firstFrontTextColor;
//        
//        
//#warning 根据类型 设置属性
//        
//        firstFrontTextColor = TypeWeightColor;
//        UIColor *firstBackTextColor = [UIColor colorFromHexRGB:K747474Color];
//        UIFont *firstFrontTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
//        UIFont *FirstBackTextFont = [UIFont fontWithName:@"Helvetica Light" size:12];
//        
//        NSArray *firstWordsFont = @[@{@"120/80": firstFrontTextFont},
//                                    @{@"mmHg": FirstBackTextFont},];
//        
//        NSArray *firstWordsColor = @[@{@"120/80": firstFrontTextColor},
//                                     @{@"mmHg": firstBackTextColor},];
//        NSMutableAttributedString *firstValueStr = [[NSMutableAttributedString alloc] init];
//        for (int i = 0; i < 2; i ++) {
//            
//            NSString *text = [firstWordsFont[i] allKeys][0];
//            NSDictionary *attributes = @{NSForegroundColorAttributeName : [firstWordsColor[i] objectForKey:text], NSFontAttributeName : [firstWordsFont[i] objectForKey:text]};
//            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
//            [firstValueStr appendAttributedString:subString];
//        }
//        self.firstValueLabel.attributedText = firstValueStr;
//        
//        
//        // 定义血压 血糖 体重值的文字属性
//        UIColor *seconfFrontTextColor;
//        UIColor *secondBackTextColor;
//        UIFont *secondFrontTextFont;
//        UIFont *secondBackTextFont;
//        
//#warning 判断心率和状态 设置属性
//        seconfFrontTextColor = TypeWeightColor;
//        secondBackTextColor = [UIColor colorFromHexRGB:K747474Color];
//        secondFrontTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
//        secondBackTextFont = [UIFont systemFontOfSize:12];
//        
//        NSArray *secondWordsFont = @[@{@"60": secondFrontTextFont},
//                                     @{@"次/分钟": secondBackTextFont},];
//        
//        NSArray *secondWordsColor = @[@{@"60": seconfFrontTextColor},
//                                      @{@"次/分钟": secondBackTextColor},];
//        NSMutableAttributedString *secondValueStr = [[NSMutableAttributedString alloc] init];
//        for (int i = 0; i < 2; i ++) {
//            NSString *text = [secondWordsFont[i] allKeys][0];
//            NSDictionary *attributes = @{NSForegroundColorAttributeName : [secondWordsColor[i] objectForKey:text], NSFontAttributeName : [secondWordsFont[i] objectForKey:text]};
//            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
//            [secondValueStr appendAttributedString:subString];
//        }
//        self.secondValueLabel.attributedText = secondValueStr;
        
        self.firstValueLabel.attributedText = [[NSAttributedString alloc] init];
        self.secondValueLabel.attributedText = [[NSAttributedString alloc] init];
        

        NSArray *secondWordsFont = @[@{@"75.0": [UIFont fontWithName:@"Helvetica Light" size:24]},
                                     @{@"kg": [UIFont systemFontOfSize:12]},];

        NSArray *secondWordsColor = @[@{@"75.0": TypeWeightColor},
                                      @{@"kg": [UIColor colorFromHexRGB:K747474Color]}];
        NSMutableAttributedString *secondValueStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < 2; i ++) {
            NSString *text = [secondWordsFont[i] allKeys][0];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [secondWordsColor[i] objectForKey:text], NSFontAttributeName : [secondWordsFont[i] objectForKey:text]};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
            [secondValueStr appendAttributedString:subString];
        }
        self.centerLabel.hidden = NO;
        self.centerLabel.attributedText = secondValueStr;
        
        self.firstTipLabel.text = @"";
        
        self.secondTipLabel.text = @"";
        
        self.stateLabel.textColor = TypeWeightColor;

        self.stateLabel.text = @"正常";
    }
    
}

@end
