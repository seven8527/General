//
//  MYSPersonalFreeConsultDetailsQuestionTableViewCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalFreeConsultDetailsQuestionTableViewCell.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MYSPersonalFreeConsultDetailsQuestionTableViewCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *patientImageView;  // 患者头像
@property (nonatomic, weak) UILabel *patientInfoLable; // 患者资料
@property (nonatomic, weak) UIImageView *patientSexImageView; // 患者性别图标
@property (nonatomic, weak) UIImageView *timePicView; // 时间图标
@property (nonatomic, weak) UILabel *timeLabel; // 咨询时间
@property (nonatomic, weak) UILabel *questionLabel; // 患者问题
@end

@implementation MYSPersonalFreeConsultDetailsQuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor yellowColor];
        
        // 患者头像
        UIImageView *patientImageView = [UIImageView newAutoLayoutView];
        patientImageView.layer.cornerRadius = 15;
        patientImageView.clipsToBounds = YES;
        [self.contentView addSubview:patientImageView];
        self.patientImageView = patientImageView;

        
        // 患者资料
        UILabel *patientInfoLable = [UILabel newAutoLayoutView];
        patientInfoLable.textColor = [UIColor colorFromHexRGB:K747474Color];
        patientInfoLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:patientInfoLable];
        self.patientInfoLable = patientInfoLable;
        
        // 患者性别
        UIImageView *patientSexImageView = [UIImageView newAutoLayoutView];
        self.patientSexImageView = patientSexImageView;
        [self.contentView addSubview:patientSexImageView];
        
        
        // 时间图标
        UIImageView *timePicView = [UIImageView newAutoLayoutView];
        self.timePicView = timePicView;
        [self.contentView addSubview:timePicView];
        
        
        // 就诊时间
        UILabel *timeLabel = [UILabel newAutoLayoutView];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;

        
        // 咨询问题
        UILabel *questionLabel = [UILabel newAutoLayoutView];
        questionLabel.numberOfLines = 0;
        questionLabel.font = [UIFont systemFontOfSize:14];
        questionLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        [self.contentView addSubview:questionLabel];
        self.questionLabel = questionLabel;

    }
     [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.patientImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        [self.patientImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.patientImageView autoSetDimensionsToSize:CGSizeMake(30, 30)];
        
        [self.patientInfoLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.patientImageView withOffset:5];
        [self.patientInfoLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        
        
        
        [self.patientSexImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [self.patientSexImageView autoSetDimensionsToSize:CGSizeMake(15, 15)];
        
        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.timeLabel autoSetDimensionsToSize:CGSizeMake(110, 12)];
        [self.timeLabel autoSetDimension:ALDimensionHeight toSize:12];
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22];
        
        
        [self.timePicView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:-5];
        [self.timePicView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        [self.timePicView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22];
        
        [self.questionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14];
        [self.questionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:14];
        [self.questionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:14];
//        [self.questionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.patientSexImageView withOffset:12];
        
        self.didSetupConstraints = YES;
    }
}

- (void)setBriefAskModel:(MYSBriefAskModel *)briefAskModel
{
    _briefAskModel = briefAskModel;
  [self.patientImageView sd_setImageWithURL:[NSURL URLWithString:briefAskModel.patientModel.patientPic] placeholderImage: [UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:briefAskModel.patientModel.patientSex andBirthday:briefAskModel.patientModel.patientBirthday]]];

    self.patientInfoLable.text = [NSString stringWithFormat:@"%@  %@岁",briefAskModel.patientModel.patientName,[MYSFoundationCommon obtainAgeWith:briefAskModel.patientModel.patientBirthday]];
    [self.patientInfoLable autoSetDimension:ALDimensionWidth toSize:[MYSFoundationCommon sizeWithText:self.patientInfoLable.text withFont:self.patientInfoLable.font].width + 10];
    
    
    [self.patientSexImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.patientInfoLable withOffset:0];
    
    
    if ([briefAskModel.patientModel.patientSex isEqualToString:@"1"]) {// 男
        self.patientSexImageView.image = [UIImage imageNamed:@"consult_icon_man_"];
    } else {
        self.patientSexImageView.image = [UIImage imageNamed:@"consult_icon_woman_"];
    }

    
    
    self.timeLabel.text = briefAskModel.addTime;
    
//    [self.timeLabel autoSetDimension:ALDimensionWidth toSize:[MYSFoundationCommon sizeWithText:self.timeLabel.text withFont:self.timeLabel.font].width];
    
    self.timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
    
    self.questionLabel.text = briefAskModel.question;
}

@end
