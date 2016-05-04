//
//  TEConsultCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsultCell.h"
#import "UIColor+Hex.h"

@implementation TEConsultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 患者提示标签
        UILabel *promptPatientLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 50, 21)];
        promptPatientLabel.text = @"咨询者:";
        promptPatientLabel.font = [UIFont boldSystemFontOfSize:14];
        promptPatientLabel.textColor = [UIColor colorWithHex:0x383838];
        [self.contentView addSubview:promptPatientLabel];
        
        // 患者标签
        self.patientLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 80, 21)];
        self.patientLabel.font = [UIFont boldSystemFontOfSize:14];
        self.patientLabel.textColor = [UIColor colorWithHex:0x383838];
        [self.contentView addSubview:self.patientLabel];
        
        // 咨询时间标签
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 11, 130, 21)];
        self.timeLabel.font = [UIFont boldSystemFontOfSize:13];
        self.timeLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
        [self.contentView addSubview:self.timeLabel];

        
        // 咨询的专家提示标签
        UILabel *promptDoctorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 32, 80, 21)];
        promptDoctorLabel.font = [UIFont boldSystemFontOfSize:14];
        promptDoctorLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
        promptDoctorLabel.text = @"咨询的专家:";
        [self.contentView addSubview:promptDoctorLabel];
        
        // 咨询的医生标签
        self.doctorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 32, 58, 21)];
        self.doctorLabel.font = [UIFont boldSystemFontOfSize:14];
        self.doctorLabel.textColor = [UIColor colorWithHex:0x383838];
        [self.contentView addSubview:self.doctorLabel];
        
        // 咨询状态提示标签
        UILabel *promptStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 32, 70, 21)];
        promptStateLabel.text = @"状态:";
        promptStateLabel.font = [UIFont boldSystemFontOfSize:14];
        promptStateLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
        [self.contentView addSubview:promptStateLabel];
        
        // 咨询状态标签
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 32, 88, 21)];
        self.stateLabel.font = [UIFont boldSystemFontOfSize:14];
        self.stateLabel.textColor = [UIColor colorWithHex:0x383838];
        [self.contentView addSubview:self.stateLabel];
    }
    return self;
}

@end
