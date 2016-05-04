//
//  MYSUtils.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSUtils.h"

@implementation MYSUtils

/**
 *  从生日获取年龄
 */
+ (NSString *)getAgeFromBirthday:(NSString *)birthday
{
    if (!birthday || [NSNull null] == birthday || birthday.length != 10)
    {
        return @"0";
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSTimeInterval dateDiff = [[format dateFromString:birthday] timeIntervalSinceNow];
    NSInteger age = fabs(trunc(dateDiff/(60*60*24))/365);
    return [NSString stringWithFormat:@"%ld", age];
}

/**
 *  从身份证获取年龄
 */
+ (NSString *)getAgeFromID:(NSString *)ID
{
    if (!ID || [NSNull null] == ID || ID.length != 18)
    {
        return @"0";
    }
    NSRange range = {6, 8};
    NSString *birthday = [ID substringWithRange:range];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMdd";
    NSTimeInterval dateDiff = [[format dateFromString:birthday] timeIntervalSinceNow];
    NSInteger age = fabs(trunc(dateDiff/(60*60*24))/365);
    return [NSString stringWithFormat:@"%ld", age];
}

/**
 *  检测身高
 */
+ (NSString *)checkHeight:(NSString *)height
{
    if (!height || [NSNull null] == height)
    {
        return @"0cm";
    }
    return [NSString stringWithFormat:@"%@cm", height];
}

/**
 *  检测体重
 */
+ (NSString *)checkWeight:(NSString *)weight
{
    if (!weight || [NSNull null] == weight)
    {
        return @"0cm";
    }
    return [NSString stringWithFormat:@"%@kg", weight];
}

/**
 *  check对象是否为空，如果为空则返回@""
 */
+ (NSString *)checkIsNull:(id)obj
{
    if (!obj || [NSNull null] == obj)
    {
        return @"";
    }
    return obj;
}

/**
 *  check对象是否为空，如果为空则返回0
 */
+ (NSString *)checkIsNullReturnZero:(id)obj
{
    if (!obj || [NSNull null] == obj)
    {
        return @"0";
    }
    return obj;
}

/**
 *  check手机号是否正确
 *
 *  @param phone 手机号码
 *
 *  @return YES 正确
 */
+ (BOOL)checkCellPhoneNum:(NSString *)phone
{
    NSString *regex = @"^((13[0-9])|(147)|(15[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phone];
    return isMatch;
}

/**
 *  check座机号是否正确
 *
 *  @param phone 手机号码
 *
 *  @return YES 正确
 */
+ (BOOL)checkPhoneNum:(NSString *)phone
{
    NSString *regex = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phone];
    return isMatch;
}

/**
 *  获取订单状态
 *
 *  @param phone 状态ID
 *
 *  @return 状态
 */
+ (NSString *)getOderStatus:(NSInteger)mAudit_status
{
    NSString *typeStr = @"";
    switch (mAudit_status)
    {
        case 1:
            typeStr = @"审核通过";
            break;
        case 2:
            typeStr = @"等待咨询";
            break;
        case 3:
            typeStr = @"已完成";
            break;
        case 4:
            typeStr = @"已取消";
            break;
        case 5:
            typeStr = @"爽约";
            break;
        case 7:
            typeStr = @"退款申请中";
            break;
        case 8:
            typeStr = @"退款已审核";
            break;
        case 9:
            typeStr = @"已退款";
            break;
        default:
            break;
    }
    
    return typeStr;
}

@end
