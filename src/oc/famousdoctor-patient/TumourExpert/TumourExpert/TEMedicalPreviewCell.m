//
//  TEMedicalPreviewCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEMedicalPreviewCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"

@implementation TEMedicalPreviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 病历项目
        self.itemLabel = [[UILabel alloc] init];
        self.itemLabel.font = [UIFont boldSystemFontOfSize:17];
        self.itemLabel.textColor = [UIColor colorWithHex:0x383838];
        [self.contentView addSubview:self.itemLabel];
        
        // 病历
        self.imageScrollView = [[UIScrollView alloc] init];
        self.imageScrollView.showsHorizontalScrollIndicator = NO;
        self.imageScrollView.showsVerticalScrollIndicator = NO;
        self.imageScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        [self.contentView addSubview:self.imageScrollView];
    }
    
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.itemLabel.frame = CGRectMake(20, 14, 60, 21);
    
    self.imageScrollView.frame = CGRectMake(120, 2, 180, 44);
}


@end
