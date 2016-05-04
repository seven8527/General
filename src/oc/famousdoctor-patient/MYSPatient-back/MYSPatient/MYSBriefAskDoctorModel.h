//
//  MYSBriefAskDoctorModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
// 主文医生信息

#import "JSONModel.h"

@protocol MYSBriefAskDoctorModel @end

@interface MYSBriefAskDoctorModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *doctorClinical; // 医生职称
@property (nonatomic, copy) NSString<Optional> *doctorDepatrment; // 医生科室
@property (nonatomic, copy) NSString<Optional> *doctorName; // 医生名称
@property (nonatomic, copy) NSString<Optional> *doctorID; // 医生ID
@property (nonatomic, copy) NSString<Optional> *doctorPic; // 医生头像
@end
