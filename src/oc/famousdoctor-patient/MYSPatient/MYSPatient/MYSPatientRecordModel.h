//
//  MYSPatientRecordModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

// 咨询就诊记录模型

#import "JSONModel.h"
#import "MYSPatientRecordDataModel.h"
@protocol MYSPatientRecordModel @end

@interface MYSPatientRecordModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *patientRecordID; // 患者记录id
@property (nonatomic, copy) NSString<Optional> *hosptal; // 就诊医院
@property (nonatomic, copy) NSString<Optional> *department; // 就诊科室
@property (nonatomic, copy) NSString<Optional> *patientRecordDate; // 就诊时间
@property (nonatomic, copy) NSString<Optional> *diagnosis; // 诊断
@property (nonatomic, strong) NSArray<Optional> *attList;
@end
