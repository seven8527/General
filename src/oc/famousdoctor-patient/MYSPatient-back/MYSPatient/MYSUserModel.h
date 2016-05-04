//
//  MYSUserModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 用户
@interface MYSUserModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *userId; // 用户Id
@property (nonatomic, strong) NSString<Optional> *userName; // 用户名
@property (nonatomic, strong) NSString<Optional> *email; // 邮箱
@property (nonatomic, strong) NSString<Optional> *mobilephone; // 手机
@property (nonatomic, strong) NSString<Optional> *userType; // 用户类型 (0:患者, 1:医生, 2:分诊员)
@property (nonatomic, strong) NSString<Optional> *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString<Optional> *cookie; // cookie
@property (nonatomic, strong) NSString<Optional> *pic; // 用户头像

@property (nonatomic, strong) NSString <Optional> *trueName; //用户真实名称
@property (nonatomic, strong) NSString <Optional> *gender; //性别
@property (nonatomic, strong) NSString <Optional> *birthday; //出生日期
@property (nonatomic, strong) NSString <Optional> *phone; //联系电话
@property (nonatomic, strong) NSString <Optional> *province; //省市区
@property (nonatomic, strong) NSString <Optional> *city; //省市区
@property (nonatomic, strong) NSString <Optional> *region; //省市区
@property (nonatomic, strong) NSString <Optional> *detailedAddress; //详细地址
@end
