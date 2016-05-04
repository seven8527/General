//
//  TESeekExpertCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESeekExpertCell.h"
#import "UIColor+Hex.h"

@implementation TESeekExpertCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 医生头像
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 53, 53)];
        [self.contentView addSubview:self.iconImageView];
        
        // 医生标签
        self.doctorLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 10, 220, 21)];
        self.doctorLabel.font = [UIFont boldSystemFontOfSize:17];
        self.doctorLabel.textColor = [UIColor colorWithHex:0x383838];
        self.doctorLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.doctorLabel];
        
        // 职称标签
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 31, 220, 21)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.titleLabel.textColor = [UIColor colorWithHex:0x989898];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        
        // 医院标签
        self.hospitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 52, 220, 21)];
        self.hospitalLabel.font = [UIFont boldSystemFontOfSize:13];
        self.hospitalLabel.textColor = [UIColor colorWithHex:0x989898];
        self.hospitalLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.hospitalLabel];
        
    }
    return self;
}


@end
