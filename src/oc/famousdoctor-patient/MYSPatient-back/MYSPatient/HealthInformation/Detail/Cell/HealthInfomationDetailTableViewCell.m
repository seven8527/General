//
//  HealthInfomationDetailTableViewCell.m
//  MYSPatient
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "HealthInfomationDetailTableViewCell.h"
#import "UIColor+Hex.h"

#define MARGIN_LEFT 15
#define TITLE_MARGIN_TOP 15
#define USER_TIMEMARGIN_TOP 3

#define TITLE_FONT [UIFont boldSystemFontOfSize:17]
#define CONTENT_FONT [UIFont systemFontOfSize:16]
#define SOURCE_FONT [UIFont systemFontOfSize:13]

@implementation HealthInfomationDetailTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)sendValue:(id)dic
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //@"这是测试Title这是测试Title这是测试Title这是测试Title这是测试Title这是测试Title这是测试Title这是测试Title这是测试Title";//
    NSString *title = [Utils checkObjIsNull:[dic objectForKey:@"title"]];
    NSString *content = [Utils checkObjIsNull:[dic objectForKey:@"content"]];
    CGFloat titleHeight = [self calculateLabelHeight:title font:TITLE_FONT];
    CGFloat contentHeight = [self calculateAttrLabelHeight:[self getAttrStr:content]];
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    if (titleHeight > 25)
    {   // 两行的场合
        titleLabel.frame = CGRectMake(MARGIN_LEFT, TITLE_MARGIN_TOP, kScreen_Width - MARGIN_LEFT * 2, 42);
    } else {
        // 一行的场合
        titleLabel.frame = CGRectMake(MARGIN_LEFT, TITLE_MARGIN_TOP, kScreen_Width - MARGIN_LEFT * 2, 21);
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    titleLabel.font = TITLE_FONT;
    [self addSubview:titleLabel];
    
    NSString *sourceStr = @"";
    
    NSString *source = [dic objectForKey:@"source"];
    if (![Utils checkIsNull:source])
    {
        sourceStr = source;
    }
    NSString *publish_time = [dic objectForKey:@"publish_time"];
    if (![Utils checkIsNull:publish_time])
    {
        if ([Utils checkIsNull:source])
        {
            sourceStr = publish_time;
        } else {
            sourceStr = [NSString stringWithFormat:@"%@ %@", sourceStr, publish_time];
        }
    }
    
    // 来源和时间
    UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, titleLabel.frame.origin.y + titleLabel.frame.size.height + USER_TIMEMARGIN_TOP, kScreen_Width - MARGIN_LEFT * 2, 21)];
    sourceLabel.text = sourceStr;
    sourceLabel.textColor = [UIColor colorFromHexRGB:K8F8F8FColor];
    sourceLabel.font = SOURCE_FONT;
    [self addSubview:sourceLabel];
 
    // 画虚线
    xuXianImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_LEFT, sourceLabel.frame.origin.y + sourceLabel.frame.size.height + 10, kScreen_Width - MARGIN_LEFT * 2, 1)];
    [self addSubview:xuXianImage];
    [self huaXuXian];
    
    // contentLabel
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(MARGIN_LEFT, xuXianImage.frame.origin.y + 15, kScreen_Width - MARGIN_LEFT * 2, contentHeight);
    contentLabel.numberOfLines = 0;
    contentLabel.attributedText = [self getAttrStr:content];
    [self addSubview:contentLabel];
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
    return actualsize.height + 4;
}

- (NSAttributedString *)getAttrStr:(NSString *)content
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    [attrStr addAttribute:NSFontAttributeName value:CONTENT_FONT range:NSMakeRange(0, attrStr.string.length)];
    // 行间距设定
    [attrStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:4] range:NSMakeRange(0, attrStr.string.length)];
    //字间距设定
//    [attrStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:1.2] range:NSMakeRange(0, attrStr.string.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexRGB:K333333Color] range:NSMakeRange(0, attrStr.string.length)];
    
    return attrStr;
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

+ (CGFloat)calculateCellHeight:(NSString *)title content:(NSString *)content
{
    HealthInfomationDetailTableViewCell *cell = [[HealthInfomationDetailTableViewCell alloc] init];
    CGFloat height = TITLE_MARGIN_TOP + 42 + 10 + 21 + 10 + 1;
    if ([cell calculateLabelHeight:title font:TITLE_FONT] < 25)
    {
        height = height - 22;
    }
    
    NSAttributedString *attrStr = [cell getAttrStr:content];
    height = height + [cell calculateAttrLabelHeight:attrStr] + 20;
    
    return height;
}

@end
