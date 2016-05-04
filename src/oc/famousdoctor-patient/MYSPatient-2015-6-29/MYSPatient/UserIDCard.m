//
//  UserIDCard.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "UserIDCard.h"

@implementation UserIDCard

// 获取年
+ (NSString *)obtainYearWith:(NSString *)IDCard
{
    NSString *newIDCard = IDCard;
    if ([self validate18PaperId:IDCard]) {
        
        if (IDCard.length == 15) {
            newIDCard = [self exchangeTo18IDCardWith:IDCard];
        }
        
        return [self getStringWithRange:newIDCard Value1:6 Value2:4];
    }
    
    return nil;
}

// 获取月
+ (NSString *)obtainMonthWith:(NSString *)IDCard
{
    NSString *newIDCard = IDCard;
    if ([self validate18PaperId:IDCard]) {
        
        if (IDCard.length == 15) {
            newIDCard = [self exchangeTo18IDCardWith:IDCard];
        }
        
        return [self getStringWithRange:newIDCard Value1:10 Value2:2];
    }
    
    return nil;
}

// 获取日
+ (NSString *)obtainDayWith:(NSString *)IDCard
{
    NSString *newIDCard = IDCard;
    if ([self validate18PaperId:IDCard]) {
        
        if (IDCard.length == 15) {
            newIDCard = [self exchangeTo18IDCardWith:IDCard];
        }
        
        return [self getStringWithRange:newIDCard Value1:12 Value2:2];
    }
    
    return nil;
}

// 根据身份证获取生日
+ (NSString *)obtainBirthdayWith:(NSString *)IDCard
{
    NSString *newIDCard = IDCard;
    if ([self validate18PaperId:IDCard]) {
        
        if (IDCard.length == 15) {
            newIDCard = [self exchangeTo18IDCardWith:IDCard];
        }
        
        return [NSString stringWithFormat:@"%@-%@-%@",[self getStringWithRange:newIDCard Value1:6 Value2:4],[self getStringWithRange:newIDCard Value1:10 Value2:2],[self getStringWithRange:newIDCard Value1:12 Value2:2]];
    }
    return nil;
}

// 根据身份证获取年龄
+ (NSString *)obtainAgeWith:(NSString *)IDCard
{
    int IDCardYear = [[self obtainYearWith:IDCard] intValue];
    
    int IDCardMonth = [[self obtainMonthWith:IDCard] intValue];
    
    int IDCardDay = [[self obtainDayWith:IDCard] intValue];
    
    int iAge = 0;//初始化年龄数据
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    NSInteger y = [dd year];
    NSInteger m = [dd month];
    NSInteger d = [dd day];
    
    
    if(IDCardYear | IDCardMonth | IDCardDay)
    {
        if(y > IDCardYear)//现在的年比出生年大
        {
            iAge += y - IDCardYear - 1;
            if(m > IDCardMonth)//现在的月比出生月大
            {
                ++ iAge;
            }
            else if(m == IDCardMonth)//现在的月与出生月一样
            {
                if(d >= IDCardDay)//现在的日比出生日大
                {
                    ++ iAge;
                }
            }
        }
    }
    return [NSString stringWithFormat:@"%d",iAge];

}

// 根据身份证获取性别
+ (NSString *)obtainSexWith:(NSString *)IDCard
{
    NSString *newIDCard = IDCard;
    if ([self validate18PaperId:IDCard]) {
        
        if (IDCard.length == 15) {
            newIDCard = [self exchangeTo18IDCardWith:IDCard];
        }
        LOG(@"%@",[self getStringWithRange:newIDCard Value1:14 Value2:3]);
        int a = [[self getStringWithRange:newIDCard Value1:14 Value2:3] intValue] ;
        if (a % 2 == 1) {
            return @"男";
        } else {
            return @"女";
        }
    }
    return nil;
}


// 15位身份证转为18位身份证
+ (NSString *)exchangeTo18IDCardWith:(NSString *)IDCard
{
    NSString *carid = IDCard;
    
    //加权因子
    int R[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    unsigned char sChecker[11] = {'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};

    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:IDCard];
    if ([IDCard length] == 15) {
        
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
    return mString;
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

@end
