//
//  MYSUtils.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSUtils : NSObject

/**
 *  从生日获取年龄
 */
+ (NSString *)getAgeFromBirthday:(NSString *)birthday;

/**
 *  从身份证获取年龄
 */
+ (NSString *)getAgeFromID:(NSString *)ID;

/**
 *  检测身高
 */
+ (NSString *)checkHeight:(NSString *)height;

/**
 *  检测体重
 */
+ (NSString *)checkWeight:(NSString *)weight;

/**
 *  check对象是否为空，如果为空则返回@""
 */
+ (NSString *)checkIsNull:(id)obj;

/**
 *  check对象是否为空，如果为空则返回0
 */
+ (NSString *)checkIsNullReturnZero:(id)obj;

/**
 *  check手机号是否正确
 *
 *  @param phone 手机号码
 *
 *  @return YES 正确
 */
+ (BOOL)checkCellPhoneNum:(NSString *)phone;

/**
 *  check座机号是否正确
 *
 *  @param phone 手机号码
 *
 *  @return YES 正确
 */
+ (BOOL)checkPhoneNum:(NSString *)phone;

/**
 *  获取订单状态
 *
 *  @param phone 状态ID
 *
 *  @return 状态
 */
+ (NSString *)getOderStatus:(NSInteger)mAudit_status;

@end
