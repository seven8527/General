//
//  Utils.h
//  Express
//
//  Created by owen on 15/11/11.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaPlayer/MediaPlayer.h"


@interface Utils : NSObject
+ (NSString *)format:(NSString *)string;
+(BOOL) equationOfTimeGT2:(NSString *)nowdates WithLastDate:(NSString *)lastDates;
+(NSString *) getCurrentTime;

//获取原始比例的缩略图
+ (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewsize;
//判断是否为空字符串
+ (BOOL)isBlankString:(NSString *)string;


+(UIImage *)getImage:(NSString *)videoURL;
@end
