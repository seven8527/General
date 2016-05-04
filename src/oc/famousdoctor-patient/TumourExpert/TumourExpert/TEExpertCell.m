//
//  TEExpertCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertCell.h"
#import "UIColor+Hex.h"

@implementation TEExpertCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 医生头像
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 53, 53)];
        [self.contentView addSubview:self.iconImageView];
        
        // 医生标签
        self.doctorLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 14, 68, 17)];
        self.doctorLabel.font = [UIFont boldSystemFontOfSize:17];
        self.doctorLabel.textColor = [UIColor colorWithHex:0x373838];
        self.doctorLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.doctorLabel];
        
        // 职称标签
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 14, 150, 17)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        
        // 医院标签
        self.hospitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 33, 105, 17)];
        self.hospitalLabel.font = [UIFont boldSystemFontOfSize:14];
        self.hospitalLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.hospitalLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.hospitalLabel];
        
        // 科室标签
        self.departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 33, 110, 17)];
        self.departmentLabel.font = [UIFont boldSystemFontOfSize:14];
        self.departmentLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.departmentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.departmentLabel];
        
        
        // 区域
        self.areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 48, 93, 21)];
        self.areaLabel.font = [UIFont boldSystemFontOfSize:14];
        self.areaLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.areaLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.areaLabel];
        
        
        // 咨询人数
        self.consultCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 48, 130, 21)];
        self.consultCountLabel.font = [UIFont boldSystemFontOfSize:14];
        self.consultCountLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.consultCountLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.consultCountLabel];
        
    }
    return self;
}

@end
