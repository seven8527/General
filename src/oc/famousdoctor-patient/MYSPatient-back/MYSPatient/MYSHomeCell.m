//
//  MYSHomeCell.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHomeCell.h"
#import "UIColor+Hex.h"

@interface  MYSHomeCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation MYSHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
        
        UIImageView *iconImageView = [UIImageView newAutoLayoutView];
        self.iconImageView = iconImageView;

        [self.contentView addSubview:iconImageView];
        
        UILabel *nameLabel = [UILabel newAutoLayoutView];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        UILabel *describeLabel = [UILabel newAutoLayoutView];
        describeLabel.font = [UIFont systemFontOfSize:13];
        describeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        self.describeLabel = describeLabel;
        [self.contentView addSubview:describeLabel];
        
    }
    
    [self updateViewConstraints];
    
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {  
        if (iPhone6Plus) {
            [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:178/3];
            [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:28];
            [self.iconImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
            
            [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:17];
            [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:189/3];
            [self.nameLabel autoSetDimension:ALDimensionHeight toSize:15];
            
            [self.describeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:17];
            [self.describeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:189/3];
            [self.describeLabel autoSetDimension:ALDimensionHeight toSize:15];
        } else if (iPhone6) {
            [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:101/2];
            [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
            [self.iconImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
            
            [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:17];
            [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:55];
            [self.nameLabel autoSetDimension:ALDimensionHeight toSize:15];
            
            [self.describeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:17];
            [self.describeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:55];
            [self.describeLabel autoSetDimension:ALDimensionHeight toSize:15];
        } else {
            [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:75/2];
            [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
            [self.iconImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
            
            [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:17];
            [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:42];
            [self.nameLabel autoSetDimension:ALDimensionHeight toSize:15];
            
            [self.describeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:17];
            [self.describeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:42];
            [self.describeLabel autoSetDimension:ALDimensionHeight toSize:15];
        }
        
        self.didSetupConstraints = YES;
    }
}

@end
