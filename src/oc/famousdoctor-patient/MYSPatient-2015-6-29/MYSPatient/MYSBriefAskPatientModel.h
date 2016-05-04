//
//  MYSBriefAskPatientModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//  患者信息

#import "JSONModel.h"

@protocol MYSBriefAskPatientModel @end

@interface MYSBriefAskPatientModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *patientAge; // 患者年龄
@property (nonatomic, copy) NSString<Optional> *patientBirthday; // 生日
@property (nonatomic, copy) NSString<Optional> *patientHeight; // 身高
@property (nonatomic, copy) NSString<Optional> *patientIdentity; // 身份证
@property (nonatomic, copy) NSString<Optional> *patientName; // 患者名称
@property (nonatomic, copy) NSString<Optional> *patientPic; //患者头像
@property (nonatomic, copy) NSString<Optional> *patientID; // 患者ID
@property (nonatomic, copy) NSString<Optional> *patientSex; // 患者性别
@property (nonatomic, copy) NSString<Optional> *userID; // 用户ID
@property (nonatomic, copy) NSString<Optional> *patientWeight; // 患者体重
@end
