//
//  MYSBriefAskModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//  主问

#import "JSONModel.h"
#import "MYSBriefAskDoctorModel.h"
#import "MYSBriefAskPatientModel.h"
#import "MYSBriefAnswerModel.h"

@protocol MYSBriefAskModel @end

@interface MYSBriefAskModel : JSONModel
@property (nonatomic, strong) MYSBriefAskDoctorModel<Optional> *doctorModel; // 医生模型
@property (nonatomic, strong) MYSBriefAskPatientModel<Optional> *patientModel; // 患者模型
@property (nonatomic, strong) MYSBriefAnswerModel<Optional> *answerModel; // 回复模型
@property (nonatomic, copy) NSString<Optional> *pfID; // 问题ID
@property (nonatomic, copy) NSString<Optional> *userID; // 用户ID
@property (nonatomic, copy) NSString<Optional> *patientID; // 患者ID
@property (nonatomic, copy) NSString<Optional> *doctorID; // 医生ID
@property (nonatomic, copy) NSString<Optional> *addTime; // 添加时间 提问时间
@property (nonatomic, copy) NSString<Optional> *isReply; // 问题回复状态   0 未回复 1 已经回复
@property (nonatomic, copy) NSString<Optional> *times; // 回复次数
@property (nonatomic, copy) NSString<Optional> *type; // 主问追问类型 问题类型 0 主问 1 追问
@property (nonatomic, copy) NSString<Optional> *view; // 是否查看过  0 未查看 1 已查看
@property (nonatomic, copy) NSString<Optional> *question; // 咨询问题
@property (nonatomic, copy) NSString<Optional> *userView; // 用户是否查看 用户是否查看0 未查看 1 已查看
@end
