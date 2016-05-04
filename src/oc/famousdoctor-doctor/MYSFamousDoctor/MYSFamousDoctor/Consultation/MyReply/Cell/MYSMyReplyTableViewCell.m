//
//  MYSMyReplyTableViewCell.m
//  MYSFamousDoctor
//
//  我的回复 - Cell
//
//  Created by lyc on 15/4/14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyReplyTableViewCell.h"

#define CELL_HEIGHT 140
#define BG_MARGIN_TOP 10
#define BG_MARGIN_LEFT 10

#define TIME_VIEW_HEIGHT 32
#define TIME_IMAGE_W_H 10
#define TIME_IMAGE_MARGIN_LEFT 10
#define TIME_LABEL_MARGIN_LEFT 5
#define TIME_LABEL_HEIGHT 20
#define HAVE_NEW_LABEL_WIDTH 52
#define HAVE_NEW_IMAGE_WIDTH 25
#define HAVE_NEW_IMAGE_HEIGHT 25

#define QUESTION_FONT [UIFont systemFontOfSize:14]
#define QUESTION_LABEL_MARGIN_TOP TIME_VIEW_HEIGHT + 10
#define QUESTION_HEIGHT CELL_HEIGHT - TIME_VIEW_HEIGHT - BOTTOM_HEIGHT

#define QUESTION_REPLY_MARGIN 1

#define LINE_HEIGHT 1
#define LINE_COLOR [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]

@implementation MYSMyReplyTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)sendValue:(id)dic
{
    [self initCell:dic];
}

/**
 *  初始化Cell界面
 */
- (void)initCell:(id)dic
{
    id mainDic = [dic objectForKey:@"main"];
    id reply = [mainDic objectForKey:@"reply"];
    
    // 提问内容
    NSString *question_title = [mainDic objectForKey:@"question_title"];
    // 回答内容
    NSString *reply_title = [reply objectForKey:@"content"];
    // 有无新信息
    NSString *haveNewFlag = [mainDic objectForKey:@"view"];
    
    // 时间
    NSString *addDateStr = [mainDic objectForKey:@"add_time"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *addDate = [format dateFromString:addDateStr];
    format.dateFormat = @"yyyy-MM-dd";
    addDateStr = [format stringFromDate:addDate];
    
    
    // 设定背景为透明色
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat bgViewHeight = [MYSMyReplyTableViewCell calculateCellHeight:question_title reply:reply_title];
    // 背景View添加
    bgView = [[UIView alloc] initWithFrame:CGRectMake(BG_MARGIN_LEFT, BG_MARGIN_TOP, kScreen_Width - BG_MARGIN_LEFT * 2, bgViewHeight - BG_MARGIN_TOP)];
    [self addSubview:bgView];
    
    // 背景图片添加
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - BG_MARGIN_LEFT * 2, bgViewHeight - BG_MARGIN_TOP)];
    bgImageView.image = [[UIImage imageNamed:@"zoe_bg_white_"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 2, 10, 2) resizingMode:UIImageResizingModeTile];
    [bgView addSubview:bgImageView];
    
    /** 时间 start */
    // 时间 - image
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, (TIME_VIEW_HEIGHT - TIME_IMAGE_W_H) / 2, TIME_IMAGE_W_H, TIME_IMAGE_W_H)];
    timeImageView.image = [UIImage imageNamed:@"personal-information_column_time"];
    [bgView addSubview:timeImageView];
    
    // 时间 - label
    CGFloat timeLabelX = TIME_IMAGE_MARGIN_LEFT + TIME_IMAGE_W_H + TIME_LABEL_MARGIN_LEFT;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, (TIME_VIEW_HEIGHT - TIME_LABEL_HEIGHT) / 2, 120, TIME_LABEL_HEIGHT)];
    
    
    timeLabel.text = [format stringFromDate:addDate];
    timeLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:timeLabel];
    
    // 新消息Image
    haveNewsImage = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT - HAVE_NEW_LABEL_WIDTH - HAVE_NEW_IMAGE_WIDTH + 5, (TIME_VIEW_HEIGHT - HAVE_NEW_IMAGE_HEIGHT) / 2 + 0.5, HAVE_NEW_IMAGE_WIDTH, HAVE_NEW_IMAGE_HEIGHT)];
    haveNewsImage.image = [UIImage imageNamed:@"btn_reply_news"];
    // 默认隐藏
    haveNewsImage.hidden = YES;
    [bgView addSubview:haveNewsImage];
    // 新消息Label
    haveNewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT - HAVE_NEW_LABEL_WIDTH, (TIME_VIEW_HEIGHT - TIME_LABEL_HEIGHT) / 2, HAVE_NEW_LABEL_WIDTH, TIME_LABEL_HEIGHT)];
    haveNewsLabel.text = @"有新消息";
    haveNewsLabel.textColor = [UIColor colorFromHexRGB:KEF8004Color];
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    haveNewsLabel.textAlignment = NSTextAlignmentRight;
#else
    haveNewsLabel.textAlignment = UITextAlignmentRight;
#endif
    haveNewsLabel.font = [UIFont systemFontOfSize:12];
    // 默认隐藏
    haveNewsLabel.hidden = YES;
    [bgView addSubview:haveNewsLabel];
    
    id children = [dic objectForKey:@"children"];
    if (children && [NSNull null] != children)
    {
        for (id item in children)
        {
            haveNewFlag = [item objectForKey:@"view"];
            if ([@"0" isEqualToString:haveNewFlag])
            {
                break;
            }
        }
    }
    
    if ([@"0" isEqualToString:haveNewFlag])
    {   // 有新信息
        haveNewsImage.hidden = NO;
        haveNewsLabel.hidden = NO;
    } else{
        haveNewsImage.hidden = YES;
        haveNewsLabel.hidden = YES;
    }
    
    // 时间分隔线
    UIView *timeLineView = [[UIView alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, TIME_VIEW_HEIGHT - 1, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, LINE_HEIGHT)];
    [timeLineView setBackgroundColor:LINE_COLOR];
    [bgView addSubview:timeLineView];
    /** 时间 end */
    
    /** 问题 start */
    NSString *questionContent = question_title;
    questionLabel = [[UILabel alloc] init];
    questionLabel.numberOfLines = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    questionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    questionLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    questionLabel.font = QUESTION_FONT;
    [self setLabelAttr:@"问题:  " content:questionContent label:questionLabel selectColor:KEF8004Color unSelectColor:K333333Color];
    
    if (20 < [self calculateLabelHeight:questionContent]) {
        // 两行的场合
        questionLabel.frame = CGRectMake(TIME_IMAGE_MARGIN_LEFT, QUESTION_LABEL_MARGIN_TOP, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, 40);
    } else {
        // 一行的场合
        questionLabel.frame = CGRectMake(TIME_IMAGE_MARGIN_LEFT, QUESTION_LABEL_MARGIN_TOP, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, 20);
    }
    [bgView addSubview:questionLabel];
    /** 问题 end */
    
    /** 回复 start */
    NSString *replyContent = reply_title;
    replyLabel = [[UILabel alloc] init];
    replyLabel.numberOfLines = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    replyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    replyLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    replyLabel.font = QUESTION_FONT;
    [self setLabelAttr:@"回复:  " content:replyContent label:replyLabel selectColor:K00907FColor unSelectColor:K9E9E9EColor];
    
    if (20 < [self calculateLabelHeight:replyContent]) {
        // 两行的场合
        replyLabel.frame = CGRectMake(TIME_IMAGE_MARGIN_LEFT, questionLabel.frame.origin.y + questionLabel.frame.size.height + QUESTION_REPLY_MARGIN, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, 40);
    } else {
        // 一行的场合
        replyLabel.frame = CGRectMake(TIME_IMAGE_MARGIN_LEFT, questionLabel.frame.origin.y + questionLabel.frame.size.height + QUESTION_REPLY_MARGIN, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, 20);
    }
    [bgView addSubview:replyLabel];
    /** 回复 end */
}

+ (CGFloat)calculateCellHeight:(NSString *)question reply:(NSString *)reply
{
    MYSMyReplyTableViewCell *cell = [[MYSMyReplyTableViewCell alloc] init];
    
    CGFloat height = CELL_HEIGHT;
    
    if (20 > [cell calculateLabelHeight:question]) {
        height = height - 20;
    }
    
    if (20 > [cell calculateLabelHeight:reply]) {
        height = height - 20;
    }
        
    return height;
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content
{
    // 给一个比较大的高度，宽度不变
    CGSize size = CGSizeMake(kScreen_Width - BG_MARGIN_LEFT * 2 - TIME_IMAGE_MARGIN_LEFT * 2, 5000);
    
    CGSize  actualsize;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000)
    // 获取当前文本的属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: QUESTION_FONT, NSFontAttributeName,nil];
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
 *  设定Label颜色
 */
- (void)setLabelAttr:(NSString *)title content:(NSString *)content label:(UILabel *)label selectColor:(NSString *)selectColor unSelectColor:(NSString *)unSelectColor
{
    NSString *rangString1 = title;
    NSString *rangString2 = content;
    NSString *totalString = [NSString stringWithFormat:@"%@%@", rangString1, rangString2];
    
    UIFont *fontSize = QUESTION_FONT;
    
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
