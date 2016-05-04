//
//  MYSExpertGroupConsultChooseRecordCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultChooseRecordCell.h"
#import "UIColor+Hex.h"

@interface MYSExpertGroupConsultChooseRecordCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation MYSExpertGroupConsultChooseRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
        
        UILabel *tipLabel = [UILabel newAutoLayoutView];
        tipLabel.font = [UIFont systemFontOfSize:16];
        self.tipLabel = tipLabel;
        [self.contentView addSubview:tipLabel];
        
        UILabel *firstLabel = [UILabel newAutoLayoutView];
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.textAlignment = NSTextAlignmentRight;
        firstLabel.font = [UIFont systemFontOfSize:14];
        firstLabel.textColor = [UIColor lightGrayColor];
        self.firstLabel = firstLabel;
        firstLabel.hidden = YES;
        [self.contentView addSubview:firstLabel];
        
        
        UILabel *secondLabel = [UILabel newAutoLayoutView];
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.textAlignment = NSTextAlignmentRight;
        secondLabel.font = [UIFont systemFontOfSize:14];
        secondLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        secondLabel.hidden = YES;
        self.secondLabel = secondLabel;
        [self.contentView addSubview:secondLabel];
        
        
        UIImageView *disclosureIndicator = [UIImageView newAutoLayoutView];
        disclosureIndicator.image = [UIImage imageNamed:@"more_"];
        self.disclosureIndicator = disclosureIndicator;
        [self.contentView addSubview:disclosureIndicator];
        
    }
    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
        [self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
        [self.tipLabel autoSetDimensionsToSize:CGSizeMake(100, 15)];
        
//        [self.disclosureIndicator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.disclosureIndicator autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
//        [self.disclosureIndicator autoSetDimensionsToSize:CGSizeMake(8, 12.5)];
        
        
//        [self.firstLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.disclosureIndicator withOffset:-12];
        [self.firstLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
        [self.firstLabel  autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tipLabel withOffset:5];
        [self.firstLabel autoSetDimension:ALDimensionHeight toSize:12.5];
        
//        [self.secondLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.disclosureIndicator withOffset:-12];
        [self.secondLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.firstLabel withOffset:12.5];
        [self.secondLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.tipLabel withOffset:5];
        [self.firstLabel autoSetDimension:ALDimensionHeight toSize:12.5];
        
        self.didSetupConstraints = YES;
    }
    
    
}


- (void)setTestArray:(NSArray *)testArray
{
    _testArray = testArray;
    
    if (testArray.count == 2) {
        self.detailTextLabel.hidden = YES;
        self.firstLabel.hidden = NO;
        self.secondLabel.hidden = NO;
        if ([testArray[0] isKindOfClass:[NSString class]]) {
            self.firstLabel.text = testArray[0];
            self.firstLabel.textColor = [UIColor lightGrayColor];
        } else {
            self.firstLabel.text = [testArray[0]  diagnosis];
             self.firstLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        }
        if ([testArray[1] isKindOfClass:[NSString class]]) {
            self.secondLabel.text = testArray[1];
        } else {
            self.secondLabel.text = [testArray[1]  diagnosis];
            
        }
    } else if(testArray.count == 1){
        if ([testArray[0] isKindOfClass:[NSString class]]) {
            self.firstLabel.text = testArray[0];
             self.firstLabel.textColor = [UIColor lightGrayColor];
        } else {
            self.firstLabel.text = [testArray[0]  diagnosis];
            self.firstLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
            
        }
        self.secondLabel.hidden = YES;
        self.detailTextLabel.hidden = YES;
        self.firstLabel.hidden = NO;
    } else {
        self.detailTextLabel.hidden = NO;
        self.firstLabel.hidden = YES;
        self.secondLabel.hidden = YES;
    }
    if (self.disclosureIndicator.hidden == YES) {
        [self.disclosureIndicator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.disclosureIndicator autoSetDimensionsToSize:CGSizeMake(0, 0)];
        [self.firstLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.disclosureIndicator withOffset:-15];
        [self.secondLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.disclosureIndicator withOffset:-15];

    } else {
        [self.disclosureIndicator autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.firstLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.disclosureIndicator withOffset:-12];
        [self.secondLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.disclosureIndicator withOffset:-12];
        [self.disclosureIndicator autoSetDimensionsToSize:CGSizeMake(8, 12.5)];
    }
}


@end
