//
//  MYSUserInfoManager.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSUserInfoManager : NSObject

@property (nonatomic, strong) NSString *phone; // 手机号码
@property (nonatomic, strong) NSString *userId; // 用户id
@property (nonatomic, strong) NSString *cookie; // cookie
@property (nonatomic, strong) NSString *doctor_type; // 医生类型
@property (nonatomic, strong) NSString *doctor_name; // 医生名称
@property (nonatomic, strong) NSString *doctor_pic; // 医生头像

+ (MYSUserInfoManager *)shareInstance;
- (void)clearnData;
@end
