//
//  NSString+CalculateTextSize.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CalculateTextSize)

// 计算文本的size
- (CGSize)boundingRectWithSize:(CGSize)boundingSize font:(UIFont *)font;

// 计算文本的size, 还可以设置文字的行间距（奇怪：设置的好像是段间距）
- (CGSize)boundingRectWithSize:(CGSize)boundingSize font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

@end
