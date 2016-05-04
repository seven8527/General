//
//  TEConsultReplyCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsultReplyCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEConsultReply.h"

@implementation TEConsultReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.promptLabel = [[UILabel alloc] init];
        self.promptLabel.font = [UIFont boldSystemFontOfSize:17];
        self.promptLabel.textColor = [UIColor colorWithHex:0x383838];
        self.promptLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.promptLabel];
        
        // 画线
        self.line = [[UIImageView alloc] init];
        self.line.image = [[UIImage imageNamed:@"line_d1d1d1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [self.contentView addSubview:self.line];
        
        self.userLabel = [[UILabel alloc] init];
        self.userLabel.font = [UIFont boldSystemFontOfSize:13];
        self.userLabel.textColor = [UIColor colorWithHex:0xe47929];
        self.userLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.userLabel];
        
        self.questionLabel = [[MDHTMLLabel alloc] init];
        self.questionLabel.font = [UIFont boldSystemFontOfSize:14];
        self.questionLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.questionLabel.numberOfLines = 0;
        self.questionLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.questionLabel];
        
        self.doctorLabel = [[UILabel alloc] init];
        self.doctorLabel.font = [UIFont boldSystemFontOfSize:13];
        self.doctorLabel.textColor = [UIColor colorWithHex:0xe47929];
        self.doctorLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.doctorLabel];
        
        self.answerLabel = [[MDHTMLLabel alloc] init];
        self.answerLabel.font = [UIFont boldSystemFontOfSize:14];
        self.answerLabel.textColor = [UIColor colorWithHex:0x6b6b6b]; 
        self.answerLabel.numberOfLines = 0;
        self.answerLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.answerLabel];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    self.promptLabel.frame = CGRectMake(20, 14, 280, 21);
    self.line.frame = CGRectMake(20, 45, 280, 1);
    self.userLabel.frame = CGRectMake(20, 53, 280, 21);
    
    CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
    
    CGSize questionSize = [self.questionLabel.htmlText boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    self.questionLabel.frame = CGRectMake(20, 81, questionSize.width, questionSize.height);
    
    self.doctorLabel.frame = CGRectMake(20, 88 + questionSize.height, 280, 21);
    
    CGSize answerSize = [self.answerLabel.htmlText boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    if (answerSize.width < 280) {
        answerSize.width = 280;
    }
    self.answerLabel.frame = CGRectMake(20, 116 + questionSize.height, answerSize.width, answerSize.height);
}

+ (CGFloat)rowHeightWitObject:(id)object
{
    TEConsultReply *consultObject = (TEConsultReply *)object;
    
    CGSize questionSize = CGSizeZero;
    CGSize answerSize = CGSizeZero;
    CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
    
    if (consultObject.question) {
        questionSize = [consultObject.question boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    }
    
    if (consultObject.answer) {
        answerSize = [consultObject.answer boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:14]];
    }
    
    CGFloat cellHeight = 126 + questionSize.height + answerSize.height;
    
	return cellHeight;
}


@end
