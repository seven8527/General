//
//  MYSNetConsultationTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSNetConsultationTableViewCell.h"

#define CELL_HEIGHT 160
#define BG_MARGIN_TOP 10
#define BG_MARGIN_LEFT 10

#define TIME_VIEW_HEIGHT 34
#define TIME_IMAGE_W_H 10
#define TIME_IMAGE_MARGIN_LEFT 10
#define TIME_LABEL_MARGIN_LEFT 5
#define TIME_LABEL_HEIGHT 20

#define DD_LABEL_W 48

#define BOTTOM_HEIGHT 40
#define BOTTOM_BTN_WIDTH 65
#define REPLY_BTN_HEIGHT 21
#define REPLY_BTN_WIDTH 65

#define CONTENT_FONT [UIFont systemFontOfSize:14]
#define LINE_HEIGHT 1
#define LINE_COLOR [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]

@implementation MYSNetConsultationTableViewCell

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
    
    NSString *content = [dic objectForKey:@"question"];
    CGFloat bgViewHeight = [MYSNetConsultationTableViewCell calculateCellHeight:content];
    
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
    timeLabel.text = [dic objectForKey:@"add_date"];
    timeLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:timeLabel];
    
    // 信息审核状态
    UILabel *shenheLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT - 120, (TIME_VIEW_HEIGHT - TIME_LABEL_HEIGHT) / 2, 120, TIME_LABEL_HEIGHT)];
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    shenheLabel.textAlignment = NSTextAlignmentRight;
#else
    shenheLabel.textAlignment = UITextAlignmentRight;
#endif
    shenheLabel.font = [UIFont systemFontOfSize:12];
    shenheLabel.textColor = [UIColor colorFromHexRGB:KEF8004Color];
    
    NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
    if (1 == audit_status)
    {
        shenheLabel.text = @"已确认时间";
    } else if (2 == audit_status) {
        shenheLabel.text = @"审核通过";
    } else if (3 == audit_status) {
        shenheLabel.text = @"已完成";
    }
    
    [bgView addSubview:shenheLabel];
    
    // 时间分隔线
    UIView *timeLineView = [[UIView alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, TIME_VIEW_HEIGHT - 1, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, LINE_HEIGHT)];
    [timeLineView setBackgroundColor:LINE_COLOR];
    [bgView addSubview:timeLineView];
    /** 时间 end */
    
    /** 内容 start */
    // 订单
    UILabel *dingdanLabel = [[UILabel alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, timeLineView.frame.origin.y + 5, DD_LABEL_W, TIME_LABEL_HEIGHT)];
    dingdanLabel.font = [UIFont systemFontOfSize:12];
    dingdanLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    dingdanLabel.text = @"订单号：";
    [bgView addSubview:dingdanLabel];
    // 订单号
    UILabel *dingdanNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT + DD_LABEL_W, dingdanLabel.frame.origin.y, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2 - DD_LABEL_W, TIME_LABEL_HEIGHT)];
    dingdanNumLabel.font = [UIFont systemFontOfSize:12];
    dingdanNumLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    dingdanNumLabel.text = [dic objectForKey:@"billno"];
    [bgView addSubview:dingdanNumLabel];

#pragma mark 内容布局
    // 内容
    questionLabel = [[UILabel alloc] init];
    questionLabel.numberOfLines = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    questionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    questionLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    questionLabel.font = CONTENT_FONT;
    
    CGFloat questionLabelY = dingdanLabel.frame.origin.y + TIME_LABEL_HEIGHT;
    questionLabel.text = content;
    if (20 < [self calculateLabelHeight:content]) {
        // 两行的场合
        questionLabel.frame = CGRectMake(TIME_IMAGE_MARGIN_LEFT, questionLabelY, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, 40);
    } else {
        // 一行的场合
        questionLabel.frame = CGRectMake(TIME_IMAGE_MARGIN_LEFT, questionLabelY, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, 20);
    }
    [bgView addSubview:questionLabel];

    // 问题分隔线
    UIView *questionLineView = [[UIView alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, bgView.frame.size.height - BOTTOM_HEIGHT, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 2, LINE_HEIGHT)];
    [questionLineView setBackgroundColor:LINE_COLOR];
    [bgView addSubview:questionLineView];
    /** 内容 end */
    
#pragma mark 底部布局
    /** bottom start */
    id patient = [dic objectForKey:@"patient"];
    NSString *pName = [patient objectForKey:@"patient_name"];
    // 患者性别
    NSString *pSex = @"男";
    if ([@"0" isEqualToString:[patient objectForKey:@"sex"]])
    {
        pSex = @"女";
    }
    
    // 患者年龄
    NSString *pAge = [NSString stringWithFormat:@"%@岁", [MYSUtils getAgeFromBirthday:[patient objectForKey:@"birthday"]]];
    NSString *userInfo = [NSString stringWithFormat:@"%@  %@  %@", pName, pSex, pAge];
    
    CGFloat userInfoLabelY= bgView.frame.size.height - (TIME_LABEL_HEIGHT + (BOTTOM_HEIGHT - TIME_LABEL_HEIGHT) / 2 + 1);
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(TIME_IMAGE_MARGIN_LEFT, userInfoLabelY, bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT * 3 - BOTTOM_BTN_WIDTH, TIME_LABEL_HEIGHT)];
    userInfoLabel.text = userInfo;
    userInfoLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    userInfoLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:userInfoLabel];
    
    CGFloat replyBtnY = bgView.frame.size.height - (TIME_LABEL_HEIGHT + (BOTTOM_HEIGHT - REPLY_BTN_HEIGHT) / 2 + 1);
    
    // 我的回复按钮
    UIColor *replyBtnColor = [UIColor colorWithRed:0/255.0f green:164/255.0f blue:143/255.0f alpha:1];
    
    UIButton *replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.size.width - TIME_IMAGE_MARGIN_LEFT - REPLY_BTN_WIDTH, replyBtnY, REPLY_BTN_WIDTH, REPLY_BTN_HEIGHT)];
    
    if (3 == audit_status) {
        [replyBtn setTitle:@"查看" forState:UIControlStateNormal];
        [replyBtn addTarget:self action:@selector(lookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [replyBtn setTitleColor:replyBtnColor forState:UIControlStateNormal];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    replyBtn.layer.borderWidth = 0.5;
    replyBtn.layer.borderColor = [replyBtnColor CGColor];
    replyBtn.layer.cornerRadius = 3;
    
    [bgView addSubview:replyBtn];
    /** bottom start */
}

- (void)replyBtnClick
{
    if ([self.delegate respondsToSelector:@selector(cellBtnClick:)])
    {
        [self.delegate cellBtnClick:mDic];
    }
}

- (void)lookBtnClick
{
    if ([self.delegate respondsToSelector:@selector(cellBtnClick:)])
    {
        [self.delegate cellBtnClick:mDic];
    }
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content
{
    // 给一个比较大的高度，宽度不变
    CGSize size = CGSizeMake(kScreen_Width - BG_MARGIN_LEFT * 2 - TIME_IMAGE_MARGIN_LEFT * 2, 5000);
    CGSize actualsize;
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
    MYSNetConsultationTableViewCell *cell = [[MYSNetConsultationTableViewCell alloc] init];
    CGFloat height = CELL_HEIGHT;
    if (20 > [cell calculateLabelHeight:content])
    {
        height = height - 20;
    }
    return height;
}

@end
