//
//  Utils.m
//  Express
//
//  Created by owen on 15/11/11.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "Utils.h"

@implementation Utils
//
//+ (NSString *)format:(NSString *)string{
//    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate*inputDate = [inputFormatter dateFromString:string];
//    //NSLog(@"startDate= %@", inputDate);
//    
//    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
//    [outputFormatter setLocale:[NSLocale currentLocale]];
//    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    //get date str
//    NSString *str= [outputFormatter stringFromDate:inputDate];
//    //str to nsdate
//    NSDate *strDate = [outputFormatter dateFromString:str];
//    //修正8小时的差时
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: strDate];
//    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
//    //NSLog(@"endDate:%@",endDate);
//    NSString *lastTime = [self compareDate:endDate];
////    NSLog(@"lastTime = %@",lastTime);
//    return lastTime;
//}



+ (NSString *)format:(NSString *)string{
//    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*inputDate = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]/1000];
//    NSLog(@"startDate= %@", inputDate);

    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //get date str
    NSString *str= [outputFormatter stringFromDate:inputDate];
    //str to nsdate
    NSDate *strDate = [outputFormatter dateFromString:str];
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
//    NSLog(@"endDate:%@",endDate);
    NSString *lastTime = [self compareDate:endDate];
//    NSLog(@"lastTime = %@",lastTime);
    return lastTime;
}


//+ (NSString *)format:(NSString *)string{
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    long long  date = [string longLongValue]/1000;
//    NSDate *dd = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]/1000];
//    return lastTime;
//}
+(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    //NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            return time2;
        }
    }else{
        return dateString;
    }
}



+(BOOL) equationOfTimeGT2:(NSString *)anowdate WithLastDate:(NSString *)lastDate
{

    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:anowdate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
//    NSLog(@"fromdate=%@",fromDate);
    
    
   
    NSDate *fromdate1=[format dateFromString:lastDate];
    NSInteger frominterval1 = [fromzone secondsFromGMTForDate: fromdate1];
    NSDate *fromDate1 = [fromdate1  dateByAddingTimeInterval: frominterval1];
//    NSLog(@"fromdate=%@",fromDate1);
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [fromDate1 timeIntervalSinceReferenceDate];
    
//    //获取当前时间
//    NSDate *date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//    NSLog(@"enddate=%@",localeDate);
//    
//    
//    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    
//    long lTime = (long)intervalTime;
//    NSInteger iSeconds = lTime % 60;
//    NSInteger iMinutes = (lTime / 60) % 60;
//    NSInteger iHours = (lTime / 3600);
//    NSInteger iDays = lTime/60/60/24;
//    NSInteger iMonth = lTime/60/60/24/12;
//    NSInteger iYears = lTime/60/60/24/384;
    
//    NSLog(@"相差M年d月 或者 d日d时d分d秒", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
    if (intervalTime >= 60*2) {
        return YES;
    }
    else
    {
        return NO;
    }
}



+(NSString *) getCurrentTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   return  [dateformatter stringFromDate:senddate];
}



//计算适合的大小。并保留其原始图片大小 ，根据高度计算

+ (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize
{
    CGFloat scale;
    CGSize newsize = thisSize;
    scale = newsize.width / newsize.height;
    newsize.width = scale*aSize.height;
    newsize.height = aSize.height;
    return newsize;
}

//返回调整的缩略图
+ (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewsize
{
    // calculate the fitted size
    CGSize size = [self fitSize:image.size inSize:viewsize];
    UIGraphicsBeginImageContext(size);
//    float dwidth = (size.width ) / 2.0f;
//    float dheight = (size.height ) / 2.0f;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}



//ios 判断字符串为空和只为空格
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES; 
    } 
    return NO; 
}

+(UIImage *)getImage:(NSString *)videoURL
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}
@end
