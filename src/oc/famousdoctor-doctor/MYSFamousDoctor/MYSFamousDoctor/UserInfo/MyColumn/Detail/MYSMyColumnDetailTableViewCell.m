//
//  MYSMyColumnDetailTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyColumnDetailTableViewCell.h"
#import "NSString+EMAdditions.h"
#import "EMStringStylingConfiguration.h"

#define TOP_HEIGHT 90

#define MARGIN_LEFT 15

#define TITLE_MARGIN_TOP 15
#define USER_TIMEMARGIN_TOP 3
#define USER_TIME_W kScreen_Width / 2
#define USER_TIME_H 20

#define TITLE_FONT [UIFont systemFontOfSize:15]
#define CONTENT_FONT [UIFont systemFontOfSize:14]
#define NAME_FONT [UIFont systemFontOfSize:11]

@implementation MYSMyColumnDetailTableViewCell

- (void)sendValue:(id)dic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *title = [MYSUtils checkIsNull:[dic objectForKey:@"title"]];
    NSString *content = [MYSUtils checkIsNull:[dic objectForKey:@"contents"]];
    CGFloat titleHeight = [self calculateLabelHeight:title font:TITLE_FONT];
    CGFloat contentHeight = [self calculateAttrLabelHeight:[self getAttrStr:content]];
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    if (titleHeight > 20)
    {   // 两行的场合
        titleLabel.frame = CGRectMake(MARGIN_LEFT, TITLE_MARGIN_TOP, kScreen_Width - MARGIN_LEFT * 2, 42);
    } else {
        // 一行的场合
        titleLabel.frame = CGRectMake(MARGIN_LEFT, TITLE_MARGIN_TOP, kScreen_Width - MARGIN_LEFT * 2, 21);
    }
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
#else
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
#endif
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorFromHexRGB:K363636Color];
    titleLabel.font = TITLE_FONT;
    [self addSubview:titleLabel];
    
    NSString *add_date = [MYSUtils checkIsNull:[dic objectForKey:@"add_date"]];
    if (add_date.length > 10)
    {
        add_date = [add_date substringToIndex:10];
    }
    
    // 用户名和时间
    UILabel *userAndTime = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, titleLabel.frame.origin.y + titleLabel.frame.size.height + USER_TIMEMARGIN_TOP, USER_TIME_W, USER_TIME_H)];
    userAndTime.text = [NSString stringWithFormat:@"%@  %@", [dic objectForKey:@"doctor_name"], add_date];
    userAndTime.textColor = [UIColor colorFromHexRGB:K999999Color];
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    userAndTime.textAlignment = NSTextAlignmentRight;
#else
    userAndTime.textAlignment = UITextAlignmentRight;
#endif
    userAndTime.font = NAME_FONT;
    [self addSubview:userAndTime];
    
    // 阅读书目
    UIImageView *lookNumImage = [[UIImageView alloc] initWithFrame:CGRectMake(userAndTime.frame.origin.x + USER_TIME_W + 15, titleLabel.frame.origin.y + titleLabel.frame.size.height + USER_TIMEMARGIN_TOP + 5, 14, 10)];
    lookNumImage.image = [UIImage imageNamed:@"personal_information_column_browse"];
    [self addSubview:lookNumImage];
    
    NSString *view_time = [dic objectForKey:@"view_time"];
    if (!view_time || [NSNull null] == view_time || [@"" isEqualToString:view_time])
    {
        view_time = @"0";
    }
    UILabel *lookNum = [[UILabel alloc] initWithFrame:CGRectMake(lookNumImage.frame.origin.x + 16, userAndTime.frame.origin.y, 100, USER_TIME_H)];
    lookNum.text = view_time;
    lookNum.textColor = [UIColor colorFromHexRGB:K999999Color];
    lookNum.font = NAME_FONT;
    [self addSubview:lookNum];
    
    // 画虚线
    xuXianImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_LEFT, userAndTime.frame.origin.y + userAndTime.frame.size.height + 10, kScreen_Width - MARGIN_LEFT * 2, 1)];
    [self addSubview:xuXianImage];
    [self huaXuXian];
    
    // contentLabel
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(MARGIN_LEFT, xuXianImage.frame.origin.y + 15, kScreen_Width - MARGIN_LEFT * 2, contentHeight);
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
#else
    contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
#endif
    contentLabel.numberOfLines = 0;
    contentLabel.attributedText = [self getAttrStr:content];
    contentLabel.textColor = [UIColor colorFromHexRGB:K8F8F8FColor];
    [self addSubview:contentLabel];
}

- (void)huaXuXian
{
    UIGraphicsBeginImageContext(xuXianImage.frame.size);   //开始画线
    [xuXianImage.image drawInRect:CGRectMake(0, 0, xuXianImage.frame.size.width, xuXianImage.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    CGFloat lengthsssss[] = {1,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorFromHexRGB:KC2C1C0Color].CGColor);
    
    CGContextSetLineDash(line, 0, lengthsssss, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, xuXianImage.frame.size.height);    //开始画线
    CGContextAddLineToPoint(line, xuXianImage.frame.size.width, xuXianImage.frame.size.height);
    CGContextStrokePath(line);
    
    xuXianImage.image = UIGraphicsGetImageFromCurrentImageContext();
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content font:(UIFont *)font
{
    // 给一个比较大的高度，宽度不变
    CGSize size = CGSizeMake(kScreen_Width - MARGIN_LEFT * 2, 5000);
    
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
 * 计算一个文字段的高度
 */
- (CGFloat)calculateAttrLabelHeight:(NSAttributedString *)content
{
    // 给一个比较大的高度，宽度不变
    CGSize size = CGSizeMake(kScreen_Width - MARGIN_LEFT * 2, 10000);
    CGSize actualsize;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    actualsize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading context:nil].size;
#endif
    return actualsize.height;
}

+ (CGFloat)calculateCellHeight:(NSString *)title content:(NSString *)content
{
    MYSMyColumnDetailTableViewCell *cell = [[MYSMyColumnDetailTableViewCell alloc] init];
    CGFloat height = TOP_HEIGHT;
    if ([cell calculateLabelHeight:title font:TITLE_FONT] < 20)
    {
        height = height - 22;
    }
    
    NSAttributedString *attrStr = [cell getAttrStr:content];
    height = height + [cell calculateAttrLabelHeight:attrStr] + 5;
    
    return height;
}

- (NSAttributedString *)getAttrStr:(NSString *)content
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    [attrStr addAttribute:NSFontAttributeName value:CONTENT_FONT range:NSRangeFromString(content)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:K8F8F8FColor] range:NSRangeFromString(content)];

    return attrStr;
}

@end
