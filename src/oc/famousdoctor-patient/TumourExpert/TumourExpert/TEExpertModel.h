//
//  TEExpertModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEExpertModel @end

// 专家
@interface TEExpertModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *expertId; // 专家ID
@property (nonatomic, strong) NSString<Optional> *expertName; // 专家姓名
@property (nonatomic, strong) NSString<Optional> *hospitalId; // 医院ID
@property (nonatomic, strong) NSString<Optional> *departmentId; // 科室ID
@property (nonatomic, strong) NSString<Optional> *hospitalName; // 医院名称
@property (nonatomic, strong) NSString<Optional> *department; // 所在科室
@property (nonatomic, strong) NSString<Optional> *area; // 地区
@property (nonatomic, strong) NSString<Optional> *consultCount; // 咨询人数
@property (nonatomic, strong) NSString<Optional> *phoneConsultCount; // 电话咨询人数
@property (nonatomic, strong) NSString<Optional> *onlineconsultCount; // 网络咨询人数
@property (nonatomic, strong) NSString<Optional> *offlineconsultCount; // 面对面咨询人数
@property (nonatomic, strong) NSString<Optional> *expertIcon; // 专家头像
@property (nonatomic, strong) NSString<Optional> *expertTitle; // 专家职称
@property (nonatomic, strong) NSString<Optional> *expertForte; // 专家擅长
@property (nonatomic, strong) NSString<Optional> *expertIntroduce; // 专家介绍






@end





