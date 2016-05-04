//
//  MYSPatientQuestionsTableViewCell.m
//  MYSFamousDoctor
//
//  患者提问-cell
//
//  Created by lyc on 15/4/14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPatientQuestionsTableViewCell.h"

#define CELL_HEIGHT 140
#define BG_MARGIN_TOP 10
#define BG_MARGIN_LEFT 10

#define TIME_VIEW_HEIGHT 32
#define TIME_IMAGE_W_H 10
#define TIME_IMAGE_MARGIN_LEFT 10
#define TIME_LABEL_MARGIN_LEFT 5
#define TIME_LABEL_HEIGHT 20

#define BOTTOM_HEIGHT 45

#define QUESTION_FONT [UIFont systemFontOfSize:14]
#define QUESTION_LABEL_MARGIN_TOP TIME_VIEW_HEIGHT + 10
#define QUESTION_HEIGHT CELL_HEIGHT - TIME_VIEW_HEIGHT - BOTTOM_HEIGHT

#define BOTTOM_BTN_WIDTH 65
#define REPLY_BTN_HEIGHT 21
#define REPLY_BTN_WIDTH 65

#define LINE_HEIGHT 1
#define LINE_COLOR [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]

@implementation MYSPatientQuestionsTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)sendValue:(id)dic
{
    mDic = dic;
    
    // 设定背景为透明色
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *content = [dic objectForKey:@"question_title"];
    CGFloat bgViewHeight = [MYSPatientQuestionsTableViewCell calculateCellHeight:content];
    
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
    timeLabel.text = [dic objectForKey:@"add_time"];
    timeLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:timeLabel];
    
    // 时间分隔线
    UIView *timeLineView = [[UIView alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, TIME_VIEW_HEIGHT - 1, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, LINE_HEIGHT)];
    [timeLineView setBackgroundColor:LINE_COLOR];
    [bgView addSubview:timeLineView];
    /** 时间 end */
    
    /** 问题 start */
    questionLabel = [[UILabel alloc] init];
    questionLabel.numberOfLines = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    questionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    questionLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    questionLabel.font = QUESTION_FONT;
    [self setQuestionLabel:content];
    
    if (20 < [self calculateLabelHeight:content]) {
        // 两行的场合
        questionLabel.frame = CGRectMake(TIME_IMAGE_MARGIN_LEFT, QUESTION_LABEL_MARGIN_TOP, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, 40);
    } else {
        // 一行的场合
        questionLabel.frame = CGRectMake(TIME_IMAGE_MARGIN_LEFT, QUESTION_LABEL_MARGIN_TOP, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, 20);
    }
    [bgView addSubview:questionLabel];
    
    // 问题分隔线
    UIView *questionLineView = [[UIView alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, bgView.frame.size.height - 40, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, LINE_HEIGHT)];
    [questionLineView setBackgroundColor:LINE_COLOR];
    [bgView addSubview:questionLineView];
    /** 问题 end */
    
    /** 底部 start */
    id patient = [dic objectForKey:@"patient"];
    NSString *pName = [patient objectForKey:@"patient_name"];
    // 患者性别
    NSString *pSex = @"男";
    if ([@"0" isEqualToString:[patient objectForKey:@"sex"]])
    {
        pSex = @"女";
    }
    // 患者年龄
    NSString *ageStr = [patient objectForKey:@"age"];
    if ([NSNull null] == ageStr)
    {
        ageStr = @"0";
    }
    NSString *pAge = [NSString stringWithFormat:@"%@岁", ageStr];
    NSString *userInfo = [NSString stringWithFormat:@"%@  %@  %@", pName, pSex, pAge];
    CGFloat userInfoLabelY= bgView.frame.size.height - (TIME_LABEL_HEIGHT + (BOTTOM_HEIGHT - TIME_LABEL_HEIGHT) / 2 - 3);
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, userInfoLabelY, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 3 - BOTTOM_BTN_WIDTH, TIME_LABEL_HEIGHT)];
    userInfoLabel.text = userInfo;
    userInfoLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    userInfoLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:userInfoLabel];
    
    CGFloat replyBtnY= bgView.frame.size.height - (TIME_LABEL_HEIGHT + (BOTTOM_HEIGHT - REPLY_BTN_HEIGHT) / 2 - 3);
    
    // 我的回复按钮
    UIColor *replyBtnColor = [UIColor colorWithRed:0/255.0f green:164/255.0f blue:143/255.0f alpha:1];
    
    UIButton *replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT - REPLY_BTN_WIDTH, replyBtnY, REPLY_BTN_WIDTH, REPLY_BTN_HEIGHT)];
    [replyBtn setTitle:@"我要回复" forState:UIControlStateNormal];
    [replyBtn setTitleColor:replyBtnColor forState:UIControlStateNormal];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    replyBtn.layer.borderWidth = 0.5;
    replyBtn.layer.borderColor = [replyBtnColor CGColor];
    replyBtn.layer.cornerRadius = 3;
    [replyBtn addTarget:self action:@selector(iWantReplyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:replyBtn];
    /** 底部 end */
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

+ (CGFloat)calculateCellHeight:(NSString *)question
{
    MYSPatientQuestionsTableViewCell *cell = [[MYSPatientQuestionsTableViewCell alloc] init];
    
    CGFloat height = CELL_HEIGHT;
    
    if (20 > [cell calculateLabelHeight:question]) {
        height = height - 20;
    }
    
    return height;
}

/**
 *  设定Label颜色
 */
- (void)setQuestionLabel:(NSString *)content
{
    NSString *rangString1 = @"问题: ";
    NSString *rangString2 = content;
    NSString *totalString = [NSString stringWithFormat:@"%@%@", rangString1, rangString2];
    
    UIFont *fontSize = QUESTION_FONT;
    
    UIColor *selectStepColor = [UIColor colorFromHexRGB:KEF8004Color];
    UIColor *unselectStepColor = [UIColor colorFromHexRGB:K333333Color];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:totalString];
    [str addAttribute:NSForegroundColorAttributeName value:selectStepColor range:[totalString rangeOfString:rangString1]];
    [str addAttribute:NSForegroundColorAttributeName value:unselectStepColor range:[totalString rangeOfString:rangString2]];
    [str addAttribute:NSFontAttributeName value:fontSize range:[totalString rangeOfString:rangString1]];
    [str addAttribute:NSFontAttributeName value:fontSize range:[totalString rangeOfString:rangString2]];
    
    questionLabel.attributedText = str;
}

/**
 *  我要回复按钮点击事件
 */
- (void)iWantReplyBtnClick
{
    if ([self.delegate respondsToSelector:@selector(cellBtnClick:)])
    {
        [self.delegate cellBtnClick:mDic];
    }
}

@end
