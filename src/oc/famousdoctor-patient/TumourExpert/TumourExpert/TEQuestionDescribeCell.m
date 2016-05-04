//
//  TEQuestionDescribeCell.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEQuestionDescribeCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEQuestionDescribe.h"

@implementation TEQuestionDescribeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.titleLabel.textColor = [UIColor colorWithHex:0xe47929];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.questionLabel = [[MDHTMLLabel alloc] init];
        self.questionLabel.font = [UIFont boldSystemFontOfSize:14];
        self.questionLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.questionLabel.numberOfLines = 0;
        self.questionLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.questionLabel];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(15, 14, 280, 21);

    
    CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
    
    CGSize questionSize = [self.questionLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    self.questionLabel.frame = CGRectMake(15, 40, questionSize.width, questionSize.height);
    
}

+ (CGFloat)rowHeightWitObject:(id)object
{
    TEQuestionDescribe *questionDescribrtObject = (TEQuestionDescribe *)object;
    
    CGSize questionSize = CGSizeZero;
    CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
    
    if (questionDescribrtObject.question) {
        questionSize = [questionDescribrtObject.question boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    }
    
    CGFloat cellHeight = 44 + questionSize.height;
    
	return cellHeight;
}

@end
