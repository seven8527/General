//
//  MYSExpertGroupDoctorModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSExpertGroupDoctorModel @end

// 名医圈--医生的数据模型
@interface MYSExpertGroupDoctorModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *doctorId; // 医生id
@property (nonatomic, strong) NSString<Optional> *doctorName; // 医生姓名
@property (nonatomic, strong) NSString<Optional> *headPortrait; // 医生头像
@property (nonatomic, strong) NSString<Optional> *hospital; // 医院
@property (nonatomic, strong) NSString<Optional> *department; // 科室
@property (nonatomic, strong) NSString<Optional> *qualifications; // 职称
@property (nonatomic, strong) NSString<Optional> *attentionState; // 关注状态（0: 未关注， 1：已关注）
@property (nonatomic, strong) NSString<Optional> *doctorType; // 医生类型(0:名医汇， 1:主任医生团)
@end

