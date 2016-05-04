//
//  TEDiseaseCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEDiseaseCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"

@implementation TEDiseaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 圆点
        self.dot = [[UIImageView alloc] init];
        self.dot.image = [[UIImage imageNamed:@"point.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [self.contentView addSubview:self.dot];
        
        // 疾病项目
        self.itemLabel = [[UILabel alloc] init];
        self.itemLabel.font = [UIFont boldSystemFontOfSize:15];
        self.itemLabel.textColor = [UIColor colorWithHex:0x383838];
        self.itemLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.itemLabel];
        
        // 疾病项目介绍
        self.itemIntroLabel = [[MDHTMLLabel alloc] init];
        self.itemIntroLabel.font = [UIFont boldSystemFontOfSize:13];
        self.itemIntroLabel.textColor = [UIColor colorWithHex:0x383838];
        self.itemIntroLabel.numberOfLines = 0;
        self.itemIntroLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.itemIntroLabel];
    }

    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.dot.frame = CGRectMake(20, 17, 7, 7);
    self.itemLabel.frame = CGRectMake(30, 10, 280, 21);
    
    CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
    CGFloat itemIntroSize = [MDHTMLLabel sizeThatFitsHTMLString:self.itemIntroLabel.htmlText withFont:[UIFont boldSystemFontOfSize:13] constraints:boundingSize limitedToNumberOfLines:3000];
    self.itemIntroLabel.frame = CGRectMake(20, 41, 280, itemIntroSize);
}


@end
