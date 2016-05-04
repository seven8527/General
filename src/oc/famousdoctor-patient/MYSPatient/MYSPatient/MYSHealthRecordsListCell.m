//
//  MYSHealthRecordsListCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-25.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//


#import "MYSHealthRecordsListCell.h"
#import "UIColor+Hex.h"

@interface MYSHealthRecordsListCell ()
@property (nonatomic, weak) UIView *firstLine; // 第一条线
@property (nonatomic, weak) UIView *tipView; // 圆点
@property (nonatomic, weak) UIView *secondLine; // 第二条线
@property (nonatomic, weak) UILabel *firstValueLabel; // 体重值 血压值 血糖值
@property (nonatomic, weak) UILabel *secondValueLabel; // BMI值 心率值 测量时间值
@property (nonatomic, weak) UILabel *firstTipLabel; // 体重 血压 血糖
@property (nonatomic, weak) UILabel *secondTipLabel; // BMI  心率 状态
@property (nonatomic, weak) UIImageView *timePicView;
@property (nonatomic, weak) UILabel *timeLabel;
@end

@implementation MYSHealthRecordsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
        
    }
    return self;
}


- (void)setupViews
{
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 3, 12)];
    firstLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.firstLine = firstLine;
    [self.contentView addSubview:firstLine];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(firstLine.frame) + 6, 7.5, 7.5)];
    tipView.layer.cornerRadius = 7.5/2;
    tipView.clipsToBounds = YES;
    tipView.backgroundColor = [UIColor redColor];
    self.tipView = tipView;
    [self.contentView addSubview:tipView];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(tipView.frame) + 6, 3, 90 - CGRectGetMaxY(tipView.frame) -6)];
    secondLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.secondLine = secondLine;
    [self.contentView addSubview:secondLine];
    
    UILabel *firstValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipView.frame) + 15, 14, (kScreen_Width - 40)/2, 23)];
    self.firstValueLabel = firstValueLabel;
    [self.contentView addSubview:firstValueLabel];
    
    
    UILabel *secondValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstValueLabel.frame), 14, (kScreen_Width - 40)/2, 23)];
    self.secondValueLabel = secondValueLabel;
    [self.contentView addSubview:secondValueLabel];
    
    
    UILabel *firstTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(firstValueLabel.frame), CGRectGetMaxY(firstValueLabel.frame) + 8, (kScreen_Width - 40)/2, 15)];
    self.firstTipLabel = firstTipLabel;
    firstTipLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [self.contentView addSubview:firstTipLabel];
    
    
    UILabel *secondTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(secondValueLabel.frame), CGRectGetMaxY(secondValueLabel.frame) + 8, (kScreen_Width - 40)/2, 15)];
    self.secondTipLabel = secondTipLabel;
    secondTipLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [self.contentView addSubview:secondTipLabel];

    
    UIImageView *timePicView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(firstValueLabel.frame), CGRectGetMaxY(firstTipLabel.frame) + 11, 10, 10)];
    timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
    self.timePicView = timePicView;
    [self.contentView addSubview:timePicView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timePicView.frame) + 5, CGRectGetMaxY(firstTipLabel.frame) + 9, kScreen_Width - 50, 15)];
    timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    timeLabel.font = [UIFont fontWithName:@"Helvetica Light" size:13];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];

}

- (void)setIdentification:(int)identification
{
    _identification = identification;
}

- (void)setModel:(id)model
{
    _model = model;
    // 定义血压 血糖 体重值的文字属性
    UIColor *firstFrontTextColor = [UIColor colorFromHexRGB:K747474Color];
#warning 根据类型 设置属性
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
    if (self.identification == 1) {
        seconfFrontTextColor = [UIColor colorFromHexRGB:K747474Color];
        secondBackTextColor = [UIColor colorFromHexRGB:K747474Color];
        secondFrontTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
        secondBackTextFont = [UIFont systemFontOfSize:12];
#warning 下面的根据模型看看是否能够合并
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
    } else if(self.identification == 2){
        seconfFrontTextColor = [UIColor colorFromHexRGB:K747474Color];
        secondBackTextColor = [UIColor colorFromHexRGB:K747474Color];
        secondBackTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
        secondFrontTextFont = [UIFont systemFontOfSize:12];
 #warning 下面的根据模型看看是否能够合并
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

    } else {
        seconfFrontTextColor = [UIColor colorFromHexRGB:K747474Color];
        secondBackTextColor = [UIColor colorFromHexRGB:K747474Color];
        secondBackTextFont = [UIFont fontWithName:@"Helvetica Light" size:24];
        secondFrontTextFont = [UIFont systemFontOfSize:12];
#warning 下面的根据模型看看是否能够合并
        NSArray *secondWordsFont = @[@{@"17.6": secondBackTextFont},
                                     @{@"": secondBackTextFont},];
        
        NSArray *secondWordsColor = @[@{@"17.6": seconfFrontTextColor},
                                      @{@"": secondBackTextColor},];
        NSMutableAttributedString *secondValueStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < 2; i ++) {
            NSString *text = [secondWordsFont[i] allKeys][0];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [secondWordsColor[i] objectForKey:text], NSFontAttributeName : [secondWordsFont[i] objectForKey:text]};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
            [secondValueStr appendAttributedString:subString];
        }
        self.secondValueLabel.attributedText = secondValueStr;

    }
    
//    NSArray *secondWordsFont = @[@{@"60": secondFrontTextFont},
//                                 @{@"次/分钟": secondBackTextFont},];
//    
//    NSArray *secondWordsColor = @[@{@"60": seconfFrontTextColor},
//                                  @{@"次/分钟": secondBackTextColor},];
//    NSMutableAttributedString *secondValueStr = [[NSMutableAttributedString alloc] init];
//    for (int i = 0; i < 2; i ++) {
//        NSString *text = [secondWordsFont[i] allKeys][0];
//        NSDictionary *attributes = @{NSForegroundColorAttributeName : [secondWordsColor[i] objectForKey:text], NSFontAttributeName : [secondWordsFont[i] objectForKey:text]};
//        NSAttributedString *subString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
//        [secondValueStr appendAttributedString:subString];
//    }
//    self.secondValueLabel.attributedText = secondValueStr;
    
    self.firstTipLabel.text = @"血压";
    
    self.secondTipLabel.text = @"心率";
    
    self.timeLabel.text = @"2015/01/11 19:30";

}

@end
