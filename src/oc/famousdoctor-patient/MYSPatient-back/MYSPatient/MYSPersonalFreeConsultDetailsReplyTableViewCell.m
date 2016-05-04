//
//  MYSPersonalFreeConsultDetailsReplyTableViewCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalFreeConsultDetailsReplyTableViewCell.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import "MYSBriefAskModel.h"
#import "MYSPlusAskModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MYSPersonalFreeConsultDetailsReplyTableViewCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *personImageView;  // 患者头像
@property (nonatomic, weak) UILabel *personInfoLable; // 患者资料
@property (nonatomic, weak) UIImageView *timePicView; // 时间图标
@property (nonatomic, weak) UILabel *timeLabel; // 咨询时间
@property (nonatomic, weak) UILabel *questionLabel; // 患者问题
@end

@implementation MYSPersonalFreeConsultDetailsReplyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor yellowColor];
        
        // 患者头像
        UIImageView *personImageView = [UIImageView newAutoLayoutView];
        personImageView.layer.cornerRadius = 15;
        personImageView.clipsToBounds = YES;
        [self.contentView addSubview:personImageView];
        self.personImageView = personImageView;
        
        
        // 患者资料
        UILabel *personInfoLable = [UILabel newAutoLayoutView];
        personInfoLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:personInfoLable];
        self.personInfoLable = personInfoLable;
        
        
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
        
        [self.personImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        [self.personImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.personImageView autoSetDimensionsToSize:CGSizeMake(30, 30)];
        
        [self.personInfoLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.personImageView withOffset:6];
        [self.personInfoLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        
        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        //        [self.timeLabel autoSetDimensionsToSize:CGSizeMake(80, 12)];
        [self.timeLabel autoSetDimension:ALDimensionHeight toSize:12];
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22];
        
        
        [self.timePicView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:-5];
        [self.timePicView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        [self.timePicView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22];
        
        [self.questionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50];
        [self.questionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:14];
        [self.questionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:14];
//        [self.questionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.personInfoLable withOffset:12];
        
        self.didSetupConstraints = YES;
    }
}

- (void)setUserInfoModel:(id)userInfoModel
{
    _userInfoModel = userInfoModel;
    
    if ([userInfoModel isKindOfClass:[MYSBriefAskDoctorModel  class]]) {
        [self.personImageView sd_setImageWithURL:[NSURL URLWithString:[userInfoModel doctorPic]] placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
        self.personInfoLable.text = [userInfoModel doctorName];
        self.personInfoLable.textColor = [UIColor colorFromHexRGB:K00907FColor];
        self.timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
    } else {
        [self.personImageView sd_setImageWithURL:[NSURL URLWithString:[userInfoModel patientPic]] placeholderImage:[UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:[userInfoModel patientSex] andBirthday:[userInfoModel patientBirthday]]]];
        self.personInfoLable.text = [userInfoModel patientName];
        self.personInfoLable.textColor = [UIColor colorFromHexRGB:K747474Color];
        self.timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
    }
}


- (void)setContentModel:(id)contentModel
{
    _contentModel = contentModel;
    LOG(@"%@",[contentModel addTime]);
    if ([contentModel isKindOfClass:[MYSBriefAnswerModel class]]) {
        self.timeLabel.text = [contentModel addTime];
        self.questionLabel.text = [contentModel content];
    } else if ([contentModel isKindOfClass:[MYSPlusAnswerModel class]]) {
        self.timeLabel.text = [contentModel addTime];
        self.questionLabel.text = [contentModel content];
    } else {
        
        self.timeLabel.text = [contentModel addTime];
        self.questionLabel.text = [contentModel question];
    }
    [self.timeLabel autoSetDimension:ALDimensionWidth toSize:[MYSFoundationCommon sizeWithText:self.timeLabel.text withFont:self.timeLabel.font].width];
     self.timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
}

//- (void)setModel:(id)model
//{
//    self.personImageView.image = [UIImage imageNamed:@"favicon_boy"];
//    self.personInfoLable.text = @"周纯武";
//    [self.personInfoLable autoSetDimension:ALDimensionWidth toSize:[MYSFoundationCommon sizeWithText:self.personInfoLable.text withFont:self.personInfoLable.font].width];
//    
//    
//    self.timeLabel.text = @"2015/01/11 11:40";
//    
//    [self.timeLabel autoSetDimension:ALDimensionWidth toSize:[MYSFoundationCommon sizeWithText:self.timeLabel.text withFont:self.timeLabel.font].width];
//    
//    self.timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
//    
//    self.questionLabel.text = @"fdasfafasdfhafdas和发动机克萨斯了；贷款方案的了是伐是大哥家阿喀琉斯；DDF架考虑是啊啥都fahjasdagasfgasdfasdfasfdas";
//}

@end
