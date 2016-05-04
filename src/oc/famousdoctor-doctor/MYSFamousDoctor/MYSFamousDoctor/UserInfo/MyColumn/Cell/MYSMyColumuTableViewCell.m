//
//  MYSMyColumuTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyColumuTableViewCell.h"

#define ORANGE_COLOR [UIColor colorWithRed:251/255.0f green:74/255.0f blue:9/255.0f alpha:1]
#define BLACK_COLOR [UIColor colorWithRed:65/255.0f green:65/255.0f blue:65/255.0f alpha:1]
#define GRAY_COLOR [UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1]

#define TITLE_FONT [UIFont systemFontOfSize:16]
#define OTHER_FONT [UIFont systemFontOfSize:12]
#define TITLE_MARGIN_LEFT 12

#define IMAGE_HEIGHT 12
#define IMAGE_MARGIN_BOTTOM 8

#define CELL_HEIGHT 80

#define LINE_HEIGHT 1
#define LINE_COLOR [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]

@implementation MYSMyColumuTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)getCellHeight
{
    return CELL_HEIGHT;
}

- (void)sendTitle:(NSString *)title time:(NSString *)time count:(NSString *)count
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = TITLE_FONT;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    titleLabel.text = title;
    titleLabel.textColor = BLACK_COLOR;
    [self addSubview:titleLabel];
    CGFloat titleHeight = [self calculateLabelHeight:title];
    if (titleHeight < 35)
    {
        titleLabel.frame = CGRectMake(TITLE_MARGIN_LEFT, TITLE_MARGIN_LEFT, kScreen_Width - TITLE_MARGIN_LEFT * 2, 20);
    } else {
        titleLabel.frame = CGRectMake(TITLE_MARGIN_LEFT, TITLE_MARGIN_LEFT, kScreen_Width - TITLE_MARGIN_LEFT * 2, 40);
    }
    
    CGFloat bottomY = CELL_HEIGHT - IMAGE_MARGIN_BOTTOM - IMAGE_HEIGHT;
    // 底部发表时间Image
    UIImageView *dateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TITLE_MARGIN_LEFT, bottomY, IMAGE_HEIGHT, IMAGE_HEIGHT)];
    dateImageView.image = [UIImage imageNamed:@"personal-information_column_time"];
    [self addSubview:dateImageView];
    // 底部发表时间Label
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_MARGIN_LEFT + IMAGE_HEIGHT + 5, bottomY, 100, IMAGE_HEIGHT)];
    dateLabel.font = OTHER_FONT;
    dateLabel.text = [MYSUtils checkIsNull:time];
    dateLabel.textColor = GRAY_COLOR;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    dateLabel.lineBreakMode = NSLineBreakByCharWrapping;
#else
    dateLabel.lineBreakMode = UILineBreakModeCharacterWrap;
#endif
    [self addSubview:dateLabel];
    
    CGFloat countMarginX = TITLE_MARGIN_LEFT + IMAGE_HEIGHT + 5 + 80 + 20 + 20;
    // 底部浏览数目Image
    UIImageView *countImageView = [[UIImageView alloc] initWithFrame:CGRectMake(countMarginX, bottomY  + 1.5 , IMAGE_HEIGHT + 2, IMAGE_HEIGHT - 2)];
    countImageView.image = [UIImage imageNamed:@"personal_information_column_browse"];
    [self addSubview:countImageView];
    // 底部浏览数目Label
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(countMarginX + IMAGE_HEIGHT + 5, bottomY, 80, IMAGE_HEIGHT)];
    countLabel.font = OTHER_FONT;
    countLabel.text = count;
    countLabel.textColor = GRAY_COLOR;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    countLabel.lineBreakMode = NSLineBreakByCharWrapping;
#else
    countLabel.lineBreakMode = UILineBreakModeCharacterWrap;
#endif
    [self addSubview:countLabel];
    
    // 问题分隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT - 1, kScreen_Width, LINE_HEIGHT)];
    [lineView setBackgroundColor:LINE_COLOR];
    [self addSubview:lineView];
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content
{
    // 给一个比较大的高度，宽度不变
    CGSize size =CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 5000);
    
    CGSize  actualsize;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000)
    // 获取当前文本的属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: TITLE_FONT, NSFontAttributeName,nil];
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
@end
