//
//  MYSDoctorHomeIntroducesModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 名医生专家主页介绍信息
@protocol MYSDoctorHomeIntroducesModel @end

@interface MYSDoctorHomeIntroducesModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *doctorId; // 医生id
@property (nonatomic, strong) NSString<Optional> *doctorName; // 医生姓名
@property (nonatomic, strong) NSString<Optional> *headPortrait; // 医生头像
@property (nonatomic, strong) NSString<Optional> *hospital; // 医院
@property (nonatomic, strong) NSString<Optional> *department; // 科室
@property (nonatomic, strong) NSString<Optional> *qualifications; // 职称
@property (nonatomic, strong) NSString<Optional> *attentionNumber; // 关注人数（0: 没关注）
@property (nonatomic, strong) NSString<Optional> *attentionState; // 关注状态（0: 未关注， 1：已关注）
@property (nonatomic, strong) NSString<Optional> *territory; // 擅长
@property (nonatomic, strong) NSString<Optional> *introduce; // 个人简介
@end
