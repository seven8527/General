//
//  MYSConsultationAutoTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSConsultationAutoTableViewCell.h"

#define TITLE_COLOR [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]
#define CONTENT_COLOR [UIColor colorWithRed:158/255.0f green:158/255.0f blue:158/255.0f alpha:1]
#define BOTTOM_LINE_COLOR [UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1]
@implementation MYSConsultationAutoTableViewCell

- (void)awakeFromNib
{
    // 去掉选中背景色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 * 设定Cell
 */
- (void)sendValue:(NSString *)title titleFont:(UIFont *)titleFont content:(NSString *)content contentFont:(UIFont *)contentFont cellType:(AutoCellType)type bottomLineType:(BottomLineType)lineType
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat titleHeight = 0;
    CGFloat contentHeight = 0;
    if (AutoTableViewCellHaveTitle == type)
    {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.font = titleFont;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
#else
        titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
#endif
        titleLabel.text = title;
        titleLabel.textColor = TITLE_COLOR;
        [self addSubview:titleLabel];
        titleHeight = [self calculateLabelHeight:title font:titleFont];
        titleLabel.frame = CGRectMake(15, 14, screenWidth - 30, titleHeight);
    }
    
    contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = contentFont;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
#else
    contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
#endif
    contentLabel.text = content;
    contentLabel.textColor = CONTENT_COLOR;
    [self addSubview:contentLabel];
    contentHeight = [self calculateLabelHeight:content font:contentFont];
    if (AutoTableViewCellHaveTitle == type) {
        contentLabel.frame = CGRectMake(15, 10 + titleHeight + 8 , screenWidth - 30, contentHeight);
    } else {
        contentLabel.frame = CGRectMake(15, 10, screenWidth - 30, contentHeight);
    }
    
    CGFloat totalHeight = [MYSConsultationAutoTableViewCell cellHeight:title titleFont:titleFont content:content contentFont:contentFont cellType:type];
    
    // 添加底部分割线
    UIView *lineView = [[UIView alloc] init];
    if (All == lineType)
    {
        lineView.frame = CGRectMake(0, totalHeight - 1, screenWidth, 1);
    } else {
        lineView.frame = CGRectMake(15, totalHeight - 1, screenWidth - 15, 1);
    }
    lineView.backgroundColor = BOTTOM_LINE_COLOR;
    [self addSubview:lineView];
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content font:(UIFont *)font
{
    // 给一个比较大的高度，宽度不变
    CGSize size =CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 5000);
    
    CGSize  actualsize;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000)
    // 获取当前文本的属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName,nil];
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

/**
 * 通过字体，和字符串计算Cell的高度
 */
+ (CGFloat)cellHeight:(NSString *)title titleFont:(UIFont *)titleFont content:(NSString *)content contentFont:(UIFont *)contentFont cellType:(AutoCellType)type
{
    MYSConsultationAutoTableViewCell *cell = [[MYSConsultationAutoTableViewCell alloc] init];
    CGFloat titleHeight = 0;
    CGFloat contentHeight = [cell calculateLabelHeight:content font:contentFont];
    if (AutoTableViewCellHaveTitle == type)
    {
        titleHeight = [cell calculateLabelHeight:title font:titleFont];
        return contentHeight + titleHeight + 33;
    } else {
        return contentHeight + 20;
    }
}

@end
