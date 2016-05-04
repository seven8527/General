//
//  MYSExpertGroupPatientModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
@protocol MYSExpertGroupPatientModel @end

// 患者
@interface MYSExpertGroupPatientModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *patientId; // 患者ID
@property (nonatomic, copy) NSString<Optional> *patientName; // 患者姓名
@property (nonatomic, copy) NSString<Optional> *patientIcon; // 患者头像
@property (nonatomic, copy) NSString<Optional> *patientSex; // 患者性别 // 1 男 0 女
@property (nonatomic, copy) NSString<Optional> *patientAge; // 患者年龄
@property (nonatomic, copy) NSString<Optional> *patientBirthday; // 患者生日
@property (nonatomic, copy) NSString<Optional> *identity; // 身份证
@end
