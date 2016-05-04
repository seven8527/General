//
//  MYSNetDetailTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSNetDetailTableViewCell.h"

#define CELL_HEIGHT 130

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

@implementation MYSNetDetailTableViewCell

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
    if (60 < [self calculateLabelHeight:content]) {
        // 三行以上
        contentLabel.frame = CGRectMake(TITLE_MARGIN_LEFT, TITLE_MARGIN_TOP + TITLE_HEIGHT + CONTENT_MARGIN_TOP, kScreen_Width - TITLE_MARGIN_LEFT * 2, 60);
        
        UIButton *zhankaiBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - TITLE_MARGIN_LEFT - BTN_W, CELL_HEIGHT - BTN_H - 5, BTN_W, BTN_H)];
        zhankaiBtn.backgroundColor = [UIColor clearColor];
        [zhankaiBtn addTarget:self action:@selector(zhankaiBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zhankaiBtn];
        
        UILabel *zhankaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(zhankaiBtn.frame.origin.x + 5, CELL_HEIGHT - BTN_H - 5, BTN_W, BTN_H)];
        zhankaiLabel.text = @"展开";
        zhankaiLabel.font = [UIFont systemFontOfSize:12];
        zhankaiLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        [self addSubview:zhankaiLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - TITLE_MARGIN_LEFT - IMG_W_H - 5, CELL_HEIGHT - BTN_H, IMG_W_H, IMG_W_H)];
        imageView.image = [UIImage imageNamed:@"btn_arrows"];
        [self addSubview:imageView];
    } else if (40 < [self calculateLabelHeight:content]) {
        // 三行的场合
        contentLabel.frame = CGRectMake(TITLE_MARGIN_LEFT, TITLE_MARGIN_TOP + TITLE_HEIGHT + CONTENT_MARGIN_TOP, kScreen_Width - TITLE_MARGIN_LEFT * 2, 60);
    } else if (20 < [self calculateLabelHeight:content]) {
        // 两行的场合
        contentLabel.frame = CGRectMake(TITLE_MARGIN_LEFT, TITLE_MARGIN_TOP + TITLE_HEIGHT + CONTENT_MARGIN_TOP, kScreen_Width - TITLE_MARGIN_LEFT * 2, 40);
    } else {
        // 一行的场合
        contentLabel.frame = CGRectMake(TITLE_MARGIN_LEFT, TITLE_MARGIN_TOP + TITLE_HEIGHT + CONTENT_MARGIN_TOP, kScreen_Width - TITLE_MARGIN_LEFT * 2, 20);
    }
    [self addSubview:contentLabel];
    
    CGFloat cellH = [MYSNetDetailTableViewCell calculateCellHeight:content];
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

- (void)zhankaiBtnClick
{
    [mDic setValue:@"1" forKey:@"status"];
    if ([self.delegate respondsToSelector:@selector(detailCellZhanKaiBtnClick)])
    {
        [self.delegate detailCellZhanKaiBtnClick];
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
    MYSNetDetailTableViewCell *cell = [[MYSNetDetailTableViewCell alloc] init];
    CGFloat contentHeight = [cell calculateLabelHeight:content];
    
    CGFloat height = CELL_HEIGHT;
    if (60 < contentHeight) {
        // 三行以上
        height = CELL_HEIGHT;
    } else if (40 < contentHeight) {
        // 三行的场合
        height = CELL_HEIGHT - 25;
    } else if (20 < contentHeight) {
        // 两行的场合
        height = CELL_HEIGHT - 40;
    } else {
        // 一行的场合
        height = CELL_HEIGHT - 60;
    }
    
    //CGFloat height = TITLE_MARGIN_LEFT * 2 + TITLE_HEIGHT + contentHeight + 15;
    return height;
}

@end
