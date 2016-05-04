//
//  MYSFoundationCommon.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-7.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSFoundationCommon.h"
#import "NSString+CalculateTextSize.h"

@implementation MYSFoundationCommon

// 生成图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color withButton:(UIView *)view
{
    CGRect rect = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// 生成图片
+ (UIImage *)imageFromColor:(UIColor *)color withRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(0, 0, contentRect.size.width, contentRect.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//// 计算单位字体的高度
//+ (CGFloat) heightWithFont:(UIFont *)font {
////    NSString *text = @"周";
//    return [@"周" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:font].height;
//}


/**
 *  根据字符串和字体大小计算单行文字求size
 *
 *  @param content 字符串
 *  @param font    字体大小
 *
 *  @return 控件大小
 */
+ (CGSize)sizeWithText:(NSString *)content withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName: font};
    
    return [content boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


/**
 *  根据传入的字符以及字体大小 最大宽度求控件的size
 *
 *  @param content 传入字符串
 *  @param font    字体大小
 *  @param size    最大宽度
 *
 *  @return 控件size
 */
+ (CGSize)sizeWithText:(NSString *)content withFont:(UIFont*) font constrainedToSize:(CGSize)size
{
    NSDictionary * attrs = @{NSFontAttributeName: font};
    
    return [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


// 可展开cell
+ (CGFloat)expandCellHeightWithText:(NSString *)text withFont:(UIFont *)font constrainedToSize:(CGSize)size unExpandHeight:(CGFloat )unExpandHeght withOpenStatus:(BOOL)isOpen topHeight:(CGFloat)topHeight andBottomHeight:(CGFloat)bottomHeight andBottomMargin:(CGFloat)bottomMargin
{
    CGSize textSize = [self sizeWithText:text withFont:font constrainedToSize:size];
    if (isOpen) {
        LOG(@"%f",textSize.height + topHeight + bottomHeight);
        if (iPhone5) {
            return textSize.height + topHeight + bottomHeight + bottomMargin;
        } else {
            return textSize.height + topHeight + bottomHeight + bottomMargin;
        }
        
    } else {
        if (textSize.height >= unExpandHeght) {
             LOG(@"%f",unExpandHeght + topHeight + bottomHeight);
            if(iPhone5){
                return unExpandHeght + bottomHeight +topHeight + bottomMargin/4;
            } else {
                 return unExpandHeght + topHeight + bottomHeight + bottomMargin;
            }
        } else {
             LOG(@"%f",textSize.height + topHeight);
            return textSize.height + topHeight +bottomMargin;
        }
    }
}

// 根据患者性别和生日判断占位图片
+ (NSString *)placeHolderImageWithGender:(NSString *)gender andBirthday:(NSString *)birthday
{
    int birth = 25;
    if (birthday.length > 0) {
        birth = [[self obtainAgeWith:birthday] intValue];
    }
    if([gender isEqualToString:@"0"]) { // 女
        if (birth < 25) {
            return @"favicon_girl";
        } else if (birth > 60) {
            return @"favicon_old-lady";
        } else {
            return @"favicon_lady";
        }
    } else {
        if (birth < 25) {
            return @"favicon_boy";
        } else if (birth > 60) {
            return @"favicon_old-man";
        } else {
            return @"favicon_man";
        }
    }
    return nil;
}


// 根据生日获得年龄
+ (NSString *)obtainAgeWith:(NSString *)birthday
{
    NSInteger year = [[birthday substringToIndex:4] integerValue];
    
    NSInteger month = [[birthday substringWithRange:NSMakeRange(5, 2)] integerValue];
    
    NSInteger day = [[birthday substringWithRange:NSMakeRange(8, 2)] integerValue];
    
    int iAge = 0;//初始化年龄数据
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    NSInteger y = [dd year];
    NSInteger m = [dd month];
    NSInteger d = [dd day];
    
    
    if(year | month | day)
    {
        if(y > year)//现在的年比出生年大
        {
            iAge += y - year - 1;
            if(m > month)//现在的月比出生月大
            {
                ++ iAge;
            }
            else if(m == month)//现在的月与出生月一样
            {
                if(d >= day)//现在的日比出生日大
                {
                    ++ iAge;
                }
            }
        }
    }
    return [NSString stringWithFormat:@"%d",iAge];
    
}
@end
