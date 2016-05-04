//
//  MYSExpertGroupConsultMedicalRecordsHeaderView.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultMedicalRecordsHeaderView.h"
#import "UIColor+Hex.h"

@interface MYSExpertGroupConsultMedicalRecordsHeaderView ()
@property (nonatomic, weak) UILabel *diseaseNameLabel;
@property (nonatomic, weak) UILabel *hospitalAndDepartmentLabel;
@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UIImageView *timePicView;
@property (nonatomic, weak) UIImageView *hospitalPicView;
@end

@implementation MYSExpertGroupConsultMedicalRecordsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)layoutUI
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width - 15, 1)];
    topLine.backgroundColor = [UIColor colorFromHexRGB:KD1D1D1Color];
    self.topLine = topLine;
    [self addSubview:topLine];
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, kScreen_Width, 1)];
    bottomLine.backgroundColor = [UIColor colorFromHexRGB:KD1D1D1Color];
    self.bottomLine = bottomLine;
    [self addSubview:bottomLine];
    
    // 病名
    UILabel *diseaseNameLabel = [UILabel newAutoLayoutView];
    diseaseNameLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
    diseaseNameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:diseaseNameLabel];
    self.diseaseNameLabel = diseaseNameLabel;
    
    
    UIImageView *hospitalPicView = [UIImageView newAutoLayoutView];
    self.hospitalPicView = hospitalPicView;
    [self addSubview:hospitalPicView];
    
    // 医院和科室
    UILabel *hospitalAndDepartmentLabel = [UILabel newAutoLayoutView];
    hospitalAndDepartmentLabel.font = [UIFont systemFontOfSize:13];
    hospitalAndDepartmentLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    [self addSubview:hospitalAndDepartmentLabel];
    self.hospitalAndDepartmentLabel = hospitalAndDepartmentLabel;
    
    // 时间标志
    UIImageView *timePicView = [[UIImageView alloc] init];
    self.timePicView = timePicView;
    [self addSubview:timePicView];

    
    // 就诊时间
    UILabel *timeLabel = [UILabel newAutoLayoutView];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 选择
//    UIButton *checkButton = [UIButton newAutoLayoutView];
//    checkButton.clipsToBounds = YES;
//    [checkButton addTarget:self action:@selector(clickCheckButton) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:checkButton];
//    self.checkButton = checkButton;
    
    UIButton *checkButton = [UIButton newAutoLayoutView];
    checkButton.layer.cornerRadius = 20;
    checkButton.clipsToBounds = YES;
    checkButton.backgroundColor = [UIColor whiteColor];
    checkButton.layer.borderWidth = 6.0;
    checkButton.layer.borderColor = [UIColor colorFromHexRGB:KFFFFFFColor].CGColor;
    [checkButton setImage:[UIImage imageNamed:@"consult_radio2_"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"consult_radio1_"] forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(clickCheckButton) forControlEvents:UIControlEventTouchUpInside];
    self.checkButton = checkButton;
    [self  addSubview:checkButton];
    
    // 指示标志
    UIImageView *indicatorView = [UIImageView newAutoLayoutView];
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;

    [self updateViewConstraints];

}

- (void)updateViewConstraints
{
    
    [self.diseaseNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
    [self.diseaseNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.diseaseNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
    [self.diseaseNameLabel autoSetDimension:ALDimensionHeight toSize:16];
    
    [self.checkButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
    [self.checkButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [self.checkButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
    
    [self.indicatorView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18.5];
    [self.indicatorView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.5];
    [self.indicatorView autoSetDimensionsToSize:CGSizeMake(12.5, 8)];
    
    [self.timePicView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14];
    [self.timePicView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16];
    [self.timePicView autoSetDimensionsToSize:CGSizeMake(11, 11)];
    
    [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:14];
    [self.timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.timePicView withOffset:5];
    [self.timeLabel autoSetDimensionsToSize:CGSizeMake(kScreen_Width - 100, 12)];
    
    [self.hospitalPicView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14];
    [self.hospitalPicView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.timePicView withOffset:-10];
    [self.hospitalPicView autoSetDimensionsToSize:CGSizeMake(11, 11)];
    
    [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.hospitalPicView withOffset:5];
    [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.indicatorView withOffset:20];
    [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.diseaseNameLabel withOffset:-12];
    [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.timeLabel withOffset:10];
    
}

- (void)setPatientRecordModel:(MYSExpertGroupPatientRecordDataModel *)patientRecordModel
{
    _patientRecordModel = patientRecordModel;
    self.diseaseNameLabel.text = patientRecordModel.diagnosis;
    
    self.hospitalAndDepartmentLabel.text = [NSString stringWithFormat:@"%@  %@",patientRecordModel.hospital,patientRecordModel.department];
    
    self.timeLabel.text = patientRecordModel.vistingTime;
    
    self.indicatorView.image = [UIImage imageNamed:@"doctor_button_down_"];
    
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"login_checkbox_default_"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"login_checkbox_selected_"] forState:UIControlStateSelected];
    
    self.timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
    
    self.hospitalPicView.image = [UIImage imageNamed:@"doctor_icon1_"];
}

- (void)clickCheckButton {
    self.checkButton.selected = !self.checkButton.selected;
//    self.isSelect = self.checkButton.selected;
    if (self.checkButton.selected == YES) {
        if ( [self.delegate respondsToSelector:@selector(expertGroupConsultMedicalRecordDidSelectWithIndex:)]) {
            [self.delegate expertGroupConsultMedicalRecordDidSelectWithIndex:self.tag];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(expertGroupConsultMedicalRecordDidDeselectWithIndex:)]) {
            [self.delegate expertGroupConsultMedicalRecordDidDeselectWithIndex:self.tag];
        }
    }
}

@end
