//
//  MYSExpertGroupConsultDescriptionCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultDescriptionCell.h"
#import "UIColor+Hex.h"

@interface MYSExpertGroupConsultDescriptionCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;

@end
@implementation MYSExpertGroupConsultDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
        // 反馈
        LPlaceholderTextView *contentTextView = [LPlaceholderTextView newAutoLayoutView];
        contentTextView.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
        contentTextView.placeholderText = @"请详细描述您的病情、症状、治疗经过及想获得的帮助(40-300范围内)";
        contentTextView.placeholderColor = [UIColor colorFromHexRGB:KC2C2C2Color];
        contentTextView.font = [UIFont systemFontOfSize:13];
        contentTextView.textColor = [UIColor blackColor];
        contentTextView.layer.borderWidth = 0.5f;
        contentTextView.layer.cornerRadius = 5;
        contentTextView.layer.borderColor = [UIColor colorFromHexRGB:KC2C2C2Color].CGColor;
        self.contentTextView = contentTextView;
        [self.contentView addSubview:contentTextView];
        
        
        
    }
    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.contentTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.contentTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.5];
        [self.contentTextView autoSetDimensionsToSize:CGSizeMake(kScreen_Width - 30, 55)];
        self.didSetupConstraints = YES;
    }
    
    
}
@end
