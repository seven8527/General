//
//  MYSPersonalFreeConsultationCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalFreeConsultationCell.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSFoundationCommon.h"

@interface MYSPersonalFreeConsultationCell ()
@property (nonatomic, weak) UIImageView *backImageView;
@property (nonatomic, weak) UIImageView *patientImageView;  // 患者头像
@property (nonatomic, weak) UILabel *patientInfoLable; // 患者资料
@property (nonatomic, weak) UIImageView *patientSexImageView; // 患者性别图标
@property (nonatomic, weak) UILabel *consultStatusLabel; // 回复状态
@property (nonatomic, weak) UIView *firstLine; //  第一条线
@property (nonatomic, weak) UILabel *questionLabel; // 患者问题
@property (nonatomic, weak) UILabel *doctorNameLabel; // 专家姓名
@property (nonatomic, weak) UILabel *doctorInfoLabel; // 医生信息
@property (nonatomic, weak) UIImageView *replyImageView; // 回复背景
@property (nonatomic, weak) UILabel *replyLabel; // 回复内容
@property (nonatomic, weak) UILabel *timeLabel; // 咨询时间
@property (nonatomic, weak) UIImageView *timePicView; // 时间图标
@property (nonatomic, weak) UIButton *replyButton; // 回复按钮
@property (nonatomic, weak) UIView *secondLine; //  第二条线
@end

@implementation MYSPersonalFreeConsultationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *backImageView =[[UIImageView alloc] init];
        [self.contentView addSubview:backImageView];
        self.backImageView = backImageView;
        
        
        // 患者头像
        UIImageView *patientImageView = [[UIImageView alloc] init];
        patientImageView.layer.cornerRadius = 10;
        patientImageView.clipsToBounds = YES;
        [self.contentView addSubview:patientImageView];
        self.patientImageView = patientImageView;
        
        // 患者资料
        UILabel *patientInfoLable = [[UILabel alloc] init];
        patientInfoLable.textColor = [UIColor colorFromHexRGB:K747474Color];
        patientInfoLable.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:patientInfoLable];
        self.patientInfoLable = patientInfoLable;

        // 患者性别
        UIImageView *patientSexImageView = [[UIImageView alloc] init];
        self.patientSexImageView = patientSexImageView;
        [self.contentView addSubview:patientSexImageView];

        // 回复状态
        UILabel *consultStatusLabel = [[UILabel alloc] init];
        consultStatusLabel.font = [UIFont systemFontOfSize:13];
        consultStatusLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        [self.contentView addSubview:consultStatusLabel];
        self.consultStatusLabel = consultStatusLabel;

        
        // 第一分割线
        UIView *firstLine = [[UIView alloc] init];
        firstLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        self.firstLine = firstLine;
        [self.contentView addSubview:firstLine];

        
        
        // 咨询问题
        UILabel *questionLabel = [[UILabel alloc] init];
        questionLabel.font = [UIFont systemFontOfSize:14];
        questionLabel.numberOfLines = 0;
        questionLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        [self.contentView addSubview:questionLabel];
        self.questionLabel = questionLabel;

        // 医生姓名
        UILabel *doctorNameLabel = [[UILabel alloc] init];
        doctorNameLabel.font = [UIFont systemFontOfSize:13];
        doctorNameLabel.textColor = [UIColor colorFromHexRGB:K00907FColor];
        doctorNameLabel.text= @"ASFDFADS";
        [self.contentView addSubview:doctorNameLabel];
        self.doctorNameLabel = doctorNameLabel;

        
        // 医生资料
        UILabel *doctorInfoLabel = [[UILabel alloc] init];
        doctorInfoLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        doctorInfoLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:doctorInfoLabel];
        self.doctorInfoLabel = doctorInfoLabel;

        UIImageView *replyImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:replyImageView];
        self.replyImageView = replyImageView;

        
        // 回复
        UILabel *replyLabel = [[UILabel alloc] init];
        replyLabel.font = [UIFont systemFontOfSize:14];
        replyLabel.numberOfLines = 0;
        replyLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        [replyImageView addSubview:replyLabel];
        self.replyLabel = replyLabel;

        
        UIImageView *timePicView = [[UIImageView alloc] init];
        self.timePicView = timePicView;
        [self.contentView addSubview:timePicView];

        
        // 就诊时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;

        
        UIButton *replyButton = [[UIButton alloc] init];
        replyButton.userInteractionEnabled = NO;
        [replyButton setTitle:@"回复" forState:UIControlStateNormal];
        replyButton.layer.cornerRadius = 3;
        replyButton.clipsToBounds = YES;
        replyButton.layer.borderColor = [UIColor colorFromHexRGB:K00907FColor].CGColor;
        replyButton.layer.borderWidth = 0.5;
        replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [replyButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
        [self.contentView addSubview:replyButton];
        self.replyButton = replyButton;
        self.replyButton.hidden = YES;

        // 第二分割线
        UIView *secondLine = [[UIView alloc] init];
        secondLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        self.secondLine = secondLine;
        [self.contentView addSubview:secondLine];
        
        
    }
    return self;
}

- (void)setFreeConsultFrame:(MYSPersonalFreeConsultationFrame *)freeConsultFrame
{
    _freeConsultFrame = freeConsultFrame;
    
    // 主问
    MYSBriefAskModel *briefAskModel = freeConsultFrame.freeConsultModel.briefAskModel;
    
    self.patientImageView.frame = freeConsultFrame.patientImageViewF;
    [self.patientImageView sd_setImageWithURL:[NSURL URLWithString:briefAskModel.patientModel.patientPic] placeholderImage: [UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:briefAskModel.patientModel.patientSex andBirthday:briefAskModel.patientModel.patientBirthday]]];
    
    self.patientInfoLable.frame = freeConsultFrame.patientInfoLableF;
    self.patientInfoLable.text = [NSString stringWithFormat:@"%@ %@岁",briefAskModel.patientModel.patientName,[MYSFoundationCommon obtainAgeWith:briefAskModel.patientModel.patientBirthday]];
    
    self.patientSexImageView.frame = freeConsultFrame.patientSexImageViewF;
    if ([briefAskModel.patientModel.patientSex isEqualToString:@"1"]) {// 男
        self.patientSexImageView.image = [UIImage imageNamed:@"consult_icon_man_"];
    } else {
        self.patientSexImageView.image = [UIImage imageNamed:@"consult_icon_woman_"];
    }
    
    
    self.consultStatusLabel.frame = freeConsultFrame.consultStatusLabelF;
    
    self.questionLabel.frame = freeConsultFrame.questionLabelF;
    self.questionLabel.text = freeConsultFrame.freeConsultModel.briefAskModel.question;
    self.doctorNameLabel.frame =freeConsultFrame.doctorNameLabelF;
    self.doctorInfoLabel.frame = freeConsultFrame.doctorInfoLabelF;
    self.replyLabel.frame = freeConsultFrame.replyLabelF;
    self.timePicView.frame = freeConsultFrame.timePicViewF;
    self.timeLabel.frame = freeConsultFrame.timeLabelF;
    self.replyButton.frame = freeConsultFrame.replyButtonF;
    if(freeConsultFrame.replyButtonF.size.height > 0){
        self.replyButton.hidden = NO;
    } else {
        self.replyButton.hidden = YES;
    }
    
    if(briefAskModel.answerModel) {// 如果存在主答
        if(freeConsultFrame.freeConsultModel.plusAskArray.count > 0) {// 存在追问
            // 追问
            MYSPlusAskModel *plusAskModel = [freeConsultFrame.freeConsultModel.plusAskArray firstObject];
            if([plusAskModel.isReply isEqualToString:@"1"]) {// 查看追问是否回复
                self.doctorNameLabel.text = briefAskModel.doctorModel.doctorName;
                self.doctorInfoLabel.text = [NSString stringWithFormat:@"%@  %@",briefAskModel.doctorModel.doctorDepatrment,briefAskModel.doctorModel.doctorClinical];
                
                self.replyLabel.text = plusAskModel.answerModel.content;
            }
            if([plusAskModel.isReply isEqualToString:@"1"]){
                if ([briefAskModel.userView isEqualToString:@"1"]) {
                    self.consultStatusLabel.text = @"已读取";
                    self.consultStatusLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
                } else {
                    self.consultStatusLabel.text = @"未读取";
                    self.consultStatusLabel.textColor = [UIColor colorFromHexRGB:KEF8004Color];
                }
            } else {
                self.consultStatusLabel.text = @"未回复";
                self.consultStatusLabel.textColor = [UIColor colorFromHexRGB:KEF8004Color];
            }
        } else { // 没有追问 即只有主答
            if([briefAskModel.isReply isEqualToString:@"1"]) {
                if ([briefAskModel.userView isEqualToString:@"1"]) {
                    self.consultStatusLabel.text = @"已读取";
                    self.consultStatusLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
                } else {
                    self.consultStatusLabel.text = @"未读取";
                    self.consultStatusLabel.textColor = [UIColor colorFromHexRGB:KEF8004Color];
                }
                self.doctorNameLabel.text = briefAskModel.doctorModel.doctorName;
                self.doctorInfoLabel.text = [NSString stringWithFormat:@"%@  %@",briefAskModel.doctorModel.doctorDepatrment,briefAskModel.doctorModel.doctorClinical];
                self.replyLabel.text = briefAskModel.answerModel.content ;
            }
        }
    } else { // 没有主答
        self.consultStatusLabel.text = @"未回复";
        self.consultStatusLabel.textColor = [UIColor colorFromHexRGB:KEF8004Color];
    }
    
    self.timePicView.image =[UIImage imageNamed:@"doctor_icon_time_"];
    self.timeLabel.text = briefAskModel.addTime;
    self.firstLine.frame = freeConsultFrame.firstLineF;
    self.secondLine.frame = freeConsultFrame.secondLineF;
    self.backImageView.frame = CGRectMake(0, 0, kScreen_Width - 20, freeConsultFrame.CellHeight);
    self.backImageView.image = [[UIImage imageNamed:@"zoe_bg_white_"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 2, 10, 2) resizingMode:UIImageResizingModeTile];
    self.replyImageView.frame = freeConsultFrame.replyImageViewF;
    self.replyImageView.image = [[UIImage imageNamed:@"zoe_bg_gray_"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 2, 0.5) resizingMode:UIImageResizingModeTile];
}

@end
