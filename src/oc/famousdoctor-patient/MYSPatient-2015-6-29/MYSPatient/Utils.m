//
//  Utils.m
//  MYSPatient
//
//  Created by lyc on 15/5/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)showMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
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

+ (BOOL)checkObjNoNull:(id)obj
{
    if (obj && [NSNull null] != obj)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)checkIsNull:(id)obj
{
    if (!obj || [NSNull null] == obj || [@"" isEqualToString:obj])
    {
        return YES;
    }
    return NO;
}

+ (id)checkObjIsNull:(id)obj
{
    if (!obj || [NSNull null] == obj)
    {
        return @"";
    }
    return obj;
}

@end
