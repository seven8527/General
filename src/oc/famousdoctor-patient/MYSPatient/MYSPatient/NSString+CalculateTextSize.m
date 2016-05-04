//
//  NSString+CalculateTextSize.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "NSString+CalculateTextSize.h"

@implementation NSString (CalculateTextSize)

// 计算文本的size
- (CGSize)boundingRectWithSize:(CGSize)boundingSize font:(UIFont *)font
{
    CGSize size;
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self boundingRectWithSize:boundingSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{ NSFontAttributeName : font }
                                  context:nil].size;
    } 
    
    return size;
}

// 计算文本的size, 还可以设置文字的行间距（奇怪：设置的好像是段间距）
- (CGSize)boundingRectWithSize:(CGSize)boundingSize font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSAttributedString *attributedText = [self attributedStringFromStingWithFont:font lineSpacing:lineSpacing];
    CGSize size = [attributedText boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return size;
}

// sting转AttributedString
- (NSAttributedString *)attributedStringFromStingWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    
    return attributedStr;
}

@end
