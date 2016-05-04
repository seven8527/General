//
//  MYSPersonalMedicalRecordHeaderCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-30.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalMedicalRecordHeaderCell.h"
#import "UIColor+Hex.h"

@implementation MYSPersonalMedicalRecordHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.center = CGPointMake( 65 -24, 25);
        iconImageView.clipsToBounds = YES;
        self.iconImageView = iconImageView;
        iconImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        iconImageView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:iconImageView];
        
        UIView *maskView = [[UIView alloc] init];
        maskView.center = CGPointMake( 65 -24, 25);
        maskView.clipsToBounds = YES;
        self.maskView = maskView;
        maskView.alpha = 0.6;
        maskView.backgroundColor = [UIColor colorFromHexRGB:K000000Color];
        [self.contentView addSubview:maskView];
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"新店开发";
        nameLabel.textColor = [UIColor blueColor];
        self.nameLabel = nameLabel;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

@end
