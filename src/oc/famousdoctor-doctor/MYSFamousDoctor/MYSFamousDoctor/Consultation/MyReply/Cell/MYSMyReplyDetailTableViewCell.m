//
//  MYSMyReplyDetailTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyReplyDetailTableViewCell.h"

#define HEAD_IMG_MARGIN_LEFT 15
#define HEAD_IMG_W_H 30
#define USERINFO_MARGIN_HEAD 5
#define TIME_LABEL_W 110

#define CONTENT_FONT [UIFont systemFontOfSize:14]

#define LINE_HEIGHT 1
#define LINE_COLOR [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]

@implementation MYSMyReplyDetailTableViewCell

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
 *  初始化Cell
 */
- (void)initCell:(id)dic
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 数据类型属于第一条还是非第一条
    NSString *dataType = [dic objectForKey:@"type"];
    
    // 数据是患者发出，还是医生发出   0，患者  1医生
    NSString *dataKind = [dic objectForKey:@"kind"];
    
    /** 头部信息 start */
    // 头像Image
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(HEAD_IMG_MARGIN_LEFT, HEAD_IMG_MARGIN_LEFT, HEAD_IMG_W_H, HEAD_IMG_W_H)];
    headImageView.layer.cornerRadius = HEAD_IMG_W_H / 2;
    headImageView.layer.masksToBounds = YES;
    
    NSString *imageUrl = [dic objectForKey:@"pic"];
    if ([NSNull null] == imageUrl)
    {
        imageUrl = @"";
    }
    NSURL *url = [NSURL URLWithString:imageUrl];
    if ([@"0" isEqualToString:dataKind])
    {
        [headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"favicon_man"]];
    } else {
        [headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
    }
    
    [self addSubview:headImageView];
    
    // 用户姓名、性别、年龄
    CGFloat userInfoX = HEAD_IMG_MARGIN_LEFT + USERINFO_MARGIN_HEAD + HEAD_IMG_W_H;
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(userInfoX, HEAD_IMG_MARGIN_LEFT, kScreen_Width - userInfoX - TIME_LABEL_W - USERINFO_MARGIN_HEAD*2, HEAD_IMG_W_H)];
    userInfoLabel.text = [dic objectForKey:@"name"];
    userInfoLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    userInfoLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:userInfoLabel];
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - HEAD_IMG_MARGIN_LEFT - TIME_LABEL_W, HEAD_IMG_MARGIN_LEFT, TIME_LABEL_W, HEAD_IMG_W_H)];
    timeLabel.text = [dic objectForKey:@"add_time"];
    timeLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
    timeLabel.font = [UIFont systemFontOfSize:12];
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    timeLabel.textAlignment = NSTextAlignmentRight;
#else
    timeLabel.textAlignment = UITextAlignmentRight;
#endif
    [self addSubview:timeLabel];
    /** 头部信息 end */
    
    /** 内容 start */
    NSString *content = [dic objectForKey:@"content"];
    
    contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    contentLabel.text = content;
    contentLabel.font = CONTENT_FONT;
    contentLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    
    CGFloat contentWidth = 0;
    if ([@"first" isEqualToString:dataType])
    {
        contentWidth = kScreen_Width - HEAD_IMG_MARGIN_LEFT * 2;
    } else {
        contentWidth = kScreen_Width - (HEAD_IMG_MARGIN_LEFT + USERINFO_MARGIN_HEAD + HEAD_IMG_W_H) - HEAD_IMG_MARGIN_LEFT;
    }
    CGFloat contentHeight = [self calculateLabelHeight:content width:contentWidth];
    contentLabel.frame = CGRectMake(kScreen_Width - contentWidth - HEAD_IMG_MARGIN_LEFT, headImageView.frame.origin.y + HEAD_IMG_W_H + HEAD_IMG_MARGIN_LEFT, contentWidth, contentHeight);
    [self addSubview:contentLabel];
    /** 内容 end */
    
    /** 底部边线 start */
    CGFloat bottomLineY = [MYSMyReplyDetailTableViewCell calculateCellHeight:content type:[dic objectForKey:@"type"]] - LINE_HEIGHT;
    
    UIView *bottomLine = [[UIView alloc] init];
    if ([@"first" isEqualToString:dataType])
    {
        bottomLine.frame = CGRectMake(0, bottomLineY, kScreen_Width, LINE_HEIGHT);
    } else {
        bottomLine.frame = CGRectMake(contentLabel.frame.origin.x, bottomLineY, kScreen_Width - contentLabel.frame.origin.x, LINE_HEIGHT);
    }
    [bottomLine setBackgroundColor:LINE_COLOR];
    [self addSubview:bottomLine];
    /** 底部边线 end */
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content width:(CGFloat)width
{
    // 给一个比较大的高度，宽度不变
    CGSize size = CGSizeMake(width, 5000);
    
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

+ (CGFloat)calculateCellHeight:(NSString *)content type:(NSString *)type
{
    MYSMyReplyDetailTableViewCell *cell = [[MYSMyReplyDetailTableViewCell alloc] init];
    
    CGFloat contentWidth = 0;
    if ([@"first" isEqualToString:type])
    {
        contentWidth = kScreen_Width - HEAD_IMG_MARGIN_LEFT * 2;
    } else {
        contentWidth = kScreen_Width - (HEAD_IMG_MARGIN_LEFT + USERINFO_MARGIN_HEAD + HEAD_IMG_W_H) - HEAD_IMG_MARGIN_LEFT;
    }
    CGFloat contentHeight = [cell calculateLabelHeight:content width:contentWidth];

    CGFloat height = HEAD_IMG_MARGIN_LEFT * 2 + HEAD_IMG_W_H + contentHeight + 15;
    return height;
}

@end
