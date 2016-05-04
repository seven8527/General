//
//  TEValidateTools.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-12.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEValidateTools.h"

@implementation TEValidateTools


// 判断是否为数字
+ (BOOL)validateNumber:(NSString *)number
{
    NSString *numberRegex = @"[0-9]+";
	NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
	return [passwordPredicate evaluateWithObject:number];
}

// 判断是否为非0的正整数
+ (BOOL)validatePositiveNumber:(NSString *)number
{
    NSString *numberRegex = @"^\\+?[1-9][0-9]*$";
	NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
	return [passwordPredicate evaluateWithObject:number];
}

// 验证邮箱有效性
+ (BOOL)validateEmail:(NSString*)email
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
	return [emailPredicate evaluateWithObject:email];
}

// 验证手机有效性
+ (BOOL)validateMobile:(NSString *)mobileNum;
{
    NSString *mobileRegex = @"^1\\d{10}$";
    NSPredicate *predicateMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [predicateMobile evaluateWithObject:mobileNum];
}

// 验证固定电话
+ (BOOL)validateFixedLine:(NSString *)fixedLine
{
    NSString *fixedLineRegex = @"^(0[0-9]{2,3})-([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$";
    NSPredicate *predicateMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", fixedLineRegex];
    return [predicateMobile evaluateWithObject:fixedLine];
    
}

// 判断密码
+ (BOOL)validatePassword:(NSString *)password
{
    NSString *passwordRegex = @"[A-Z0-9a-z]+";
	NSPredicate *predicatePassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
	return [predicatePassword evaluateWithObject:password];
}

// 判断用户名
+ (BOOL)validateUserName:(NSString *)userName
{
	NSString *accountRegex = @"[A-Z0-9a-z]{6,20}";
	NSPredicate *predicateAccount = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",accountRegex];
	return [predicateAccount evaluateWithObject:userName];
}


/**
 *  获取指定范围的字符串
 *
 *  @param str    目标字符串
 *  @param value1 字符串的开始下标
 *  @param value2 字符串的结束下标
 *
 *  @return 截取后的字符串
 */
+ (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2;
{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}


/**
 *  判断是否在地区码内
 *
 *  @param code 地区码
 *
 *  @return 是否在地区码内
 */
+ (BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    
    return YES;
}


/**
 *  验证身份证是否合法
 *
 *  @param sPaperId 输入的身份证号
 *
 *  @return 是否是合法的身份证
 */
+ (BOOL)validate18PaperId:(NSString *) sPaperId
{
    //判断位数
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    
    long lSumQT =0;
    
    //加权因子
    int R[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    unsigned char sChecker[11] = {'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == 15) {
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i = 0; i <= 16; i++)
        {
            p += (pid[i] - 48) * R[i];
        }
        
        int o = p % 11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
    }
    
    //判断地区码
    NSString *sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        
        return NO;
        
    }
    
    //判断年月日是否有效

    //年份
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    
    //月份
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    

    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId)) return -1;

    //校验数字
    for (int i = 0; i < 18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    
    //验证最末的校验码
    for (int i = 0; i <= 16; i++)
    {
        lSumQT += (PaperId[i] - 48) * R[i];
    }
    
    if (sChecker[lSumQT % 11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}

// 验证输入中文英文字符集
+ (BOOL)validatechineseAndEngSet:(NSString *)aString
{
    NSString * const regularExpression = @"^[\u4e00-\u9fa5_a-zA-Z]+$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:aString
                                                        options:0
                                                          range:NSMakeRange(0, [aString length])];
    return numberOfMatches > 0;
}

@end
