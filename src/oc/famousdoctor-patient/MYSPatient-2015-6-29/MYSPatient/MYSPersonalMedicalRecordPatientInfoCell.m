//
//  MYSPersonalMedicalRecordPatientInfoCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalMedicalRecordPatientInfoCell.h"
#import "UIColor+Hex.h"

@interface MYSPersonalMedicalRecordPatientInfoCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UILabel *diseaseNameLabel;
@property (nonatomic, weak) UILabel *hospitalAndDepartmentLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIImageView *timePicView;
@property (nonatomic, weak) UIImageView *hospitalPicView;

@end

@implementation MYSPersonalMedicalRecordPatientInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor yellowColor];
        self.didSetupConstraints = NO;
    

        // 病名
        UILabel *diseaseNameLabel = [UILabel newAutoLayoutView];
        diseaseNameLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
        diseaseNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:diseaseNameLabel];
        self.diseaseNameLabel = diseaseNameLabel;
        
        
        UIImageView *hospitalPicView = [UIImageView newAutoLayoutView];
        self.hospitalPicView = hospitalPicView;
        [self.contentView addSubview:hospitalPicView];
        
        // 医院和科室
        UILabel *hospitalAndDepartmentLabel = [UILabel newAutoLayoutView];
        hospitalAndDepartmentLabel.font = [UIFont systemFontOfSize:13];
        hospitalAndDepartmentLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        [self.contentView addSubview:hospitalAndDepartmentLabel];
        self.hospitalAndDepartmentLabel = hospitalAndDepartmentLabel;
        
        
        
        UIImageView *timePicView = [[UIImageView alloc] init];
        self.timePicView = timePicView;
        [self.contentView addSubview:timePicView];
        
        
        // 就诊时间
        UILabel *timeLabel = [UILabel newAutoLayoutView];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        
    }
    
    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.diseaseNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11];
        [self.diseaseNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
//        [self.diseaseNameLabel autoSetDimensionsToSize:CGSizeMake(kScreen_Width - 30, 14)];
        [self.diseaseNameLabel autoSetDimension:ALDimensionWidth toSize:(kScreen_Width-30)];
        
        [self.hospitalPicView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.hospitalPicView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.diseaseNameLabel withOffset:10];
        [self.hospitalPicView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        
        [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.hospitalPicView withOffset:5];
        [self.hospitalAndDepartmentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.diseaseNameLabel withOffset:10];
        [self.hospitalAndDepartmentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
        

        
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.timeLabel autoSetDimensionsToSize:CGSizeMake(80, 12)];
        [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
       
        
        [self.timePicView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:5];
        [self.timePicView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        [self.timePicView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        
        
        [self.diseaseNameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timePicView withOffset:-5];
        
         self.didSetupConstraints = YES;
    }
}

- (void)setPatientRecordModel:(MYSPersonalPatientRecordDataModel *)patientRecordModel
{
    _patientRecordModel = patientRecordModel;
    if(patientRecordModel) {
    self.diseaseNameLabel.text = patientRecordModel.diagnosis;
    
    self.hospitalAndDepartmentLabel.text = [NSString stringWithFormat:@"%@  %@",patientRecordModel.hospital,patientRecordModel.department];
    
    self.timeLabel.text = patientRecordModel.vistingTime;
    
    self.timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
    
    self.hospitalPicView.image = [UIImage imageNamed:@"doctor_icon1_"];
    }
}

@end
