//
//  UserIDCard.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserIDCard : NSObject

// 根据身份证获取生日 年
+ (NSString *)obtainYearWith:(NSString *)IDCard;

// 根据身份证获取生日 月
+ (NSString *)obtainMonthWith:(NSString *)IDCard;

// 根据身份证获取生日 日
+ (NSString *)obtainDayWith:(NSString *)IDCard;

// 根据身份证获取生日
+ (NSString *)obtainBirthdayWith:(NSString *)IDCard;

// 根据身份证获取年龄
+ (NSString *)obtainAgeWith:(NSString *)IDCard;

// 根据身份证获取性别
+ (NSString *)obtainSexWith:(NSString *)IDCard;

@end
