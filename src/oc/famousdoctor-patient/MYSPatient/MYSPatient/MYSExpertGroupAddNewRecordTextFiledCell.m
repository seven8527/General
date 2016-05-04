//
//  MYSExpertGroupAddNewRecordTextFiledCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupAddNewRecordTextFiledCell.h"
#import "UIColor+Hex.h"
@interface MYSExpertGroupAddNewRecordTextFiledCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MYSExpertGroupAddNewRecordTextFiledCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *infoLabel = [UILabel newAutoLayoutView];
        self.infoLabel = infoLabel;
        infoLabel.font = [UIFont systemFontOfSize:16];
        infoLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        infoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:infoLabel];
        
        UITextField *valueTextField = [UITextField newAutoLayoutView];
        self.valueTextField = valueTextField;
        valueTextField.returnKeyType = UIReturnKeyDone;
        valueTextField.font = [UIFont systemFontOfSize:14];
//        valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        valueTextField.textAlignment = NSTextAlignmentRight;
        valueTextField.textColor = [UIColor colorFromHexRGB:K747474Color];

        [self.contentView addSubview:valueTextField];
    }
    [self updateViewConstraints];
    return self;
}
- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.infoLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
        [self.infoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [self.infoLabel autoSetDimensionsToSize:CGSizeMake(100, 16)];
        
        [self.valueTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [self.valueTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.valueTextField autoSetDimension:ALDimensionHeight toSize:15];
        [self.infoLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.valueTextField withOffset:10];

        self.didSetupConstraints = YES;
    }
}


@end
