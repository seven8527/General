//
//  MYSLoginModel.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface MYSLoginModel : JSONModel

/*
 -1电话号码为空
 -2密码为空
 -403 用户为黑名单
 -405 账户为普通用户不允许登录
 -406未填资料
 -407资料待审核
 -408审核不通过
 1登录成功
 -100登录失败,
*/
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString *uid; // 用户ID
@property (nonatomic, strong) NSString *nick_name; // 用户名字
/* 0患者 1医生 2分诊员 */
@property (nonatomic, strong) NSString *user_type; // 用户类型
@property (nonatomic, strong) NSString *cookie;


@property (nonatomic, strong) NSString *close;
@property (nonatomic, strong) NSString *doctor_type;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *email_confirm;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *mobile_confirm;

@end
