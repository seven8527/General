//
//  MYSNetDetailAllTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSNetDetailAllTableViewCell.h"

#define TITLE_MARGIN_LEFT 15
#define TITLE_MARGIN_TOP 14
#define TITLE_HEIGHT 20

#define CONTENT_MARGIN_TOP 5

#define BTN_W 50
#define BTN_H 30

#define IMG_W_H 20

#define TITLE_FONT [UIFont systemFontOfSize:14]
#define CONTENT_FONT [UIFont systemFontOfSize:13]

#define LINE_HEIGHT 1
#define LINE_COLOR [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]

@implementation MYSNetDetailAllTableViewCell

- (void)sendValue:(id)dic
{
    mDic = dic;
    NSString *title = [dic objectForKey:@"title"];
    NSString *content =[dic objectForKey:@"content"];
    
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_MARGIN_LEFT, TITLE_MARGIN_TOP, kScreen_Width - TITLE_MARGIN_LEFT * 2, TITLE_HEIGHT)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    titleLabel.font = TITLE_FONT;
    [self addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    contentLabel.font = CONTENT_FONT;
    contentLabel.text = content;
    contentLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    
    CGFloat contentLabelH = [self calculateLabelHeight:content];
    CGFloat cellH = [MYSNetDetailAllTableViewCell calculateCellHeight:content];
    contentLabel.frame = CGRectMake(TITLE_MARGIN_LEFT, TITLE_MARGIN_TOP + TITLE_HEIGHT + CONTENT_MARGIN_TOP, kScreen_Width - TITLE_MARGIN_LEFT * 2, contentLabelH);
    [self addSubview:contentLabel];
    
    UIButton *shouqiBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - TITLE_MARGIN_LEFT - BTN_W, cellH - BTN_H - 5, BTN_W, BTN_H)];
    shouqiBtn.backgroundColor = [UIColor clearColor];
    [shouqiBtn addTarget:self action:@selector(shouqiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shouqiBtn];
    
    UILabel *shouqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(shouqiBtn.frame.origin.x + 5, cellH - BTN_H - 5, BTN_W, BTN_H)];
    shouqiLabel.text = @"收起";
    shouqiLabel.font = [UIFont systemFontOfSize:12];
    shouqiLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    [self addSubview:shouqiLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - TITLE_MARGIN_LEFT - IMG_W_H - 5, cellH - BTN_H, IMG_W_H, IMG_W_H)];
    imageView.image = [UIImage imageNamed:@"btn_arrows_back"];
    [self addSubview:imageView];
    
    // 分隔线
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:LINE_COLOR];
    [self addSubview:lineView];
    if ([@"end" isEqualToString:[dic objectForKey:@"countType"]])
    {
        lineView.frame = CGRectMake(0, cellH - 1, kScreen_Width, LINE_HEIGHT);
    } else {
        lineView.frame = CGRectMake(TITLE_MARGIN_LEFT, cellH - 1, kScreen_Width - TITLE_MARGIN_LEFT, LINE_HEIGHT);
    }
}

- (void)shouqiBtnClick
{
    [mDic setValue:@"0" forKey:@"status"];
    if ([self.delegate respondsToSelector:@selector(detailCellShouQiBtnClick)])
    {
        [self.delegate detailCellShouQiBtnClick];
    }
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content
{
    // 给一个比较大的高度，宽度不变
    CGSize size = CGSizeMake(kScreen_Width - TITLE_MARGIN_LEFT * 2, 5000);
    
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
    MYSNetDetailAllTableViewCell *cell = [[MYSNetDetailAllTableViewCell alloc] init];
    CGFloat contentHeight = [cell calculateLabelHeight:content];
    return contentHeight + CONTENT_MARGIN_TOP + TITLE_MARGIN_TOP * 2 + TITLE_HEIGHT + BTN_H;
}

@end
