//
//  MYSNetDetailDocTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSNetDetailDocTableViewCell.h"

#define CONTENT_MARGIN_LEFT 15
#define CONTENT_MARGIN_TOP 14
#define CONTENT_FONT [UIFont systemFontOfSize:13]

#define LINE_HEIGHT 1
#define LINE_COLOR [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]

@implementation MYSNetDetailDocTableViewCell

- (void)sendValue:(id)dic
{
    NSString *content =[dic objectForKey:@"content"];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    contentLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    
    CGFloat contentLabelH = [self calculateLabelHeight:content];
    contentLabel.frame = CGRectMake(CONTENT_MARGIN_LEFT, CONTENT_MARGIN_TOP, kScreen_Width - CONTENT_MARGIN_LEFT * 2, contentLabelH);
    [self addSubview:contentLabel];
    
    [self setLabelAttr:@"回复:  " content:content label:contentLabel selectColor:K00907FColor unSelectColor:K9E9E9EColor];

    CGFloat cellH = [MYSNetDetailDocTableViewCell calculateCellHeight:content];
    // 分隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellH - 1, kScreen_Width, LINE_HEIGHT)];
    [lineView setBackgroundColor:LINE_COLOR];
    [self addSubview:lineView];
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content
{
    // 给一个比较大的高度，宽度不变
    CGSize size = CGSizeMake(kScreen_Width - CONTENT_MARGIN_LEFT * 2, 5000);
    
    CGSize  actualsize;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000)
    // 获取当前文本的属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: CONTENT_FONT, NSFontAttributeName,nil];
    actualsize =[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
#else
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    actualsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#else
    actualsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
#endif
#endif
    return actualsize.height;
}

+ (CGFloat)calculateCellHeight:(NSString *)content
{
    MYSNetDetailDocTableViewCell *cell = [[MYSNetDetailDocTableViewCell alloc] init];
    CGFloat contentHeight = [cell calculateLabelHeight:content];
    return contentHeight + CONTENT_MARGIN_TOP * 2;
}

/**
 *  设定Label颜色
 */
- (void)setLabelAttr:(NSString *)title content:(NSString *)content label:(UILabel *)label selectColor:(NSString *)selectColor unSelectColor:(NSString *)unSelectColor
{
    NSString *rangString1 = title;
    NSString *rangString2 = content;
    NSString *totalString = [NSString stringWithFormat:@"%@%@", rangString1, rangString2];
    
    UIFont *fontSize = CONTENT_FONT;
    
    UIColor *selectStepColor = [UIColor colorFromHexRGB:selectColor];
    UIColor *unselectStepColor = [UIColor colorFromHexRGB:unSelectColor];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:totalString];
    [str addAttribute:NSForegroundColorAttributeName value:selectStepColor range:[totalString rangeOfString:rangString1]];
    [str addAttribute:NSForegroundColorAttributeName value:unselectStepColor range:[totalString rangeOfString:rangString2]];
    [str addAttribute:NSFontAttributeName value:fontSize range:[totalString rangeOfString:rangString1]];
    [str addAttribute:NSFontAttributeName value:fontSize range:[totalString rangeOfString:rangString2]];
    
    label.attributedText = str;
}

@end
