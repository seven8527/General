//
//  MYSExpertGroupAddNewRecordPatientCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupAddNewRecordPatientCell.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSExpertGroupPatientModel.h"
#import "MYSFoundationCommon.h"

@interface MYSExpertGroupAddNewRecordPatientCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *genderImageView;
@end

@implementation MYSExpertGroupAddNewRecordPatientCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
        UIImageView *iconImageView = [UIImageView newAutoLayoutView];
        iconImageView.layer.cornerRadius = 18.5;
        iconImageView.clipsToBounds = YES;
        self.iconImageView = iconImageView;
        [self.contentView addSubview:iconImageView];
        
        UILabel *nameLabel = [UILabel newAutoLayoutView];
        nameLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        UIImageView *genderImageView = [UIImageView newAutoLayoutView];
        self.genderImageView = genderImageView;
        [self.contentView addSubview:genderImageView];
    }
    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.iconImageView autoSetDimensionsToSize:CGSizeMake(37, 37)];
        
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:12];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25];
        [self.nameLabel autoSetDimension:ALDimensionHeight toSize:18];
        
        [self.genderImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25];
        [self.genderImageView autoSetDimensionsToSize:CGSizeMake(16, 16)];
        [self.genderImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel withOffset:10];
        self.didSetupConstraints = YES;
    }
    
    
}

- (void)setModel:(id)model
{
    _model = model;
    
    if ([model isKindOfClass:[MYSExpertGroupPatientModel class]]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[model patientIcon]] placeholderImage:[UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:[model patientSex] andBirthday:[model patientBirthday]]]];
        
        if ([[model patientSex] isEqualToString:@"0"]) {
            self.genderImageView.image = [UIImage imageNamed:@"consult_icon_woman_"];
        } else {
            self.genderImageView.image = [UIImage imageNamed:@"consult_icon_man_"];
        }
        
        self.nameLabel.text = [model patientName];
    }
    
}

@end
